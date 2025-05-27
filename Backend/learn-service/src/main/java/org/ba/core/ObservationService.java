package org.ba.core;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.ba.core.mapper.ObservationMapper;
import org.ba.entities.db.ObservationEntity;
import org.ba.entities.dto.ObservationDTO;
import org.ba.entities.dto.ObservationsDataDTO;
import org.ba.exceptions.LearnerNotFoundException;
import org.ba.repositories.ObservationRepository;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import org.hibernate.exception.ConstraintViolationException;
import jakarta.validation.Valid;

@ApplicationScoped
public class ObservationService {
    @Inject
    ObservationRepository repository;
    @Inject 
    ObservationMapper mapper;

    @Transactional
    public void save(@Valid ObservationDTO observation) {
        ObservationEntity entity = mapper.toEntity(observation);
        try {
            repository.persist(entity);
        } catch (ConstraintViolationException e) {
            throw new LearnerNotFoundException("Learner with ID [" + observation.getLearnerId() + "] not found");
        }
        mapper.updateDomainFromEntity(entity, observation);
    }

    public List<ObservationDTO> findAllByLearnerId(Long learnerId, String sortField, String sortOrder, Long eventId, int timespanInDays) {
        return this.mapper.toDomainList(repository.findAllByLearnerId(learnerId, sortField, sortOrder, eventId, timespanInDays));
    }

    public ObservationDTO getObservationById(Long observationId) {
        return this.mapper.toDomain(this.repository.findById(observationId));
    }

    public Map<Long, Long> getCountMapPerLearnerId() {
        return repository.getEntriesCountPerLearnerId().stream()
            .collect(Collectors.toMap(
                    row -> (Long) row[0],
                    row -> (Long) row[1]
                )
            );
    }

    public Map<Long, ObservationsDataDTO> getCountMapPerLearnerId(Long eventId, Integer timespanInDays, List<Long> learners) {
        
        List<Object[]> totalCountList = repository.getCountMapByLearnerId(eventId, timespanInDays, learners);
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
    
            List<Object[]> timespanResult = repository.getEntriesCountPerLearnerIdWithTimespanQueries(eventId, start, now, learners);
    
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

    @Transactional
    public boolean deleteObservation(Long observationId) {
        ObservationEntity entity = repository.findById(observationId);
        if (entity != null) {
            boolean deleted = repository.deleteById(entity.getObservationId());
            if (deleted) {
                return true;
            } else {
                throw new IllegalStateException("Failed to delete observation with ID " + observationId);
            }
        } else {
            throw new IllegalArgumentException("Observation with ID " + observationId + " does not exist.");
        }
    }
}
