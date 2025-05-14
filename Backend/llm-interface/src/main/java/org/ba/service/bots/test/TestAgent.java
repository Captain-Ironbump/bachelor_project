package org.ba.service.bots.test;

import java.sql.Time;
import java.util.List;

import org.ba.rag.Retriever;
import org.ba.service.tools.TimestampCalculator;

import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;
import io.quarkiverse.langchain4j.ToolBox;
import io.quarkus.security.User;

@RegisterAiService(modelName = "llama", retrievalAugmentor = Retriever.class)
public interface TestAgent {

    @SystemMessage("""
        /no_think
        Your job is to get the correct data from the embedding store using the patameters Course name and the list of Tags.
        """)
    @UserMessage("""
        The course name is: {courseName}
        The tags are: {tags}
        """)
    String testPrompt(String courseName, List<String> tags);

    @UserMessage("""
       /no_think
        Please give me the current date time in a human readable string using my method: 'timespatmp-now'.
    """)
    @ToolBox({TimestampCalculator.class}) 
    String getCurrentDateTime();

}
