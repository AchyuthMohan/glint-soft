package com.glintsoft.examples;

import com.glintsoft.framework.annotation.GlintApplication;
import org.springframework.boot.SpringApplication;

/**
 * Example application demonstrating Glint Framework usage.
 */
@GlintApplication
public class ExampleApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(ExampleApplication.class, args);
    }
}
