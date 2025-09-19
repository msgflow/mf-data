# mf-data
Providing queries and views for various BI use cases

## Structure

This repository is organized by database platform and query type:

- `bigquery/` - BigQuery-specific queries and views
  - `views/` - SQL view definitions

## Available Queries

### BigQuery Views
- [`call_records`](bigquery/views/call_records.sql) - Comprehensive call record data with tenant and user information

## Contributing

When adding new queries:
1. Place them in the appropriate platform directory (e.g., `bigquery/`, `postgresql/`, etc.)
2. Use descriptive filenames
3. Include comments explaining the purpose and key fields
4. Update the relevant README files
