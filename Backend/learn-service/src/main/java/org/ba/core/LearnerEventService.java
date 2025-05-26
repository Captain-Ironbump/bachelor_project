package org.ba.core;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.ba.core.mapper.LearnerMapper;
import org.ba.entities.db.EventEntity;
import org.ba.entities.db.LearnerEntity;
import org.ba.entities.dto.EventDTO;
import org.ba.entities.dto.LearnerDTO;
import org.ba.exceptions.EventNotFoundException;
import org.ba.exceptions.LearnerNotFoundException;
import org.ba.repositories.EventRepository;
import org.ba.repositories.LearnerRepository;
import org.yaml.snakeyaml.events.Event;
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

    public List<LearnerDTO> getLearnersByEventId(Long eventId) {
        Set<LearnerEntity> learners = this.eventRepository.findByIdWithLearners(eventId)
            .orElseThrow(() -> new EntityNotFoundException("Event not found"))
            .getLearners();
        System.out.println(learners);
        return this.learnerMapper.toDomainList(new ArrayList<>(learners));
    }

    public List<EventDTO> getEventsByLearnerId(Long learnerId) {
        Set<EventEntity> events = this.learnerRepository.findById(learnerId).getEvents();
        return this.eventMapper.toDomainList(events.stream().toList());
    }

}
