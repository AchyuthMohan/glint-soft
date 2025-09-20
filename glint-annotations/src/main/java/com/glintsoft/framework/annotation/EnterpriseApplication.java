package com.glintsoft.framework.annotation;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Meta-annotation for enterprise Spring Boot applications.
 * Combines multiple Spring Boot annotations for enterprise-ready applications.
 * 
 * <p>This annotation includes:
 * <ul>
 *   <li>Spring Boot auto-configuration</li>
 *   <li>AspectJ auto-proxy for AOP</li>
 *   <li>Async processing support</li>
 *   <li>Scheduled task support</li>
 *   <li>Transaction management</li>
 * </ul>
 * 
 * <p>Usage:
 * <pre>
 * &#64;EnterpriseApplication
 * public class MyApplication {
 *     public static void main(String[] args) {
 *         SpringApplication.run(MyApplication.class, args);
 *     }
 * }
 * </pre>
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@SpringBootApplication
@EnableAspectJAutoProxy
@EnableAsync
@EnableScheduling
@EnableTransactionManagement
public @interface EnterpriseApplication {
    
    /**
     * Exclude specific auto-configuration classes.
     */
    Class<?>[] exclude() default {};
    
    /**
     * Exclude specific auto-configuration class names.
     */
    String[] excludeName() default {};
    
    /**
     * Specify the name of the Spring profile(s) to activate.
     */
    String[] profiles() default {};
    
    /**
     * Whether to enable web environment.
     */
    boolean web() default true;
}
