-- Procedure: refresh_customer_metrics
-- Purpose: Refreshes customer metrics materialized view with latest data
-- Author: Data Engineering Team
-- Created: 2024-01-15
-- Schedule: Run daily at 2 AM UTC
-- Dependencies: customers, orders tables

CREATE OR REPLACE PROCEDURE `project.dataset.refresh_customer_metrics`()
BEGIN
  DECLARE rows_processed INT64;
  DECLARE execution_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP();
  
  -- Log procedure start
  INSERT INTO `project.dataset.procedure_logs` (
    procedure_name,
    execution_timestamp,
    status,
    message
  )
  VALUES (
    'refresh_customer_metrics',
    execution_start,
    'STARTED',
    'Beginning customer metrics refresh'
  );
  
  -- Create or replace the materialized view
  CREATE OR REPLACE MATERIALIZED VIEW `project.dataset.customer_metrics_mv`
  PARTITION BY DATE(customer_since)
  CLUSTER BY customer_segment
  AS
  SELECT
    customer_id,
    email,
    customer_since,
    customer_status,
    total_orders,
    total_spent,
    avg_order_value,
    first_order_date,
    last_order_date,
    days_since_last_order,
    estimated_annual_value,
    customer_segment,
    recency_segment,
    CURRENT_TIMESTAMP() AS last_updated
  FROM
    `project.dataset.customer_metrics_view`;
  
  -- Get row count for logging
  SET rows_processed = (
    SELECT COUNT(*)
    FROM `project.dataset.customer_metrics_mv`
  );
  
  -- Log successful completion
  INSERT INTO `project.dataset.procedure_logs` (
    procedure_name,
    execution_timestamp,
    status,
    message,
    rows_processed,
    execution_duration_seconds
  )
  VALUES (
    'refresh_customer_metrics',
    CURRENT_TIMESTAMP(),
    'COMPLETED',
    'Customer metrics refresh completed successfully',
    rows_processed,
    TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), execution_start, SECOND)
  );
  
EXCEPTION WHEN ERROR THEN
  -- Log error
  INSERT INTO `project.dataset.procedure_logs` (
    procedure_name,
    execution_timestamp,
    status,
    message,
    execution_duration_seconds
  )
  VALUES (
    'refresh_customer_metrics',
    CURRENT_TIMESTAMP(),
    'FAILED',
    CONCAT('Error: ', @@error.message),
    TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), execution_start, SECOND)
  );
  
  -- Re-raise the error
  RAISE USING MESSAGE = @@error.message;
END;