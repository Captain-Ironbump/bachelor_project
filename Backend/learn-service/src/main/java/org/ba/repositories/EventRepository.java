package org.ba.repositories;

import java.util.List;
import java.util.Optional;

import org.ba.entities.db.EventEntity;
import org.jboss.resteasy.reactive.common.NotImplementedYet;

import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;
import lombok.extern.slf4j.Slf4j;

@ApplicationScoped
@Slf4j
public class EventRepository implements PanacheRepositoryBase<EventEntity, Long>{
    public List<Object[]> getAllEventsWithLearnerCount() {
        return getEntityManager().createNamedQuery("Event.getWithLearnersCount", Object[].class).getResultList();
    }

    public List<Object[]> getAllEventsWithLearnerCount(String eventSortReason) {
        String baseQuery = "SELECT e.name, e.eventId, COUNT(l) AS learnerCount " +
                           "FROM Event e " +
                           "LEFT JOIN e.learners l " +
                           "GROUP BY e.eventId, e.name";
        log.info(eventSortReason);
    
        if (eventSortReason == null || eventSortReason.equals("NONE")) {
            return getEntityManager().createQuery(baseQuery, Object[].class).getResultList();
        }
    
        String orderByClause = "";
        switch (eventSortReason) {
            case "alpabeticASC":
                orderByClause = " ORDER BY e.name ASC";
                break;
            case "alpabeticDESC":
                orderByClause = " ORDER BY e.name DESC";
                break;
            case "urgency":
                throw new NotImplementedYet();
            default:
                // Optional: handle unrecognized values
                throw new IllegalArgumentException("Unsupported sort reason: " + eventSortReason);
        }
    
        String fullQuery = baseQuery + orderByClause;
        return getEntityManager().createQuery(fullQuery, Object[].class).getResultList();
    }
    

    public Optional<EventEntity> findByIdWithLearners(Long eventId) {
        return getEntityManager()
            .createQuery("SELECT e FROM Event e LEFT JOIN FETCH e.learners WHERE e.eventId = :eventId", EventEntity.class)
            .setParameter("eventId", eventId)
            .getResultStream()
            .findFirst();
    }
}
