package org.ba;

import java.net.URI;
import java.util.List;
import java.util.Map;

import org.ba.core.ObservationService;
import org.ba.entities.dto.ObservationDTO;
import org.ba.exceptions.LearnerNotFoundException;
import org.eclipse.microprofile.openapi.annotations.media.Content;
import org.eclipse.microprofile.openapi.annotations.media.Schema;
import org.eclipse.microprofile.openapi.annotations.responses.APIResponse;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;
import org.eclipse.microprofile.openapi.annotations.enums.SchemaType;
import org.jboss.resteasy.reactive.RestPath;

import io.smallrye.common.constraint.NotNull;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.UriInfo;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Path("/observations")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Tag(name = "observation", description = "Observations per Learner")
@AllArgsConstructor
@Slf4j
public class ObservationResource {
    @Inject
    ObservationService service;

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
    public Response create(@NotNull @Valid ObservationDTO observation, @Context UriInfo uriInfo) {
        try {
            service.save(observation);
            URI uri = uriInfo.getAbsolutePathBuilder().path(Long.toString(observation.getObservationId())).build();
            return Response.created(uri).entity(observation).build();
        } catch (LearnerNotFoundException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Invalid Observation", e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/learnerId/{learnerId}")
    @APIResponse(
        responseCode = "200",
        description = "Get All Observations by the provided Learner ID",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.ARRAY, implementation = ObservationDTO.class)
        )
    )
    public Response getAllByLearnerId(@RestPath Long learnerId) {
        return Response.ok(service.findAllByLearnerId(learnerId)).build();
    }

    @GET
    @Path("/count-map")
    @APIResponse(
        responseCode = "200",
        description = "Get For each Learner the number of Observations",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.OBJECT, implementation = Map.class)
        )
    )
    public Response getCountMap(@QueryParam("timeSpanInDays") Integer timeSpamInDays, @QueryParam("learners") List<Integer> learners) {
        
        return Response.ok(service.getCountMapPerLearnerId(timeSpamInDays, learners)).build();
    }
}
