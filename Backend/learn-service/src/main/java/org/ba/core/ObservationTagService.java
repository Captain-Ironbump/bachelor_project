package org.ba.core;

import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.ba.core.mapper.ObservationMapper;
import org.ba.core.mapper.TagMapper;
import org.ba.entities.db.ObservationEntity;
import org.ba.entities.db.TagEntity;
import org.ba.entities.dto.ObservationDTO;
import org.ba.entities.dto.ObservationWithTagsDTO;
import org.ba.entities.dto.TagDTO;
import org.ba.exceptions.LearnerNotFoundException;
import org.ba.repositories.ObservationRepository;
import org.ba.repositories.TagRepository;
import org.hibernate.exception.ConstraintViolationException;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import jakarta.ws.rs.WebApplicationException;
import lombok.extern.slf4j.Slf4j;

@ApplicationScoped
@Slf4j
public class ObservationTagService {
    @Inject
    ObservationRepository observationRepository;

    @Inject
    TagRepository tagRepository;

    @Inject
    ObservationMapper observationMapper;

    @Inject
    TagMapper tagMapper;

    @Transactional
    public void saveObservationWithTag(@Valid ObservationDTO observation, @Valid List<TagDTO> tags) {
        ObservationEntity observationEntity = this.observationMapper.toEntity(observation);

        Set<TagEntity> tagEntities = tags.stream()
            .map(this.tagMapper::toEntity)
            .filter(entity -> tagRepository.findById(entity.getTag()) != null)
            .collect(Collectors.toSet());

        observationEntity.setTags(tagEntities);
        
        try {
            this.observationRepository.persist(observationEntity);
            this.observationMapper.updateDomainFromEntity(observationEntity, observation);
        } catch (ConstraintViolationException e) {
            throw new LearnerNotFoundException("Learner with ID [" + observation.getLearnerId() + "] not found");
        }
    }

    @Transactional
    public void patchObservationWithTag(Long observationId, ObservationDTO observation, List<TagDTO> tags) {
        ObservationEntity observationEntity = this.observationRepository.findById(observationId);
        if (observationEntity == null) {
            throw new WebApplicationException("Observation not found", 404);
        }

        if (observation != null && observation.getRawObservation() != null) {
            observationEntity.setRawObservation(observation.getRawObservation());
        }

        if (tags != null && !tags.isEmpty()) {
            Set<TagEntity> tagEntities = tags.stream()
                .map(this.tagMapper::toEntity)
                .filter(entity -> this.tagRepository.findById(entity.getTag()) != null)
                .collect(Collectors.toSet());
            observationEntity.setTags(tagEntities);
        }
        this.observationMapper.updateDomainFromEntity(observationEntity, observation);
    }

    public List<ObservationWithTagsDTO> fetchObservationsWithTagsByLearnerAndEvent(Long learnerId, String sortField, String sortOrder, Long eventId, int timespanInDays) {
        List<ObservationWithTagsDTO> data = new LinkedList<>();
        try {
            List<ObservationEntity> observationEntities = this.observationRepository.fetchObservationsWithTagsByLearnerAndEvent(learnerId, sortField, sortOrder, eventId, timespanInDays);
            observationEntities.forEach(entity -> 
                data.add(new ObservationWithTagsDTO(
                    this.observationMapper.toDomain(entity),
                    this.tagMapper.toDomainList(entity.getTags().stream().toList())
                ))
            );
        } catch (Exception e) {
            log.error("Error fetching observations", e);
            throw e;
        }
        return data;
    }

    public ObservationWithTagsDTO fetchObservationWithTagsById(Long observationId) {
        try {
            ObservationEntity observationEntity = this.observationRepository.findById(observationId);
            ObservationWithTagsDTO dto = new ObservationWithTagsDTO(
                this.observationMapper.toDomain(observationEntity),
                this.tagMapper.toDomainList(observationEntity.getTags().stream().toList())
            );
            return dto;
        } catch (Exception e) {
            log.error("Error fetching observation", e);
        }
        return null;
    }
}
