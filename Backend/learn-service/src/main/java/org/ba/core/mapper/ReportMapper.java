package org.ba.core.mapper;

import java.util.List;

import org.ba.entities.db.ReportEntity;
import org.ba.entities.dto.ReportDTO;
import org.mapstruct.InheritInverseConfiguration;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import org.ba.entities.db.LearnerEntity;
import org.ba.entities.db.EventEntity;

@Mapper(componentModel = "cdi")
public interface ReportMapper {

    List<ReportDTO> toDomainList(List<ReportEntity> entities);

    @Mapping(source = "learner", target = "learnerId", qualifiedByName = "mapLearnerToId")
    @Mapping(source = "event", target = "eventId", qualifiedByName = "mapEventToId")
    @Mapping(source = "reportQuality", target = "quality")
    ReportDTO toDomain(ReportEntity entity);

    @InheritInverseConfiguration(name = "toDomain")
    @Mapping(source = "learnerId", target = "learner", qualifiedByName = "mapLearner")
    @Mapping(source = "eventId", target = "event", qualifiedByName = "mapEvent")
    @Mapping(source = "quality", target = "reportQuality")
    ReportEntity toEntity(ReportDTO domain);

    @Mapping(source = "learnerId", target = "learner", qualifiedByName = "mapLearner")
    @Mapping(source = "eventId", target = "event", qualifiedByName = "mapEvent")
    @Mapping(source = "quality", target = "reportQuality")
    void updateEntityFromDomain(ReportDTO domain, @MappingTarget ReportEntity entity);

    @Mapping(source = "learner", target = "learnerId", qualifiedByName = "mapLearnerToId")
    @Mapping(source = "event", target = "eventId", qualifiedByName = "mapEventToId")
    @Mapping(source = "reportQuality", target = "quality")
    void updateDomainFromEntity(ReportEntity entity, @MappingTarget ReportDTO domain);

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
