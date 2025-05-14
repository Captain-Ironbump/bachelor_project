package org.ba.service.bots;

import java.util.List;

import org.ba.models.TaggingResult;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;

@RegisterAiService(modelName = "llama")
public interface ObservationTaggerAgent {

    @SystemMessage("You are an expert tagger. Based on the observation, select all relevant tags from the list — even if multiple tags describe the same concept. The tags are listed with a '*' or '-' sign. Only extract the names behind these signs (ignore the symbols). Do not deduplicate tags that mean the same thing — include all that match.")
    @UserMessage("""
    Observation ID: {observationId}
    Observation: {observation}
    
    Available Tags:
    {tags}
    
    Based on the observation, select all tags from the list that semantically match or describe concepts mentioned in the observation. If two or more tags describe the same concept (e.g., 'OOP' and 'Object Orientated Programming'), include them all.
    
    Only return a JSON object in the following format:
    {
        "observationId": "<same as provided>",
        "tags": ["<tagName1>", "<tagName2>", "..."]
    }
    
    Return only valid JSON — no extra text or explanation.
    ONLY use the tag names exactly as provided (excluding any list symbols like '*' or '-') — do not invent or infer new tags.
    """)
    TaggingResult tagObservation(String observation, String observationId, List<String> tags);
    
}
