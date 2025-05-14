package org.ba;

import java.net.URI;
import java.util.List;

import org.ba.core.EventService;
import org.ba.entities.dto.EventDTO;
import org.eclipse.microprofile.openapi.annotations.enums.SchemaType;
import org.eclipse.microprofile.openapi.annotations.media.Content;
import org.eclipse.microprofile.openapi.annotations.media.Schema;
import org.eclipse.microprofile.openapi.annotations.responses.APIResponse;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;
import org.jboss.resteasy.reactive.RestPath;

import io.smallrye.common.constraint.NotNull;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.UriInfo;

@Path("/events")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Tag(name = "events")
@AllArgsConstructor
@Slf4j
public class EventResource {
    @Inject
    EventService service;

    @GET
    @APIResponse(
        responseCode = "200",
        description = "fetch all Events",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.ARRAY, implementation = EventDTO.class)
        )
    )
    @APIResponse(
        responseCode = "400",
        description = "Invalid Observation",
        content = @Content(mediaType = MediaType.APPLICATION_JSON)
    )
    @APIResponse(
        responseCode = "500",
        description = "Internal Server Error",
        content = @Content(mediaType = MediaType.APPLICATION_JSON)
    )
    public Response fetchAllEvents(@QueryParam("withLearnerCount") Boolean withLearnerCount, @QueryParam("eventSortReason") String eventSortReason) {
        try {
            List<EventDTO> events = Boolean.TRUE.equals(withLearnerCount)
                ? service.getAllEventsWithLeanerCount(eventSortReason)
                : service.findAll();
            return Response.ok().entity(events).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Invalid Parameters", e.getMessage()))
                .build();
        }
    }

    @POST
    @APIResponse(
        responseCode = "201",
        description = "Event created",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.OBJECT, implementation = EventDTO.class)
        )
    )
    @APIResponse(
        responseCode = "400",
        description = "Invalid Observation",
        content = @Content(mediaType = MediaType.APPLICATION_JSON)
    )
    public Response save(@NotNull @Valid EventDTO event, @Context UriInfo uriInfo) {
        try {
            this.service.save(event);
            URI uri = uriInfo.getAbsolutePathBuilder().path(Long.toString(event.getEventId())).build();
            return Response.created(uri).entity(event).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Invalid Observation", e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/{eventId}")
    @APIResponse(
        responseCode = "200",
        description = "fetch Event By given Id",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.OBJECT, implementation = EventDTO.class)
        )
    )
    @APIResponse(
        responseCode = "400",
        description = "Invalid Observation",
        content = @Content(mediaType = MediaType.APPLICATION_JSON)
    )
    public Response getEventDetailsById(@RestPath Long eventId) {
        try {
            EventDTO event = this.service.getEventDetailById(eventId);
            return Response.ok().entity(event).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Invalid Parameters", e.getMessage()))
                .build();
        }
    }
}
