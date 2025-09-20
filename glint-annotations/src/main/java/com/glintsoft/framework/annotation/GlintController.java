package com.glintsoft.framework.annotation;

import org.springframework.web.bind.annotation.RestController;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Meta-annotation for Glint REST controllers.
 * Provides enterprise-ready controller configuration with standardized response handling.
 * 
 * <p>This annotation provides:
 * <ul>
 *   <li>REST controller registration</li>
 *   <li>Standardized API versioning</li>
 *   <li>Enterprise response formatting</li>
 * </ul>
 * 
 * <p>Usage:
 * <pre>
 * &#64;GlintController
 * &#64;RequestMapping("/api/v1/users")
 * public class UserController {
 *     // Controller implementation
 * }
 * </pre>
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@RestController
public @interface GlintController {
    
    /**
     * The value may indicate a suggestion for a logical component name.
     */
    String value() default "";
    
    /**
     * API version for this controller.
     */
    String version() default "v1";
    
    /**
     * Whether to enable request/response logging.
     */
    boolean enableLogging() default true;
}
