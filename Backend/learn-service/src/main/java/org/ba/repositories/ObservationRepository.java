package org.ba.repositories;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.ba.entities.db.ObservationEntity;
import org.ba.utils.FieldValidator;

import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import io.quarkus.logging.Log;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class ObservationRepository implements PanacheRepositoryBase<ObservationEntity, Long> {
    public Object fetchRawObservationBytes(Long id) {
        return getEntityManager()
            .createNativeQuery("SELECT * FROM observation WHERE observation_id = :id")
            .setParameter("id", id)
            .getSingleResult(); // cast to byte[] if needed
    }


    public List<ObservationEntity> findAllByLearnerId(Long learnerId, String sortField, String sortOrder, Long eventId, int timeSpamInDays) {
        String sortBy = "createdDateTime"; // Default field is createdDateTime
        String order = "ASC"; // Default order is ascending
        
        if (sortField != null && !sortField.isEmpty() && FieldValidator.isValidSortField(sortField, ObservationEntity.class)) {
            sortBy = sortField;
        }

        if (sortOrder != null) {
            if (sortOrder.equalsIgnoreCase("DESC")) {
                order = "DESC";
            } else if (sortOrder.equalsIgnoreCase("ASC")) {
                order = "ASC";
            }
        }

        StringBuilder query = new StringBuilder("learner.learnerId = :learnerId");
        Map<String, Object> params = new HashMap<>();
        params.put("learnerId", learnerId);

        if (eventId != null) {
            query.append(" AND event.eventId = :eventId");
            params.put("eventId", eventId);
        }

        if (timeSpamInDays > 0) {
            LocalDateTime end = LocalDateTime.now();
            LocalDateTime start = end.minusDays(timeSpamInDays);
            query.append(" AND createdDateTime BETWEEN :start AND :end");
            params.put("start", start);
            params.put("end", end);
        }

        return find(query.toString() + " ORDER BY " + sortBy + " " + order, params).list();
    }

    public List<Object[]> getEntriesCountPerLearnerId() {
        return getEntityManager().createNamedQuery("Observation.countByLearnerId", Object[].class).getResultList();
    }

    public List<Object[]> getCountMapByLearnerId(String query, Map<String, Object> params) {
        var queryBuilder = getEntityManager().createQuery(query, Object[].class);
    
        // Set the 'ids' parameter only if it's provided
        if (params.containsKey("ids") && params.get("ids") != null) {
            queryBuilder.setParameter("ids", params.get("ids"));
        }

        if (params.containsKey("eventId") && params.get("eventId") != null) {
            queryBuilder.setParameter("eventId", params.get("eventId"));
        }
    
        return queryBuilder.getResultList();
    }
    
    public List<Object[]> getEntriesCountPerLearnerIdWithTimespanQueries(String query, Map<String, Object> params) {
        var queryBuilder = getEntityManager().createQuery(query, Object[].class);
    
        // Set 'ids' parameter only if it's provided
        if (params.containsKey("ids") && params.get("ids") != null) {
            queryBuilder.setParameter("ids", params.get("ids"));
        }

        if (params.containsKey("eventId") && params.get("eventId") != null) {
            queryBuilder.setParameter("eventId", params.get("eventId"));
        }
    
        // Set 'start' and 'end' parameters for the timespan query
        if (params.containsKey("start") && params.get("start") != null) {
            queryBuilder.setParameter("start", params.get("start"));
        }
    
        if (params.containsKey("end") && params.get("end") != null) {
            queryBuilder.setParameter("end", params.get("end"));
        }
    
        return queryBuilder.getResultList();
    }

    public List<ObservationEntity> findByKursAndLearnerWithTags(Long learnerId, Long eventId) {
        System.out.println(learnerId);
        System.out.println(eventId);
        System.out.println("Hello");
        return find(
            "SELECT DISTINCT o FROM Observation o LEFT JOIN FETCH o.tags WHERE o.learner.learnerId = ?1 AND o.event.eventId = ?2",
            learnerId, eventId
        ).list();
    }

    public ObservationEntity findByIdWithTags(Long observationId) {
        return find("SELECT DISTINCT o FROM Observation o LEFT JOIN FETCH o.tags WHERE o.observationId = ?1", observationId).firstResult();
    }     

    public List<ObservationEntity> fetchObservationsWithTagsByLearnerAndEvent(Long learnerId, String sortField, String sortOrder, Long eventId, int timespanInDays) {
        Log.info("In Here");
        String sortBy = "createdDateTime"; // Default field is createdDateTime
        String order = "ASC"; // Default order is ascending

        if (sortField != null && !sortField.isEmpty() && FieldValidator.isValidSortField(sortField, ObservationEntity.class)) {
            sortBy = sortField;
        }

        if (sortOrder != null) {
            if (sortOrder.equalsIgnoreCase("DESC")) {
                order = "DESC";
            } else if (sortOrder.equalsIgnoreCase("ASC")) {
                order = "ASC";
            }
        }

        StringBuilder query = new StringBuilder("SELECT DISTINCT o FROM Observation o LEFT JOIN FETCH o.tags WHERE o.learner.learnerId = :learnerId");
        Map<String, Object> params = new HashMap<>();
        params.put("learnerId", learnerId);

        if (eventId != null) {
            query.append(" AND o.event.eventId = :eventId");
            params.put("eventId", eventId);
        }

        if (timespanInDays > 0) {
            LocalDateTime end = LocalDateTime.now();
            LocalDateTime start = end.minusDays(timespanInDays);
            query.append(" AND o.createdDateTime BETWEEN :start AND :end");
            params.put("start", start);
            params.put("end", end);
        }

        query.append(" ORDER BY o.").append(sortBy).append(" ").append(order);

        return find(query.toString(), params).list();
    }
}
