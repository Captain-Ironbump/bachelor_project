package org.ba.service.tools;

import dev.langchain4j.agent.tool.Tool;
import io.quarkus.logging.Log;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class ObservationDecoder {
    @Tool("asciiValues decoder to convert bytes into readable String")
    public String decodeObservation(byte[] asciiValues) {
        StringBuilder decoded = new StringBuilder();
        for (byte code : asciiValues) {
            decoded.append((char) code);
        }
        Log.info(decoded.toString());
        return decoded.toString();
    }
}
