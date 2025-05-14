package org.ba;

import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.Produces;
import jakarta.inject.Inject;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.UriInfo;
import org.ba.core.ReportService;
import org.ba.entities.dto.ReportDTO;
import org.eclipse.microprofile.openapi.annotations.enums.SchemaType;
import org.eclipse.microprofile.openapi.annotations.media.Content;
import org.eclipse.microprofile.openapi.annotations.media.Schema;
import org.eclipse.microprofile.openapi.annotations.responses.APIResponse;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;
import io.smallrye.common.constraint.NotNull;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.QueryParam;
import java.net.URI;

@Path("/reports")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Tag(name = "reports", description = "Reports API")
@AllArgsConstructor
@Slf4j
public class ReportResource {
    @Inject
    ReportService service;

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @APIResponse(
        responseCode = "201",
        description = "Report Created",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.OBJECT, implementation = ReportDTO.class)
        )
    )
    @APIResponse(
        responseCode = "400",
        description = "Invalid Report",
        content = @Content(mediaType = MediaType.APPLICATION_JSON)
    )
    public Response createReport(@NotNull ReportDTO report, @Context UriInfo uriInfo) {
        try {
            log.info("Report created with ID: {}", report.toString());
            service.saveReport(report);
            URI uri = uriInfo.getAbsolutePathBuilder().path(Long.toString(report.getReportId())).build();
            return Response.created(uri).entity(report).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Failed to create report", e.getMessage()))
                .build();
        }
    }

    @GET
    @Path("/{reportId}")
    @APIResponse(
        responseCode = "200",
        description = "Get Report by ID",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.OBJECT, implementation = ReportDTO.class)
        )
    )
    public Response getReportById(@PathParam("reportId") Long reportId) {
        return Response.ok(service.getReportById(reportId)).build();
    }

    @GET
    @Path("/learner/{learnerId}")
    @APIResponse(
        responseCode = "200",
        description = "Get Reports by Learner and Event",
        content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(type = SchemaType.ARRAY, implementation = ReportDTO.class)
        )
    )
    public Response getReportsByLearnerAndEvent(@PathParam("learnerId") Long learnerId, @QueryParam("eventId") Long eventId, @QueryParam("sort") String sortField, @QueryParam("order") String sortOrder, @QueryParam("timespanInDays") int timespanInDays) {
        return Response.ok(service.findAllReportsByLearnerAndEvent(learnerId, eventId, sortField, sortOrder, timespanInDays)).build();
    }
}
