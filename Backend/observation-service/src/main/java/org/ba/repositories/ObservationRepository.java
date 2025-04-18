package org.ba.repositories;

import java.util.List;

import org.ba.entities.db.ObservationEntity;

import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class ObservationRepository implements PanacheRepositoryBase<ObservationEntity, Long> {
    public List<ObservationEntity> findAllByLearnerId(Long learnerId) {
        return find("learnerId", learnerId).list();
    }

    public List<Object[]> getEntriesCountPerLearnerId() {
        return getEntityManager().createNamedQuery("Observation.countByLearnerId", Object[].class).getResultList();
    }
}
