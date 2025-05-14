package org.ba.service.bots;

import java.util.List;

import org.ba.rag.Retriever;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;
import io.quarkus.security.User;


@RegisterAiService(modelName = "llama", retrievalAugmentor = Retriever.class)
public interface CompetenceLLMService {

    @UserMessage(
        """
        [{competence}]
        """
    )
    String sendCompetenceData(String competence);

    @SystemMessage(
        """
        You are an teacher of a school and want to use your provided competences to map unstructured obersvation data and create a structured form for the student to see his/her learned competences.
        """
    )
    @UserMessage(
        """
            Your task is to use the provided, individual, competence observation of one Student and use this unstructured data
            to map them to the statically defined competence listet below and create a structured form for this one student.
    
            Each competence is divided into n amount of so called "partial competence"
    
            The statically defined competence with its partial competences are provided in your embeddings.
    
            In the following block of text (marked by using the '[' and ']' brackets) is the unstructured observation of the student, which you should use to generate the form
            for the Student {name} {surname}.
            [{query}]
            """
    )
    String sendCompetenceData(String name, String surname, String query);

    @SystemMessage(
        """
        You are a teacher assistant helping to assess a student’s performance in a specific course based on a list of unstructured observations.
        You are also given a list of competences (and their indicators), each tied to specific courses.
    
        Your task is to generate a markdown feedback form for a student in a specific course. To do this:

        IMPORTANT: The user provides a desired response length: short, medium, or long.
    
        - "short" = minimal summary and no elaboration beyond 1 observation per indicator.
        - "medium" = a balanced summary and up to 2 observations per indicator if relevant.
        - "long" = detailed summary and include all relevant observations per indicator.
        - any other variant given will be threated as "short".
    
        - ONLY include competences and indicators that belong to the specified course.
        - DO NOT include competences or indicators from other courses.
        - The markdown output should have the student's name and the course title at the top.
        - After the title and name, include a Summary to all observations.
        - For each competence, list ALL of its indicators in order.
        - For each indicator, check if an observation supports it. If it does, copy the observation under the indicator with a corresponding rating from 1 (insufficient) to 4 (excellent).
        - If no observation clearly supports an indicator, leave the observation and rating blank — but still list the indicator.
        - If an observation applies to multiple indicators (e.g., one observation discusses both inheritance and abstraction), repeat the observation for each applicable indicator with the appropriate rating.
        - The final output must be valid markdown and must **not contain explanations** or any data unrelated to the selected course.
        """
    )    
    @UserMessage(
        """
        The student's name is: {studentName}  
        The course is: {course}  
        Response length: {responseLength}

        Here are the unstructured observations:  
        {observations}

        Please return the feedback as a markdown file using the following template:

        # {studentName} - {course}
        ## Competences with indicators

        ## Summary
        (include a Summary here like explained earlier)

        ### [Competence Title]

        #### [Indicator Code and Text]
        Observation: [If any]  
        Rating: [1-4 or blank]

        Ensure to:
        - List ALL indicators for the given course.
        - Do not omit any indicator even if no observation matches it.
        - Repeat observations if they apply to multiple indicators (e.g., for both inheritance and abstraction).
        - Don't forget to add the Summary.
        - DO NOT create any code.
        - ONLY return a markdown wich structures the data.
        """
    )
    String createForm(String studentName, String course, List<String> observations, String responseLength);
}
