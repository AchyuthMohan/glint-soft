#!/bin/bash

# CircleCI Setup Script for Glint Spring Framework
# This script sets up the environment and dependencies for CircleCI builds

set -e

echo "🚀 Setting up Glint Spring Framework CI environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running in CircleCI
if [ -n "$CIRCLECI" ]; then
    print_status "Running in CircleCI environment"
    export CI=true
else
    print_warning "Not running in CircleCI environment"
fi

# Set environment variables
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512m"

print_status "Java version: $(java -version 2>&1 | head -n 1)"
print_status "Maven version: $(mvn -version | head -n 1)"

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p ~/.m2/repository
mkdir -p target/reports
mkdir -p target/site
mkdir -p ~/test-results/junit

# Set Maven settings
print_status "Configuring Maven settings..."
cat > ~/.m2/settings.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                              http://maven.apache.org/xsd/settings-1.0.0.xsd">
    <localRepository>~/.m2/repository</localRepository>
    <interactiveMode>false</interactiveMode>
    <offline>false</offline>
    <mirrors>
        <mirror>
            <id>central</id>
            <name>Maven Central</name>
            <url>https://repo1.maven.org/maven2/</url>
            <mirrorOf>*</mirrorOf>
        </mirror>
    </mirrors>
    <profiles>
        <profile>
            <id>ci</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <maven.test.failure.ignore>false</maven.test.failure.ignore>
                <maven.test.skip>false</maven.test.skip>
                <skip.integration.tests>false</skip.integration.tests>
                <maven.javadoc.skip>false</maven.javadoc.skip>
                <maven.source.skip>false</maven.source.skip>
            </properties>
        </profile>
    </profiles>
</settings>
EOF

# Install additional tools if needed
print_status "Installing additional tools..."
apt-get update -qq
apt-get install -y -qq curl wget unzip

# Set up test database configuration
print_status "Setting up test database configuration..."
export SPRING_PROFILES_ACTIVE=test,ci
export SPRING_DATASOURCE_URL=jdbc:h2:mem:testdb
export SPRING_DATASOURCE_USERNAME=sa
export SPRING_DATASOURCE_PASSWORD=password

# Configure logging for CI
print_status "Configuring logging for CI..."
export LOGGING_LEVEL_ROOT=INFO
export LOGGING_LEVEL_COM_GLINTSOFT=DEBUG
export LOGGING_LEVEL_ORG_SPRINGFRAMEWORK_WEB=DEBUG

# Set up artifact paths
print_status "Setting up artifact paths..."
export ARTIFACT_BASE_PATH=target
export REPORT_BASE_PATH=target/site

# Configure parallel execution
print_status "Configuring parallel execution..."
export MAVEN_OPTS="$MAVEN_OPTS -Dmaven.artifact.threads=4"

# Set up security scanning
print_status "Setting up security scanning..."
export DEPENDENCY_CHECK_VERSION=8.4.0
export SECURITY_SCAN_ENABLED=true

# Configure performance monitoring
print_status "Configuring performance monitoring..."
export MONITORING_ENABLED=true
export METRICS_ENDPOINT=/actuator/metrics
export HEALTH_ENDPOINT=/actuator/health

# Set up notification configuration
if [ -n "$SLACK_WEBHOOK_URL" ]; then
    print_status "Slack webhook configured for notifications"
    export NOTIFICATION_ENABLED=true
else
    print_warning "Slack webhook not configured - notifications disabled"
    export NOTIFICATION_ENABLED=false
fi

# Create test data directory
print_status "Creating test data directory..."
mkdir -p test-data
echo "Test data directory created" > test-data/README.md

# Set up code quality tools
print_status "Setting up code quality tools..."
export CHECKSTYLE_CONFIG=checkstyle-minimal.xml
export JACOCO_THRESHOLD=0.8
export SPOTBUGS_ENABLED=false  # Disabled due to Java 17 compatibility

# Configure build optimization
print_status "Configuring build optimization..."
export MAVEN_COMPILER_SOURCE=17
export MAVEN_COMPILER_TARGET=17
export MAVEN_COMPILER_RELEASE=17

# Set up integration test configuration
print_status "Setting up integration test configuration..."
export INTEGRATION_TEST_PORT=8080
export INTEGRATION_TEST_TIMEOUT=300
export INTEGRATION_TEST_RETRIES=3

# Create CircleCI specific configuration
print_status "Creating CircleCI specific configuration..."
cat > circleci.properties << EOF
# CircleCI specific properties
circleci.build.number=${CIRCLE_BUILD_NUM:-local}
circleci.build.url=${CIRCLE_BUILD_URL:-local}
circleci.commit.sha=${CIRCLE_SHA1:-local}
circleci.branch=${CIRCLE_BRANCH:-local}
circleci.project.name=${CIRCLE_PROJECT_REPONAME:-glint-spring-framework}
circleci.user.name=${CIRCLE_USERNAME:-local}
EOF

# Set up Docker configuration if needed
if [ -n "$DOCKER_REGISTRY" ]; then
    print_status "Docker registry configured: $DOCKER_REGISTRY"
    export DOCKER_ENABLED=true
else
    print_warning "Docker registry not configured"
    export DOCKER_ENABLED=false
fi

# Final environment check
print_status "Performing final environment check..."
echo "Environment variables:"
echo "  JAVA_HOME: $JAVA_HOME"
echo "  MAVEN_OPTS: $MAVEN_OPTS"
echo "  SPRING_PROFILES_ACTIVE: $SPRING_PROFILES_ACTIVE"
echo "  CI: $CI"
echo "  CIRCLE_BUILD_NUM: ${CIRCLE_BUILD_NUM:-not set}"
echo "  CIRCLE_SHA1: ${CIRCLE_SHA1:-not set}"
echo "  CIRCLE_BRANCH: ${CIRCLE_BRANCH:-not set}"

# Test Maven configuration
print_status "Testing Maven configuration..."
mvn -version
mvn help:effective-settings | grep -E "(localRepository|mirrors)" || true

print_success "CircleCI setup completed successfully!"
print_status "Ready to run Glint Spring Framework builds"

# Create a summary report
cat > setup-summary.txt << EOF
CircleCI Setup Summary
=====================
Date: $(date)
Java Version: $(java -version 2>&1 | head -n 1)
Maven Version: $(mvn -version | head -n 1)
Environment: ${CI:-local}
Build Number: ${CIRCLE_BUILD_NUM:-local}
Commit SHA: ${CIRCLE_SHA1:-local}
Branch: ${CIRCLE_BRANCH:-local}

Configuration:
- Maven Repository: ~/.m2/repository
- Test Database: H2 in-memory
- Logging Level: INFO (DEBUG for com.glintsoft)
- Parallel Execution: Enabled
- Security Scanning: Enabled
- Code Quality: Checkstyle, JaCoCo
- Notifications: ${NOTIFICATION_ENABLED:-false}

Ready for build!
EOF

print_success "Setup summary saved to setup-summary.txt"
