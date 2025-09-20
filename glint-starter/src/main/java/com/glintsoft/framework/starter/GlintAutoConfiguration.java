package com.glintsoft.framework.starter;

import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Auto-configuration for Glint Framework.
 * Automatically configures framework components when Glint starter is included.
 */
@Configuration
public class GlintAutoConfiguration {
    
    /**
     * Configures the global exception handler if not already present.
     */
    @Bean
    @ConditionalOnMissingBean
    public GlintExceptionHandler glintExceptionHandler() {
        return new GlintExceptionHandler();
    }
}
