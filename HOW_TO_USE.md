# How to Use Glint Spring Framework

## 🚀 Quick Start Guide

### Prerequisites
- Java 17 or higher
- Maven 3.6 or higher
- Your favorite IDE (IntelliJ IDEA, Eclipse, VS Code)

---

## 📦 Step 1: Add Dependency

Add the Glint starter to your `pom.xml`:

```xml
<dependency>
    <groupId>com.glintsoft</groupId>
    <artifactId>glint-starter</artifactId>
    <version>1.0.0-SNAPSHOT</version>
</dependency>
```

---

## 🏗️ Step 2: Create Your Application

### 2.1 Create Main Application Class

```java
package com.example.myapp;

import com.glintsoft.framework.annotation.GlintApplication;
import org.springframework.boot.SpringApplication;

@GlintApplication
public class MyApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyApplication.class, args);
    }
}
```

**What `@GlintApplication` does:**
- Combines `@SpringBootApplication`
- Enables AspectJ auto-proxy
- Enables async processing
- Enables scheduling
- Enables transaction management

---

## 🎯 Step 3: Create Your Service Layer

### 3.1 Create a Service Class

```java
package com.example.myapp.service;

import com.glintsoft.framework.annotation.GlintService;
import com.glintsoft.framework.annotation.ErrorCode;
import com.glintsoft.framework.exception.GlintException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@GlintService
public class UserService {
    
    // This service automatically has:
    // - @Service annotation
    // - @Transactional(readOnly = true) by default
    
    public String getUserById(Long id) {
        if (id == null || id <= 0) {
            throw new InvalidUserIdException(id);
        }
        
        // Your business logic here
        return "User " + id;
    }
    
    @Transactional  // Override default read-only for write operations
    public String createUser(String name) {
        // Your create logic here
        return "Created user: " + name;
    }
    
    // Custom exception with error code
    @ErrorCode(code = "INVALID_USER_ID", message = "Invalid user ID: {0}", httpStatus = 400)
    public static class InvalidUserIdException extends GlintException {
        public InvalidUserIdException(Long id) {
            super("INVALID_USER_ID", String.format("Invalid user ID: %s", id));
        }
    }
}
```

---

## 🌐 Step 4: Create Your REST Controller

### 4.1 Create a Controller Class

```java
package com.example.myapp.controller;

import com.glintsoft.framework.annotation.GlintController;
import com.example.myapp.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@GlintController
@RequestMapping("/api/v1/users")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/{id}")
    public ResponseEntity<String> getUser(@PathVariable Long id) {
        String user = userService.getUserById(id);
        return ResponseEntity.ok(user);
    }
    
    @PostMapping
    public ResponseEntity<String> createUser(@RequestBody String name) {
        String result = userService.createUser(name);
        return ResponseEntity.ok(result);
    }
}
```

**What `@GlintController` does:**
- Combines `@RestController`
- Provides enterprise-ready controller configuration
- Enables request/response logging
- Supports API versioning

---

## ⚙️ Step 5: Configure Your Application

### 5.1 Create application.yml

```yaml
server:
  port: 8080
  servlet:
    context-path: /

spring:
  application:
    name: my-glint-app
  
  # Database configuration (example with H2)
  datasource:
    url: jdbc:h2:mem:testdb
    driver-class-name: org.h2.Driver
    username: sa
    password: password
  
  h2:
    console:
      enabled: true
      path: /h2-console
  
  jpa:
    hibernate:
      ddl-auto: create-drop
    show-sql: true

# Glint Framework specific configuration
glint:
  error-handling:
    enable-logging: true
    include-stack-trace: false
  logging:
    enable-request-logging: true
    enable-response-logging: true

# Actuator endpoints
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
  endpoint:
    health:
      show-details: always
```

---

## 🏃‍♂️ Step 6: Run Your Application

### 6.1 Run from Command Line

```bash
# Navigate to your project directory
cd your-project-directory

# Run the application
mvn spring-boot:run
```

### 6.2 Run from IDE

1. Open your IDE
2. Navigate to `MyApplication.java`
3. Right-click and select "Run MyApplication"
4. Or use the Run button in your IDE

---

## 🧪 Step 7: Test Your Application

### 7.1 Test with curl

```bash
# Test GET endpoint
curl http://localhost:8080/api/v1/users/123

# Test POST endpoint
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '"John Doe"'

# Test error handling
curl http://localhost:8080/api/v1/users/-1
```

