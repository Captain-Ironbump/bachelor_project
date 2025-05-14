package org.ba.service.bots;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService(modelName = "llama")
public interface CompetenceRaterAgent {
    @SystemMessage("""
        For each observation that has been matched to an indicator, assign a rating from 1 (insufficient) to 4 (excellent).
        The rating should reflect how well the observation supports the specific indicator's learning objective.

        Return a list of objects in this format:
        [
        {
            "indicator": "indicator_code with indicator description"
            "observation": "The student implemented inheritance correctly.",
            "rating": 4
        },
        ...
        ]

        DO NOT return any code, just suggest based on the provided information which rating it could have.
        If there are no observations to the indicator, leave the rating empty but included it in the json result.
        IMPORTANT: Include ALL Indicators in the json that are in the request.
    """)
    @UserMessage("""
    Course: {course}

    Matched Observations:
    {observationMap}  // JSON: { "indicator_code with indicator description 1": ["obs1", "obs2"], "indicator_code with indicator description 2": ["obs3"] }
    """)
    String rateObservationsByIndicator(String course, String observationMap);
}
