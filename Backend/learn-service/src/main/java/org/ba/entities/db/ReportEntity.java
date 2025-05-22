package org.ba.entities.db;

import jakarta.persistence.Entity;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import jakarta.persistence.Column;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import java.time.LocalDateTime;

import org.ba.entities.ReportQuality;
import org.hibernate.annotations.JdbcType;
import org.hibernate.dialect.PostgreSQLEnumJdbcType;

import jakarta.persistence.ManyToOne;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ForeignKey;
import jakarta.validation.constraints.NotEmpty;
import lombok.NoArgsConstructor;
import jakarta.persistence.PrePersist;

@Entity(name = "Report")
@Table(name = "report")
@Getter
@Setter
@ToString
@NoArgsConstructor
// @EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class ReportEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "report_id")
    //@EqualsAndHashCode.Include
    private Long reportId;

    @Column(name = "created_date")
    private LocalDateTime createdDateTime;

    @PrePersist
    public void prePresist() {
        if (createdDateTime == null) {
            createdDateTime = LocalDateTime.now();
        }
    }

    @ManyToOne
    @JoinColumn(name = "learner_id", foreignKey = @ForeignKey(name = "fk_report_learner"), referencedColumnName = "learner_id", nullable = false)
    private LearnerEntity learner;

    @ManyToOne
    @JoinColumn(name = "event_id", foreignKey = @ForeignKey(name = "fk_report_event"), referencedColumnName = "event_id", nullable = false)
    private EventEntity event;

    @Column(name = "report_data", columnDefinition = "TEXT")
    @NotEmpty
    private String reportData;

    @Enumerated
    @Column(
        name = "report_quality",
        nullable = true
    )
    @JdbcType(PostgreSQLEnumJdbcType.class)
    private ReportQuality reportQuality;
}
