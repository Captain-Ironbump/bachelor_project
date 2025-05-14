package org.ba;

import org.ba.service.bots.ChatBot;

import io.quarkus.websockets.next.OnOpen;
import io.quarkus.websockets.next.OnTextMessage;
import io.quarkus.websockets.next.WebSocket;
import io.smallrye.mutiny.Multi;

@WebSocket(path = "/chat")
public class ChatBotResource {
    private final ChatBot bot;

    public ChatBotResource(ChatBot bot) {
        this.bot = bot;
    }

    @OnOpen
    public Multi<String> onOpen() {
        return bot.chat("Hello AI, please help me");
    }

    @OnTextMessage
    public Multi<String> onMessage(String message) {
        return bot.chat(message);
    }
}