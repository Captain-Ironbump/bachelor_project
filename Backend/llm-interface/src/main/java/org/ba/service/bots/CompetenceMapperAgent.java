package org.ba.service.bots;

import java.util.List;
import java.util.Set;

import org.ba.infrastructure.restclient.dto.Event;
import org.ba.infrastructure.restclient.dto.Learner;
import org.ba.infrastructure.restclient.dto.Observation;
import org.ba.models.DataFetcherResult;
import org.ba.rag.Retriever;
import org.ba.service.tools.ObservationDecoder;

import dev.langchain4j.agent.tool.Tool;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import dev.langchain4j.service.V;
import io.quarkiverse.langchain4j.RegisterAiService;
import io.quarkiverse.langchain4j.ToolBox;

@RegisterAiService(modelName = "llama", retrievalAugmentor = Retriever.class)
public interface CompetenceMapperAgent {

    @SystemMessage("""
        You are an educational assistant responsible for identifying which competences and indicators apply to a specific learner in a given event context and observations.

        You MUST respond with a single valid JSON array only — NO code blocks, NO markdown, NO explanations, and NO additional output of any kind.
    """)
    @UserMessage("""
        Learner:
        {learner}

        Event:
        {event}

        Observations:
        {observations}

        ---

        Instructions:

        - Use only the decoded observation strings for analysis.
        - For each decoded observation:
        - Check it against **every indicator** from the competences listed in the event.
        - If it provides evidence for an indicator, include that indicator’s `code` and a concise, human-readable summary from the decoded observation in the `text` field.
        - If no decoded observation supports an indicator, include it with an empty `text` field.
        - A single observation can match multiple indicators — evaluate all.

        ⚠️ IMPORTANT:

        - Use **only** the competences and indicators listed below.
        - DO NOT invent, infer, or include any competences or indicators not provided in this prompt.
        - Ignore any observation that appears to match indicators from unrelated or undefined competences.


        ✅ Output Format (JSON only):

        Return your result in this exact structure — nothing more, nothing less:

        [
        {
            "competenceTitle": "The student understands the usage of Object-Orientated-Programming practices",
            "indicators": [
            {
                "code": "1.1",
                "text": "<summary from decoded observation or empty string>"
            },
            ...
            ]
        }
        ]
    """)
    @ToolBox({ObservationDecoder.class})
    String mapCompetences(
        Learner learner,
        Event event,
        List<Observation> observations
    );
}

