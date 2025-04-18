package org.ba;

import java.net.URI;

import org.ba.core.TagService;
import org.ba.entities.dto.TagDTO;
import org.eclipse.microprofile.openapi.annotations.enums.SchemaType;
import org.eclipse.microprofile.openapi.annotations.media.Content;
import org.eclipse.microprofile.openapi.annotations.media.Schema;
import org.eclipse.microprofile.openapi.annotations.responses.APIResponse;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;

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

@Path("/tags")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Tag(name = "tag", description = "Tag with color")
@AllArgsConstructor
public class TagResource {
    @Inject
    TagService service;
    
    @GET
    @APIResponse(
        responseCode = "200",
        description = "Get all Tags",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.ARRAY, implementation = TagDTO.class)
        )
    )
    public Response getAllTags() {
        return Response.ok(this.service.fetchAllTags()).build();
    }

    @POST
    @APIResponse(
        responseCode = "201",
        description = "Tag created",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.OBJECT, implementation = TagDTO.class)
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
    public Response create(@NotNull @Valid TagDTO tag, @Context UriInfo uriInfo) {
        try {
            service.save(tag);
            URI uri = uriInfo.getAbsolutePathBuilder().path(tag.getTag()).build();
            return Response.created(uri).entity(tag).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Exception thrown: ", e.getMessage()))
                    .build();
        }
    }

}
