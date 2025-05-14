package org.ba.service.bots.newAgents;

import java.util.List;

import org.ba.infrastructure.restclient.dto.Event;
import org.ba.models.competence.Competence;
import org.ba.rag.Retriever;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService(modelName = "llama", retrievalAugmentor = Retriever.class)
public interface CompetenceRetrieverAgent {
    @SystemMessage("/no_think You are an assistant that extracts competences and indicators related to a given educational event.")
    @UserMessage("""
        Extract competences and indicators for this event: {event.name}.
        Use this json format:
        ```json
        [
            {
                "number": 1 // the numver of the competence
                "name": "Competence name here",
                "indicators": [
                    {
                        "code": 1.1, // the double number of the indicator
                        "description": "Description of the indicator here."
                    },
                ]
            }
        ]
        ```
        Remove every unneccessary signs like ```json or comments for a better result for deserilization.
    """)
    String getCompetences(Event event);
}
