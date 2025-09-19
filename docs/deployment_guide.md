# Deployment Guide

## Overview
This guide covers deploying SQL objects to BigQuery using the provided deployment scripts and following best practices.

## Prerequisites

### Required Tools
- Google Cloud SDK (`gcloud` CLI)
- BigQuery CLI (`bq`)
- Git
- Access to target BigQuery projects

### Authentication
Ensure you're authenticated with Google Cloud:
```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

## Deployment Process

### 1. Development Workflow
1. Create feature branch: `git checkout -b feature/new-customer-view`
2. Develop your SQL in the appropriate directory
3. Test locally using dry run: `./scripts/deploy_bigquery.sh development view path/to/file.sql --dry-run`
4. Commit changes: `git commit -m "Add customer segmentation view"`
5. Create pull request for review

### 2. Environment Promotion
Deploy through environments in this order:
- Development → Staging → Production

#### Development Deployment
```bash
./scripts/deploy_bigquery.sh development view bigquery/views/customer_metrics_view.sql
```

#### Staging Deployment  
```bash
./scripts/deploy_bigquery.sh staging view bigquery/views/customer_metrics_view.sql
```

#### Production Deployment
```bash
./scripts/deploy_bigquery.sh production view bigquery/views/customer_metrics_view.sql
```

### 3. Configuration Management
Update `config/bigquery_config.yaml` with environment-specific settings:
- Project IDs
- Dataset names  
- Resource limits
- Security settings

## Deployment Script Options

### Basic Usage
```bash
./scripts/deploy_bigquery.sh [environment] [object_type] [file_path]
```

### Available Options
- `--dry-run`: Test deployment without making changes
- `--verbose`: Show detailed output
- `--help`: Display help information

### Examples
```bash
# Dry run deployment
./scripts/deploy_bigquery.sh development view bigquery/views/sales_summary.sql --dry-run

# Deploy with verbose output
./scripts/deploy_bigquery.sh production function bigquery/functions/calculate_ltv.sql --verbose

# Deploy procedure to staging
./scripts/deploy_bigquery.sh staging procedure bigquery/procedures/refresh_metrics.sql
```

## Validation and Testing

### Pre-deployment Validation
1. **Syntax Check**: Ensure SQL syntax is valid
2. **Dry Run**: Use `--dry-run` flag to validate without executing
3. **Dependencies**: Verify all referenced objects exist
4. **Permissions**: Confirm deployment account has necessary permissions

### Post-deployment Testing
1. **Functionality**: Test deployed objects work as expected
2. **Performance**: Monitor query performance and resource usage
3. **Data Quality**: Validate output data meets expectations
4. **Integration**: Ensure compatibility with dependent objects

## Rollback Procedures

### For Views and Functions
- Deploy previous version of the SQL file
- Views and functions are automatically replaced

### For Tables
- Use table snapshots for point-in-time recovery
- Restore from backup if available
- Consider data loss implications

### For Procedures
- Deploy previous version
- Check for any side effects from failed executions

## Monitoring and Alerting

### Key Metrics to Monitor
- Query execution time
- Slot usage and costs
- Error rates
- Data freshness

### Setting Up Alerts
1. Configure BigQuery monitoring in Google Cloud Console
2. Set up alerts for query failures
3. Monitor cost thresholds
4. Track data quality metrics

## Troubleshooting

### Common Issues

#### Permission Errors
```
Error: Access Denied
```
**Solution**: Verify deployment account has necessary BigQuery permissions

#### Syntax Errors  
```
Error: Syntax error at line X
```
**Solution**: Review SQL syntax, check for typos and missing semicolons

#### Dependency Errors
```
Error: Table/View not found
```
**Solution**: Ensure all dependencies exist in target environment

#### Resource Limits
```
Error: Query exceeded resource limits
```
**Solution**: Optimize query or increase resource allocation

### Getting Help
1. Check deployment logs for detailed error messages
2. Review BigQuery documentation
3. Contact data engineering team
4. Use `--verbose` flag for additional debugging information

## Security Considerations

### Access Control
- Use least privilege principle
- Implement authorized views for sensitive data
- Regular access audits

### Data Protection
- Encrypt data at rest and in transit
- Mask sensitive data in non-production environments
- Follow data retention policies

### Audit Logging
- Enable BigQuery audit logs
- Monitor data access patterns
- Track schema changes