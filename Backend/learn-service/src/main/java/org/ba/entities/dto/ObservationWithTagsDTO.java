package org.ba.entities.dto;

import java.util.List;

import lombok.Data;

@Data
public class ObservationWithTagsDTO {
    ObservationDTO observationDTO;
    List<TagDTO> tags;
}
