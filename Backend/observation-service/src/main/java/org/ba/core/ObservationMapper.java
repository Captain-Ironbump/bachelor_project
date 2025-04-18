package org.ba.core;

import java.util.List;

import org.ba.entities.db.ObservationEntity;
import org.ba.entities.dto.ObservationDTO;
import org.mapstruct.InheritInverseConfiguration;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "cdi")
public interface ObservationMapper {
    List<ObservationDTO> toDomainList(List<ObservationEntity> entities);

    ObservationDTO toDomain(ObservationEntity entity);

    @InheritInverseConfiguration(name = "toDomain")
    ObservationEntity toEntity(ObservationDTO domain);

    void updateEntityFromDomain(ObservationDTO domain, @MappingTarget ObservationEntity entity);

    void updateDomainFromEntity(ObservationEntity entity, @MappingTarget ObservationDTO domain);
}
