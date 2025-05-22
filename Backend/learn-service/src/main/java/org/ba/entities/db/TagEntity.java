package org.ba.entities.db;

import java.util.Set;
import org.ba.entities.TagColor;
import org.hibernate.annotations.JdbcType;
import org.hibernate.dialect.PostgreSQLEnumJdbcType;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import lombok.Data;

@Entity(name = "Tag")
@Table(name = "tag")
@Data
public class TagEntity {
    @Id
    @Column(name = "tag", nullable = false, unique = true)
    private String tag;

    @Enumerated
    @Column(
        name = "tag_color",
        nullable = false
    )
    @JdbcType(PostgreSQLEnumJdbcType.class)
    private TagColor color;

    @ManyToMany(mappedBy = "tags")
    private Set<ObservationEntity> observations;
}
