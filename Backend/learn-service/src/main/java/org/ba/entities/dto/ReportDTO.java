package org.ba.entities.dto;

import lombok.Data;
import io.smallrye.common.constraint.NotNull;
import jakarta.validation.constraints.NotEmpty;

@Data
public class ReportDTO {
    private Long reportId;
    @NotNull
    private Long learnerId;
    @NotNull
    private Long eventId;
    @NotEmpty
    private byte[] reportData;
    private String createdDateTime;
}
