# Glint Spring Framework

A comprehensive Java Spring Boot framework designed for enterprise applications with quick startup time, easy maintenance, and standardized error handling.

## 🚀 Features

- **Quick Startup**: Optimized Spring Boot configuration for faster application startup
- **Enterprise-Ready**: Built-in enterprise features and best practices
- **Custom Annotations**: Simplified development with meta-annotations
- **Standardized Error Handling**: Centralized exception management with error codes
- **Apache Standards**: Follows Apache Maven project standards
- **Code Quality**: Integrated CodeQL and Checkstyle for code quality assurance
- **CI/CD Ready**: Pre-configured GitHub Actions and CircleCI workflows

## 📦 Modules

### Core Modules

- **glint-core**: Core framework components and utilities
- **glint-annotations**: Custom annotations for simplified development
- **glint-starter**: Spring Boot starter for easy integration
- **glint-examples**: Example applications demonstrating framework usage

## 🛠️ Quick Start

### 1. Add Dependency

Add the Glint starter to your `pom.xml`:

```xml
<dependency>
    <groupId>com.glintsoft</groupId>
    <artifactId>glint-starter</artifactId>
    <version>1.0.0-SNAPSHOT</version>
</dependency>
```

### 2. Create Application Class

```java
import com.glintsoft.framework.annotation.GlintApplication;
import org.springframework.boot.SpringApplication;

@GlintApplication
public class MyApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyApplication.class, args);
    }
}
```

### 3. Create Service Layer

```java
import com.glintsoft.framework.annotation.GlintService;
import org.springframework.stereotype.Service;

@GlintService
public class UserService {
    // Your service implementation
}
```

### 4. Create REST Controller

```java
import com.glintsoft.framework.annotation.GlintController;
import org.springframework.web.bind.annotation.*;

@GlintController
@RequestMapping("/api/v1/users")
public class UserController {
    // Your controller implementation
}
```

## 🎯 Custom Annotations

### @GlintApplication

Meta-annotation that combines multiple Spring Boot annotations for enterprise applications:

- `@SpringBootApplication`
- `@EnableAspectJAutoProxy`
- `@EnableAsync`
- `@EnableScheduling`
- `@EnableTransactionManagement`

### @GlintService

Meta-annotation for service classes with built-in transaction management:

- `@Service`
- `@Transactional(readOnly = true)`

### @GlintController

Meta-annotation for REST controllers with enterprise features:

- `@RestController`
- Built-in API versioning
- Request/response logging

### @ErrorCode

Annotation for defining error codes and messages:

```java
@ErrorCode(code = "USER_NOT_FOUND", message = "User with ID {0} not found", httpStatus = 404)
public class UserNotFoundException extends GlintException {
    public UserNotFoundException(Long userId) {
        super("USER_NOT_FOUND", String.format("User with ID %d not found", userId));
    }
}
```

## 🔧 Error Handling

The framework provides centralized error handling with standardized error responses:

```json
{
  "errorCode": "USER_NOT_FOUND",
  "message": "User with ID 123 not found",
  "path": "/api/v1/users/123",
  "timestamp": "2024-01-15T10:30:00.000",
  "context": {
    "userId": 123
  }
}
```

## 📋 Code Quality

### Checkstyle Configuration

The framework includes Apache-compliant Checkstyle configuration:

```bash
mvn checkstyle:check
```

### CodeQL Security Analysis

Automated security analysis with GitHub CodeQL:

```bash
# Runs automatically on push/PR
# Manual trigger: GitHub Actions > CodeQL
```

### SpotBugs Integration

Static analysis for bug detection:

```bash
mvn spotbugs:check
```

## 🏗️ Project Structure

