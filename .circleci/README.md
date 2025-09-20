# CircleCI Configuration for Glint Spring Framework

This directory contains the CircleCI configuration files for the Glint Spring Framework project.

## 📁 Files Overview

- **`config.yml`** - Main CircleCI configuration file
- **`env.yml`** - Environment variables and configuration
- **`setup.sh`** - Setup script for CI environment
- **`README.md`** - This documentation file

## 🚀 Quick Start

### 1. Connect Repository to CircleCI

1. Go to [CircleCI](https://circleci.com/)
2. Sign in with your GitHub account
3. Click "Add Projects"
4. Find your `glint-spring-framework` repository
5. Click "Set Up Project"
6. Select "Use existing config" and click "Start Building"

### 2. Configure Environment Variables

In your CircleCI project settings, add the following environment variables:

```bash
# Optional: Slack notifications
SLACK_WEBHOOK_URL=your_slack_webhook_url

# Optional: Docker registry
DOCKER_REGISTRY=docker.io
DOCKER_NAMESPACE=your_namespace

# Optional: Deployment
DEPLOY_ENVIRONMENT=staging
```

## 🔧 Configuration Details

### Workflows

The CI pipeline includes the following workflows:

#### 1. **build-test-and-deploy** (Default)
- **Triggers**: All branches
- **Jobs**:
  - `build-and-test` - Compile and run unit tests
  - `code-quality` - Checkstyle and JaCoCo coverage
  - `security-scan` - OWASP dependency check
  - `integration-tests` - End-to-end API testing
  - `build-package` - Create JAR artifacts

#### 2. **nightly-build**
- **Triggers**: Daily at 2 AM UTC
- **Jobs**: Same as default workflow
- **Purpose**: Regular health checks

#### 3. **release**
- **Triggers**: `main` branch only
- **Jobs**: Same as default workflow
- **Purpose**: Production-ready builds

### Jobs Overview

#### 🔨 **build-and-test**
- **Purpose**: Compile code and run unit tests
- **Docker Image**: `openjdk:17-jdk-slim`
- **Steps**:
  - Checkout code
  - Cache Maven dependencies
  - Install Maven
  - Run `mvn clean compile test`
  - Generate test reports
  - Store test results and artifacts

#### 📊 **code-quality**
- **Purpose**: Code quality and coverage analysis
- **Steps**:
  - Run Checkstyle analysis
  - Generate JaCoCo coverage report
  - Store quality reports
- **Artifacts**: Checkstyle HTML report, Coverage HTML report

#### 🔒 **security-scan**
- **Purpose**: Security vulnerability scanning
- **Steps**:
  - Run OWASP dependency check
  - Generate security report
  - Store security artifacts
- **Artifacts**: Dependency check HTML report

#### 🧪 **integration-tests**
- **Purpose**: End-to-end API testing
- **Steps**:
  - Build framework modules
  - Start example application
  - Test health endpoint
  - Test API endpoints (GET, POST)
  - Verify application functionality

#### 📦 **build-package**
- **Purpose**: Create distributable artifacts
- **Steps**:
  - Build all modules
  - Package JAR files
  - Build example application
  - Store JAR artifacts
- **Artifacts**: All framework JAR files

## 📋 Prerequisites

### Required Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `JAVA_VERSION` | Java version to use | No | 17 |
| `MAVEN_VERSION` | Maven version | No | 3.9.6 |
| `BUILD_PROFILE` | Maven build profile | No | ci |
| `CHECKSTYLE_CONFIG` | Checkstyle config file | No | checkstyle-minimal.xml |
| `JACOCO_THRESHOLD` | Coverage threshold | No | 0.8 |

### Optional Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `SLACK_WEBHOOK_URL` | Slack webhook for notifications | No | - |
| `DOCKER_REGISTRY` | Docker registry URL | No | docker.io |
| `DEPLOY_ENVIRONMENT` | Deployment environment | No | staging |

## 🎯 Build Process

### 1. **Dependency Caching**
- Maven dependencies are cached using `pom.xml` checksum
- Cache is restored on each build for faster execution
- Cache is saved after successful dependency resolution

### 2. **Parallel Execution**
- Jobs run in parallel where possible
- `build-and-test`, `code-quality`, and `security-scan` run simultaneously
- `integration-tests` runs after `build-and-test` completes
- `build-package` runs after all other jobs complete

### 3. **Artifact Storage**
- Test results stored for 30 days
- Coverage reports stored as HTML artifacts
- Security reports stored as HTML artifacts
- JAR files stored for distribution

### 4. **Quality Gates**
- All tests must pass
- Checkstyle violations must be resolved
- Coverage must meet threshold (80%)
- No high-severity security vulnerabilities

## 🔍 Monitoring and Notifications

### Build Status
- ✅ **Success**: All jobs completed successfully
- ❌ **Failed**: One or more jobs failed
- ⚠️ **Warning**: Jobs completed with warnings

### Notifications
- **Slack**: Configure `SLACK_WEBHOOK_URL` for team notifications
- **Email**: Automatic notifications to commit author
- **GitHub**: Status checks on pull requests

### Artifacts
- **Test Results**: JUnit XML reports
- **Coverage**: JaCoCo HTML reports
- **Security**: OWASP dependency check reports
- **Builds**: JAR artifacts for distribution

## 🛠️ Troubleshooting

### Common Issues

#### 1. **Build Failures**
```bash
# Check build logs
# Look for specific error messages
# Verify environment variables are set
```

#### 2. **Test Failures**
```bash
# Check test output in artifacts
# Verify test database configuration
# Check for flaky tests
```

#### 3. **Security Scan Failures**
```bash
# Review dependency check report
# Update vulnerable dependencies
# Add exclusions if needed
```

#### 4. **Integration Test Failures**
```bash
# Check application startup logs
# Verify port availability
# Check database connectivity
```

### Debug Mode

To enable debug mode, add this environment variable:
```bash
DEBUG=true
```

This will provide additional logging and verbose output.

## 📈 Performance Optimization

### Caching Strategy
- **Maven Dependencies**: Cached by `pom.xml` checksum
- **Build Artifacts**: Cached for 24 hours
- **Test Results**: Cached for 30 days

### Parallel Execution
- **Jobs**: Run in parallel where dependencies allow
- **Tests**: Use parallel test execution
- **Maven**: Use parallel dependency resolution

### Resource Allocation
- **Memory**: 2GB heap size for Maven
- **CPU**: 4 parallel jobs
- **Timeout**: 10 minutes per job

## 🔄 Maintenance

### Regular Tasks
- **Weekly**: Review build performance metrics
- **Monthly**: Update dependency versions
- **Quarterly**: Review and update CI configuration

### Updates
- **Java Version**: Update when new LTS versions are available
- **Maven Version**: Update for security and performance
- **Docker Images**: Update base images regularly

## 📚 Additional Resources

- [CircleCI Documentation](https://circleci.com/docs/)
- [Maven CI Best Practices](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)
- [Spring Boot Testing](https://spring.io/guides/gs/testing-web/)
- [OWASP Dependency Check](https://owasp.org/www-project-dependency-check/)

## 🤝 Contributing

When contributing to the CI configuration:

1. **Test Locally**: Use CircleCI CLI to test changes
2. **Small Changes**: Make incremental improvements
3. **Documentation**: Update this README for any changes
4. **Review**: Have changes reviewed by team members

## 📞 Support

For CI-related issues:
- Check CircleCI documentation
- Review build logs and artifacts
- Contact the development team
- Create an issue in the repository

---

**Happy Building! 🚀**
