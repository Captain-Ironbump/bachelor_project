package org.ba.repositories;

import org.ba.entities.db.ReportEntity;
import org.ba.utils.FieldValidator;

import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDateTime;

@ApplicationScoped
public class ReportRepository implements PanacheRepositoryBase<ReportEntity, Long>  {

    public List<ReportEntity> findAllByLearnerAndEvent(Long learnerId, Long eventId, String sortField, String sortOrder, int timespanInDays) {
        StringBuilder query = new StringBuilder("learner.learnerId = :learnerId");
        Map<String, Object> params = new HashMap<>();
        String sortBy = "createdDateTime"; // Default field is createdDateTime
        String order = "ASC";
        params.put("learnerId", learnerId);

        if (sortField != null && !sortField.isEmpty() && FieldValidator.isValidSortField(sortField, ReportEntity.class)) {
            sortBy = sortField;
        }

        if (sortOrder != null) {
            if (sortOrder.equalsIgnoreCase("DESC")) {
                order = "DESC";
            } else if (sortOrder.equalsIgnoreCase("ASC")) {
                order = "ASC";
            }
        }

        if (eventId != null) {
            query.append(" AND event.eventId = :eventId");
            params.put("eventId", eventId);
        }

        if (timespanInDays > 0) {
            LocalDateTime end = LocalDateTime.now();
            LocalDateTime start = end.minusDays(timespanInDays);
            query.append(" AND createdDateTime BETWEEN :start AND :end");
            params.put("start", start);
            params.put("end", end);
        }

        return find(query.toString() + " ORDER BY " + sortBy + " " + order, params).list();
    }
    
}
