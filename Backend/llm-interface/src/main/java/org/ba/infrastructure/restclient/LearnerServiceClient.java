package org.ba.infrastructure.restclient;

import org.ba.infrastructure.restclient.dto.Learner;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;
import org.jboss.resteasy.reactive.RestResponse;

import dev.langchain4j.agent.tool.Tool;
import io.quarkus.websockets.next.PathParam;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@RegisterRestClient(configKey = "learner-api")
public interface LearnerServiceClient {
    
    @GET
    @Path("/learners/{learnerId}")
    @Produces(MediaType.APPLICATION_JSON)
    Learner getLearnerById(@PathParam("learnerId") Long learnerId);
}
