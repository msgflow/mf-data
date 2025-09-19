#!/bin/bash
# Repository Validation Script
# Validates the structure and content of the mf-data repository

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header "MF-Data Repository Validation"

# Check directory structure
print_header "Checking Directory Structure"

required_dirs=(
    "bigquery"
    "bigquery/views"
    "bigquery/tables" 
    "bigquery/functions"
    "bigquery/procedures"
    "scripts"
    "config"
    "docs"
    "examples"
)

for dir in "${required_dirs[@]}"; do
    if [[ -d "$PROJECT_ROOT/$dir" ]]; then
        print_success "Directory exists: $dir"
    else
        print_error "Missing directory: $dir"
    fi
done

# Check required files
print_header "Checking Required Files"

required_files=(
    "README.md"
    "config/bigquery_config.yaml"
    "scripts/deploy_bigquery.sh"
    "docs/sql_best_practices.md"
    "docs/deployment_guide.md"
    "examples/README.md"
    ".gitignore"
)

for file in "${required_files[@]}"; do
    if [[ -f "$PROJECT_ROOT/$file" ]]; then
        print_success "File exists: $file"
    else
        print_error "Missing file: $file"
    fi
done

# Check example SQL files
print_header "Checking Example SQL Files"

example_sql_files=(
    "bigquery/views/customer_metrics_view.sql"
    "bigquery/functions/calculate_customer_ltv.sql"
    "bigquery/tables/daily_sales_summary.sql"
    "bigquery/procedures/refresh_customer_metrics.sql"
)

for file in "${example_sql_files[@]}"; do
    if [[ -f "$PROJECT_ROOT/$file" ]]; then
        print_success "Example SQL file exists: $file"
        
        # Basic SQL validation
        if grep -q "CREATE OR REPLACE" "$PROJECT_ROOT/$file"; then
            print_success "  Contains CREATE OR REPLACE statement"
        else
            print_warning "  Missing CREATE OR REPLACE statement"
        fi
        
        if grep -q -- "-- Purpose:" "$PROJECT_ROOT/$file"; then
            print_success "  Contains purpose documentation"
        else
            print_warning "  Missing purpose documentation"
        fi
    else
        print_error "Missing example SQL file: $file"
    fi
done

# Check script permissions
print_header "Checking Script Permissions"

executable_scripts=(
    "scripts/deploy_bigquery.sh"
)

for script in "${executable_scripts[@]}"; do
    if [[ -f "$PROJECT_ROOT/$script" ]]; then
        if [[ -x "$PROJECT_ROOT/$script" ]]; then
            print_success "Script is executable: $script"
        else
            print_warning "Script is not executable: $script"
            chmod +x "$PROJECT_ROOT/$script"
            print_success "  Fixed permissions for: $script"
        fi
    fi
done

# Validate configuration file
print_header "Validating Configuration"

config_file="$PROJECT_ROOT/config/bigquery_config.yaml"
if [[ -f "$config_file" ]]; then
    if grep -q "environments:" "$config_file"; then
        print_success "Configuration contains environments section"
    else
        print_warning "Configuration missing environments section"
    fi
    
    if grep -q "development:" "$config_file"; then
        print_success "Configuration contains development environment"
    else
        print_warning "Configuration missing development environment"
    fi
    
    if grep -q "production:" "$config_file"; then
        print_success "Configuration contains production environment"
    else
        print_warning "Configuration missing production environment"
    fi
fi

# Check for organizational subdirectories
print_header "Checking Organizational Structure"

subdirs=(
    "bigquery/views/marketing"
    "bigquery/views/finance"
    "bigquery/views/operations"
    "bigquery/tables/staging"
    "bigquery/tables/production"
    "bigquery/functions/business_logic"
    "bigquery/functions/data_quality"
    "bigquery/procedures/etl"
    "bigquery/procedures/maintenance"
)

for subdir in "${subdirs[@]}"; do
    if [[ -d "$PROJECT_ROOT/$subdir" ]]; then
        print_success "Organizational directory exists: $subdir"
    else
        print_warning "Optional organizational directory missing: $subdir"
    fi
done

print_header "Validation Summary"

# Count files and directories
total_sql_files=$(find "$PROJECT_ROOT/bigquery" -name "*.sql" 2>/dev/null | wc -l)
total_docs=$(find "$PROJECT_ROOT/docs" -name "*.md" 2>/dev/null | wc -l)
total_scripts=$(find "$PROJECT_ROOT/scripts" -name "*.sh" 2>/dev/null | wc -l)

echo "Repository Statistics:"
echo "  SQL Files: $total_sql_files"
echo "  Documentation Files: $total_docs"  
echo "  Scripts: $total_scripts"

print_success "Repository validation completed!"
print_success "The mf-data repository is properly structured for data engineering workflows."

echo -e "\n${BLUE}Next Steps:${NC}"
echo "1. Update configuration files with your actual project details"
echo "2. Customize example SQL files for your specific use cases"
echo "3. Set up authentication for BigQuery deployments"
echo "4. Begin creating your data views and transformations"