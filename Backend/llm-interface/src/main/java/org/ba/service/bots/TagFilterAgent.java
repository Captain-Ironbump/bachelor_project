package org.ba.service.bots;

import java.util.List;

import org.ba.models.AssignedTag;
import org.ba.models.Tag;
import org.ba.rag.Retriever;

import com.arjuna.ats.internal.jdbc.drivers.modifiers.list;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;


@RegisterAiService(
    modelName = "llama",
    retrievalAugmentor = Retriever.class
)
public interface TagFilterAgent {

    @SystemMessage("""
        You are an expert in competence classification. Your task is to select all tags from the provided list that semantically represent or are essential components of the given competences. These may include principles, terminology, or concepts that clearly reflect the competence's meaning.
        
        CRITICAL:
        - Tags must be selected only from the provided list.
        - Use tag names exactly as given — do not correct, reformat, or infer variations (e.g. do not turn 'OOP' into 'Object-Oriented Programming').
        - These tag names are database keys and must match exactly, including casing and spacing.
        - Include multiple tags if they refer to the same or overlapping concepts.
        - Do not invent new tag names under any circumstances.
        """)        
    
    @UserMessage("""
        Available Tags:
        {tags}  // Example input format: ["inheritance", "Object Orientated Programming", "java", "OOP"]
        
        Relevant Competences:
        (are provided in the RAG result at the end of this message) // Example input format: ["Object Orientated Programming"]
        
        Return only a JSON array of selected tag names that match the competences above, using exact values from the Available Tags list. 
        Format your response like this:
        ["tagName1", "tagName2", ...]
        
        Do not return any explanation or extra text.
    """)
    List<String> filterTags(List<Tag> tags);
}
