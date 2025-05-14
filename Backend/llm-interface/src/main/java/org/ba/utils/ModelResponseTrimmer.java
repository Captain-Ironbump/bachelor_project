package org.ba.utils;

public class ModelResponseTrimmer {
    public static String trimThinking(String input) {
        return input.replaceAll("(?s)<think>.*?</think>", "").trim();
    }
}
