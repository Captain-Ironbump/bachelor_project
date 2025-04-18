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

    public List<ObservationDTO> findAllByLearnerId(Long learnerId) {
        return this.mapper.toDomainList(repository.findAllByLearnerId(learnerId));
    }

    public Map<Long, Long> getCountMapPerLearnerId() {
        return repository.getEntriesCountPerLearnerId().stream()
            .collect(Collectors.toMap(
                    row -> (Long) row[0],
                    row -> (Long) row[1]
                )
            );
    }

    public Map<Long, ObservationsDataDTO> getCountMapPerLearnerId(Integer timespanInDays, List<Integer> learners) {
        StringBuilder query = new StringBuilder("SELECT o.learner.learnerId, COUNT(o) FROM Observation o WHERE 1=1");
        Map<String, Object> params = new HashMap<>();
    
        if (learners != null && !learners.isEmpty()) {
            query.append(" AND o.learner.learnerId IN :ids");
            params.put("ids", learners);
        }
    
        query.append(" GROUP BY o.learner.learnerId");
    
        List<Object[]> totalCountList = repository.getCountMapByLearnerId(query.toString(), params);
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
    
            StringBuilder timespanQuery = new StringBuilder("SELECT o.learner.learnerId, COUNT(o) FROM Observation o WHERE 1=1");
            Map<String, Object> timespanParams = new HashMap<>(params);
    
            timespanQuery.append(" AND o.createdDateTime BETWEEN :start AND :end");
            timespanParams.put("start", start);
            timespanParams.put("end", now);
    
            if (learners != null && !learners.isEmpty()) {
                timespanQuery.append(" AND o.learner.learnerId IN :ids");
            }
    
            timespanQuery.append(" GROUP BY o.learner.learnerId");
    
            List<Object[]> timespanResult = repository.getEntriesCountPerLearnerIdWithTimespanQueries(timespanQuery.toString(), timespanParams);
    
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
}
