## A. Data Exploration and Cleansing

**1. Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month**

```sql
ALTER TABLE fresh_segments.interest_metrics
ALTER month_year TYPE DATE USING month_year::DATE;
```

**2. What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?**

```sql
SELECT
	month_year,
	COUNT(*) AS total_count
FROM
	fresh_segments.interest_metrics
GROUP BY
	month_year
```

**3. What do you think we should do with these null values in the fresh_segments.interest_metrics?**

```sql
SELECT
  ROUND(100 * (SUM(CASE WHEN interest_id IS NULL THEN 1 END) * 1.0 /
    COUNT(*)),2) AS null_perc
FROM fresh_segments.interest_metrics
```

**4. How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?**

```sql
SELECT
	COUNT(DISTINCT interest_metrics.interest_id) AS interest_metrics_count,
	COUNT(DISTINCT interest_map.id) AS interest_map_count,
	SUM(CASE WHEN interest_metrics.interest_id IS NULL THEN 1 ELSE 0 END) AS not_in_map
FROM
	fresh_segments.interest_metrics
	FULL OUTER JOIN fresh_segments.interest_map ON interest_metrics.interest_id = interest_map.id
```

**5. Summarise the id values in the fresh_segments.interest_map by its total record count in this table**

```sql
SELECT
   ima.interest_name,
   COUNT(*) AS interest_count
FROM fresh_segments.interest_map ima
	INNER JOIN fresh_segments.interest_metrics ime ON ima.id = ime.interest_id
GROUP BY
	ima.interest_name
```

**6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where 'interest_id = 21246' in your joined output and include all columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.**

```sql
SELECT
	*
FROM
	fresh_segments.interest_map ima
	INNER JOIN fresh_segments.interest_metrics ime ON ima.id = ime.interest_id
WHERE
	ime.interest_id = 21246 AND ime._month IS NOT NULL;
```

**7. Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? Do you think these values are valid and why?**

## B. Interest Analysis

**1. Which interests have been present in all month_year dates in our dataset?**

```sql
SELECT
	COUNT(DISTINCT interest_id) AS interest_all_month
FROM
	(SELECT
		interest_id,
		COUNT(DISTINCT month_year) AS interest_month_year
	FROM
		fresh_segments.interest_metrics
	GROUP BY
		interest_id) interest_cte
WHERE
	interest_month_year = 14
```

**2. Using this same total_months measure - calculate the cumulative percentage of all records starting at 14 months - which total_months value passes the 90% cumulative percentage value?**

```sql
WITH interest_metrics_cte AS
(SELECT
	interest_month_year,
	COUNT(DISTINCT interest_id) AS interest_month_count
FROM
	(SELECT
		interest_id,
		COUNT(DISTINCT month_year) AS interest_month_year
	FROM
		fresh_segments.interest_metrics
	GROUP BY
		interest_id) interest_cte
GROUP BY
	interest_month_year
ORDER BY
	interest_month_year DESC)

SELECT
	interest_month_year,
	SUM(interest_month_count) OVER(ORDER BY interest_month_year DESC) / SUM(interest_month_count) OVER() AS cumulative_month_interest
FROM
	interest_metrics_cte
```
