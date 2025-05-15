package org.ba.infrastructure.bots;

import java.util.List;

import org.ba.rag.Retriever;

import dev.langchain4j.agent.tool.Tool;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService(modelName = "llama", retrievalAugmentor = Retriever.class)
public interface ObsMapperAgent {
    @UserMessage("""
        /no_think
        You have a list of observations and a course name. Your task is to map the observations to the competences of the given course.
        Objective: Generate a JSON response with specific keys:

        JSON Structure:
        {
            "competences": [
                {
                    "name": "Competence name here",
                    "indicators": [
                        {
                            "code": 1.1, // the double number of the indicator
                            "description": "Description of the indicator here."
                            "observations": [
                                "Observation 1",
                                "Observation 2"
                            ]
                        },
                    ]
                }
            ]
        }

        Provided Data:
        - The course name is: {courseName}
        - Observations: {observations}

        IMPORTANT:
        - Sometimes the observations are not clearly supporting the indicator or are a random string of text. In this case, you should not include the observation in the JSON response but include ALL listet numbered indicators.
        - Translate the observations from UTF-8 encoded to a human-readable format.
        """)
    @Tool(name = "mapCompetences", value = "Maps observations to competences based on the course name.")
    String mapCompetences(String courseName, List<String> observations);
}
