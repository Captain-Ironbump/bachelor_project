package org.ba;


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
//import org.ba.rag.Ingestor;
import org.ba.requests.pojo.RequestStudentText;
import org.ba.requests.pojo.Student;
import org.ba.service.bots.CompetencMapperAgent;
import org.ba.service.bots.CompetenceLLMService;
import org.ba.service.bots.CompetenceRaterAgent;
import org.ba.service.bots.CompetenceSummaryAgent;
import org.ba.service.bots.FormGeneratorAgent;
import org.ba.service.bots.test.TestAgent;
import org.ba.service.restclient.EventService;
import org.ba.service.restclient.LearnerService;
import org.ba.service.restclient.ObservationService;
import org.ba.service.restclient.ReportService;
import org.ba.service.tools.TimestampCalculator;
import org.ba.utils.ModelResponseTrimmer;
import org.jboss.resteasy.reactive.PartType;
import org.jboss.resteasy.reactive.ResponseHeader;
import org.jboss.resteasy.reactive.ResponseStatus;
import org.jboss.resteasy.reactive.RestForm;

import dev.langchain4j.model.embedding.EmbeddingModel;
import io.quarkus.arc.Arc;
import io.quarkus.arc.ManagedContext;
import io.quarkus.logging.Log;
import jakarta.enterprise.context.control.ActivateRequestContext;
import jakarta.inject.Inject;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.concurrent.CompletableFuture;

@Path("/hello")
public class GreetingResource {

    private final String query1 = """
            Timestamp: 10:15 AM
            Observation: Max is working on a class definition for a "Car" object in Python. He defines attributes like make, model, and year in the __init__ method, explaining to a peer that each object represents a car instance and can have unique values for these attributes. Max also explains that the methods within the class, such as start() and stop(), allow the car object to perform actions related to its attributes.
            Competence Assessed:

            Objects as Instances of Classes
            Max demonstrates a clear understanding of objects and their attributes and methods, correctly explaining their role as instances of a class.
            """;
    
    private final String query2 = """
            Timestamp: 10:45 AM
            Observation: Max is discussing how to implement different types of vehicles using polymorphism. He writes a method called start_engine() for a Vehicle superclass and shows how the method behaves differently when called on a "Car" object versus a "Bike" object, using the isinstance() method to ensure proper behavior. Max emphasizes how this makes the code more flexible and reusable across different vehicle types.
            Competence Assessed:

            Polymorphism
            Max effectively applies polymorphism, demonstrating how different object types can be handled in a unified way while maintaining flexibility in method behavior.
            """;

    private final String query3 = """
                Hello World!
                """;

    
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
    TestAgent testAgent;

    @Inject
    OrchestratorAgent orchestratorAgent;

    @Inject
    LearnerService learnerService;
    @Inject
    ObservationService observationService;
    @Inject
    EventService eventService;
    @Inject
    ReportService reportService;

    @POST
    @Path("/hello")
    public String hello() {
        return competenceLLMService.sendCompetenceData(query3);
    } 

    @POST
    @Path("/test")
    @Consumes(MediaType.APPLICATION_JSON)
    public String test(RequestStudentText body) {
        String query = body.getQuery();
        Student student = body.getStudent();
        return competenceLLMService.sendCompetenceData(student.getName(), student.getSurname(), query1);
    }

    @GET
    @Path("/testi")
    public String testi() {
        return competenceLLMService.createForm("Max Mustermann", "Software Engineering", List.of("For the final project, the student developed a specialized account type tailored for learners, building upon a more general user framework. This new version included added features such as managing course participation and monitoring academic performance, while still relying on the foundational elements like login procedures and credential checks from the original design. By reusing existing components rather than recreating them, the student demonstrated an ability to extend and adapt previous work efficiently."), "short");
    }
    
    @GET
    @Path("/testo")
    public String testo() {
        String competenceMapperResponse = competencMapperAgent.matchObservationsToIndicators("Software Engineering", List.of("For the final project, the student developed a specialized account type tailored for learners, building upon a more general user framework. This new version included added features such as managing course participation and monitoring academic performance, while still relying on the foundational elements like login procedures and credential checks from the original design. By reusing existing components rather than recreating them, the student demonstrated an ability to extend and adapt previous work efficiently."));
        Log.info(competenceMapperResponse);
        String competenceRaterResponse = competenceRaterAgent.rateObservationsByIndicator("Software Engineering", competenceMapperResponse);
        Log.info(competenceRaterResponse);
        String competenceSummarizerResponse = competenceSummaryAgent.generateSummary("short", competenceRaterResponse);
        Log.info(competenceSummarizerResponse);
        String competenceMarkdownGeneratorResponse = formGeneratorAgent.assembleMarkdown("Max Mustermann", "Software Engineering", competenceSummarizerResponse, competenceMapperResponse, competenceRaterResponse, "");
        return competenceMarkdownGeneratorResponse;
    }

    @GET
    @Path("/testoo")
    public String testoo() {
        return testAgent.testPrompt("Database Systems", List.of("inheritance"));
    }

    @POST
    @Path("/testoo2")
    public Response testoo2() {
        CompletableFuture.runAsync(() -> {
            ManagedContext requestContext = Arc.container().requestContext();
            requestContext.activate();
            try {
                CompletableFuture<Set<Observation>> observationsFuture = 
                    CompletableFuture.supplyAsync(() -> observationService.getObservationByEventAndLeanrner(1L, 1L));

                CompletableFuture<Event> eventFuture = 
                    CompletableFuture.supplyAsync(() -> eventService.getEventById(1L));

                CompletableFuture<Learner> learnerFuture = 
                    CompletableFuture.supplyAsync(() -> learnerService.getLearnerById(1L));
            
                CompletableFuture<Void> combinedFuture = CompletableFuture.allOf(observationsFuture, eventFuture, learnerFuture);
                combinedFuture.join();

                //Log.info(observationsFuture.get());

                List<String> observations = observationsFuture.get()
                    .stream()
                    .map(obs -> new String(obs.getRawObservation(), StandardCharsets.UTF_8))
                    .collect(Collectors.toList());
                Event event = eventFuture.get();
                Learner learner = learnerFuture.get();
                String res = orchestratorAgent.orchestrate(
                    String.format("%1$s %2$s", learner.getFirstName(), learner.getLastName()), 
                    event.getName(), 
                    observations
                );
                Log.info("Orchestration result: " + res);
                res = ModelResponseTrimmer.trimThinking(res);
                reportService.saveResponse(Report.builder()
                        .reportData(res.getBytes())
                        .eventId(event.getEventId())
                        .learnerId(learner.getLearnerId())
                        .build()
                );
            } catch (Exception e) {
                Log.error("Error during orchestration: " + e.getMessage(), e);
            }
        });
        return Response.accepted("Processing report generation. This can take a while.").build();
    }

    @GET
    @Path("/now")
    public String now() {
        TimestampCalculator timestampCalculator = new TimestampCalculator();
        return timestampCalculator.getTimestampOfNow();
    }

    @GET
    @Path("/agentNow")
    public String agentNow() {
        return testAgent.getCurrentDateTime();
    }

    @POST
    @Path("/testoo3")
    public void testoo3() {
        reportService.saveResponse(Report.builder()
                .reportData("Hello World du schmock".getBytes())
                .eventId(1L)
                .learnerId(10L)
                .build()
        );
    }
}
