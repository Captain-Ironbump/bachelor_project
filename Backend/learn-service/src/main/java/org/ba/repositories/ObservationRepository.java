package org.ba.repositories;

import java.lang.reflect.Field;
import java.util.List;
import java.util.Map;

import org.ba.entities.db.ObservationEntity;
import org.ba.utils.FieldValidator;

import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class ObservationRepository implements PanacheRepositoryBase<ObservationEntity, Long> {
    public List<ObservationEntity> findAllByLearnerId(Long learnerId, String sortField, String sortOrder) {
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

        return find("learner.learnerId = ?1 ORDER BY o." + sortBy + " " + order, learnerId).list();
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
    
        return queryBuilder.getResultList();
    }
    
    public List<Object[]> getEntriesCountPerLearnerIdWithTimespanQueries(String query, Map<String, Object> params) {
        var queryBuilder = getEntityManager().createQuery(query, Object[].class);
    
        // Set 'ids' parameter only if it's provided
        if (params.containsKey("ids") && params.get("ids") != null) {
            queryBuilder.setParameter("ids", params.get("ids"));
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
}
