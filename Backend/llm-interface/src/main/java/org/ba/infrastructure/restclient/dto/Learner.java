package org.ba.infrastructure.restclient.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Learner {
    private Long learnerId;
    private String firstName;
    private String lastName;
}