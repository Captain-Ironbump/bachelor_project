package org.ba.core;

import java.util.List;

import org.ba.core.mapper.LearnerMapper;
import org.ba.entities.db.LearnerEntity;
import org.ba.entities.dto.LearnerDTO;
import org.ba.repositories.LearnerRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@ApplicationScoped
@AllArgsConstructor
@Slf4j
public class LearnerService {
    @Inject
    LearnerRepository repository;
    @Inject
    LearnerMapper mapper;

    @Transactional
    public void save(@Valid LearnerDTO learner) {
        //log.debug("Saving Learner: {}", learner);
        LearnerEntity entity = mapper.toEntity(learner);
        System.out.println(entity.toString());
        repository.persist(entity);
        mapper.updateDomainFromEntity(entity, learner);
    }

    public List<LearnerDTO> findAll() {
        return this.mapper.toDomainList(repository.findAll().list());
    }
}
