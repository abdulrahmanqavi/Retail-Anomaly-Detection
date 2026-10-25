USE food_cpi;

CREATE OR REPLACE VIEW food_mom_flags AS
WITH changes AS (
  SELECT
    month_date,
    cpi_index,
    (cpi_index / LAG(cpi_index) OVER (ORDER BY month_date) - 1) * 100 AS mom_pct
  FROM cpi_clean
  WHERE coicop_code = '01'
),
stats AS (
  SELECT AVG(mom_pct) AS avg_mom, STDDEV_SAMP(mom_pct) AS sd_mom
  FROM changes
  WHERE mom_pct IS NOT NULL
)
SELECT
  c.month_date,
  c.cpi_index,
  ROUND(c.mom_pct, 2) AS mom_pct,
  ROUND((c.mom_pct - s.avg_mom) / s.sd_mom, 2) AS z_score,
  CASE WHEN ABS((c.mom_pct - s.avg_mom) / s.sd_mom) >= 2
       THEN 'FLAG' ELSE 'normal' END AS status
FROM changes c
CROSS JOIN stats s
WHERE c.mom_pct IS NOT NULL;

SELECT status, COUNT(*) AS months
FROM food_mom_flags
GROUP BY status;
USE food_cpi;
SELECT * FROM food_mom_flags ORDER BY month_date;