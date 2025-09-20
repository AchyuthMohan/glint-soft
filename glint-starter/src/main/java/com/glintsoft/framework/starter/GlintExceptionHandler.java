package com.glintsoft.framework.starter;

import com.glintsoft.framework.exception.GlobalExceptionHandler;
import org.springframework.context.annotation.Configuration;

/**
 * Wrapper for GlobalExceptionHandler to enable auto-configuration.
 */
@Configuration
public class GlintExceptionHandler extends GlobalExceptionHandler {
    // Inherits all functionality from GlobalExceptionHandler
}
