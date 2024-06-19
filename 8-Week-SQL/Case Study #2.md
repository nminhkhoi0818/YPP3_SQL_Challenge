https://www.db-fiddle.com/f/7VcQKQwsS3CTkGRFG7vu98/65

# Data Cleansing

```sql
CREATE TEMP TABLE customer_orders_temp AS
SELECT
  order_id,
  customer_id,
  pizza_id,
  CASE
      WHEN exclusions IS NULL OR exclusions LIKE 'null' THEN ' '
      ELSE exclusions
      END AS exclusions,
  CASE
      WHEN extras IS NULL OR extras LIKE 'null' THEN ' '
      ELSE extras
      END AS extras,
  order_time
FROM pizza_runner.customer_orders;

CREATE TEMP TABLE runner_orders_temp AS
SELECT
  order_id,
  runner_id,
  CASE
      WHEN pickup_time LIKE 'null' THEN NULL
      ELSE TO_TIMESTAMP(pickup_time, 'YYYY-MM-DD HH24:MI:SS')
      END AS pickup_time,
  CASE
      WHEN distance LIKE 'null' THEN NULL
      WHEN distance LIKE '%km' THEN TRIM('km' FROM distance)::FLOAT
      ELSE distance::FLOAT
    END AS distance,
  CASE
      WHEN duration LIKE 'null' THEN NULL
      WHEN duration LIKE '%mins' THEN TRIM('mins' FROM duration)::INT
      WHEN duration LIKE '%minute' THEN TRIM('minute' FROM duration)::INT
      WHEN duration LIKE '%minutes' THEN TRIM('minutes' FROM duration)::INT
      ELSE duration::INT
      END AS duration,
  CASE
      WHEN cancellation IS NULL OR cancellation LIKE 'null' THEN ' '
      ELSE cancellation
      END AS cancellation
FROM pizza_runner.runner_orders;

ALTER TABLE runner_orders_temp
ALTER COLUMN pickup_time TYPE TIMESTAMP;

ALTER TABLE runner_orders_temp
ALTER COLUMN distance TYPE FLOAT;

ALTER TABLE runner_orders_temp
ALTER COLUMN duration TYPE INT;
```

A. Pizza Metrics

1. How many pizzas were ordered?

```sql
SELECT COUNT(pizza_id)
FROM
    pizza_runner.customer_orders
```

2. How many unique customer orders were made?

```sql
SELECT
    COUNT(DISTINCT order_id)
FROM
    pizza_runner.customer_orders
```

3. How many successful orders were delivered by each runner?

```sql
SELECT runner_id, COUNT(order_id)
FROM
    pizza_runner.runner_orders
WHERE distance != 'null'
GROUP BY runner_id
ORDER BY runner_id
```

4. How many of each type of pizza was delivered?

```sql
SELECT
    pn.pizza_name,
    COUNT(co.pizza_id)
FROM
    pizza_runner.runner_orders ro
    INNER JOIN pizza_runner.customer_orders co ON ro.order_id = co.order_id
    INNER JOIN pizza_runner.pizza_names pn ON co.pizza_id = pn.pizza_id
WHERE distance != 'null'
GROUP BY pn.pizza_name, co.pizza_id
```

5. How many Vegetarian and Meatlovers were ordered by each customer?\*\*

```sql
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
```

6. What was the maximum number of pizzas delivered in a single order?

```sql
SELECT
	COUNT(co.order_id) maximum_order
FROM
	pizza_runner.customer_orders co
GROUP BY
	co.order_id
ORDER BY maximum_order DESC
LIMIT 1
```

7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

```sql
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
```

8. How many pizzas were delivered that had both exclusions and extras?

```sql
SELECT COUNT(*) as pizza_exclustion_extra
FROM
	pizza_runner.customer_orders co
    INNER JOIN pizza_runner.runner_orders ro ON co.order_id = ro.order_id
WHERE duration <> 'null' AND exclusions NOT IN ('', 'null') AND extras NOT IN ('', 'null')
```

9. What was the total volume of pizzas ordered for each hour of the day?

```sql
SELECT
	TO_CHAR(co.order_time, 'HH24') AS order_hour,
	COUNT(co.order_id) AS pizza_count
FROM
	pizza_runner.customer_orders co
GROUP BY
	TO_CHAR(co.order_time, 'HH24')
ORDER BY order_hour
```

10. What was the volume of orders for each day of the week?

