package com.glintsoft.framework.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation for defining error codes and messages.
 * Used for centralized error code management and documentation.
 * 
 * <p>Usage:
 * <pre>
 * &#64;ErrorCode(code = "USER_NOT_FOUND", message = "User with ID {0} not found")
 * public class UserNotFoundException extends GlintException {
 *     public UserNotFoundException(String userId) {
 *         super("USER_NOT_FOUND", String.format("User with ID %s not found", userId));
 *     }
 * }
 * </pre>
 */
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface ErrorCode {
    
    /**
     * The error code identifier.
     */
    String code();
    
    /**
     * The error message template.
     * Supports parameterized messages using {0}, {1}, etc.
     */
    String message();
    
    /**
     * HTTP status code for this error.
     */
    int httpStatus() default 400;
    
    /**
     * Category of the error for grouping.
     */
    String category() default "GENERAL";
}
