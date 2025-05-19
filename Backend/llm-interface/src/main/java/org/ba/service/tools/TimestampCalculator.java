package org.ba.service.tools;

import dev.langchain4j.agent.tool.Tool;
import jakarta.enterprise.context.ApplicationScoped;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@ApplicationScoped
@Slf4j
public class TimestampCalculator {
    @Tool(name = "timestamp-now", value = "Calculate the current timestamp.")
    public String getTimestampOfNow() {
        log.info("Calculating the current timestamp.");
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd. MMMM yyyy, HH:mm");
        return now.format(formatter);
    }
}
