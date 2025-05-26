package org.ba.service;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

import org.ba.infrastructure.bots.ollama.report.OllamaOrchestratorAgent;
import org.ba.infrastructure.bots.openai.report.OpenAIOrchestratorAgent;
import org.ba.infrastructure.restclient.dto.Event;
import org.ba.infrastructure.restclient.dto.Learner;
import org.ba.infrastructure.restclient.dto.Observation;
import org.ba.infrastructure.restclient.dto.Report;
import org.ba.service.restclient.EventService;
import org.ba.service.restclient.LearnerService;
import org.ba.service.restclient.ObservationService;
import org.ba.service.restclient.ReportService;
import org.ba.utils.ModelResponseTrimmer;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import lombok.extern.slf4j.Slf4j;
import io.quarkus.arc.Arc;
import io.quarkus.arc.ManagedContext;

@ApplicationScoped
@Slf4j
public class GenerateReportService {

    private final OllamaOrchestratorAgent ollamaOrchestratorAgent;
    private final OpenAIOrchestratorAgent openAIOrchestratorAgent;
    private final boolean useOpenAI;
    
    @Inject 
    public GenerateReportService(
        OllamaOrchestratorAgent ollamaOrchestratorAgent,
        OpenAIOrchestratorAgent openAIOrchestratorAgent,
        @ConfigProperty(name = "use.openai", defaultValue = "false") boolean useOpenAI
    ) {
        this.ollamaOrchestratorAgent = ollamaOrchestratorAgent;
        this.openAIOrchestratorAgent = openAIOrchestratorAgent;
        this.useOpenAI = useOpenAI;
    }

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

                List<String> observations = observationsFuture.get().stream()
                    .map(obs -> obs.getRawObservation())
                    .collect(Collectors.toList());
                Event event = eventFuture.get();
                Learner learner = learnerFuture.get();

                String report = "";
                if (useOpenAI) {
                    report = openAIOrchestratorAgent.orchestrate(
                        String.format("%1$s %2$s", learner.getFirstName(), learner.getLastName()), 
                        event.getName(), 
                        observations,
                        reportLength
                    );
                } else {
                    report = ollamaOrchestratorAgent.orchestrate(
                        String.format("%1$s %2$s", learner.getFirstName(), learner.getLastName()), 
                        event.getName(), 
                        observations,
                        reportLength
                    );
                }
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
