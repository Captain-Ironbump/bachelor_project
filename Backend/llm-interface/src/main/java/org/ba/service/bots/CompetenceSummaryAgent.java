package org.ba.service.bots;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService(modelName = "llama")
public interface CompetenceSummaryAgent {
    /**
     * Generates a performance summary based on rated observations.
     */
    @SystemMessage("""
        Write a performance summary based on the observations and ratings provided.
        Make the length consistent with the given response length.
        """)
    @UserMessage("""
        Response length: {responseLength}
        Observations with ratings:
        {ratedObservations}
        """)
    String generateSummary(String responseLength, String ratedObservations);
}
