package org.ba.infrastructure.restclient;

import org.ba.infrastructure.restclient.dto.Event;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;
import org.jboss.resteasy.reactive.RestResponse;

import dev.langchain4j.agent.tool.Tool;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@RegisterRestClient(configKey = "event-api")
public interface EventServiceClient {

    @GET
    @Path("/events/{eventId}")
    @Produces(MediaType.APPLICATION_JSON)
    Event getEventById(@PathParam("eventId") Long eventId);
}