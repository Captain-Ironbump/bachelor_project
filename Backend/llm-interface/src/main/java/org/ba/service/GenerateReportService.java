package org.ba.service;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

import org.ba.infrastructure.bots.OrchestratorAgent;
import org.ba.infrastructure.restclient.dto.Event;
import org.ba.infrastructure.restclient.dto.Learner;
import org.ba.infrastructure.restclient.dto.Observation;
import org.ba.service.restclient.EventService;
import org.ba.service.restclient.LearnerService;
import org.ba.service.restclient.ObservationService;
import org.ba.utils.ModelResponseTrimmer;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import lombok.extern.slf4j.Slf4j;

@ApplicationScoped
@Slf4j
public class GenerateReportService {
    @Inject
    OrchestratorAgent orchestratorAgent;

    @Inject
    LearnerService learnerService;

    @Inject
    EventService eventService;

    @Inject
    ObservationService observationService;

    //rest client service for posting the report
    // validator for the report

    public void generateReport(Long learnerId, Long eventId) {
        try {
            CompletableFuture<Set<Observation>> observationsFuture = 
                CompletableFuture.supplyAsync(() -> observationService.getObservationByEventAndLeanrner(1L, 1L));

            CompletableFuture<Event> eventFuture = 
                CompletableFuture.supplyAsync(() -> eventService.getEventById(1L));

            CompletableFuture<Learner> learnerFuture = 
                CompletableFuture.supplyAsync(() -> learnerService.getLearnerById(1L));
        
            CompletableFuture<Void> combinedFuture = CompletableFuture.allOf(observationsFuture, eventFuture, learnerFuture);
            combinedFuture.join();

            log.info(observationsFuture.get().toString());

            List<String> observations = observationsFuture.get()
                .stream()
                .map(obs -> new String(obs.getRawObservation(), StandardCharsets.UTF_8))
                .collect(Collectors.toList());
            Event event = eventFuture.get();
            Learner learner = learnerFuture.get();
            String report = orchestratorAgent.orchestrate(
                String.format("%1$s %2$s", learner.getFirstName(), learner.getLastName()), 
                event.getName(), 
                observations
            );
            report = ModelResponseTrimmer.trimThinking(report);
            
        } catch (Exception e) {
            throw new RuntimeException("Error generating report: " + e.getMessage(), e);
        }
    }
}
