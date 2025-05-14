package org.ba.infrastructure.restclient.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Observation {
    private Long observationId;
    private LocalDateTime createdDateTime;
    private byte[] rawObservation;
    private Long learnerId;
    private Long eventId;
}