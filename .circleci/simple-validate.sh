#!/bin/bash

# Simple CircleCI Configuration Validation
# This script performs basic validation without external dependencies

set -e

echo "🔍 Simple CircleCI configuration validation..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Basic YAML syntax check
check_yaml_basic() {
    print_status "Performing basic YAML syntax check..."
    
    local files=(".circleci/config.yml" ".circleci/local-config.yml" ".circleci/env.yml")
    local errors=0
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            # Check for basic YAML structure
            if grep -q "^version:" "$file" || grep -q "^[A-Z_]*:" "$file"; then
                print_success "Basic YAML structure OK: $file"
            else
                print_error "Invalid YAML structure: $file"
                errors=$((errors + 1))
            fi
            
            # Check for common YAML issues
            if grep -q ":$" "$file" && ! grep -q ":\s*$" "$file"; then
                print_success "No trailing colons: $file"
            else
                print_warning "Check for trailing colons: $file"
            fi
        else
            print_warning "File not found: $file"
        fi
    done
    
    return $errors
}

# Check required sections
check_required_sections() {
    print_status "Checking required CircleCI sections..."
    
    local config_file=".circleci/config.yml"
    local errors=0
    
    if [ -f "$config_file" ]; then
        # Check for version
        if grep -q "^version:" "$config_file"; then
            print_success "Version section found"
        else
            print_error "Version section missing"
            errors=$((errors + 1))
        fi
        
        # Check for jobs
        if grep -q "^jobs:" "$config_file"; then
            print_success "Jobs section found"
        else
            print_error "Jobs section missing"
            errors=$((errors + 1))
        fi
        
        # Check for workflows
        if grep -q "^workflows:" "$config_file"; then
            print_success "Workflows section found"
        else
            print_error "Workflows section missing"
            errors=$((errors + 1))
        fi
        
        # Check for required jobs
        local required_jobs=("build-and-test" "code-quality" "security-scan" "integration-tests" "build-package")
        for job in "${required_jobs[@]}"; do
            if grep -q "^  $job:" "$config_file"; then
                print_success "Job found: $job"
            else
                print_warning "Job not found: $job"
            fi
        done
    else
        print_error "Config file not found: $config_file"
        errors=$((errors + 1))
    fi
    
    return $errors
}

# Check file structure
check_file_structure() {
    print_status "Checking file structure..."
    
    local required_files=(
        ".circleci/config.yml"
        ".circleci/setup.sh"
        ".circleci/README.md"
    )
    
    local errors=0
    
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            print_success "Found: $file"
            
            # Check file size
            local size=$(wc -c < "$file")
            if [ "$size" -gt 0 ]; then
                print_success "File has content: $file ($size bytes)"
            else
                print_error "File is empty: $file"
                errors=$((errors + 1))
            fi
        else
            print_error "Missing: $file"
            errors=$((errors + 1))
        fi
    done
    
    return $errors
}

# Check permissions
check_permissions() {
    print_status "Checking file permissions..."
    
    local script_files=(".circleci/setup.sh" ".circleci/validate.sh")
    local errors=0
    
    for file in "${script_files[@]}"; do
        if [ -f "$file" ]; then
            if [ -x "$file" ]; then
                print_success "Executable: $file"
            else
                print_warning "Not executable: $file"
                chmod +x "$file"
                print_success "Fixed permissions: $file"
            fi
        fi
    done
    
    return $errors
}

# Check environment variables
check_env_vars() {
    print_status "Checking environment variables..."
    
    local env_file=".circleci/env.yml"
    local errors=0
    
    if [ -f "$env_file" ]; then
        local required_vars=("JAVA_VERSION" "MAVEN_VERSION" "BUILD_PROFILE")
        
        for var in "${required_vars[@]}"; do
            if grep -q "^$var:" "$env_file"; then
                print_success "Environment variable found: $var"
            else
                print_warning "Environment variable not found: $var"
            fi
        done
    else
        print_warning "Environment file not found: $env_file"
    fi
    
    return $errors
}

# Main validation
main() {
    print_status "Starting simple CircleCI validation..."
    
    local total_errors=0
    
    check_yaml_basic || total_errors=$((total_errors + $?))
    check_required_sections || total_errors=$((total_errors + $?))
    check_file_structure || total_errors=$((total_errors + $?))
    check_permissions || total_errors=$((total_errors + $?))
    check_env_vars || total_errors=$((total_errors + $?))
    
    echo ""
    if [ $total_errors -eq 0 ]; then
        print_success "All validations passed! ✅"
        echo ""
        echo "CircleCI configuration is ready!"
        echo "Next steps:"
        echo "1. Push to GitHub"
        echo "2. Connect to CircleCI"
        echo "3. Configure environment variables"
        echo "4. Start building!"
    else
        print_error "Found $total_errors issues! ❌"
        echo ""
        echo "Please fix the issues above."
    fi
    
    return $total_errors
}

# Run validation
main "$@"
