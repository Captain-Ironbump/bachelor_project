package org.ba;

import java.net.URI;

import org.ba.core.LearnerService;
import org.ba.entities.dto.LearnerDTO;
import org.eclipse.microprofile.openapi.annotations.enums.SchemaType;
import org.eclipse.microprofile.openapi.annotations.media.Content;
import org.eclipse.microprofile.openapi.annotations.media.Schema;
import org.eclipse.microprofile.openapi.annotations.responses.APIResponse;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;
import org.jboss.resteasy.reactive.RestPath;

import io.smallrye.common.constraint.NotNull;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.UriInfo;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Path("/api/learners")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Tag(name = "learner", description = "Learners for the application")
@AllArgsConstructor
@Slf4j
public class LearnerResource {
    @Inject
    LearnerService service;

    @POST
    @APIResponse(
        responseCode = "201",
        description = "Learner Created",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.OBJECT, implementation = LearnerDTO.class)
        )
    )
    @APIResponse(
        responseCode = "400",
        description = "Invalid Learner",
        content = @Content(mediaType = MediaType.APPLICATION_JSON)
    )
    public Response create(@NotNull @Valid LearnerDTO learner, @Context UriInfo uriInfo) {
        service.save(learner);
        URI uri = uriInfo.getAbsolutePathBuilder().path(Long.toString(learner.getLearnerId())).build();
        return Response.created(uri).entity(learner).build();
    }

    @GET
    @Path("/{learnerId}")
    @APIResponse(
        responseCode = "200",
        description = "Get Learner Detail by ID",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.OBJECT, implementation = LearnerDTO.class)
        )
    )
    public Response getLearnerById(@RestPath Long learnerId) {
        return Response.ok(service.findById(learnerId)).build();
    }

    @GET
    @APIResponse(
        responseCode = "200",
        description = "Get All Learners",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.ARRAY, implementation = LearnerDTO.class)
        )
    )
    public Response get() {
        return Response.ok(service.findAll()).build();
    }
}
