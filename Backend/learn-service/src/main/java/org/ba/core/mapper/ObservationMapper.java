package org.ba.core.mapper;

import java.util.List;

import org.ba.entities.db.LearnerEntity;
import org.ba.entities.db.ObservationEntity;
import org.ba.entities.dto.ObservationDTO;
import org.mapstruct.InheritInverseConfiguration;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "cdi")
public interface ObservationMapper {
    List<ObservationDTO> toDomainList(List<ObservationEntity> entities);

    @Mapping(source = "learner.learnerId", target = "learnerId")
    ObservationDTO toDomain(ObservationEntity entity);

    @InheritInverseConfiguration(name = "toDomain")
    @Mapping(source = "learnerId", target = "learner.learnerId")
    @Mapping(target = "tags", ignore = true) 
    ObservationEntity toEntity(ObservationDTO domain);

    @Mapping(target = "tags", ignore = true)
    @Mapping(source = "learnerId", target = "learner")
    void updateEntityFromDomain(ObservationDTO domain, @MappingTarget ObservationEntity entity);

    @Mapping(source = "learner.learnerId", target = "learnerId")
    void updateDomainFromEntity(ObservationEntity entity, @MappingTarget ObservationDTO domain);

    default LearnerEntity map(Long learnerId) {
        if (learnerId == null) {
            return null;
        }
        LearnerEntity learnerEntity = new LearnerEntity();
        learnerEntity.setLearnerId(learnerId);
        return learnerEntity;
    }

    default Long map(LearnerEntity learnerEntity) {
        return learnerEntity != null ? learnerEntity.getLearnerId() : null;
    }
}
