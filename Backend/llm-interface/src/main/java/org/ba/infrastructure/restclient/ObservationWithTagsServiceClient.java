package org.ba.infrastructure.restclient;

import java.util.Set;

import org.ba.infrastructure.restclient.dto.ObservationWithTags;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

import io.quarkus.websockets.next.PathParam;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.MediaType;

@RegisterRestClient(configKey = "observation-with-tags-api")
public interface ObservationWithTagsServiceClient {
    @GET
    @Path("/observations/tags/learner/{learnerId}")
    @Produces(MediaType.APPLICATION_JSON)
    Set<ObservationWithTags> getObservationsWithTagsByEventAndLeanrner(@PathParam("learnerId") Long learnerId, @QueryParam("eventId") Long eventId);
}
