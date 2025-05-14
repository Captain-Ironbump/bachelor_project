package org.ba;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

import org.ba.infrastructure.restclient.dto.Event;
import org.ba.infrastructure.restclient.dto.Learner;
import org.ba.infrastructure.restclient.dto.Observation;
import org.ba.models.DataFetcherResult;
import org.ba.models.competence.Competence;
import org.ba.models.competence.ObservationMapping;
import org.ba.service.bots.CompetencMapperAgent;
import org.ba.service.bots.CompetenceLLMService;
import org.ba.service.bots.CompetenceMapperAgent;
import org.ba.service.bots.CompetenceRaterAgent;
import org.ba.service.bots.CompetenceSummaryAgent;
import org.ba.service.bots.FormGeneratorAgent;
import org.ba.service.bots.newAgents.CompetenceRetrieverAgent;
import org.ba.service.bots.newAgents.DataFetcherAgent;
import org.ba.service.bots.newAgents.IndicatorMappingAgent;
import org.ba.service.bots.newAgents.RatingAgent;
import org.ba.service.restclient.EventService;
import org.ba.service.restclient.LearnerService;
import org.ba.service.restclient.ObservationService;
import org.ba.utils.ModelResponseTrimmer;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.netty.util.concurrent.CompleteFuture;
import io.quarkus.logging.Log;
import io.quarkus.websockets.next.PathParam;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/reporttrigger")
public class TriggerReportResource {

    @Inject
    @Named("objectMapper")
    ObjectMapper objectMapper;
    
    @Inject
    ObservationService observationService;

    @Inject
    EventService eventService;

    @Inject
    LearnerService learnerService;

    @Inject
    CompetenceLLMService competenceLLMService;

    @Inject
    CompetencMapperAgent competencMapperAgent;

    @Inject
    CompetenceRaterAgent competenceRaterAgent;

    @Inject
    CompetenceSummaryAgent competenceSummaryAgent;

    @Inject
    FormGeneratorAgent formGeneratorAgent;


    @Inject
    DataFetcherAgent dataFetcherAgent;
    @Inject
    CompetenceMapperAgent competenceMapperAgent;

    @Inject
    CompetenceRetrieverAgent competenceRetrieverAgent;
    @Inject
    IndicatorMappingAgent indicatorMappingAgent;
    @Inject
    RatingAgent ratingAgent;

    @GET
    @Path("/old/event/{eventId}/learner/{learnerId}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response triggerReportGenerationOld(@PathParam("eventId") Long eventId, @PathParam("learnerId") Long learnerId, @QueryParam("length") String responseLength) {
        try {
            CompletableFuture<Set<Observation>> observationsFuture = 
                CompletableFuture.supplyAsync(() -> observationService.getObservationByEventAndLeanrner(eventId, learnerId));

            CompletableFuture<Event> eventFuture = 
                CompletableFuture.supplyAsync(() -> eventService.getEventById(eventId));

            CompletableFuture<Learner> learnerFuture = 
                CompletableFuture.supplyAsync(() -> learnerService.getLearnerById(learnerId));
        
            CompletableFuture<Void> combinedFuture = CompletableFuture.allOf(observationsFuture, eventFuture, learnerFuture);
            combinedFuture.join();

            Log.info(observationsFuture.get());

            List<String> observations = observationsFuture.get()
                .stream()
                .map(obs -> new String(obs.getRawObservation(), StandardCharsets.UTF_8))
                .collect(Collectors.toList());
            Event event = eventFuture.get();
            Learner learner = learnerFuture.get();

            Log.info(observations);

            String response = competenceLLMService.createForm(String.format("%1$s %2$s", learner.getFirstName(), learner.getLastName()), event.getName(), observations, responseLength);

            return Response.ok().entity(response).build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                           .entity("Error generating report: " + e.getMessage())
                           .build();
        }
    }


