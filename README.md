# Irish Food Price Anomaly Detection (CSO CPI, 2012–2023)

SQL and dashboard project that flags unusual month-on-month movements in Irish food prices using Central Statistics Office (CSO) Consumer Price Index data.

## Business question
Which months saw food price changes far outside the normal range, and how would a risk or finance team spot them early?

## Data
- Source: CSO Consumer Price Index, table CPM17 (data.gov.ie), licensed CC BY 4.0
- Index values, base December 2016 = 100, monthly, by COICOP division
- Focus: division 01, Food and non-alcoholic beverages
- Coverage: January 2012 to December 2023, 144 months (143 monthly changes)

## Tools
MySQL (MySQL Workbench), Power BI Desktop, GitHub

## Method
1. Loaded the raw CSO CSV into MySQL as text, to keep category codes like `01` intact.
2. Cleaned it into `cpi_clean`: converted months to dates, cast index values to numbers, and removed blank rows (the two service divisions have no goods index values).
3. Calculated month-on-month % change using the `LAG` window function.
4. Calculated each month's z-score against the series mean and standard deviation, and flagged months with |z| >= 2.
5. Saved the logic as a view (`food_mom_flags`) and built a dashboard from it.

## Key findings
- June 2022 is the most unusual month: food prices rose 2.31% in one month (z-score 4.53), far beyond anything else in the series.
- July 2022 (+1.47%, z-score 2.85) and February 2023 (+1.20%, z-score 2.30) are also flagged.
- October 2022 (+1.05%, z-score 2.00) is a borderline flag, only just over the threshold.
- February 2018 is flagged in the opposite direction: a 1.01% fall (z-score -2.13).
- Five months are flagged in total, and four of them fall in 2022–2023. The data shows when the movements happened, not why.

## Dashboard
![Dashboard](Dashboard/Food%20Prices%20Dashboard.JPG)

## Limitations
- This is an index, not euro prices, so it shows relative change only.
- Food is a single national category. A finer breakdown (bread, meat, dairy) would be a useful next step.
- A fixed z-score threshold of 2 is a convention. Borderline months can flip between flagged and normal depending on rounding or threshold choice, so a real monitoring process would tune and review the threshold.
- Z-scores here use the whole period's average and spread, so a sustained shift in volatility (such as 2022 onwards) inflates the spread and affects what gets flagged.

## Repo structure
- `data/`: raw CSO CSV and the exported view
- `sql/`: numbered scripts (run in order)
- `dashboard/`: Power BI file and screenshot
- `notes/`: working notes

## Reproduce
1. Create a MySQL database named `food_cpi` and import the CSV from `data/` into a table called `cpm17_raw`.
2. Run the scripts in `sql/` in numbered order.