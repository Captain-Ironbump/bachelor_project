package org.ba.entities.db;

import java.time.LocalDateTime;
import java.util.Set;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
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
import jakarta.persistence.SecondaryTable;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Entity(name = "Observation")
@Table(name = "observation")
@Data
@NamedQuery(
    name = "Observation.countByLearnerId",
    query = "SELECT o.learner.learnerId, COUNT(o) FROM Observation o GROUP BY o.learner.learnerId"
)
public class ObservationEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "observation_id")
    private Long observationId;

    @Column(name = "created_date")
    private LocalDateTime createdDateTime;

    @PrePersist
    public void prePresist() {
        if (createdDateTime == null) {
            createdDateTime = LocalDateTime.now();
        }
    }

    @Column(name = "raw_observation")
    @NotEmpty
    @Lob 
    private byte[] rawObservation;

    @ManyToOne
    @JoinColumn(name = "learner_id", referencedColumnName = "learner_id", nullable = false, foreignKey = @ForeignKey(name = "fk_learner_id"))
    private LearnerEntity learner;

    @ManyToMany
    @JoinTable(
        name = "observation_tags",
        joinColumns = @JoinColumn(name = "observation_id", referencedColumnName = "observation_id"),
        inverseJoinColumns = @JoinColumn(name = "tag", referencedColumnName = "tag")
    )
    private Set<TagEntity> tags;
}
