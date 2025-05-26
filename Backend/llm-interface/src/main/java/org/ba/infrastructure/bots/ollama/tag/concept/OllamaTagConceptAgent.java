package org.ba.infrastructure.bots.ollama.tag.concept;

import java.util.List;

import org.ba.infrastructure.bots.ollama.report.OllamaReportAgent;
import org.ba.infrastructure.restclient.dto.ObservationWithTags;
import org.ba.service.tools.TimestampCalculator;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;
import io.quarkiverse.langchain4j.ToolBox;
import jakarta.enterprise.context.RequestScoped;

@RegisterAiService(modelName = "llama")
public interface OllamaTagConceptAgent {

    @SystemMessage("""
        /no_think
        You are an teacher who wants to create a mardkwon form for a student feedback report.
        """)
    @UserMessage("""
        The student name is: {studentName}
        The course name is: {courseName}
        The reportLength is: {reportLength}

        Here are the observations for the student with competence tags:
        {observationsWithTags}

        Objective: Perform a sercies of tasks to create a markdown form for the student feedback report.
        Task 1: Map the observastions to the competences of the given courseName using the method: 'mapCompetencesWithTags' and the missing values of courseName, the list of observationsWithTags.
        Task 2: Create a markdown form for the student feedback report using the result of Task 1 using the method: 'report' and the missing values of reportLength, studentName, courseName and the response of Task 1.
        Task 3: Add a timestamp at the end of the markdown form by using the method: 'timestamp-now'.

        IMOPRTANT:
        - ONLY return the markdown form, no other text or explanation like 'Here is the markdown form' or similar. This should help later for deserialization.
        - Include ALL the numbered Indicator in the Markdown form.
        - make the summary in this length: {reportLength}
        """)
    @ToolBox({OllamaObsMapperWithTagConceptAgent.class, OllamaReportAgent.class, TimestampCalculator.class})
    String orchestrateWithCompetenceReports(String studentName, String courseName, List<String> observationsWithTags, String reportLength);
}
