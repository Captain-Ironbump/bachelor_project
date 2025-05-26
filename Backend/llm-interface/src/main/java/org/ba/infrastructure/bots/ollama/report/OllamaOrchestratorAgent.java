package org.ba.infrastructure.bots.ollama.report;

import java.util.List;

import org.ba.service.tools.TimestampCalculator;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;
import io.quarkiverse.langchain4j.ToolBox;

@RegisterAiService(modelName = "llama")
public interface OllamaOrchestratorAgent {

    @SystemMessage("""
        /no_think
        
        You are an teacher who wants to create a mardkwon form for a student feedback report.
        """)
    @UserMessage("""
        The student name is: {studentName}
        The course name is: {courseName}
        The reportLength is: {reportLength}

        Here are the observations for the student:
        {observations}

        Objective: Perform a sercies of tasks to create a markdown form for the student feedback report.
        Task 1: Map the observastions to the competences of the given courseName using the method: 'mapCompetences' and the missing values of courseName and the list of observations.
        Task 2: Create a markdown form for the student feedback report using the result of Task 1 using the method: 'report' and the missing values of reportLength, studentName, courseName and the response of Task 1.
        Task 3: Add a timestamp at the end of the markdown form by using the method: 'timestamp-now'.

        IMOPRTANT:
        - ONLY return the markdown form, no other text or explanation like 'Here is the markdown form' or similar. This should help later for deserialization.
        - Include ALL the numbered Indicator in the Markdown form.
        - make the summary in this length: {reportLength}
        - use the timestamp-now tool to add a timestamp at the end of the markdown form, it starts with 'created at ' and then the timestamp in the format ofPattern("dd. MMMM yyyy, HH:mm").
        """)
    @ToolBox({OllamaObsMapperAgent.class, OllamaReportAgent.class, TimestampCalculator.class})
    String orchestrate(String studentName, String courseName, List<String> observations, String reportLength);
}
