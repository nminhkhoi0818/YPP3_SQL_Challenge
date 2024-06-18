https://www.db-fiddle.com/f/7VcQKQwsS3CTkGRFG7vu98/65

A. Pizza Metrics

1. How many pizzas were ordered?
SELECT COUNT(pizza_id)
FROM 
    pizza_runner.customer_orders

2. How many unique customer orders were made?
SELECT
    COUNT(DISTINCT order_id)
FROM
    pizza_runner.customer_orders

3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id)
FROM 
    pizza_runner.runner_orders
WHERE distance != 'null'
GROUP BY runner_id
ORDER BY runner_id

4. How many of each type of pizza was delivered?
SELECT 
    pn.pizza_name, 
    COUNT(co.pizza_id)
FROM 
    pizza_runner.runner_orders ro
    INNER JOIN pizza_runner.customer_orders co ON ro.order_id = co.order_id
    INNER JOIN pizza_runner.pizza_names pn ON co.pizza_id = pn.pizza_id
WHERE distance != 'null'
GROUP BY pn.pizza_name, co.pizza_id

5. How many Vegetarian and Meatlovers were ordered by each customer?**
SELECT
	co.customer_id, 
    pn.pizza_name, 
    COUNT(co.pizza_id) AS pizza_count
FROM
	pizza_runner.customer_orders co
	INNER JOIN pizza_runner.pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY
	co.customer_id, pn.pizza_name, co.pizza_id
ORDER BY 
	co.customer_id

6. What was the maximum number of pizzas delivered in a single order?
SELECT
	COUNT(co.order_id) maximum_order
FROM
	pizza_runner.customer_orders co
GROUP BY 
	co.order_id
ORDER BY maximum_order DESC
LIMIT 1

7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
	co.customer_id,
    SUM(
    	CASE WHEN co.exclusions NOT IN ('null', '') OR co.extras NOT IN ('null', '') THEN 1 ELSE 0 END 
    ) AS at_least_1_change,
    SUM(
    	CASE WHEN co.exclusions IN ('null', '') AND (co.extras IN ('null', '') OR co.extras IS NULL) THEN 1 ELSE 0 END 
    ) AS no_change
FROM 
	pizza_runner.customer_orders co
    INNER JOIN pizza_runner.runner_orders ro ON co.order_id = ro.order_id
WHERE 
	ro.duration != 'null'
GROUP BY 
	co.customer_id
ORDER BY 
	co.customer_id

8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(*) as pizza_exclustion_extra
FROM
	pizza_runner.customer_orders co
    INNER JOIN pizza_runner.runner_orders ro ON co.order_id = ro.order_id
WHERE duration <> 'null' AND exclusions NOT IN ('', 'null') AND extras NOT IN ('', 'null')

9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 	
	TO_CHAR(co.order_time, 'HH24') AS order_hour, 
	COUNT(co.order_id) AS pizza_count
FROM
	pizza_runner.customer_orders co
GROUP BY 
	TO_CHAR(co.order_time, 'HH24')
ORDER BY order_hour

10. What was the volume of orders for each day of the week?
SELECT
	TO_CHAR(order_time, 'Day'),
    COUNT(order_id) AS total_pizza
FROM 
	pizza_runner.customer_orders
GROUP BY 
	TO_CHAR(order_time, 'Day')

B. Runner and Customer Experience

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT
	TO_CHAR(registration_date, 'W') AS week, 
    COUNT(runner_id) AS week_count
FROM 
	pizza_runner.runners
GROUP BY 
	TO_CHAR(registration_date, 'W')
ORDER BY
	TO_CHAR(registration_date, 'W')

2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
WITH time_taken_cte AS (
  SELECT 
    c.order_id, 
    c.order_time::timestamp, 
    r.pickup_time::timestamp, 
    EXTRACT(EPOCH FROM (r.pickup_time::timestamp - c.order_time::timestamp)) / 60 AS pickup_minutes
  FROM pizza_runner.customer_orders c
  INNER JOIN pizza_runner.runner_orders r
    ON c.order_id = r.order_id
  WHERE r.distance != 'null'
  GROUP BY c.order_id, c.order_time, r.pickup_time
)

SELECT 
  AVG(pickup_minutes) AS avg_pickup_minutes
FROM time_taken_cte

3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH time_taken_cte AS (
  SELECT 
    c.order_id, 
    c.order_time::timestamp, 
    r.pickup_time::timestamp, 
  	COUNT(c.order_id) AS pizza_order,
    EXTRACT(EPOCH FROM (r.pickup_time::timestamp - c.order_time::timestamp)) / 60 AS pickup_minutes
  FROM pizza_runner.customer_orders c
  INNER JOIN pizza_runner.runner_orders r
    ON c.order_id = r.order_id
  WHERE r.distance != 'null'
  GROUP BY c.order_id, c.order_time, r.pickup_time
)

SELECT 
	pizza_order, AVG(pickup_minutes)
FROM time_taken_cte
GROUP BY 
	pizza_order
ORDER BY 
	pizza_order

-- 4. Is there any relationship between the number of pizzas and how long the order takes to prepare?

5. What was the difference between the longest and shortest delivery times for all orders?
SELECT  
	(MAX(duration_minutes)::INT - MIN(duration_minutes)::INT) AS different_delivery_time 
FROM 
    (SELECT
        TRIM('minutes' from duration) AS duration_minutes
    FROM
        pizza_runner.runner_orders
    WHERE 
        duration != 'null') AS filter_duration

6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

7. What is the successful delivery percentage for each runner?

C. Ingredient Optimisation

1. What are the standard ingredients for each pizza?

2. What was the most commonly added extra?

3. What was the most common exclusion?

