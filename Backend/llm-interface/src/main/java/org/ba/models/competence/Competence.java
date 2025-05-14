package org.ba.models.competence;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Competence {
    private int number;
    private String name;
    private List<Indicator> indicators;
}
