package org.ba.models.shared.commands;

public enum CommandType {
    GET_OBSERVATION_DETAIL_COMMAND("GetObservationDetailCommand");

    public final String type;

    private CommandType(String type) {
        this.type = type;
    }
}
