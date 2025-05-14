package org.ba;

import java.net.URI;
import java.util.List;

import org.ba.core.ObservationTagService;
import org.ba.entities.db.ObservationEntity;
import org.ba.entities.dto.ObservationDTO;
import org.ba.entities.dto.ObservationWithTagsDTO;
import org.ba.entities.dto.TagDTO;
import org.ba.exceptions.LearnerNotFoundException;
import org.eclipse.microprofile.openapi.annotations.enums.SchemaType;
import org.eclipse.microprofile.openapi.annotations.media.Content;
import org.eclipse.microprofile.openapi.annotations.media.Schema;
import org.eclipse.microprofile.openapi.annotations.parameters.RequestBody;
import org.eclipse.microprofile.openapi.annotations.responses.APIResponse;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;
import org.jboss.resteasy.reactive.RestPath;

import io.smallrye.common.constraint.NotNull;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.PATCH;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.UriInfo;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import jakarta.ws.rs.QueryParam;

@Path("/observations/tags")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Tag(name = "observation_tags")
@AllArgsConstructor
@Slf4j
public class ObservationTagResource {
    @Inject
    ObservationTagService service;

    @POST
    @APIResponse(
        responseCode = "201",
        description = "Observation created",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.OBJECT, implementation = ObservationDTO.class)
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
    public Response saveObsWithTags(@NotNull @Valid ObservationWithTagsDTO request, @Context UriInfo uriInfo) {
        try {
            ObservationDTO observation = request.getObservationDTO();
            List<TagDTO> tags = request.getTags();
            log.info(observation.toString());
            log.info(tags.toString());
            service.saveObservationWithTag(observation, tags);
            URI uri = uriInfo.getAbsolutePathBuilder().path(Long.toString(observation.getObservationId())).build();
            return Response.created(uri).entity(observation).build();
        } catch (LearnerNotFoundException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Invalid Observation", e.getMessage()))
                    .build();
        }
    }

    @PATCH
    @Path("/{observationId}")
    @APIResponse(
        responseCode = "200",
        description = "Observation patched",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.OBJECT, implementation = ObservationDTO.class)
        )
    )
    @APIResponse(
        responseCode = "400",
        description = "Invalid Observation",
        content = @Content(mediaType = MediaType.APPLICATION_JSON)
    )
    public Response updateObsWithTags(@RestPath Long observationId, @RequestBody ObservationWithTagsDTO request, @Context UriInfo uriInfo) {
        try {
            ObservationDTO observation = request.getObservationDTO();
            if (observation == null) {
                observation = new ObservationDTO();
            }
            List<TagDTO> tags = request.getTags();
            service.patchObservationWithTag(observationId, observation, tags);
            URI uri = uriInfo.getAbsolutePathBuilder().path(Long.toString(observation.getObservationId())).build();
            return Response.created(uri).entity(observation).build();
        } catch (WebApplicationException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Invalid Parameters", e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/learner/{learnerId}")
    public Response getObservationsWithTagsByLearnerAndEvent(@RestPath Long learnerId, @QueryParam("eventId") Long eventId, @QueryParam("sort") String sortField, @QueryParam("order") String sortOrder, @QueryParam("timespanInDays") int timespanInDays) {
        try {
            List<ObservationWithTagsDTO> observationWithTagsDTOs = this.service.fetchObservationsWithTagsByLearnerAndEvent(learnerId, sortField, sortOrder, eventId, timespanInDays);
            return Response.ok().entity(observationWithTagsDTOs).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Invalid Parameters", e.getMessage()))
                .build();
        }
    }

    @GET
    @Path("/observation/{observationId}")
    public Response getObservationWithTagsById(@RestPath Long observationId) {
        try {
            ObservationWithTagsDTO dto = this.service.fetchObservationWithTagsById(observationId);
            return Response.ok().entity(dto).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Invalid Parameters", e.getMessage()))
                .build(); 
        }
    }
}
