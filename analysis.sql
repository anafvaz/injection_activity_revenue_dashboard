-- ============================================
-- 1. DATA VALIDATION
-- ============================================

-- Row count and null check across all key fields
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) - COUNT(NULLIF(TRIM(clinic), '')) AS missing_clinic,
  COUNT(*) - COUNT(NULLIF(TRIM(physician), '')) AS missing_physician,
  COUNT(*) - COUNT(NULLIF(TRIM(appointment_id), '')) AS missing_appointment_id,
  COUNT(*) - COUNT(revenue) AS missing_revenue,
  COUNT(*) - COUNT(appointment_date) AS missing_appointment_date
FROM msk_injection;

-- Confirm clinic and physician counts
SELECT
  clinic,
  COUNT(DISTINCT physician) AS physician_count
FROM msk_injection
GROUP BY clinic;

-- Confirm date range
SELECT
  MIN(appointment_date) AS earliest_date,
  MAX(appointment_date) AS latest_date
FROM msk_injection;


-- ============================================
-- 2. DATA CLEANING
-- ============================================

ALTER TABLE msk_injection
ALTER COLUMN appointment_date TYPE DATE USING appointment_date::DATE;


-- ============================================
-- 3. ANALYSIS
-- ============================================

-- Revenue by clinic (last 12 months)
SELECT
  clinic,
  COUNT(*) AS total_injections,
  SUM(revenue) AS total_revenue,
  ROUND(AVG(revenue)::NUMERIC, 2) AS avg_revenue_per_injection
FROM msk_injection
WHERE appointment_date > CURRENT_DATE - INTERVAL '12 months'
  AND appointment_date < CURRENT_DATE
GROUP BY clinic
ORDER BY total_revenue DESC;

-- Revenue by physician (last 12 months)
-- Sorted descending to surface concentration risk
SELECT
  physician,
  clinic,
  COUNT(*) AS total_injections,
  SUM(revenue) AS total_revenue
FROM msk_injection
WHERE appointment_date > CURRENT_DATE - INTERVAL '12 months'
  AND appointment_date < CURRENT_DATE
GROUP BY physician, clinic
ORDER BY total_revenue DESC;

-- Monthly revenue trend by clinic and billing code (last 12 months)
-- Used to identify seasonal patterns and code mix shifts over time
SELECT
  clinic,
  code,
  TO_CHAR(DATE_TRUNC('month', appointment_date), 'YYYY-MM') AS month,
  COUNT(*) AS total_injections,
  SUM(revenue) AS total_revenue
FROM msk_injection
WHERE appointment_date > CURRENT_DATE - INTERVAL '12 months'
  AND appointment_date < CURRENT_DATE
GROUP BY clinic, code, month
ORDER BY clinic, code, month;

-- Billing code mix summary (last 12 months)
SELECT
  code,
  COUNT(*) AS total_injections,
  SUM(revenue) AS total_revenue,
  ROUND(COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER () * 100, 1) AS pct_of_total_injections
FROM msk_injection
WHERE appointment_date > CURRENT_DATE - INTERVAL '12 months'
  AND appointment_date < CURRENT_DATE
GROUP BY code
ORDER BY total_injections DESC;
