package org.ba;


import org.ba.bots.CompetenceLLMService;
//import org.ba.rag.Ingestor;
import org.ba.requests.pojo.RequestStudentText;
import org.ba.requests.pojo.Student;
import org.jboss.resteasy.reactive.PartType;
import org.jboss.resteasy.reactive.ResponseHeader;
import org.jboss.resteasy.reactive.ResponseStatus;
import org.jboss.resteasy.reactive.RestForm;

import dev.langchain4j.model.embedding.EmbeddingModel;
import jakarta.inject.Inject;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

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
    
}
