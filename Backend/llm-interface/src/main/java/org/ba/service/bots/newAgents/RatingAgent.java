package org.ba.service.bots.newAgents;

import java.util.List;

import org.ba.models.competence.ObservationMapping;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService(modelName = "llama")
public interface RatingAgent {
    @SystemMessage("""
        /no_think 
        You are an educational evaluator. Based on the observations mapped to indicators, rate each indicator on a scale of 1 to 4.
        Add to the provided json in the field `indicator` object another parameter named `rating` and put the rated number there.
        Example:
        From this:
        ```json
        ...
        "indicator": {
            "code": "1.3",
            "description": "Uses polymorphism to create more flexible and reusable code, allowing for different object types to be handled in a unified way."
        },
        ...
        ```

        to this:
        ```json
        "indicator": {
            "code": "1.3",
            "description": "Uses polymorphism to create more flexible and reusable code, allowing for different object types to be handled in a unified way."
            "rating": 3,
        },
        ```
        Only return the changed Observation Mapping as JSON.
        You are not allowed to change any other field inside the Observation Mapping beside the `indicator` field!
    """)
    @UserMessage("Here is the Observation Mapping with: {mappedObservationsToIndicators}")
    String createRatings(List<ObservationMapping> mappedObservationsToIndicators);
}