### 7.2 Expected Responses

**Success Response:**
```json
"User 123"
```

**Error Response (automatic):**
```json
{
  "errorCode": "INVALID_USER_ID",
  "message": "Invalid user ID: -1",
  "path": "/api/v1/users/-1",
  "timestamp": "2024-01-15T10:30:00.000"
}
```

---

## 🔧 Advanced Usage

### Custom Error Codes

```java
@ErrorCode(code = "USER_NOT_FOUND", message = "User with ID {0} not found", httpStatus = 404)
public class UserNotFoundException extends GlintException {
    public UserNotFoundException(Long userId) {
        super("USER_NOT_FOUND", String.format("User with ID %d not found", userId));
    }
}
```

### Service with Custom Transaction Settings

```java
@GlintService
public class OrderService {
    
    @Transactional(readOnly = false)  // Override default read-only
    public void processOrder(Order order) {
        // Write operations here
    }
    
    public Order getOrder(Long id) {
        // Read-only operation (default)
        return orderRepository.findById(id);
    }
}
```

### Controller with Custom Configuration

```java
@GlintController(version = "v2", enableLogging = false)
@RequestMapping("/api/v2/users")
public class UserV2Controller {
    // Custom version and logging settings
}
```

---

## 📊 Monitoring and Health Checks

### Access Health Endpoints

```bash
# Application health
curl http://localhost:8080/actuator/health

# Application info
curl http://localhost:8080/actuator/info

# Metrics
curl http://localhost:8080/actuator/metrics
```

### H2 Database Console

Visit: `http://localhost:8080/h2-console`
- JDBC URL: `jdbc:h2:mem:testdb`
- Username: `sa`
- Password: `password`

---

## 🧪 Testing Your Application

### Unit Testing

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    
    @Mock
    private UserRepository userRepository;
    
    @InjectMocks
    private UserService userService;
    
    @Test
    void shouldThrowExceptionForInvalidUserId() {
        // Test invalid user ID
        assertThrows(InvalidUserIdException.class, 
            () -> userService.getUserById(-1L));
    }
}
```

### Integration Testing

```java
@SpringBootTest
@AutoConfigureTestDatabase
class UserControllerIntegrationTest {
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Test
    void shouldReturnUser() {
        ResponseEntity<String> response = restTemplate.getForEntity(
            "/api/v1/users/123", String.class);
        
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("User 123", response.getBody());
    }
}
```

---

## 🚀 Production Deployment

### 1. Build the Application

```bash
mvn clean package
```

### 2. Run the JAR

```bash
java -jar target/my-app-1.0.0.jar
```

### 3. Docker Deployment

```dockerfile
FROM openjdk:17-jdk-slim
COPY target/my-app-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

---

## 🔍 Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Change port in application.yml
   server:
     port: 8081
   ```

2. **Database Connection Issues**
   ```yaml
   # Check database configuration
   spring:
     datasource:
       url: jdbc:h2:mem:testdb
       username: sa
       password: password
   ```

3. **Missing Dependencies**
   ```xml
   <!-- Add required dependencies to pom.xml -->
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-data-jpa</artifactId>
   </dependency>
   ```

### Debug Mode

```bash
# Run with debug logging
mvn spring-boot:run -Dspring-boot.run.arguments="--debug"
```

---

## 📚 Next Steps

1. **Explore Examples**: Check the `glint-examples` module for complete examples
2. **Read Documentation**: Review `README.md` and `ARCHITECTURE.md`
3. **Customize Configuration**: Modify `application.yml` for your needs
4. **Add Database**: Integrate with your preferred database
5. **Add Security**: Implement authentication and authorization
6. **Deploy**: Use the provided CI/CD workflows

---

## 🆘 Getting Help

- **Documentation**: Check the `README.md` and `ARCHITECTURE.md` files
- **Examples**: Review the `glint-examples` module
- **Issues**: Create an issue in the project repository
- **Discussions**: Join the project discussions

---

## 🎉 Congratulations!

You've successfully created your first Glint Spring Framework application! The framework has automatically configured:

✅ **Enterprise features** (AOP, async, scheduling, transactions)  
✅ **Standardized error handling** with error codes  
✅ **REST API** with proper HTTP status codes  
✅ **Health checks** and monitoring  
✅ **Code quality** tools integration  

Your application is now ready for development and production use!
