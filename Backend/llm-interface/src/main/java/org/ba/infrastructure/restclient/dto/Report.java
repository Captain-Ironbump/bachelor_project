package org.ba.infrastructure.restclient.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Report {
    private Long reportId;
    private LocalDateTime createdDateTime;
    private String reportData;
    private Long learnerId;
    private Long eventId;
}
