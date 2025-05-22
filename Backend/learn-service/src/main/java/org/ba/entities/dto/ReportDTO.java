package org.ba.entities.dto;

import org.ba.entities.ReportQuality;

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
    private Long learnerId;
    private Long eventId;
    private String reportData;
    private String createdDateTime;
    private ReportQuality quality;
}
