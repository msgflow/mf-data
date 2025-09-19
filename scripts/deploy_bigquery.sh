#!/bin/bash
# BigQuery Deployment Script
# Usage: ./deploy_bigquery.sh [environment] [object_type] [file_path]

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_ROOT/config/bigquery_config.yaml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Help function
show_help() {
    cat << EOF
BigQuery Deployment Script

Usage: $0 [environment] [object_type] [file_path]

Arguments:
    environment    Target environment (development|staging|production)
    object_type    Type of object (view|table|function|procedure)
    file_path      Path to the SQL file to deploy

Examples:
    $0 development view bigquery/views/customer_metrics_view.sql
    $0 production function bigquery/functions/calculate_retention.sql

Options:
    -h, --help     Show this help message
    -d, --dry-run  Perform a dry run without executing
    -v, --verbose  Enable verbose output

EOF
}

# Parse command line arguments
ENVIRONMENT=""
OBJECT_TYPE=""
FILE_PATH=""
DRY_RUN=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            if [[ -z "$ENVIRONMENT" ]]; then
                ENVIRONMENT=$1
            elif [[ -z "$OBJECT_TYPE" ]]; then
                OBJECT_TYPE=$1
            elif [[ -z "$FILE_PATH" ]]; then
                FILE_PATH=$1
            else
                print_error "Too many arguments"
                show_help
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate arguments
if [[ -z "$ENVIRONMENT" || -z "$OBJECT_TYPE" || -z "$FILE_PATH" ]]; then
    print_error "Missing required arguments"
    show_help
    exit 1
fi

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(development|staging|production)$ ]]; then
    print_error "Invalid environment: $ENVIRONMENT"
    print_error "Valid environments: development, staging, production"
    exit 1
fi

# Validate object type
if [[ ! "$OBJECT_TYPE" =~ ^(view|table|function|procedure)$ ]]; then
    print_error "Invalid object type: $OBJECT_TYPE"
    print_error "Valid types: view, table, function, procedure"
    exit 1
fi

# Validate file exists
if [[ ! -f "$PROJECT_ROOT/$FILE_PATH" ]]; then
    print_error "File not found: $PROJECT_ROOT/$FILE_PATH"
    exit 1
fi

# Check if bq CLI is available
if ! command -v bq &> /dev/null; then
    print_error "Google Cloud SDK (bq) is not installed or not in PATH"
    print_error "Please install Google Cloud SDK: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

print_status "Starting BigQuery deployment..."
print_status "Environment: $ENVIRONMENT"
print_status "Object Type: $OBJECT_TYPE"
print_status "File: $FILE_PATH"

if [[ "$DRY_RUN" == true ]]; then
    print_warning "DRY RUN MODE - No changes will be made"
fi

# TODO: Parse configuration file to get project and dataset info
# For now, using placeholder values
PROJECT_ID="your-${ENVIRONMENT}-project"
DATASET="analytics"

print_status "Target Project: $PROJECT_ID"
print_status "Target Dataset: $DATASET"

# Read SQL file
SQL_CONTENT=$(cat "$PROJECT_ROOT/$FILE_PATH")

if [[ "$VERBOSE" == true ]]; then
    print_status "SQL Content:"
    echo "$SQL_CONTENT"
fi

# Execute deployment based on object type
case $OBJECT_TYPE in
    view)
        print_status "Deploying view..."
        if [[ "$DRY_RUN" == true ]]; then
            echo "bq query --use_legacy_sql=false --project_id=$PROJECT_ID '$SQL_CONTENT'"
        else
            bq query --use_legacy_sql=false --project_id="$PROJECT_ID" "$SQL_CONTENT"
        fi
        ;;
    table)
        print_status "Deploying table..."
        if [[ "$DRY_RUN" == true ]]; then
            echo "bq query --use_legacy_sql=false --project_id=$PROJECT_ID '$SQL_CONTENT'"
        else
            bq query --use_legacy_sql=false --project_id="$PROJECT_ID" "$SQL_CONTENT"
        fi
        ;;
    function)
        print_status "Deploying function..."
        if [[ "$DRY_RUN" == true ]]; then
            echo "bq query --use_legacy_sql=false --project_id=$PROJECT_ID '$SQL_CONTENT'"
        else
            bq query --use_legacy_sql=false --project_id="$PROJECT_ID" "$SQL_CONTENT"
        fi
        ;;
    procedure)
        print_status "Deploying procedure..."
        if [[ "$DRY_RUN" == true ]]; then
            echo "bq query --use_legacy_sql=false --project_id=$PROJECT_ID '$SQL_CONTENT'"
        else
            bq query --use_legacy_sql=false --project_id="$PROJECT_ID" "$SQL_CONTENT"
        fi
        ;;
esac

if [[ "$DRY_RUN" == false ]]; then
    print_status "Deployment completed successfully!"
else
    print_status "Dry run completed successfully!"
fi