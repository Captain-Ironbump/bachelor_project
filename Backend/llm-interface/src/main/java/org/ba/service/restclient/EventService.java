package org.ba.service.restclient;

import org.ba.infrastructure.restclient.EventServiceClient;
import org.ba.infrastructure.restclient.dto.Event;
import org.eclipse.microprofile.rest.client.inject.RestClient;

import dev.langchain4j.agent.tool.Tool;
import dev.langchain4j.service.V;
import io.quarkus.logging.Log;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class EventService {
    
    @Inject
    @RestClient
    EventServiceClient eventServiceClient;

    @Tool("Fetches the Event Object of a given eventId")
    public Event getEventById(@V("learnerId") Long eventId) {
        Event event = eventServiceClient.getEventById(eventId);
        Log.info(event);
        return event;
    }
}
