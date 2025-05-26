package org.ba.infrastructure.restclient.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class ObservationWithTags {
    Observation observationDTO;
    List<Tag> tags;
}