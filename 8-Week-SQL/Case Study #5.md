## A. Data Cleansing

```sql
DROP TABLE IF EXISTS clean_weekly_sales;
CREATE TEMP TABLE clean_weekly_sales AS (
SELECT
  TO_DATE(week_date, 'DD/MM/YY') AS week_date,
  DATE_PART('week', TO_DATE(week_date, 'DD/MM/YY')) AS week_number,
  DATE_PART('month', TO_DATE(week_date, 'DD/MM/YY')) AS month_number,
  DATE_PART('year', TO_DATE(week_date, 'DD/MM/YY')) AS calendar_year,
  region,
  platform,
  segment,
  CASE
    WHEN RIGHT(segment,1) = '1' THEN 'Young Adults'
    WHEN RIGHT(segment,1) = '2' THEN 'Middle Aged'
    WHEN RIGHT(segment,1) in ('3','4') THEN 'Retirees'
    ELSE 'unknown' END AS age_band,
  CASE
    WHEN LEFT(segment,1) = 'C' THEN 'Couples'
    WHEN LEFT(segment,1) = 'F' THEN 'Families'
    ELSE 'unknown' END AS demographic,
  transactions,
  ROUND((sales::NUMERIC/transactions),2) AS avg_transaction,
  sales
FROM data_mart.weekly_sales
);
```

## B. Data Exploration

1. What day of the week is used for each week_date value?

```sql
SELECT
	DISTINCT TO_CHAR(week_date, 'day')
FROM
	clean_weekly_sales
```

2. What range of week numbers are missing from the dataset?

```sql
SELECT
	DISTINCT sw.series_week_number
FROM
	(SELECT
		GENERATE_SERIES(1, 52) AS series_week_number) AS sw
	LEFT JOIN clean_weekly_sales cws ON cws.week_number = sw.series_week_number
WHERE
	cws.week_number IS NULL
```

3. How many total transactions were there for each year in the dataset?

```sql
SELECT
	calendar_year, SUM(transactions)
FROM
	clean_weekly_sales
GROUP BY
	calendar_year
ORDER BY
	calendar_year
```

4. What is the total sales for each region for each month?

```sql
SELECT
	month_number, region, SUM(sales)
FROM
	clean_weekly_sales
GROUP BY
	month_number, region
ORDER BY
	month_number, region
```

5. What is the total count of transactions for each platform?

```sql
SELECT
	platform, SUM(transactions) AS total_transactions
FROM
	clean_weekly_sales
GROUP BY
	platform
```

6. What is the percentage of sales for Retail vs Shopify for each month? (Hàm MAX giúp không cần gọi table name ở GROUP BY)

```sql
WITH month_sales_table AS
(
	SELECT month_number, calendar_year, platform, SUM(sales) month_sales
	FROM clean_weekly_sales
	GROUP BY month_number, calendar_year, platform
)

SELECT month_number, calendar_year,
	ROUND(100 * MAX(CASE WHEN platform = 'Retail' THEN month_sales ELSE NULL END) / SUM(month_sales), 2) AS retail_percentage,
	ROUND(100 * MAX(CASE WHEN platform = 'Shopify' THEN month_sales ELSE NULL END) / SUM(month_sales), 2) AS shopify_percentage
FROM month_sales_table
GROUP BY month_number, calendar_year
```

7. What is the percentage of sales by demographic for each year in the dataset?

```sql
WITH sales_year_table AS
	(SELECT calendar_year, demographic, SUM(sales) AS sales_year
	FROM clean_weekly_sales
	GROUP BY calendar_year, demographic)

SELECT calendar_year,
		100 * MAX(CASE WHEN demographic = 'Couples' THEN sales_year ELSE NULL END) / SUM(sales_year) AS couples_sales,
		100 * MAX(CASE WHEN demographic = 'unknown' THEN sales_year ELSE NULL END) / SUM(sales_year) AS unknown_sales,
		100 * MAX(CASE WHEN demographic = 'Families' THEN sales_year ELSE NULL END) / SUM(sales_year) AS families_sales
FROM sales_year_table
GROUP BY calendar_year
```

8. Which age_band and demographic values contribute the most to Retail sales?

```sql
SELECT
	age_band, demographic, 100 * SUM(sales) / SUM(SUM(sales)) OVER()
FROM
	clean_weekly_sales
WHERE
	platform = 'Retail'
GROUP BY
	age_band, demographic
```

9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?

```sql
SELECT
	calendar_year,
	platform,
	AVG(avg_transaction) AS avg_platform_transaction
FROM
	clean_weekly_sales
GROUP BY
	calendar_year, platform
ORDER BY
	calendar_year, platform
```

## C. Before & After Analysis

1. What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?

```sql
SELECT
	DISTINCT week_number
FROM
	clean_weekly_sales
WHERE
	week_date = '2020-06-15';

-- Target week is 25

SELECT
	SUM(CASE WHEN week_number BETWEEN 25 AND 28 THEN sales END)
	- SUM(CASE WHEN week_number BETWEEN 21 AND 24 THEN sales END) AS sales_variance
FROM
	clean_weekly_sales
WHERE
	calendar_year = 2020
```

2. What about the entire 12 weeks before and after?

```sql
SELECT
	SUM(CASE WHEN week_number BETWEEN 25 AND 37 THEN sales END)
	- SUM(CASE WHEN week_number BETWEEN 13 AND 24 THEN sales END) AS sales_variance
FROM
	clean_weekly_sales
WHERE
	calendar_year = 2020
```

3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?

```sql
SELECT
	calendar_year,
	SUM(CASE WHEN week_number BETWEEN 25 AND 28 THEN sales END)
	- SUM(CASE WHEN week_number BETWEEN 21 AND 24 THEN sales END) AS sales_variance
FROM
	clean_weekly_sales
GROUP BY
	calendar_year;

SELECT
	calendar_year,
	SUM(CASE WHEN week_number BETWEEN 25 AND 37 THEN sales END)
	- SUM(CASE WHEN week_number BETWEEN 13 AND 24 THEN sales END) AS sales_variance
FROM
	clean_weekly_sales
GROUP BY
	calendar_year
```
