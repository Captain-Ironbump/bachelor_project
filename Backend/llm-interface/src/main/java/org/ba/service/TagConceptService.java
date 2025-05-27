package org.ba.service;

import java.util.List;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

import org.ba.infrastructure.bots.ollama.tag.concept.OllamaGenTagConceptAgent;
import org.ba.infrastructure.bots.ollama.tag.concept.OllamaTagConceptAgent;
import org.ba.infrastructure.bots.openai.tag.concept.OpenAIGenTagConceptAgent;
import org.ba.infrastructure.bots.openai.tag.concept.OpenAITagConceptAgent;
import org.ba.infrastructure.restclient.dto.Event;
import org.ba.infrastructure.restclient.dto.Learner;
import org.ba.infrastructure.restclient.dto.Observation;
import org.ba.infrastructure.restclient.dto.ObservationWithTags;
import org.ba.infrastructure.restclient.dto.Report;
import org.ba.service.restclient.EventService;
import org.ba.service.restclient.LearnerService;
import org.ba.service.restclient.ObservationWithTagsService;
import org.ba.service.restclient.ReportService;
import org.ba.utils.ModelResponseTrimmer;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import io.netty.util.concurrent.CompleteFuture;
import io.quarkus.arc.Arc;
import io.quarkus.arc.ManagedContext;
import io.quarkus.logging.Log;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import lombok.extern.slf4j.Slf4j;

@ApplicationScoped
@Slf4j
public class TagConceptService {
    @Inject
    OllamaTagConceptAgent ollamaTagConceptAgent;

    @Inject
    OllamaGenTagConceptAgent ollamaGenTagConceptAgent;

    @Inject
    OpenAITagConceptAgent openAITagConceptAgent;

    @Inject
    OpenAIGenTagConceptAgent openAIGenTagConceptAgent;

    @Inject
    @ConfigProperty(name = "use.openai", defaultValue = "false")
    boolean useOpenAI;

    @Inject
    LearnerService learnerService;

    @Inject
    EventService eventService;

    @Inject
    ObservationWithTagsService observationWithTagsService;

    @Inject
    ReportService reportService;


    public String tagConcept(Long learnerId, Long eventId, String reportLength) {
        CompletableFuture.runAsync(() -> {
            ManagedContext requestContext = Arc.container().requestContext();
            requestContext.activate();

            try {
                CompletableFuture<Set<ObservationWithTags>> observationsWithTags = 
                    CompletableFuture.supplyAsync(() -> observationWithTagsService.getObservationsWithTagsByEventAndLeanrner(learnerId, eventId));

                CompletableFuture<Event> eventFuture = 
                    CompletableFuture.supplyAsync(() -> eventService.getEventById(eventId));

                CompletableFuture<Learner> learnerFuture =
                    CompletableFuture.supplyAsync(() -> learnerService.getLearnerById(learnerId));

                CompletableFuture<Void> combinedFuture = CompletableFuture.allOf(observationsWithTags, eventFuture, learnerFuture);
                combinedFuture.join();

                List<String> observationsWithTagsSet = observationsWithTags.get()
                    .stream()
                    .map(obs -> obs.toString())
                    .collect(Collectors.toList());
                Event event = eventFuture.get();
                Learner learner = learnerFuture.get();
                String learnerName = learner.getFirstName() + " " + learner.getLastName();
                String eventName = event.getName();

                String report = "";

                if (useOpenAI) {
                    report = openAITagConceptAgent.orchestrateWithCompetenceReports(
                        learnerName,
                        eventName,
                        observationsWithTagsSet,
                        reportLength
                    );
                } else {
                    report = ollamaTagConceptAgent.orchestrateWithCompetenceReports(
                        learnerName,
                        eventName,
                        observationsWithTagsSet,
                        reportLength
                    );
                }
                report = ModelResponseTrimmer.trimThinking(report);
                log.info("Generated tagConcept report: " + report);
                reportService.saveResponse(Report.builder()
                    .reportData(report)
                    .eventId(event.getEventId())
                    .learnerId(learner.getLearnerId())
                    .build()
                );
            } catch (Exception e) {
                throw new RuntimeException("Error generating tagConcept report: " + e.getMessage(), e);
            }
        });
        return "Tag concept 'Concept Tags' report generation initiated. This can take a while!";
    }


    public String generalTagConcept(Long learnerId, Long eventId, String reportLength) {
        CompletableFuture.runAsync(() -> {
            ManagedContext requestContext = Arc.container().requestContext();
            requestContext.activate();

            try {
                CompletableFuture<Event> eventFuture = 
                    CompletableFuture.supplyAsync(() -> eventService.getEventById(eventId));

                CompletableFuture<Set<ObservationWithTags>> observationsWithTags = 
                    CompletableFuture.supplyAsync(() -> observationWithTagsService.getObservationsWithTagsByEventAndLeanrner(learnerId, eventId));

                CompletableFuture<Learner> learnerFuture =
                    CompletableFuture.supplyAsync(() -> learnerService.getLearnerById(learnerId));

                CompletableFuture<Void> combinedFuture = CompletableFuture.allOf(observationsWithTags, eventFuture, learnerFuture);
                combinedFuture.join();

                Event event = eventFuture.get();
                Learner learner = learnerFuture.get();
                List<String> observationsWithTagsSet = observationsWithTags.get()
                    .stream()
                    .map(obs -> obs.toString())
                    .collect(Collectors.toList());

                String learnerName = learner.getFirstName() + " " + learner.getLastName();
                String eventName = event.getName();

                String report = "";

                if (useOpenAI) {
                    report = openAIGenTagConceptAgent.orchestrateWithGenerallTagsReport(
                        learnerName,
                        eventName,
                        observationsWithTagsSet,
                        reportLength
                    );
                } else {
                    report = ollamaGenTagConceptAgent.orchestrateWithGenerallTagsReport(
                        learnerName,
                        eventName,
                        observationsWithTagsSet,
                        reportLength
                    );
                }
                report = ModelResponseTrimmer.trimThinking(report);
                log.info("Generated general tagConcept report: " + report);
                reportService.saveResponse(Report.builder()
                    .reportData(report)
                    .eventId(event.getEventId())
                    .learnerId(learner.getLearnerId())
                    .build()
                );
            } catch (Exception e) {
                throw new RuntimeException("Error generating general tagConcept report: " + e.getMessage(), e);
            }
        });
        return "Tag concept 'General Tags' report generation initiated. This can take a while!";
    }
}
