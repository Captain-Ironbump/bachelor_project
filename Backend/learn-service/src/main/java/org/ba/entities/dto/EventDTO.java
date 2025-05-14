package org.ba.entities.dto;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class EventDTO {
    private Long eventId;
    @NotEmpty
    private String name;
    private Integer learnerCount;
}
