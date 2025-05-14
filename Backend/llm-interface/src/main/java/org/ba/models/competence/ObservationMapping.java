package org.ba.models.competence;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ObservationMapping {
    private String observation;
    private Competence competence;
    private Indicator indicator;
    private String explanation;
}

