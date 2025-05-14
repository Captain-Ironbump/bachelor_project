package org.ba.configuration;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import dev.langchain4j.memory.chat.ChatMemoryProvider;
import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import dev.langchain4j.memory.ChatMemory;
import jakarta.annotation.PreDestroy;
import jakarta.enterprise.context.RequestScoped;

@RequestScoped
public class ChatMemoryBean implements ChatMemoryProvider {
    Map<Object, ChatMemory> memories = new ConcurrentHashMap<>();
    
    @Override
    public ChatMemory get(Object memoryId) {
        return memories.computeIfAbsent(memoryId,
            id -> MessageWindowChatMemory.builder()
                    .maxMessages(10)
                    .id(memoryId)
                    .build()
            );
    }

    @PreDestroy
    public void close() {
        memories.clear();
    }
}
