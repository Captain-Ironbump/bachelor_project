package org.ba.core.mapper;

import java.util.List;

import org.ba.entities.db.EventEntity;
import org.ba.entities.db.LearnerEntity;
import org.ba.entities.db.ObservationEntity;
import org.ba.entities.dto.ObservationDTO;
import org.mapstruct.InheritInverseConfiguration;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

@Mapper(componentModel = "cdi")
public interface ObservationMapper {

    List<ObservationDTO> toDomainList(List<ObservationEntity> entities);

    @Mapping(source = "learner", target = "learnerId", qualifiedByName = "mapLearnerToId")
    @Mapping(source = "event", target = "eventId", qualifiedByName = "mapEventToId")
    ObservationDTO toDomain(ObservationEntity entity);

    @InheritInverseConfiguration(name = "toDomain")
    @Mapping(target = "tags", ignore = true)
    @Mapping(source = "learnerId", target = "learner", qualifiedByName = "mapLearner")
    @Mapping(source = "eventId", target = "event", qualifiedByName = "mapEvent")
    ObservationEntity toEntity(ObservationDTO domain);

    @Mapping(target = "tags", ignore = true)
    @Mapping(source = "learnerId", target = "learner", qualifiedByName = "mapLearner")
    @Mapping(source = "eventId", target = "event", qualifiedByName = "mapEvent")
    void updateEntityFromDomain(ObservationDTO domain, @MappingTarget ObservationEntity entity);

    @Mapping(source = "learner", target = "learnerId", qualifiedByName = "mapLearnerToId")
    @Mapping(source = "event", target = "eventId", qualifiedByName = "mapEventToId")
    void updateDomainFromEntity(ObservationEntity entity, @MappingTarget ObservationDTO domain);

    @Named("mapLearner")
    default LearnerEntity mapLearner(Long learnerId) {
        if (learnerId == null) {
            return null;
        }
        LearnerEntity learnerEntity = new LearnerEntity();
        learnerEntity.setLearnerId(learnerId);
        return learnerEntity;
    }

    @Named("mapLearnerToId")
    default Long mapLearnerToId(LearnerEntity learnerEntity) {
        return learnerEntity != null ? learnerEntity.getLearnerId() : null;
    }

    @Named("mapEvent")
    default EventEntity mapEvent(Long eventId) {
        if (eventId == null) {
            return null;
        }
        EventEntity eventEntity = new EventEntity();
        eventEntity.setEventId(eventId);
        return eventEntity;
    }

    @Named("mapEventToId")
    default Long mapEventToId(EventEntity entity) {
        return entity != null ? entity.getEventId() : null;
    }
}
