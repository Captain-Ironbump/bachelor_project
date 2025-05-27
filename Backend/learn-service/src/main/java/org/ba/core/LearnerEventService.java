package org.ba.core;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.ba.core.mapper.LearnerMapper;
import org.ba.core.mapper.ObservationMapper;
import org.ba.entities.db.EventEntity;
import org.ba.entities.db.LearnerEntity;
import org.ba.entities.dto.EventDTO;
import org.ba.entities.dto.LearnerDTO;
import org.ba.entities.dto.ObservationsDataDTO;
import org.ba.exceptions.EventNotFoundException;
import org.ba.exceptions.LearnerNotFoundException;
import org.ba.repositories.EventRepository;
import org.ba.repositories.LearnerRepository;
import org.ba.repositories.ObservationRepository;
import org.ba.core.mapper.EventMapper;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;

@ApplicationScoped
public class LearnerEventService {
    @Inject
    LearnerRepository learnerRepository;
    @Inject
    LearnerMapper learnerMapper;
    @Inject
    EventRepository eventRepository;
    @Inject
    EventMapper eventMapper;
    @Inject
    ObservationRepository observationRepository;
    @Inject
    ObservationMapper observationMapper;

    @Transactional
    public void addLearnerToEvent(Long learnerId, Long eventId) {
        LearnerEntity learner = learnerRepository.findById(learnerId);
        EventEntity event = eventRepository.findById(eventId);

        if (learner == null) {
            throw new LearnerNotFoundException("Learner not found for ID: " + learnerId);
        }

        if (event == null) {
            throw new EventNotFoundException("Event not found for ID: " + eventId);
        }

        if (learner.getEvents() == null) {
            learner.setEvents(new HashSet<>());
        }

        if (!learner.getEvents().contains(event)) {
            learner.getEvents().add(event);
        }

        if (event.getLearners() == null) {
            event.setLearners(new HashSet<>());
        }
        if (!event.getLearners().contains(learner)) {
            event.getLearners().add(learner);
        }
    }

    @Transactional
    public void addLearnersToEvent(List<Long> learners, Long eventId) {
        EventEntity event = this.eventRepository.findById(eventId);
        if (event == null) {
            throw new EventNotFoundException("Event not found for ID: " + eventId);
        }
        Set<LearnerEntity> newLearnerEntities = new HashSet<>();
        for (Long learnerId : learners) {
            LearnerEntity learner = this.learnerRepository.findById(learnerId);
            if (learner == null) {
                throw new LearnerNotFoundException("Learner not found for ID: " + learnerId);
            }
            if (learner.getEvents() == null) {
                learner.setEvents(new HashSet<>());
            }
            newLearnerEntities.add(learner);
        }
        Set<LearnerEntity> oldLearners = event.getLearners() != null ? new HashSet<>(event.getLearners()) : new HashSet<>();
        for (LearnerEntity oldLearner : oldLearners) {
            if (!newLearnerEntities.contains(oldLearner)) {
                oldLearner.getEvents().remove(event);
            }
        }
        event.setLearners(newLearnerEntities);
        for (LearnerEntity learner : newLearnerEntities) {
            learner.getEvents().add(event);
        }
    }

    public List<LearnerDTO> getLearnersByEventId(Long eventId, Integer timespanInDays, String sortField, String sortOrder) {
        String usedSortOrder = "ASC";
        String usedSortField = "lastname";

        if (sortOrder != null && !sortOrder.isEmpty()) {
            usedSortOrder = sortOrder.equalsIgnoreCase("DESC") ? "DESC" : "ASC";
        } 

        if (sortField != null && !sortField.isEmpty()) {
            usedSortField = sortField;
        }

        Set<LearnerEntity> learners = this.eventRepository.findByIdWithLearners(eventId)
            .orElseThrow(() -> new EntityNotFoundException("Event not found"))
            .getLearners();
        System.out.println(learners);
        
        List<LearnerDTO> learnerDTOs = new ArrayList<>();

        final String finalUsedSortOrder = usedSortOrder;

        switch (usedSortField.toLowerCase()) {
            case "lastname":
                learnerDTOs = this.learnerMapper.toDomainList(learners.stream()
                    .sorted((l1, l2) -> {
                        if (finalUsedSortOrder.equals("ASC")) {
                            return l1.getLastName().compareToIgnoreCase(l2.getLastName());
                        } else {
                            return l2.getLastName().compareToIgnoreCase(l1.getLastName());
                        }
                    }).toList());
                break;
        
            case "obs-count":
                var countMap = getObservationCountMapByLearnerAndEventAndTimespan(eventId, timespanInDays, learners);
                learnerDTOs = this.learnerMapper.toDomainList(learners.stream()
                    .sorted((l1, l2) -> {
                        Long count1 = countMap.getOrDefault(l1.getLearnerId(), new ObservationsDataDTO(0L, null)).getCount();
                        Long count2 = countMap.getOrDefault(l2.getLearnerId(), new ObservationsDataDTO(0L, null)).getCount();
                        if (finalUsedSortOrder.equals("ASC")) {
                            return count1.compareTo(count2);
                        } else {
                            return count2.compareTo(count1);
                        }
                    }).toList());
                break;
            default:
                break;
        }

        return learnerDTOs;
    }

    private Map<Long, ObservationsDataDTO> getObservationCountMapByLearnerAndEventAndTimespan(Long eventId, Integer timespanInDays, Set<LearnerEntity> learners) {
        List<Long> learnerIds = learners.stream().map(LearnerEntity::getLearnerId).toList();
        
        List<Object[]> totalCountList = this.observationRepository.getCountMapByLearnerId(eventId, timespanInDays, learnerIds);
        Map<Long, ObservationsDataDTO> countMap = new HashMap<>();
        for (Object[] row : totalCountList) {
            Long learnerId = (Long) row[0];
            Long count = (Long) row[1];
            countMap.put(learnerId, new ObservationsDataDTO(count, null));
        }

        if (timespanInDays != null && timespanInDays > 0) {
            for (ObservationsDataDTO entryValue : countMap.values()) {
                entryValue.setCountWithTimespan(0L);
            }

            LocalDateTime now = LocalDateTime.now();
            LocalDateTime start = now.minusDays(timespanInDays);

            List<Object[]> timespanResult = this.observationRepository.getEntriesCountPerLearnerIdWithTimespanQueries(eventId, now, start, learnerIds);

            for (Object[] row : timespanResult) {
                Long learnerId = (Long) row[0];
                Long countWithTimespan = (Long) row[1];
                ObservationsDataDTO observationsDataDTO = countMap.get(learnerId);
                if (observationsDataDTO != null) {
                    observationsDataDTO.setCountWithTimespan(countWithTimespan);
                }
            }
        }
        return countMap;
    }

    public List<EventDTO> getEventsByLearnerId(Long learnerId) {
        Set<EventEntity> events = this.learnerRepository.findById(learnerId).getEvents();
        return this.eventMapper.toDomainList(events.stream().toList());
    }

}
