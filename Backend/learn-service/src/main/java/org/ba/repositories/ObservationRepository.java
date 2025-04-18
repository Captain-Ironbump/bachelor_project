package org.ba.repositories;

import java.util.List;
import java.util.Map;

import org.ba.entities.db.ObservationEntity;

import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class ObservationRepository implements PanacheRepositoryBase<ObservationEntity, Long> {
    public List<ObservationEntity> findAllByLearnerId(Long learnerId) {
        return find("learner.learnerId", learnerId).list();
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
