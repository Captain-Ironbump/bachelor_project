package org.ba.infrastructure.bots.ollama.tag.concept;

import java.util.List;

import org.ba.rag.Retriever;

import dev.langchain4j.agent.tool.Tool;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService(modelName = "llama", retrievalAugmentor = Retriever.class)
public interface OllamaObsMapperWithTagConceptAgent {
    @UserMessage("""
        /no_think
        You have a list of observations and a course name. Your task is to map the observations to the competences of the given course.
        To do this, you will be provided with a list of observations and their competence tags as well. These tags are used to identify the competences related to the observations.
        If there are no clear competence tags for the observations, try to map the indicators without using the tags.
        If you can clearly identify the competence tags, use them to map the observations to the competences.
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
                    ],
                    "identified_tags": [
                        "tag1",
                        "tag2"
                    ]
                }
            ]
        }

        Provided Data:
        - The course name is: {courseName}
        - Observations: {observationsWithTags}

        IMPORTANT:
        - Sometimes the observations are not clearly supporting the indicator or are a random string of text. In this case, you should not include the observation in the JSON response but include ALL listet numbered indicators.
        - Translate the observations from UTF-8 encoded to a human-readable format.
        """)
    @Tool(name = "mapCompetencesWithTags", value = "Maps observations to competences based on the course name and competence tags.")
    String mapCompetencesWithTags(String courseName, List<String> observationsWithTags);
}
