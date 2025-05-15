package org.ba.service.restclient;

import org.ba.infrastructure.restclient.ReportServiceClient;
import org.ba.infrastructure.restclient.dto.Report;
import org.eclipse.microprofile.rest.client.inject.RestClient;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class ReportService {
    @Inject
    @RestClient
    ReportServiceClient reportServiceClient;

    public void saveResponse(Report report) {
        reportServiceClient.saveResponse(report);
    }
}
