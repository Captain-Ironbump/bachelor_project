package org.ba.models.shared.events;

public enum EventType {
    GET_OBSERVATION_DETAIL_EVENT("GetObservationDetailEvent");

    public final String type;

    private EventType(String type) {
        this.type = type;
    }
}
