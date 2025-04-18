package org.ba.core;

import java.util.List;

import org.ba.core.mapper.TagMapper;
import org.ba.entities.db.TagEntity;
import org.ba.entities.dto.TagDTO;
import org.ba.exceptions.TagConstraintException;
import org.ba.repositories.TagRepository;
import org.hibernate.exception.ConstraintViolationException;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;

@ApplicationScoped
public class TagService {
    @Inject
    TagRepository repository;
    @Inject
    TagMapper mapper;

    @Transactional
    public void save(@Valid TagDTO tag) {
        TagEntity entity = this.mapper.toEntity(tag);
        try {
            this.repository.persist(entity);
        } catch (ConstraintViolationException e) {
            throw new TagConstraintException(e.getMessage());
        }
    }

    public List<TagDTO> fetchAllTags() {
        return this.mapper.toDomainList(this.repository.findAll().list());
    }

    public TagDTO fetchTagById(@Valid TagDTO tag) {
        return this.mapper.toDomain(this.repository.findById(tag.getTag()));
    }

    public boolean isTagSaved(@Valid TagDTO tag) {
        return (this.repository.findById(tag.getTag()) != null) ? true : false;
    }
}
