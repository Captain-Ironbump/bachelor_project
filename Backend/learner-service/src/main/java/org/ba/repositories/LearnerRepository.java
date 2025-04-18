package org.ba.repositories;

import org.ba.entities.db.LearnerEntity;

import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class LearnerRepository implements PanacheRepositoryBase<LearnerEntity, Integer> {
     
}
