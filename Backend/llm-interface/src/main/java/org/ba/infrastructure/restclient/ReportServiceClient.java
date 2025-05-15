package org.ba.infrastructure.restclient;

import org.ba.infrastructure.restclient.dto.Report;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@RegisterRestClient(configKey = "report-api")
public interface ReportServiceClient {
    @POST
    @Path("/reports")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    void saveResponse(Report report);
}
