package org.ba.core.mapper;

import java.util.List;

import org.ba.entities.db.TagEntity;
import org.ba.entities.dto.TagDTO;
import org.mapstruct.InheritInverseConfiguration;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "cdi")
public interface TagMapper {
    List<TagDTO> toDomainList(List<TagEntity> entities);
    
    TagDTO toDomain(TagEntity entity);

    @InheritInverseConfiguration(name = "toDomain")
    @Mapping(target = "observations", ignore = true)
    TagEntity toEntity(TagDTO domain);

    @Mapping(target = "observations", ignore = true)
    void updateEntityFromDomain(TagDTO domain, @MappingTarget TagEntity entity);

    void updateDomainFromEntity(TagEntity entity, @MappingTarget TagDTO domain);
}
