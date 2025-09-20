#!/bin/bash

# CircleCI Configuration Validation Script
# This script validates the CircleCI configuration files

set -e

echo "🔍 Validating CircleCI configuration..."

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

# Check if CircleCI CLI is installed
check_circleci_cli() {
    print_status "Checking CircleCI CLI installation..."
    if command -v circleci &> /dev/null; then
        print_success "CircleCI CLI is installed: $(circleci version)"
        return 0
    else
        print_warning "CircleCI CLI not found. Install it for local testing:"
        echo "  curl -fLSs https://raw.githubusercontent.com/CircleCI-Public/circleci-cli/main/install.sh | sudo bash"
        return 1
    fi
}

# Validate YAML syntax
validate_yaml() {
    print_status "Validating YAML syntax..."
    
    # Check main config
    if [ -f ".circleci/config.yml" ]; then
        if python3 -c "import yaml; yaml.safe_load(open('.circleci/config.yml'))" 2>/dev/null; then
            print_success "config.yml syntax is valid"
        else
            print_error "config.yml has syntax errors"
            return 1
        fi
    else
        print_error "config.yml not found"
        return 1
    fi
    
    # Check local config
    if [ -f ".circleci/local-config.yml" ]; then
        if python3 -c "import yaml; yaml.safe_load(open('.circleci/local-config.yml'))" 2>/dev/null; then
            print_success "local-config.yml syntax is valid"
        else
            print_error "local-config.yml has syntax errors"
            return 1
        fi
    fi
    
    # Check env config
    if [ -f ".circleci/env.yml" ]; then
        if python3 -c "import yaml; yaml.safe_load(open('.circleci/env.yml'))" 2>/dev/null; then
            print_success "env.yml syntax is valid"
        else
            print_error "env.yml has syntax errors"
            return 1
        fi
    fi
}

# Validate CircleCI config with CLI
validate_circleci_config() {
    if check_circleci_cli; then
        print_status "Validating CircleCI configuration with CLI..."
        if circleci config validate .circleci/config.yml; then
            print_success "CircleCI configuration is valid"
        else
            print_error "CircleCI configuration validation failed"
            return 1
        fi
    else
        print_warning "Skipping CircleCI CLI validation (CLI not installed)"
    fi
}

# Check required files
check_required_files() {
    print_status "Checking required files..."
    
    local required_files=(
        ".circleci/config.yml"
        ".circleci/setup.sh"
        ".circleci/README.md"
    )
    
    local missing_files=()
    
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            print_success "Found: $file"
        else
            print_error "Missing: $file"
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -eq 0 ]; then
        print_success "All required files present"
        return 0
    else
        print_error "Missing ${#missing_files[@]} required files"
        return 1
    fi
}

# Check file permissions
check_permissions() {
    print_status "Checking file permissions..."
    
    if [ -f ".circleci/setup.sh" ]; then
        if [ -x ".circleci/setup.sh" ]; then
            print_success "setup.sh is executable"
        else
            print_warning "setup.sh is not executable, fixing..."
            chmod +x .circleci/setup.sh
            print_success "setup.sh permissions fixed"
        fi
    fi
}

# Validate Maven configuration
validate_maven_config() {
    print_status "Validating Maven configuration..."
    
    if [ -f "pom.xml" ]; then
        print_success "Found pom.xml"
        
        # Check for required plugins
        local required_plugins=(
            "maven-compiler-plugin"
            "maven-surefire-plugin"
            "maven-checkstyle-plugin"
            "jacoco-maven-plugin"
        )
        
        for plugin in "${required_plugins[@]}"; do
            if grep -q "$plugin" pom.xml; then
                print_success "Found plugin: $plugin"
            else
                print_warning "Plugin not found: $plugin"
            fi
        done
    else
        print_error "pom.xml not found"
        return 1
    fi
}

# Check environment variables
check_environment_variables() {
    print_status "Checking environment variables..."
    
    local required_vars=(
        "JAVA_VERSION"
        "MAVEN_VERSION"
        "BUILD_PROFILE"
    )
    
    local missing_vars=()
    
    for var in "${required_vars[@]}"; do
        if grep -q "$var" .circleci/env.yml; then
            print_success "Found environment variable: $var"
        else
            print_warning "Environment variable not found: $var"
            missing_vars+=("$var")
        fi
    done
    
    if [ ${#missing_vars[@]} -eq 0 ]; then
        print_success "All required environment variables present"
    else
        print_warning "Missing ${#missing_vars[@]} environment variables"
    fi
}

# Test local configuration
test_local_config() {
    print_status "Testing local configuration..."
    
    if [ -f ".circleci/local-config.yml" ]; then
        if check_circleci_cli; then
            if circleci config validate .circleci/local-config.yml; then
                print_success "Local configuration is valid"
            else
                print_error "Local configuration validation failed"
                return 1
            fi
        else
            print_warning "Skipping local config validation (CLI not installed)"
        fi
    else
        print_warning "Local configuration file not found"
    fi
}

# Generate validation report
generate_report() {
    print_status "Generating validation report..."
    
    local report_file="circleci-validation-report.txt"
    
    cat > "$report_file" << EOF
CircleCI Configuration Validation Report
=======================================
Date: $(date)
Repository: $(basename "$PWD")

Validation Results:
- YAML Syntax: $([ $? -eq 0 ] && echo "PASS" || echo "FAIL")
- CircleCI Config: $([ $? -eq 0 ] && echo "PASS" || echo "FAIL")
- Required Files: $([ $? -eq 0 ] && echo "PASS" || echo "FAIL")
- File Permissions: $([ $? -eq 0 ] && echo "PASS" || echo "FAIL")
- Maven Config: $([ $? -eq 0 ] && echo "PASS" || echo "FAIL")
- Environment Variables: $([ $? -eq 0 ] && echo "PASS" || echo "FAIL")
- Local Config: $([ $? -eq 0 ] && echo "PASS" || echo "FAIL")

Files Checked:
$(find .circleci -type f -name "*.yml" -o -name "*.sh" -o -name "*.md" | sort)

Environment Variables:
$(grep -E "^[A-Z_]+:" .circleci/env.yml | cut -d: -f1 | sort)

Recommendations:
1. Install CircleCI CLI for local testing
2. Test configuration with: circleci config validate
3. Run local tests with: circleci local execute
4. Review environment variables in CircleCI project settings

EOF

    print_success "Validation report saved to: $report_file"
}

# Main validation function
main() {
    print_status "Starting CircleCI configuration validation..."
    
    local exit_code=0
    
    # Run all validations
    validate_yaml || exit_code=1
    validate_circleci_config || exit_code=1
    check_required_files || exit_code=1
    check_permissions || exit_code=1
    validate_maven_config || exit_code=1
    check_environment_variables || exit_code=1
    test_local_config || exit_code=1
    generate_report
    
    if [ $exit_code -eq 0 ]; then
        print_success "All validations passed! ✅"
        echo ""
        echo "Next steps:"
        echo "1. Push changes to GitHub"
        echo "2. Connect repository to CircleCI"
        echo "3. Configure environment variables"
        echo "4. Start building!"
    else
        print_error "Some validations failed! ❌"
        echo ""
        echo "Please fix the issues above before proceeding."
    fi
    
    return $exit_code
}

# Run main function
main "$@"
