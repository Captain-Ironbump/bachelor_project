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
import org.ba.infrastructure.restclient.dto.Report;
import org.ba.service.restclient.EventService;
import org.ba.service.restclient.LearnerService;
import org.ba.service.restclient.ObservationService;
import org.ba.service.restclient.ReportService;
import org.ba.utils.ModelResponseTrimmer;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import lombok.extern.slf4j.Slf4j;
import io.quarkus.arc.Arc;
import io.quarkus.arc.ManagedContext;

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

    @Inject
    ReportService reportService;

    public String generateReport(Long learnerId, Long eventId, String reportLength) {
        CompletableFuture.runAsync(() -> {
            ManagedContext requestContext = Arc.container().requestContext();
            requestContext.activate();

            try {
                CompletableFuture<Set<Observation>> observationsFuture = 
                    CompletableFuture.supplyAsync(() -> observationService.getObservationByEventAndLeanrner(eventId, learnerId));

                CompletableFuture<Event> eventFuture = 
                    CompletableFuture.supplyAsync(() -> eventService.getEventById(eventId));

                CompletableFuture<Learner> learnerFuture = 
                    CompletableFuture.supplyAsync(() -> learnerService.getLearnerById(learnerId));
            
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
                    observations,
                    reportLength
                );
                report = ModelResponseTrimmer.trimThinking(report);
                log.info("Orchestration result: " + report);
                reportService.saveResponse(Report.builder()
                        .reportData(report.getBytes())
                        .eventId(event.getEventId())
                        .learnerId(learner.getLearnerId())
                        .build()
                );
            } catch (Exception e) {
                throw new RuntimeException("Error generating report: " + e.getMessage(), e);
            }
        });
        return "Processing report generation. This can take a while.";
    }
}
