package org.ba.service.restclient;

import java.util.Set;

import org.ba.infrastructure.restclient.ObservationWithTagsServiceClient;
import org.ba.infrastructure.restclient.dto.ObservationWithTags;
import org.eclipse.microprofile.rest.client.inject.RestClient;

import io.quarkus.logging.Log;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class ObservationWithTagsService {
    
    @Inject
    @RestClient
    ObservationWithTagsServiceClient observationWithTagsServiceClient;

    public Set<ObservationWithTags> getObservationsWithTagsByEventAndLeanrner(Long learnerId, Long eventId) {
        Set<ObservationWithTags> observationsWithTags = observationWithTagsServiceClient.getObservationsWithTagsByEventAndLeanrner(learnerId, eventId);
        Log.info(observationsWithTags.toString());
        return observationsWithTags;
    }
}
