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
-- SELECT
-- 	co.customer_id, COUNT(co.customer_id) AS no_change
-- FROM
-- 	pizza_runner.customer_orders co
-- WHERE co.exclusions != ' ' AND co.extras != ' '
-- GROUP BY
-- 	co.customer_id, co.pizza_id
-- ORDER BY
-- 	co.customer_id

8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(*) as pizza_exclustion_extra
FROM
	pizza_runner.customer_orders co
    INNER JOIN pizza_runner.runner_orders ro ON co.order_id = ro.order_id
WHERE duration <> 'null' AND exclusions NOT IN ('', 'null') AND extras NOT IN ('', 'null')

9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
	DATE_PART('hour', co.order_time) AS hour, 
	COUNT(co.order_id) AS pizza_count
FROM
	pizza_runner.customer_orders co
GROUP BY DATE_PART('hour', co.order_time)
ORDER BY hour

10. What was the volume of orders for each day of the week?

B. Runner and Customer Experience

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
-- SELECT
-- 	DATE_PART('week', runners.registration_date),
--     COUNT(runner_id)
-- FROM
-- 	pizza_runner.runners
-- GROUP BY 
-- 	DATE_PART('week', runners.registration_date)
    
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?


3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

4. What was the average distance travelled for each customer?

5. What was the difference between the longest and shortest delivery times for all orders?

6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

7. What is the successful delivery percentage for each runner?