    @GET
    @Path("/event/{eventId}/learner/{learnerId}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response triggerReportGeneration(@PathParam("eventId") Long eventId, @PathParam("learnerId") Long learnerId, @QueryParam("length") String responseLength) {
        try {
            Log.info("Bin da");
            CompletableFuture<Set<Observation>> observationsFuture = 
                CompletableFuture.supplyAsync(() -> observationService.getObservationByEventAndLeanrner(eventId, learnerId));

            CompletableFuture<Event> eventFuture = 
                CompletableFuture.supplyAsync(() -> eventService.getEventById(eventId));

            CompletableFuture<Learner> learnerFuture = 
                CompletableFuture.supplyAsync(() -> learnerService.getLearnerById(learnerId));
        
            CompletableFuture<Void> combinedFuture = CompletableFuture.allOf(observationsFuture, eventFuture, learnerFuture);
            combinedFuture.join();
            Log.info("Bin da 2");
            Log.info(observationsFuture.get());

            List<String> observations = observationsFuture.get()
                .stream()
                .map(obs -> new String(obs.getRawObservation(), StandardCharsets.UTF_8))
                .collect(Collectors.toList());
            Event event = eventFuture.get();
            Learner learner = learnerFuture.get();

            Log.info(observations);

            String competenceMapperResponse = competencMapperAgent.matchObservationsToIndicators(event.getName(), observations);
            Log.info(competenceMapperResponse);
            String competenceRaterResponse = competenceRaterAgent.rateObservationsByIndicator(event.getName(), competenceMapperResponse);
            Log.info(competenceRaterResponse);
            String competenceSummarizerResponse = competenceSummaryAgent.generateSummary(responseLength, competenceRaterResponse);
            Log.info(competenceSummarizerResponse);
            String competenceMarkdownGeneratorResponse = formGeneratorAgent.assembleMarkdown(String.format("%1$s %2$s", learner.getFirstName(), learner.getLastName()), event.getName(), competenceSummarizerResponse, competenceMapperResponse, competenceRaterResponse, "");
            
            return Response.ok().entity(competenceMarkdownGeneratorResponse).build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                           .entity("Error generating report: " + e.getMessage())
                           .build();
        }
    }

    @GET
    @Path("/new/event/{eventId}/learner/{learnerId}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response triggerReport(@PathParam("eventId") Long eventId, @PathParam("learnerId") Long learnerId, @QueryParam("length") String responseLength) {
        try {
            String response = dataFetcherAgent.fetchData(learnerId, eventId);
            Log.info(response);
            DataFetcherResult deserialized = objectMapper.readValue(ModelResponseTrimmer.trimThinking(response), DataFetcherResult.class);
            Log.info(deserialized);

            String secondAgent = competenceRetrieverAgent.getCompetences(deserialized.getEvent());
            Log.info(secondAgent);
            List<Competence> competences = objectMapper.readValue(
                ModelResponseTrimmer.trimThinking(secondAgent),
                new TypeReference<List<Competence>>() {}
            );

            String thirdAgent = 
                indicatorMappingAgent.mapObservationsToIndicators(
                    deserialized.getObservations().stream()
                        .map(obs -> new String(obs.getRawObservation(), StandardCharsets.UTF_8))
                        .collect(Collectors.toList()),
                        competences);
            Log.info(thirdAgent);
            List<ObservationMapping> obsMapping = objectMapper.readValue(
                ModelResponseTrimmer.trimThinking(thirdAgent),
                new TypeReference<List<ObservationMapping>>() {}
            );
            String fourthAgent = ratingAgent.createRatings(obsMapping);
            Log.info(fourthAgent);

            String fifthAgent = competenceSummaryAgent.generateSummary(responseLength, fourthAgent);
            Log.info(fifthAgent);

            String competenceMarkdownGeneratorResponse = formGeneratorAgent.assembleMarkdown(
                new String(deserialized.getLearner().getFirstName() + " " + deserialized.getLearner().getLastName()),
                deserialized.getEvent().getName(),
                fifthAgent,
                obsMapping.toString(),
                fourthAgent,
                secondAgent
            );

            // markdown creator --> needs: 1. DataFetcherResult, 2. Competences from RAG, 3. Summary 

            return Response.ok().entity(ModelResponseTrimmer.trimThinking(competenceMarkdownGeneratorResponse)).build();
        } catch (Exception e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                           .entity("Error generating report: " + e.getMessage())
                           .build();
        }
    }
}
