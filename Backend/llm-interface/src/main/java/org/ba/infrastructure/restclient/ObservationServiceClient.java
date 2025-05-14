package org.ba.infrastructure.restclient;

import java.util.Set;

import org.ba.infrastructure.restclient.dto.Observation;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;
import org.jboss.resteasy.reactive.RestResponse;

import dev.langchain4j.agent.tool.Tool;
import io.quarkus.websockets.next.PathParam;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.MediaType;

@RegisterRestClient(configKey = "observation-api")
public interface ObservationServiceClient {

    @GET
    @Path("/observations/learnerId/{learnerId}")
    @Produces(MediaType.APPLICATION_JSON)
    Set<Observation> getObservationByEventAndLeanrner(@PathParam("learnerId") Long learnerId, @QueryParam("eventId") Long eventId);
}