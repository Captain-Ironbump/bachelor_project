package org.ba.service.bots;

import java.util.List;

import org.ba.rag.Retriever;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService(modelName = "llama", retrievalAugmentor = Retriever.class)
public interface CompetencMapperAgent {
    /**
     * Matches observations to indicators using retrieved indicator definitions.
     */
    @SystemMessage("""
        Match each unstructured student observation to the most relevant course indicators.
        Indicators are retrieved based on the course.
        Return a JSON object in the form:
        {
          "indicator_code with IndicatorDescription": ["matching observation", ...],
          ...
        }
        Repeat observations for all indicators they apply to.
        Only use the provided competences and Indicator that fit the given course name.

        DO NOT generate any code, just write me the JSON object and some extra information if you want to explain yourself.
        """)
    @UserMessage("""
        Course: {course}
        Observations:
        {observations}
        """)
    String matchObservationsToIndicators(String course, List<String> observations);
}
