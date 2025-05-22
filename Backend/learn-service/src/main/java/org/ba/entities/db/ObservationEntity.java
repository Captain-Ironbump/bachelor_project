package org.ba.entities.db;

import java.time.LocalDateTime;
import java.util.Set;

import org.hibernate.engine.jdbc.env.internal.LobTypes;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotEmpty;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity(name = "Observation")
@Table(name = "observation")
@Getter
@Setter
@NoArgsConstructor
@ToString(exclude = {"tags", "learner", "event"})
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@NamedQuery(
    name = "Observation.countByLearnerId",
    query = "SELECT o.learner.learnerId, COUNT(o) FROM Observation o GROUP BY o.learner.learnerId"
)
public class ObservationEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "observation_id")
    @EqualsAndHashCode.Include
    private Long observationId;

    @Column(name = "created_date")
    private LocalDateTime createdDateTime;

    @PrePersist
    public void prePresist() {
        if (createdDateTime == null) {
            createdDateTime = LocalDateTime.now();
        }
    }

    @Column(name = "raw_observation", columnDefinition = "TEXT")
    @NotEmpty
    private String rawObservation;

    @ManyToOne
    @JoinColumn(name = "learner_id", referencedColumnName = "learner_id", nullable = false, foreignKey = @ForeignKey(name = "fk_learner_id"))
    private LearnerEntity learner;

    @ManyToOne
    @JoinColumn(name = "event_id", referencedColumnName = "event_id", nullable = false, foreignKey = @ForeignKey(name = "fk_event_id"))
    private EventEntity event;

    @ManyToMany
    @JoinTable(
        name = "observation_tags",
        joinColumns = @JoinColumn(name = "observation_id", referencedColumnName = "observation_id"),
        inverseJoinColumns = @JoinColumn(name = "tag", referencedColumnName = "tag")
    )
    private Set<TagEntity> tags;
}
