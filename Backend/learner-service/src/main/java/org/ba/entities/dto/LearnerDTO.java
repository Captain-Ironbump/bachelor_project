package org.ba.entities.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class LearnerDTO {
    private Long learnerId;
    @NotNull
    private String firstName;
    @NotNull
    private String lastName;
}
