package org.ba.service.bots;

import org.ba.rag.Retriever;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService(modelName = "llama")
public interface FormGeneratorAgent {
    /**
     * Formats the entire feedback in Markdown, using the retrieved indicators.
     */
    @SystemMessage("""
        /no_think
        
        Generate a markdown-formatted student feedback report with the following format:

        - Student name and course at the top
        - Summary paragraph
        - Only show competences, which are sematically from the same course as the provided course name.
        - For each competence:
            - List all of its indicators
            - For each indicator, show:
                - Observation (if any), otherwise leave blank or write "None"
                - Rating (1-4), or blank

        Pls include all the numbered Indicator in the Makrdown form.
        But don't hallicinate new indicators or competences, which are not in the provided in the Competences with Indicators JSON.
        """)
    @UserMessage("""
        Student: {studentName}
        Course: {course}
        Summary: {summary}

        Competences with Indicators (JSON):
        {competenceWithIndicators}

        Matched Observations (JSON):
        {observationMap}

        Ratings (JSON):
        {ratings}

        Please use this markdown template to generate the end Form:
        # {studentName} - {course}

        ## Summary
        (include a Summary here like explained earlier)

        ### [Competence Title]

        #### [Indicator Code and Text]
        Observation: [If any]  
        Rating: [1-4 or blank]
        
        (repreat here for ALL indicators with their indicator code, meaning also include those, which dont have any mathed rating or observations)
        """)
    String assembleMarkdown(
        String studentName,
        String course,
        String summary,
        String observationMap,
        String ratings,
        String competenceWithIndicators
    );

}
