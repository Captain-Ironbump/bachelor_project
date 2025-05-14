package org.ba.core.mapper;

import java.util.List;

import org.ba.entities.db.LearnerEntity;
import org.ba.entities.dto.LearnerDTO;
import org.mapstruct.InheritInverseConfiguration;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "cdi")
public interface LearnerMapper {
    List<LearnerDTO> toDomainList(List<LearnerEntity> entities);

    LearnerDTO toDomain(LearnerEntity entity);

    @InheritInverseConfiguration(name = "toDomain")
    @Mapping(target = "events", ignore = true)
    LearnerEntity toEntity(LearnerDTO domain);

    @Mapping(target = "events", ignore = true)
    void updateEntityFromDomain(LearnerDTO domain, @MappingTarget LearnerEntity entity);

    void updateDomainFromEntity(LearnerEntity entity, @MappingTarget LearnerDTO domain);
}
