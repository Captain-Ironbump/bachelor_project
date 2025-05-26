package org.ba.infrastructure.bots.ollama.tag.concept;

import java.util.List;

import org.ba.rag.Retriever;

import dev.langchain4j.agent.tool.Tool;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService(modelName = "llama", retrievalAugmentor = Retriever.class)
public interface OllamaObsMapperWithGenTagConceptAgent {
    @UserMessage("""
        /no_think
        You have a list of observations and a course name. Your task is to map the observations to the competences of the given course.
        To do this, you will be provided with a list of observations and their generall tags as well. These tags are used to add additional information to the observations and to further pinpoint the competences related to the observations.
        If there are no clear competence tags for the observations, try to map the indicators without using the tags.
        Since the tags are generall tags, your task is to not only map the observations to the competences but also include the tags by adding a sentence to the observation that describes the tag.
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
                                "Observation 1 with tag description",
                                "Observation 2 with tag description"
                            ]
                        },
                    ],
                }
            ]
        }

        Provided Data:
        - The course name is: {courseName}
        - Observations: {observationsWithTags}

        IMPORTANT:
        - Sometimes the observations are not clearly supporting the indicator or are a random string of text. In this case, you should not include the observation in the JSON response but include ALL listet numbered indicators.
        - use the generall tags inisde the observations to create a more precise rating. Also use the generall tags to create a more precise summary.
        - add a setence to the observation that describes the tag, e.g. "This observation is related to the tag 'tag1' which means ...".
        """)
    @Tool(name = "mapCompetencesWithGenTags", value = "Maps observations to competences based on the course name and competence tags.")
    String mapCompetencesWithGenTags(String courseName, List<String> observationsWithTags);
}
