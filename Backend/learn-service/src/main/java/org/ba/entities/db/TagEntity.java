package org.ba.entities.db;

import java.util.Set;
import org.ba.entities.TagColor;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
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

    @Enumerated(EnumType.STRING)
    @Column(
        name = "tag_color",
        nullable = false,
        columnDefinition = "ENUM('RED', 'GREEN', 'BLUE', 'YELLOW', 'ORANGE', 'PURPLE', 'PINK', 'TEAL', 'CYAN', 'BROWN', 'BLACK', 'WHITE', 'GRAY', 'LIGHT_GRAY', 'DARK_GRAY', 'INDIGO', 'LIME', 'MAROON', 'NAVY', 'OLIVE')"
    )
    private TagColor color;

    @ManyToMany(mappedBy = "tags")
    private Set<ObservationEntity> observations;
}
