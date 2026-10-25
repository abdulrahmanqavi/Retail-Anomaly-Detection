USE food_cpi;
SELECT MIN(month_date) AS first_change, MAX(month_date) AS last_month, COUNT(*) AS months
FROM food_mom_flags;

SELECT month_date, mom_pct, z_score
FROM food_mom_flags
WHERE status = 'FLAG'
ORDER BY month_date;
USE food_cpi;
SELECT month_date, mom_pct, z_score
FROM food_mom_flags
WHERE status = 'FLAG'
ORDER BY month_date;