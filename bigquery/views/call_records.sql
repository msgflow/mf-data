-- Call Records View
-- This view provides a comprehensive mapping of call data from BigQuery
-- Includes call details, tenant information, user emails, and derived fields

WITH users_emails AS (
  SELECT
    tenant_id,
    ARRAY_AGG(DISTINCT email IGNORE NULLS ORDER BY email) AS emails
  FROM `mf-main--270107.ai_cdrs.users`
  WHERE email IS NOT NULL
  GROUP BY tenant_id
),
users_emails_with_domains AS (
  SELECT
    tenant_id,
    emails,
    ARRAY(
      SELECT REGEXP_EXTRACT(e, r'@(.+)$') FROM UNNEST(emails) AS e
    ) AS email_domains
  FROM users_emails
),
-- Normalize Ruby-style hashes in cdrs.answer into valid JSON text
answer_normalized AS (
  SELECT
    c.id AS cdr_id,
    -- Replace "=>" with ":" and Ruby nil with JSON null; keep original for reference
    REGEXP_REPLACE(REPLACE(c.answer, '=>', ':'), r'(?i)\bnil\b', 'null') AS answer_json_str
  FROM `mf-main--270107.ai_cdrs.ai_cdrs` c
)
SELECT
  -- call (cdr) fields
  c.id,
  c.answer,
  c.total_tokens,
  c.created_at,
  c.duration_ms,
  c.price AS price_per_call,

  -- parsed/derived from answer
  SAFE.PARSE_JSON(a.answer_json_str) AS answer_json,  -- JSON typed column (NULL if unparsable)
  CAST(JSON_VALUE(SAFE.PARSE_JSON(a.answer_json_str), '$.krisp_stats.totalAudioProcessedMs') AS INT64)
    AS krisp_total_audio_processed_ms,

  -- tenant raw
  t.id AS tenant_id,
  t.name AS tenant_name,
  t.created_at AS tenant_created_at,
  t.parent_id,
  t.booked_package,
  t.budget_type,
  t.budget_amount,

  -- mapped: booked_package
  CASE t.booked_package
    WHEN 1 THEN 'PACKAGE_ALL'
    WHEN 2 THEN 'PACKAGE_VOICE'
    WHEN 3 THEN 'PACKAGE_VOICE_SMARTDESK'
    ELSE 'UNKNOWN'
  END AS booked_package_label,

  -- mapped: budget_type (base kinds + minutes packages)
  CASE t.budget_type
    WHEN 1 THEN 'BUDGET_TYPE_ONE_TIME'
    WHEN 2 THEN 'BUDGET_TYPE_DAILY'
    WHEN 3 THEN 'BUDGET_TYPE_MONTHLY'
    WHEN 4 THEN 'BUDGET_TYPE_YEARLY'
    WHEN 10 THEN 'package_voice_250'
    WHEN 11 THEN 'package_voice_500'
    WHEN 12 THEN 'package_voice_1000'
    WHEN 13 THEN 'package_voice_2500'
    WHEN 14 THEN 'package_voice_5000'
    WHEN 15 THEN 'package_voice_10000'
    ELSE 'UNKNOWN'
  END AS budget_type_label,

  -- mapped: minutes for package types
  CASE t.budget_type
    WHEN 10 THEN 250
    WHEN 11 THEN 500
    WHEN 12 THEN 1000
    WHEN 13 THEN 2500
    WHEN 14 THEN 5000
    WHEN 15 THEN 10000
    ELSE NULL
  END AS package_minutes,

  -- mapped: EUR per minute for package types
  CASE t.budget_type
    WHEN 10 THEN 0.16
    WHEN 11 THEN 0.16
    WHEN 12 THEN 0.15
    WHEN 13 THEN 0.15
    WHEN 14 THEN 0.14
    WHEN 15 THEN 0.13
    ELSE NULL
  END AS package_eur_per_minute,

  -- emails aggregated + org hint
  u.emails,
  u.email_domains,
  u.email_domains[SAFE_OFFSET(0)] AS org_domain,

  -- convenience flags
  (c.total_tokens > 0 AND c.duration_ms > 0) AS has_tokens_and_duration,
  STARTS_WITH(c.question, 'browser') AS browser_test
FROM `mf-main--270107.ai_cdrs.ai_cdrs` AS c
JOIN `mf-main--270107.ai_cdrs.tenants` AS t
  ON c.tenant_id = t.id
LEFT JOIN users_emails_with_domains AS u
  ON u.tenant_id = t.id
LEFT JOIN answer_normalized AS a
  ON a.cdr_id = c.id
WHERE c.ai_prompt_name IS NULL
  AND c.status IN (100, 101)
  AND c.duration_ms IS NOT NULL
  AND c.created_at > TIMESTAMP('2025-06-02 09:00:00')
  AND t.booked_package IN (2, 3);