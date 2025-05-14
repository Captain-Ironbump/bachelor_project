package org.ba.core.mapper;

import java.util.List;

import org.ba.entities.db.EventEntity;
import org.ba.entities.dto.EventDTO;
import org.mapstruct.InheritInverseConfiguration;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "cdi")
public interface EventMapper {
    EventDTO toDomain(EventEntity entity);

    @InheritInverseConfiguration(name = "toDomain")
    @Mapping(target = "learners", ignore = true)
    EventEntity toEntity(EventDTO domain);

    @Mapping(target = "learners", ignore = true)
    void updateEntityFromDomain(EventDTO domain, @MappingTarget EventEntity entity);

    void updateDomainFromEntity(EventEntity entity, @MappingTarget EventDTO domain);

    List<EventDTO> toDomainList(List<EventEntity> list);
}
