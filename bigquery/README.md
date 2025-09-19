# BigQuery Queries

This directory contains BigQuery-specific SQL queries and views for the mf-data project.

## Structure

- `views/` - Contains SQL view definitions that can be used to create BigQuery views

## Views

### call_records.sql
A comprehensive view that provides call record data with the following features:
- Call details (ID, answer, tokens, duration, pricing)
- Tenant information with mapped package and budget type labels
- User email aggregation and domain extraction
- JSON parsing of answer fields with Krisp statistics
- Convenience flags for data analysis

**Key fields:**
- Call metadata: `id`, `total_tokens`, `duration_ms`, `price_per_call`
- Tenant data: `tenant_name`, `booked_package_label`, `budget_type_label`
- Package information: `package_minutes`, `package_eur_per_minute`
- User data: `emails`, `email_domains`, `org_domain`
- Derived fields: `has_tokens_and_duration`, `browser_test`

**Filters applied:**
- Only calls with no AI prompt name
- Status codes 100 or 101 (successful calls)
- Non-null duration
- Created after June 2, 2025 9:00 AM
- Voice packages only (booked_package 2 or 3)

## Usage

To create a view in BigQuery:
```sql
CREATE OR REPLACE VIEW `your-project.your-dataset.call_records` AS (
  -- Copy the content from call_records.sql
);
```