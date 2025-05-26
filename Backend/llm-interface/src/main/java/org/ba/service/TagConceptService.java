package org.ba.service;

import java.util.List;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

import org.ba.infrastructure.bots.ollama.tag.concept.OllamaGenTagConceptAgent;
import org.ba.infrastructure.bots.ollama.tag.concept.OllamaTagConceptAgent;
import org.ba.infrastructure.restclient.dto.Event;
import org.ba.infrastructure.restclient.dto.Learner;
import org.ba.infrastructure.restclient.dto.Observation;
import org.ba.infrastructure.restclient.dto.ObservationWithTags;
import org.ba.service.restclient.EventService;
import org.ba.service.restclient.LearnerService;
import org.ba.service.restclient.ObservationWithTagsService;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import io.netty.util.concurrent.CompleteFuture;
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
    LearnerService learnerService;

    @Inject
    EventService eventService;

    @Inject
    ObservationWithTagsService observationWithTagsService;


    public String tagConcept(Long learnerId, Long eventId) {
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

            String report = ollamaTagConceptAgent.orchestrateWithCompetenceReports(
                learnerName,
                eventName,
                observationsWithTagsSet,
                "short"
            );
            return report;

        } catch (Exception e) {
            log.info("Error in tagConcept: " + e.getMessage());
            return "Error in tagConcept: " + e.getMessage();
        }
    }


    public String generalTagConcept(Long learnerId, Long eventId) {
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

            String report = ollamaGenTagConceptAgent.orchestrateWithGenerallTagsReport(
                learnerName,
                eventName,
                observationsWithTagsSet,
                "short"
            );
            return report;
        } catch (Exception e) {
            log.info("Error in tagConcept: " + e.getMessage());
            return "Error in tagConcept: " + e.getMessage();
        }
    }
}
