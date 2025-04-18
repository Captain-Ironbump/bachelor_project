package org.ba.core;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.ba.entities.db.ObservationEntity;
import org.ba.entities.dto.ObservationDTO;
import org.ba.repositories.ObservationRepository;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
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
        repository.persist(entity);
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
}
