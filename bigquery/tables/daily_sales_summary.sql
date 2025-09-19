-- Table: daily_sales_summary
-- Purpose: Creates a partitioned table for daily sales aggregations
-- Author: Data Engineering Team
-- Created: 2024-01-15
-- Partitioning: By sale_date for performance optimization
-- Clustering: By product_category for query optimization

CREATE OR REPLACE TABLE `project.dataset.daily_sales_summary`
(
  sale_date DATE,
  product_category STRING,
  total_revenue NUMERIC(10,2),
  total_orders INT64,
  unique_customers INT64,
  avg_order_value NUMERIC(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY sale_date
CLUSTER BY product_category
OPTIONS (
  description = "Daily aggregated sales data partitioned by date",
  labels = [("team", "data-engineering"), ("purpose", "analytics")]
);