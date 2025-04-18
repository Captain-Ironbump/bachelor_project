package org.ba.entities.dto;

import java.time.LocalDateTime;

import io.smallrye.common.constraint.NotNull;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class ObservationDTO {
    private Long observationId;
    private LocalDateTime createdDateTime;
    @NotEmpty
    private byte[] rawObservation;
    @NotNull
    private Long learnerId;
}
