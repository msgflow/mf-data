-- Function: calculate_customer_ltv
-- Purpose: Calculates customer lifetime value based on historical purchase data
-- Author: Data Engineering Team
-- Created: 2024-01-15
-- Parameters: 
--   - total_spent: Total amount customer has spent (FLOAT64)
--   - days_active: Number of days between first and last purchase (INT64)
--   - prediction_period: Number of days to project forward (INT64, default 365)
-- Returns: Estimated lifetime value (FLOAT64)

CREATE OR REPLACE FUNCTION `project.dataset.calculate_customer_ltv`(
  total_spent FLOAT64,
  days_active INT64,
  prediction_period INT64
)
RETURNS FLOAT64
LANGUAGE SQL
AS (
  CASE
    -- Handle edge cases
    WHEN total_spent IS NULL OR total_spent <= 0 THEN 0.0
    WHEN days_active IS NULL OR days_active <= 0 THEN total_spent
    WHEN prediction_period IS NULL OR prediction_period <= 0 THEN total_spent
    
    -- Calculate daily spend rate and project forward
    ELSE (total_spent / days_active) * prediction_period
  END
);