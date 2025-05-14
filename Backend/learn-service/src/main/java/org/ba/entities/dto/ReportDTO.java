package org.ba.entities.dto;

import io.smallrye.common.constraint.NotNull;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.Getter;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
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
