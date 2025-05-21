package org.ba.entities;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ReportQuality {
    HIGH("HIGH"),
    MEDIUM("MEDIUM"),
    LOW("LOW");

    private final String quality;
}