```
glint-spring-framework/
├── glint-core/                 # Core framework components
│   ├── src/main/java/
│   │   └── com/glintsoft/framework/
│   │       ├── exception/      # Exception handling
│   │       └── ...
├── glint-annotations/          # Custom annotations
│   ├── src/main/java/
│   │   └── com/glintsoft/framework/annotation/
├── glint-starter/             # Spring Boot starter
│   ├── src/main/java/
│   │   └── com/glintsoft/framework/starter/
├── glint-examples/            # Example applications
│   ├── src/main/java/
│   │   └── com/glintsoft/examples/
├── .github/workflows/         # CI/CD workflows
│   ├── ci.yml
│   └── codeql.yml
├── checkstyle.xml             # Checkstyle configuration
└── pom.xml                    # Parent POM
```

## 🚀 Performance Optimizations

### Startup Time Improvements

1. **Lazy Initialization**: Components are loaded on-demand
2. **Conditional Auto-configuration**: Only necessary components are configured
3. **Optimized Bean Scanning**: Reduced component scanning overhead

### Memory Optimization

1. **Connection Pooling**: Optimized database connection management
2. **Caching**: Built-in caching strategies
3. **Resource Management**: Efficient resource cleanup

## 🔒 Security Features

1. **Input Validation**: Built-in validation with Bean Validation
2. **SQL Injection Prevention**: Parameterized queries and JPA repositories
3. **XSS Protection**: Request/response sanitization
4. **Security Headers**: Automatic security header configuration

## 📊 Monitoring & Observability

1. **Actuator Integration**: Built-in health checks and metrics
2. **Structured Logging**: SLF4J with Logback configuration
3. **Tracing**: Request tracing with correlation IDs
4. **Metrics**: Application and business metrics

## 🧪 Testing

### Unit Testing

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    
    @Mock
    private UserRepository userRepository;
    
    @InjectMocks
    private UserService userService;
    
    @Test
    void shouldFindUserById() {
        // Test implementation
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
    void shouldCreateUser() {
        // Test implementation
    }
}
```

## 📈 CI/CD Pipeline

### GitHub Actions Workflows

1. **CI Pipeline** (`ci.yml`):
   - Java 17 setup
   - Maven dependency caching
   - Unit tests execution
   - Checkstyle validation
   - SpotBugs analysis
   - JaCoCo coverage reporting

2. **Security Analysis** (`codeql.yml`):
   - CodeQL security scanning
   - Vulnerability detection
   - Security report generation

### CircleCI Configuration

The project includes comprehensive CircleCI configuration with multiple workflows:

1. **Build & Test Pipeline**:
   - Parallel job execution
   - Maven dependency caching
   - Unit and integration tests
   - Code quality checks (Checkstyle, JaCoCo)
   - Security scanning (OWASP dependency check)
   - Artifact generation and storage

2. **Workflows**:
   - **Default**: Runs on all branches
   - **Nightly**: Daily health checks at 2 AM UTC
   - **Release**: Production builds on main branch

3. **Features**:
   - ✅ Parallel execution for faster builds
   - ✅ Comprehensive test coverage
   - ✅ Security vulnerability scanning
   - ✅ Quality gates and thresholds
   - ✅ Artifact storage and management
   - ✅ Slack notifications (optional)

For detailed CircleCI setup instructions, see [CIRCLECI_SETUP.md](CIRCLECI_SETUP.md).

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run quality checks: `mvn clean verify`
5. Submit a pull request

### Development Setup

```bash
# Clone repository
git clone https://github.com/glint-soft/glint-spring-framework.git

# Build project
mvn clean install

# Run tests
mvn test

# Run quality checks
mvn checkstyle:check spotbugs:check
```

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: [Wiki](https://github.com/glint-soft/glint-spring-framework/wiki)
- **Issues**: [GitHub Issues](https://github.com/glint-soft/glint-spring-framework/issues)
- **Discussions**: [GitHub Discussions](https://github.com/glint-soft/glint-spring-framework/discussions)

## 🗺️ Roadmap

- [ ] Spring Boot 3.3 support
- [ ] Reactive programming support
- [ ] GraphQL integration
- [ ] Kubernetes deployment templates
- [ ] Performance benchmarking tools
- [ ] Additional enterprise features

---

**Glint Spring Framework** - Enterprise-ready Spring Boot framework for modern Java applications.
