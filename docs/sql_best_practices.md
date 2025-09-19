# SQL Development Best Practices

## General Guidelines

### 1. Code Style
- Use consistent indentation (2 or 4 spaces)
- Write SQL keywords in UPPERCASE
- Use descriptive column and table aliases
- Break long queries into multiple lines for readability

### 2. Naming Conventions
- **Tables**: Use descriptive names with underscores (e.g., `customer_orders`)
- **Views**: Suffix with `_view` (e.g., `monthly_revenue_view`)
- **Functions**: Use verb_noun pattern (e.g., `calculate_retention_rate`)
- **Procedures**: Use verb_noun pattern (e.g., `update_customer_metrics`)

### 3. Documentation
- Include header comments explaining purpose, author, and creation date
- Document complex business logic
- Explain data sources and assumptions
- Include example usage when appropriate

## BigQuery Specific Best Practices

### 1. Performance Optimization
- Use clustering and partitioning for large tables
- Avoid SELECT * in production queries
- Use LIMIT for testing and development
- Leverage approximate aggregation functions when exact precision isn't required

### 2. Cost Management
- Set query byte limits to prevent runaway costs
- Use query dry run to estimate costs
- Consider using clustered tables for better performance
- Cache frequently used query results

### 3. Security
- Use authorized views for data access control
- Implement row-level security where appropriate
- Follow principle of least privilege for dataset access
- Regularly audit permissions and access patterns

## Query Templates

### View Template
```sql
-- View: [view_name]
-- Purpose: [Brief description of what this view provides]
-- Author: [Your name]
-- Created: [Date]
-- Dependencies: [List source tables/views]

CREATE OR REPLACE VIEW `project.dataset.view_name` AS
SELECT
  column1,
  column2,
  -- Add computed columns with clear names
  CASE 
    WHEN condition THEN 'value1'
    ELSE 'value2'
  END AS descriptive_column_name
FROM
  `project.dataset.source_table`
WHERE
  -- Add meaningful filters
  date_column >= '2023-01-01'
  AND status = 'active';
```

### Function Template
```sql
-- Function: [function_name]
-- Purpose: [Brief description of what this function does]
-- Author: [Your name]
-- Created: [Date]
-- Parameters: [Describe input parameters]
-- Returns: [Describe return value]

CREATE OR REPLACE FUNCTION `project.dataset.function_name`(
  param1 STRING,
  param2 INT64
)
RETURNS STRING
LANGUAGE SQL
AS (
  -- Function logic here
  CASE 
    WHEN param2 > 0 THEN CONCAT(param1, '_positive')
    ELSE CONCAT(param1, '_zero_or_negative')
  END
);
```

## Testing Guidelines

### 1. Development Testing
- Test queries with LIMIT clauses during development
- Use sample datasets for initial testing
- Validate results against known data points
- Check edge cases and null value handling

### 2. Performance Testing
- Monitor query execution time and slot usage
- Test with production-sized datasets
- Validate partition pruning is working effectively
- Check query plan for optimization opportunities

### 3. Data Quality Testing
- Implement data validation checks
- Test for duplicate records
- Validate referential integrity
- Check for expected data ranges and formats

## Deployment Process

1. **Development**: Create and test queries in development environment
2. **Code Review**: Submit pull request for peer review
3. **Staging**: Deploy to staging environment for final testing
4. **Production**: Deploy to production with appropriate monitoring
5. **Monitoring**: Monitor performance and data quality post-deployment