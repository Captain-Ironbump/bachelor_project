package org.ba.infrastructure.restclient.dto;

import java.util.List;

public class ObservationWithTags {
    private Observation observationDTO;
    private List<Tag> tags;

    public ObservationWithTags() {
    }

    public ObservationWithTags(Observation observationDTO, List<Tag> tags) {
        this.observationDTO = observationDTO;
        this.tags = tags;
    }

    public Observation getObservationDTO() {
        return observationDTO;
    }

    public void setObservationDTO(Observation observationDTO) {
        this.observationDTO = observationDTO;
    }

    public List<Tag> getTags() {
        return tags;
    }

    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }

    @Override
    public String toString() {
        return "ObservationWithTags(" +
                "observationDTO=" + observationDTO +
                ", tags=" + tags +
                ')';
    }
}