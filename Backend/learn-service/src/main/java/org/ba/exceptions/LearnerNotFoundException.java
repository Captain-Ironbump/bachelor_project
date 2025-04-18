package org.ba.exceptions;

public class LearnerNotFoundException extends RuntimeException {
    public LearnerNotFoundException(String message) {
        super(message);
    }
}
