package com.glintsoft.framework.annotation;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Meta-annotation for Glint service classes.
 * Combines @Service with @Transactional for enterprise-ready service layer.
 * 
 * <p>This annotation provides:
 * <ul>
 *   <li>Spring service component registration</li>
 *   <li>Default transaction management</li>
 *   <li>Read-only transaction optimization</li>
 * </ul>
 * 
 * <p>Usage:
 * <pre>
 * &#64;GlintService
 * public class UserService {
 *     // Service implementation
 * }
 * </pre>
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Service
@Transactional(readOnly = true)
public @interface GlintService {
    
    /**
     * The value may indicate a suggestion for a logical component name.
     */
    String value() default "";
    
    /**
     * Whether to enable transaction management.
     */
    boolean transactional() default true;
    
    /**
     * Whether the transaction is read-only.
     */
    boolean readOnly() default true;
}
