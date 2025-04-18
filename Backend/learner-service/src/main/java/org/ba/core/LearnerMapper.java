package org.ba.core;

import java.util.List;

import org.ba.entities.db.LearnerEntity;
import org.ba.entities.dto.LearnerDTO;
import org.mapstruct.InheritInverseConfiguration;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "cdi")
public interface LearnerMapper {
    List<LearnerDTO> toDomainList(List<LearnerEntity> entities);

    LearnerDTO toDomain(LearnerEntity entity);

    @InheritInverseConfiguration(name = "toDomain")
    LearnerEntity toEntity(LearnerDTO domain);

    void updateEntityFromDomain(LearnerDTO domain, @MappingTarget LearnerEntity entity);

    void updateDomainFromEntity(LearnerEntity entity, @MappingTarget LearnerDTO domain);
}
