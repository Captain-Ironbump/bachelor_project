package org.ba.service.restclient;

import java.util.Set;

import org.ba.infrastructure.restclient.ObservationServiceClient;
import org.ba.infrastructure.restclient.dto.Observation;
import org.eclipse.microprofile.rest.client.inject.RestClient;

import dev.langchain4j.agent.tool.Tool;
import dev.langchain4j.service.V;
import io.quarkus.logging.Log;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class ObservationService {
    
    @Inject
    @RestClient
    ObservationServiceClient observationServiceClient;

    @Tool("fetches a list of Observation Objects by the given eventId and learnerId")
    public Set<Observation> getObservationByEventAndLeanrner(@V("eventId") Long eventId, @V("learnerId") Long learnerId) {
        Set<Observation> observations = observationServiceClient.getObservationByEventAndLeanrner(learnerId, eventId);
        Log.info(observations);
        return observations;
    }
}
