package org.ba.infrastructure.bots.ollama.tag.concept;

import dev.langchain4j.agent.tool.Tool;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService(modelName = "llama")
public interface OllamaReportGenTagAgent {
    @UserMessage("""
        /no_think
        You are a teacher who wants to create a markdown form for a student feedback report.

        Using the provided message of another agent, create a markdown form for the student feedback report with the following template:
        ```markdown
        # {studentName} - {courseName}

        ## Summary
        (include a Summary here)

        ### [Competence Title]
        #### [Indicator Code and Text]
        Observation: [If any]
        Rating: [1-4 or blank]
        (repeat here for ALL indicators with their indicator code, meaning also include those, which dont have any matched rating or observations)
        
        # created at [timestamp now]
        ```

        The message of the other agent is:
        {agentRespone}

        The student name is: {studentName}
        The course name is: {courseName}
        The reportLength is: {reportLenght}

        Objective: Generate a markdown-formatted student feedback report with the following format:
        - Student name and course at the top
        - Summary paragraph, its length is defined by the reportLenght parameter
        - Only show competences, which are semantically from the same course as the provided course name.
        - For each competence:
            - List ALL of its indicators
            - For each indicator, show:
                - Observation (if any), otherwise leave blank or write "None"
                - Rating (1-4), or blank

        IMOPRTANT:
        - DONT include any rating if there is no observation for the indicator or it the observation is not clearly supporting the indicator.
        - ONLY return the markdown form, no other text or explanation like 'Here is the markdown form' or similar. This should help later for deserialization.
        - you have to include ALL the numbered Indicator in the Markdown form.
        - the observations can have multiple general tags, use them to give a more precise rating and feedback to the student. Also use the tags to create a more precise summary of the report.
        - make the summary in this length: {reportLenght}
        """)
    @Tool(name = "reportWithGenTags", value = "Creates a markdown form for the student feedback report based on reportLength, studenName, courseName and the response of another agent.")
    String reportWithGenTags(String reportLenght ,String studentName, String courseName, String agentRespone);
}
