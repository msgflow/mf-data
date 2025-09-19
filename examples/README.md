# Example Queries and Templates

This directory contains example SQL queries and template files to help you get started with the mf-data repository.

## Templates

### View Template
```sql
-- View: [view_name]
-- Purpose: [Brief description]
-- Author: [Your name]
-- Created: [Date]
-- Dependencies: [Source tables/views]

CREATE OR REPLACE VIEW `project.dataset.view_name` AS
SELECT
  column1,
  column2,
  -- Add your columns here
FROM
  `project.dataset.source_table`
WHERE
  -- Add your filters here
  condition = 'value';
```

### Function Template  
```sql
-- Function: [function_name]
-- Purpose: [Brief description]
-- Author: [Your name]
-- Created: [Date]
-- Parameters: [Parameter descriptions]
-- Returns: [Return value description]

CREATE OR REPLACE FUNCTION `project.dataset.function_name`(
  param1 STRING,
  param2 INT64
)
RETURNS STRING
LANGUAGE SQL
AS (
  -- Your function logic here
  'result'
);
```

### Table Template
```sql
-- Table: [table_name]
-- Purpose: [Brief description]
-- Author: [Your name]
-- Created: [Date]
-- Partitioning: [Partition strategy if applicable]
-- Clustering: [Clustering fields if applicable]

CREATE OR REPLACE TABLE `project.dataset.table_name`
(
  id INT64,
  name STRING,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY DATE(created_at)
OPTIONS (
  description = "Table description",
  labels = [("team", "data-engineering")]
);
```

### Procedure Template
```sql
-- Procedure: [procedure_name]  
-- Purpose: [Brief description]
-- Author: [Your name]
-- Created: [Date]
-- Schedule: [If applicable]
-- Dependencies: [Source tables/views]

CREATE OR REPLACE PROCEDURE `project.dataset.procedure_name`()
BEGIN
  -- Your procedure logic here
  
EXCEPTION WHEN ERROR THEN
  -- Error handling
  RAISE USING MESSAGE = @@error.message;
END;
```

## Usage Examples

### Creating a Customer Segmentation View
1. Copy the view template
2. Replace placeholders with actual values
3. Add your business logic for customer segmentation
4. Test in development environment
5. Deploy using the deployment script

### Creating a Data Quality Function
1. Copy the function template
2. Define input parameters for data validation
3. Implement validation logic
4. Test with sample data
5. Deploy and use in your views/procedures

## Best Practices

- Always include comprehensive comments
- Use consistent naming conventions  
- Test thoroughly before deploying to production
- Document dependencies and business logic
- Consider performance implications for large datasets