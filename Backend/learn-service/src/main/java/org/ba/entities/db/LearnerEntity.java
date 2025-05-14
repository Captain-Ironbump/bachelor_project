package org.ba.entities.db;

import java.util.Set;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotEmpty;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity(name = "Learner")
@Table(name = "learner")
@ToString(exclude = {"events"})
@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class LearnerEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "learner_id")
    @EqualsAndHashCode.Include
    private Long learnerId;

    @Column(name = "first_name")
    @NotEmpty
    private String firstName;

    @Column(name = "last_name")
    @NotEmpty
    private String lastName;

    @ManyToMany
    @JoinTable(
        name = "learner_event",
        joinColumns = @JoinColumn(name = "learner_id", referencedColumnName = "learner_id"),
        inverseJoinColumns = @JoinColumn(name = "event_id", referencedColumnName = "event_id")
    )
    private Set<EventEntity> events;
}
