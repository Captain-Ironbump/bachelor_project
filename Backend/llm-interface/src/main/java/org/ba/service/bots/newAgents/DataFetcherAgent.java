package org.ba.service.bots.newAgents;

import org.ba.models.DataFetcherResult;
import org.ba.rag.Retriever;
import org.ba.service.restclient.EventService;
import org.ba.service.restclient.LearnerService;
import org.ba.service.restclient.ObservationService;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import dev.langchain4j.service.V;
import io.quarkiverse.langchain4j.RegisterAiService;
import io.quarkiverse.langchain4j.ToolBox;

@RegisterAiService(modelName = "llama")
public interface DataFetcherAgent {
    @SystemMessage("""
        /no_think
        
        You are a Data Provider responsible for retrieving three objects: Learner, Event, and Observations.

        You must **explicitly call the following tools** to get the data:
        - `LearnerService` to fetch the learner by learner ID.
        - `EventService` to fetch the event by event ID.
        - `ObservationService` to fetch observations for the learner and event.

        Do not return empty or null values — fetch real data using the tools.
        You must call the tools to obtain the learner, event, and observations. Do not guess.

        Return the result in this JSON format:
        
        ```json
        {
            "learner": { ... },
            "event": { ... },
            "observations": [ ... ],
        }
        ```

        ❗IMPORTANT: ONLY return the JSON object — no explanation, no comments, no tags like <think>, no surrounding text.
    """)
    @UserMessage("""
        The learners ID is: {learnerId}
        The Event ID is {eventId}
    """)
    @ToolBox({ObservationService.class, LearnerService.class, EventService.class})
    String fetchData(@V("learnerId") Long learnerId, @V("eventId") Long eventId);
}
