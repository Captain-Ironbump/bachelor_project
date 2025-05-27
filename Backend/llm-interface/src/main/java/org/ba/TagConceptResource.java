package org.ba;


import org.ba.service.TagConceptService;

import io.quarkus.websockets.next.PathParam;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.Response;

@Path("/tag-concept")
public class TagConceptResource {

    @Inject
    TagConceptService tagConceptService;

    @GET
    @Path("/competence/learners/{learnerId}")
    public Response generateReportWithTagConcept(@PathParam("learnerId") Long learnerId, @QueryParam("eventId") Long eventId, @QueryParam("reportLength") String reportLength) {
        try {
            String response = tagConceptService.tagConcept(learnerId, eventId, reportLength);
            return Response.accepted().entity(response).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error generating report with tag concept: " + e.getMessage())
                    .build();
        }
    }

    @GET
    @Path("/general/learners/{learnerId}")
    public Response generateReportWithGeneralTagConcept(@PathParam("learnerId") Long learnerId, @QueryParam("eventId") Long eventId, @QueryParam("reportLength") String reportLength) {
        try {
            String response = tagConceptService.generalTagConcept(learnerId, eventId, reportLength);
            return Response.accepted().entity(response).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error generating report with tag concept: " + e.getMessage())
                    .build();
        }
    }

}
