package org.ba.core.messages.queues.shared.events;

import java.time.OffsetDateTime;
import java.util.List;

import org.ba.entities.dto.ObservationDTO;
import org.ba.entities.dto.TagDTO;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GetObservationDetailEvent {
    private EventType type;
    private ObservationDTO observation;
    private List<TagDTO> tags;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    private OffsetDateTime timeStamp;
}
