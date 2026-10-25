USE food_cpi;

SELECT
  month_date,
  cpi_index,
  LAG(cpi_index) OVER (ORDER BY month_date) AS prev_index,
  ROUND((cpi_index / LAG(cpi_index) OVER (ORDER BY month_date) - 1) * 100, 2) AS mom_pct
FROM cpi_clean
WHERE coicop_code = '01'
ORDER BY month_date;