B. Data Analysis Questions

1. 
SELECT COUNT(DISTINCT customer_id)
FROM foodie_fi.subscriptions
2.
SELECT 
	TO_CHAR(start_date, 'Month'), COUNT(DISTINCT customer_id)
FROM 
	foodie_fi.subscriptions
WHERE 
	plan_id = 0
GROUP BY 
	TO_CHAR(start_date, 'Month')


3.
SELECT
	p.plan_name,
    COUNT(DISTINCT s.customer_id)
FROM
	foodie_fi.subscriptions s
    INNER JOIN foodie_fi.plans p ON s.plan_id = p.plan_id 
WHERE 
	s.start_date >= '2021-01-01'
GROUP BY 
	p.plan_name

4.
SELECT
   COUNT(DISTINCT s.customer_id) AS churned_customer,
   ROUND(100 * COUNT(s.customer_id) / (
   		SELECT COUNT(DISTINCT customer_id)
     	FROM foodie_fi.subscriptions
   ), 1)
FROM
   foodie_fi.plans p
   INNER JOIN foodie_fi.subscriptions s ON p.plan_id = s.plan_id
WHERE
   p.plan_id = 4;
   
5.
WITH customer_sub_table AS
    (SELECT
        customer_id,
        plan_id,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
        ) AS customer_sub_rank
    FROM 
        foodie_fi.subscriptions)
        
SELECT COUNT (*) AS churn_count, 
	100 * COUNT (*) / (
  		SELECT COUNT (DISTINCT customer_id)
  		FROM foodie_fi.subscriptions
	) AS churn_percentage
FROM customer_sub_table
WHERE plan_id = 4 AND customer_sub_rank = 2

6. What is the number and percentage of customer plans after their initial free trial?
WITH customer_plans AS
    (SELECT 
        customer_id, 
        plan_id, 
        LEAD(plan_id) OVER (
            PARTITION BY customer_id
        ) AS next_plan
    FROM 
        foodie_fi.subscriptions)
        
        
SELECT 
	next_plan,
    COUNT(next_plan) AS next_plan_count,
    ROUND((100 * COUNT(next_plan) / (SELECT COUNT (DISTINCT customer_id) FROM foodie_fi.subscriptions)), 2)
FROM 
	customer_plans
WHERE 
	plan_id = 0
GROUP BY
	next_plan

7.
WITH customer_current_plan AS
    (SELECT 
        s.customer_id,
        s.plan_id, 
        LEAD(s.start_date) OVER (
            PARTITION BY s.customer_id
            ORDER BY s.start_date
        ) AS next_date
    FROM
        foodie_fi.subscriptions s
    WHERE s.start_date <= '2020-12-31')
    
SELECT 
	ccp.plan_id, 
    COUNT(DISTINCT ccp.customer_id) AS customers_count,
    ROUND(COUNT(ccp.customer_id) * 100 / (SELECT COUNT (DISTINCT customer_id) FROM customer_current_plan), 1)
FROM 	
	customer_current_plan ccp
WHERE 
	ccp.next_date IS NULL
GROUP BY
	ccp.plan_id;

8.
SELECT
	COUNT(DISTINCT customer_id)
FROM 
	foodie_fi.subscriptions
WHERE
	plan_id = 3 AND start_date >= '2020-01-01' AND start_date <= '2020-12-31'

9.
WITH free_trial_table AS 
    (SELECT
        customer_id, 
        start_date AS free_trial_date
    FROM 
        foodie_fi.subscriptions
    WHERE 
        plan_id = 0),
    annual_table AS 
    (SELECT
        customer_id, 
        start_date AS annual_date
    FROM 
        foodie_fi.subscriptions
    WHERE 
        plan_id = 3)
        
SELECT 
	AVG(annual_date - free_trial_date)
FROM 
	free_trial_table ftt
    INNER JOIN annual_table ant ON ftt.customer_id = ant.customer_id

10.
WITH free_trial_table AS 
    (SELECT
        customer_id, 
        start_date AS free_trial_date
    FROM 
        foodie_fi.subscriptions
    WHERE 
        plan_id = 0),
    annual_table AS 
    (SELECT
        customer_id, 
        start_date AS annual_date
    FROM 
        foodie_fi.subscriptions
    WHERE 
        plan_id = 3)

SELECT period_count_table.period_count, COUNT(period_count_table.period_count)
FROM (SELECT 
	WIDTH_BUCKET(ant.annual_date - ftt.free_trial_date, 0, 365, 12) AS period_count
FROM 
	free_trial_table ftt
    INNER JOIN annual_table ant ON ftt.customer_id = ant.customer_id) period_count_table
GROUP BY
	period_count_table.period_count

11.
WITH lead_subscription_table AS
    (SELECT
        customer_id, 
        plan_id,
        LEAD(plan_id) OVER(
            PARTITION BY (customer_id)
          	ORDER BY start_date
        ) AS next_plan
    FROM 
        foodie_fi.subscriptions
    WHERE 
    	start_date <= '2020-12-31')

SELECT
	COUNT (*)
FROM 
	lead_subscription_table
WHERE
	plan_id = 2 AND next_plan = 1 
