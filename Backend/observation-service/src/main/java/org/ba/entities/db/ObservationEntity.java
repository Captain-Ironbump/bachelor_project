package org.ba.entities.db;

import java.time.LocalDateTime;
import io.smallrye.common.constraint.NotNull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Entity(name = "Observation")
@Table(name = "observation")
@Data
@NamedQuery(
    name = "Observation.countByLearnerId",
    query = "SELECT o.learnerId, COUNT(o) FROM Observation o GROUP BY o.learnerId"
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

    @Column(name = "learner_id")
    @NotNull
    private Long learnerId;
}
