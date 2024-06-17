1. What day of the week is used for each week_date value?
SELECT 
	DISTINCT TO_CHAR(week_date, 'day')
FROM 
	clean_weekly_sales

2. What range of week numbers are missing from the dataset?
SELECT
	DISTINCT sw.series_week_number
FROM 
	(SELECT 
		GENERATE_SERIES(1, 52) AS series_week_number) AS sw
	LEFT JOIN clean_weekly_sales cws ON cws.week_number = sw.series_week_number
WHERE 
	cws.week_number IS NULL

3. How many total transactions were there for each year in the dataset?
SELECT 
	calendar_year, SUM(transactions)
FROM 
	clean_weekly_sales
GROUP BY 
	calendar_year
ORDER BY
	calendar_year

4. What is the total sales for each region for each month?
SELECT
	month_number, region, SUM(sales)
FROM 
	clean_weekly_sales
GROUP BY 
	month_number, region
ORDER BY
	month_number, region

5. What is the total count of transactions for each platform?
SELECT 
	platform, SUM(transactions) AS total_transactions
FROM
	clean_weekly_sales
GROUP BY
	platform


6. What is the percentage of sales for Retail vs Shopify for each month? (Hàm MAX giúp không cần gọi table name ở GROUP BY)
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

7. What is the percentage of sales by demographic for each year in the dataset?
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

8. Which age_band and demographic values contribute the most to Retail sales?
SELECT
	age_band, demographic, 100 * SUM(sales) / SUM(SUM(sales)) OVER()
FROM 
	clean_weekly_sales
WHERE 
	platform = 'Retail'
GROUP BY 
	age_band, demographic

9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
