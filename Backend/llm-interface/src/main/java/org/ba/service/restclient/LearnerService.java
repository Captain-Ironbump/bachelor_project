package org.ba.service.restclient;

import org.ba.infrastructure.restclient.LearnerServiceClient;
import org.ba.infrastructure.restclient.dto.Learner;
import org.eclipse.microprofile.rest.client.inject.RestClient;

import dev.langchain4j.agent.tool.Tool;
import dev.langchain4j.service.V;
import io.quarkus.logging.Log;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class LearnerService {
    
    @Inject
    @RestClient
    LearnerServiceClient learnerServiceClient;

    @Tool("Finds the Learner Object of a given learnerId")
    public Learner getLearnerById(@V("learnerId") Long learnerId) {
        Learner learner = learnerServiceClient.getLearnerById(learnerId);
        Log.info(learner);
        return learner;
    }
}
