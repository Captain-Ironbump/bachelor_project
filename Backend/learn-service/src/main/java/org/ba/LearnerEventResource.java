package org.ba;

import jakarta.ws.rs.Path;

import org.ba.core.LearnerEventService;
import org.ba.entities.dto.LearnerDTO;
import org.eclipse.microprofile.openapi.annotations.enums.SchemaType;
import org.eclipse.microprofile.openapi.annotations.media.Content;
import org.eclipse.microprofile.openapi.annotations.media.Schema;
import org.eclipse.microprofile.openapi.annotations.responses.APIResponse;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;
import org.jboss.resteasy.reactive.RestPath;
import jakarta.inject.Inject;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Path("/learners/event")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Tag(name = "learners_event", description = "learners with event association")
@AllArgsConstructor
@Slf4j
public class LearnerEventResource {
    @Inject
    LearnerEventService service;

    @GET
    @Path("/{eventId}")
    @APIResponse(
        responseCode = "200",
        description = "Get All Learners by Event ID",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.ARRAY, implementation = LearnerDTO.class)
        )
    )
    public Response getAllLearnersByEventId(@RestPath Long eventId) {
        return Response.ok().entity(this.service.getLearnersByEventId(eventId)).build();
    }
}