```sql
SELECT
	TO_CHAR(order_time, 'Day'),
    COUNT(order_id) AS total_pizza
FROM
	pizza_runner.customer_orders
GROUP BY
	TO_CHAR(order_time, 'Day')
```

B. Runner and Customer Experience

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

```sql
SELECT
	TO_CHAR(registration_date, 'W') AS week,
    COUNT(runner_id) AS week_count
FROM
	pizza_runner.runners
GROUP BY
	TO_CHAR(registration_date, 'W')
ORDER BY
	TO_CHAR(registration_date, 'W')
```

2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql
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
```

3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

```sql
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
```

4. Is there any relationship between the number of pizzas and how long the order takes to prepare?

5. What was the difference between the longest and shortest delivery times for all orders?

```sql
SELECT
	(MAX(duration_minutes)::INT - MIN(duration_minutes)::INT) AS different_delivery_time
FROM
    (SELECT
        TRIM('minutes' from duration) AS duration_minutes
    FROM
        pizza_runner.runner_orders
    WHERE
        duration != 'null') AS filter_duration
```

6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

```sql
SELECT
	rot.runner_id,
	cot.order_id,
	AVG(rot.distance / rot.duration * 60) AS average_speed
FROM
	customer_orders_temp cot
	INNER JOIN runner_orders_temp rot ON cot.order_id = rot.order_id
WHERE
	rot.distance > 0
GROUP BY
	rot.runner_id, cot.order_id
ORDER BY
	rot.runner_id, cot.order_id
```

7. What is the successful delivery percentage for each runner?

```sql
SELECT
	runner_id,
	100 * SUM(CASE WHEN distance > 0 THEN 1 ELSE 0 END) / COUNT(*) AS successful_percentage
FROM
	runner_orders_temp
GROUP BY
	runner_id
ORDER BY
	runner_id
```

C. Ingredient Optimisation

1. What are the standard ingredients for each pizza?

2. What was the most commonly added extra?

```sql
SELECT
	REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+')::INTEGER AS topping_id,
	COUNT(*) AS topping_count
FROM
	pizza_runner.pizza_recipes
GROUP BY
	topping_id
ORDER BY
	topping_count DESC
```

3. What was the most common exclusion?

D. Do with cleansing data

1. How many pizzas were ordered?

```sql
SELECT
	*
FROM
	customer_orders_temp
```

2. How many unique customer orders were made?

```sql
SELECT
	COUNT(DISTINCT customer_id) AS customer_count
FROM
	customer_orders_temp
```

3. How many successful orders were delivered by each runner?

```sql
SELECT
	runner_id,
	COUNT(*) AS successful_orders
FROM
	runner_orders_temp
WHERE
	distance > 0
GROUP BY
	runner_id
```

4. How many of each type of pizza was delivered?

```sql
SELECT
	pn.pizza_name,
	COUNT(*) AS pizza_delivered
FROM
	customer_orders_temp cot
	INNER JOIN runner_orders_temp rot ON cot.order_id = rot.order_id
	INNER JOIN pizza_runner.pizza_names pn ON cot.pizza_id = pn.pizza_id
WHERE
	rot.distance > 0
GROUP BY
	pizza_name
```

5. How many Vegetarian and Meatlovers were ordered by each customer?\*\*

```sql
SELECT
	customer_id,
	SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS meatlovers_orders,
	SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS vegetarian_orders
FROM
	customer_orders_temp
GROUP BY
	customer_id
```

6. What was the maximum number of pizzas delivered in a single order?

```sql
SELECT
	COUNT(*) AS pizza_count
FROM
	customer_orders_temp cot
	INNER JOIN runner_orders_temp rot ON cot.order_id = rot.order_id
WHERE
	rot.distance > 0
GROUP BY
	rot.order_id
ORDER BY
	pizza_count DESC
LIMIT 1
```

7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

```sql
SELECT
	cot.customer_id,
	SUM(CASE WHEN cot.exclusions != ' ' AND cot.extras != ' ' THEN 1 ELSE 0 END) AS no_change,
	COUNT(*) - SUM(CASE WHEN cot.exclusions != ' ' AND cot.extras != ' ' THEN 1 ELSE 0 END) AS at_least_1_change
FROM
	customer_orders_temp cot
	INNER JOIN runner_orders_temp rot ON cot.order_id = rot.order_id
WHERE
	rot.distance > 0
GROUP BY
	cot.customer_id
```

8. How many pizzas were delivered that had both exclusions and extras?

9. What was the total volume of pizzas ordered for each hour of the day?

10. What was the volume of orders for each day of the week?
