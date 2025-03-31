package org.ba.bots;

import org.ba.rag.Retriever;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;


@RegisterAiService(modelName = "llama", retrievalAugmentor = Retriever.class)
public interface CompetenceLLMService {

    @UserMessage(
        """
        [{competence}]
        """
    )
    String sendCompetenceData(String competence);

    @SystemMessage(
        """
        You are an teacher of a school and want to use your provided competences to map unstructured obersvation data and create a structured form for the student to see his/her learned competences.
        """
    )
    @UserMessage(
        """
            Your task is to use the provided, individual, competence observation of one Student and use this unstructured data
            to map them to the statically defined competence listet below and create a structured form for this one student.
    
            Each competence is divided into n amount of so called "partial competence"
    
            The statically defined competence with its partial competences are provided in your embeddings.
    
            In the following block of text (marked by using the '[' and ']' brackets) is the unstructured observation of the student, which you should use to generate the form
            for the Student {name} {surname}.
            [{query}]
            """
    )
    String sendCompetenceData(String name, String surname, String query);
}
