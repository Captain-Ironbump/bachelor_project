package org.ba.core;

import java.util.List;
import java.util.stream.Collectors;

import org.ba.core.mapper.EventMapper;
import org.ba.entities.db.EventEntity;
import org.ba.entities.dto.EventDTO;
import org.ba.repositories.EventRepository;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;

@ApplicationScoped
@AllArgsConstructor
public class EventService {
    @Inject
    EventRepository repository;

    @Inject
    EventMapper mapper;

    @Transactional
    public void save(@Valid EventDTO event) {
        EventEntity entity = this.mapper.toEntity(event);
        this.repository.persist(entity);
        this.mapper.updateDomainFromEntity(entity, event);
    }

    public List<EventDTO> findAll() {
        return this.mapper.toDomainList(repository.findAll().list());
    }

    public List<EventDTO> getAllEventsWithLeanerCount(String eventSortReason) {
        return this.repository.getAllEventsWithLearnerCount(eventSortReason).stream().map(
            (row) -> {
                EventDTO dto = new EventDTO();
                dto.setEventId((Long) row[1]);
                dto.setName((String) row[0]);
                dto.setLearnerCount(((Number) row[2]).intValue());
                return dto;
            }
        ).collect(Collectors.toList());
    }

    public EventDTO getEventDetailById(Long eventId) {
        return this.mapper.toDomain(this.repository.findById(eventId));
    }
}
