package org.ba.entities.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ObservationWithTagsDTO {
    ObservationDTO observationDTO;
    List<TagDTO> tags;
}
