-- View: customer_metrics_view
-- Purpose: Provides aggregated customer metrics for business intelligence
-- Author: Data Engineering Team
-- Created: 2024-01-15
-- Dependencies: customers, orders, order_items tables
-- Business Logic: Calculates customer lifetime value, order frequency, and other key metrics

CREATE OR REPLACE VIEW `project.dataset.customer_metrics_view` AS
SELECT
  c.customer_id,
  c.email,
  c.created_at AS customer_since,
  c.status AS customer_status,
  
  -- Order metrics
  COUNT(DISTINCT o.order_id) AS total_orders,
  SUM(o.total_amount) AS total_spent,
  AVG(o.total_amount) AS avg_order_value,
  
  -- Date metrics
  MIN(o.order_date) AS first_order_date,
  MAX(o.order_date) AS last_order_date,
  DATE_DIFF(CURRENT_DATE(), MAX(o.order_date), DAY) AS days_since_last_order,
  
  -- Customer lifetime value calculation
  SUM(o.total_amount) / NULLIF(DATE_DIFF(MAX(o.order_date), MIN(o.order_date), DAY), 0) * 365 AS estimated_annual_value,
  
  -- Customer segments
  CASE
    WHEN SUM(o.total_amount) >= 1000 THEN 'High Value'
    WHEN SUM(o.total_amount) >= 500 THEN 'Medium Value'
    WHEN SUM(o.total_amount) > 0 THEN 'Low Value'
    ELSE 'No Purchases'
  END AS customer_segment,
  
  -- Recency scoring
  CASE
    WHEN DATE_DIFF(CURRENT_DATE(), MAX(o.order_date), DAY) <= 30 THEN 'Recent'
    WHEN DATE_DIFF(CURRENT_DATE(), MAX(o.order_date), DAY) <= 90 THEN 'Somewhat Recent'
    WHEN DATE_DIFF(CURRENT_DATE(), MAX(o.order_date), DAY) <= 365 THEN 'Dormant'
    ELSE 'Inactive'
  END AS recency_segment

FROM
  `project.dataset.customers` c
LEFT JOIN
  `project.dataset.orders` o ON c.customer_id = o.customer_id
WHERE
  c.created_at >= '2020-01-01'  -- Focus on customers from 2020 onwards
  AND c.status != 'deleted'     -- Exclude deleted customers
GROUP BY
  c.customer_id,
  c.email,
  c.created_at,
  c.status;