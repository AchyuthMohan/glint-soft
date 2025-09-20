package com.glintsoft.framework.exception;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * Base exception class for Glint Framework.
 * Provides structured error handling with error codes and context.
 */
public class GlintException extends RuntimeException {
    
    private static final long serialVersionUID = 1L;
    
    private final String errorCode;
    private final String errorMessage;
    private final LocalDateTime timestamp;
    private final Map<String, Object> context;
    
    public GlintException(String errorCode, String errorMessage) {
        super(errorMessage);
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
        this.timestamp = LocalDateTime.now();
        this.context = null;
    }
    
    public GlintException(String errorCode, String errorMessage, Throwable cause) {
        super(errorMessage, cause);
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
        this.timestamp = LocalDateTime.now();
        this.context = null;
    }
    
    public GlintException(String errorCode, String errorMessage, Map<String, Object> context) {
        super(errorMessage);
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
        this.timestamp = LocalDateTime.now();
        this.context = context;
    }
    
    public GlintException(String errorCode, String errorMessage, Throwable cause, Map<String, Object> context) {
        super(errorMessage, cause);
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
        this.timestamp = LocalDateTime.now();
        this.context = context;
    }
    
    public String getErrorCode() {
        return errorCode;
    }
    
    public String getErrorMessage() {
        return errorMessage;
    }
    
    public LocalDateTime getTimestamp() {
        return timestamp;
    }
    
    public Map<String, Object> getContext() {
        return context;
    }
}
