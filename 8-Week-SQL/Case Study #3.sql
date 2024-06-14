1. 
SELECT 
	COUNT(DISTINCT subscriptions.customer_id)
FROM 
	foodie_fi.subscriptions

2.
SELECT 
	DATE_PART('month', s.start_date), COUNT(s.customer_id)
FROM
	foodie_fi.subscriptions s
WHERE
	s.plan_id = 0
GROUP BY DATE_PART('month', s.start_date)

3.
SELECT p.plan_name, COUNT(p.plan_name) AS events
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

6.
WITH subscription_rank AS
    (SELECT
        s.customer_id,
     	p.plan_id,
        ROW_NUMBER() OVER(
            PARTITION BY s.customer_id
            ORDER BY s.start_date
        ) AS rank_row
    FROM
        foodie_fi.plans p
        INNER JOIN foodie_fi.subscriptions s ON p.plan_id = s.plan_id)

SELECT COUNT(DISTINCT sr.customer_id) AS churned_free_trial_count,
	ROUND(100 * COUNT(sr.customer_id) / (
   		SELECT COUNT(DISTINCT customer_id)
     	FROM foodie_fi.subscriptions
   ), 1) AS churned_free_trial_percentage
FROM subscription_rank sr
WHERE sr.rank_row = 2 AND sr.plan_id = 4

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

10.


