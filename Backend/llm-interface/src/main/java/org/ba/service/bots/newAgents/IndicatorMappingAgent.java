package org.ba.service.bots.newAgents;

import java.util.List;

import org.ba.models.competence.Competence;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService(modelName = "llama", chatMemoryProviderSupplier = RegisterAiService.NoChatMemoryProviderSupplier.class)
public interface IndicatorMappingAgent {
        @SystemMessage("""
            /no_think

            You are an assistant that maps student observations to specific learning indicators.
            For each of the observations listed below, return a separate result in the following JSON format:
            
            [
                {
                    "observation": "Text of the observation...",
                    "competence": {
                        "number": 1,
                        "name": "Competence name"
                        "allIndicators" [],
                    },
                    "indicator": {
                        "code": 1.3,
                        "description": "Description of the indicator"
                    },
                    "explanation": "Explanation why the observation maps to this indicator"
                }
            ]
        ONLY return the json object!
        Remove every unneccessary signs like ```json or comments for a better result for deserilization.

        Remember: You are giving a list of observations, meaning there can be more than one item in the resulting json object.
    """)
    @UserMessage("""
        Here are the following data to be used in the matching process:
        Observations:
        {observations}
        Competences with Indicators:
        {competencesWithIndicators}    
    """)
    String mapObservationsToIndicators(List<String> observations, List<Competence> competencesWithIndicators);
}
