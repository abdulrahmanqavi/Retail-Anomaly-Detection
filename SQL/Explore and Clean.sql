USE food_cpi;

DROP TABLE IF EXISTS cpi_clean;

CREATE TABLE cpi_clean AS
SELECT
  STR_TO_DATE(CONCAT(month_code, '01'), '%Y%m%d') AS month_date,
  coicop_code,
  coicop_division,
  CAST(value AS DECIMAL(7,1)) AS cpi_index
FROM cpm17_raw
WHERE statistic = 'CPM17C01'
  AND value IS NOT NULL
  AND TRIM(value) <> '';

SELECT coicop_code, coicop_division,
       COUNT(*) AS months,
       MIN(month_date) AS first_month,
       MAX(month_date) AS last_month
FROM cpi_clean
GROUP BY coicop_code, coicop_division
ORDER BY coicop_code;