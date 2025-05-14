package org.ba.entities.db;

import java.util.Set;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity(name = "Event")
@Table(name = "event")
@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@ToString(exclude = {"learners"})
@NamedQuery(
    name = "Event.getWithLearnersCount",
    query = "SELECT e.name, e.eventId, COUNT(l) AS learnerCount " +
            "FROM Event e " +
            "LEFT JOIN e.learners l " +
            "GROUP BY e.eventId, e.name"
)
public class EventEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "event_id")
    @EqualsAndHashCode.Include
    private Long eventId;

    @Column(name = "name")
    private String name;

    @ManyToMany(mappedBy = "events")
    private Set<LearnerEntity> learners;
}
