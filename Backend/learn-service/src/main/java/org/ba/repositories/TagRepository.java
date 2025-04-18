package org.ba.repositories;

import org.ba.entities.db.TagEntity;

import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class TagRepository implements PanacheRepositoryBase<TagEntity, String>{
    
}
