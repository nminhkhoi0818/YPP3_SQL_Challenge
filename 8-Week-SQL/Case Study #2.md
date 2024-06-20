## Data Cleansing

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

## A. Pizza Metrics

**1. How many pizzas were ordered?**

```sql
SELECT COUNT(pizza_id)
FROM
    pizza_runner.customer_orders
```

```sql
SELECT
	*
FROM
	customer_orders_temp
```

**2. How many unique customer orders were made?**

```sql
SELECT
    COUNT(DISTINCT order_id)
FROM
    pizza_runner.customer_orders
```

```sql
SELECT
	COUNT(DISTINCT customer_id) AS customer_count
FROM
	customer_orders_temp
```

**3. How many successful orders were delivered by each runner?**

```sql
SELECT runner_id, COUNT(order_id)
FROM
    pizza_runner.runner_orders
WHERE distance != 'null'
GROUP BY runner_id
ORDER BY runner_id
```

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

**4. How many of each type of pizza was delivered?**

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

**5. How many Vegetarian and Meatlovers were ordered by each customer?**

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

**6. What was the maximum number of pizzas delivered in a single order?**

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

**7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**

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

**8. How many pizzas were delivered that had both exclusions and extras?**

```sql
SELECT COUNT(*) as pizza_exclustion_extra
FROM
	pizza_runner.customer_orders co
    INNER JOIN pizza_runner.runner_orders ro ON co.order_id = ro.order_id
WHERE duration <> 'null' AND exclusions NOT IN ('', 'null') AND extras NOT IN ('', 'null')
```

**9. What was the total volume of pizzas ordered for each hour of the day?**

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

**10. What was the volume of orders for each day of the week?**

```sql
SELECT
	TO_CHAR(order_time, 'Day'),
    COUNT(order_id) AS total_pizza
FROM
	pizza_runner.customer_orders
GROUP BY
	TO_CHAR(order_time, 'Day')
```

## B. Runner and Customer Experience

**1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)**

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

**2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?**

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

**3. Is there any relationship between the number of pizzas and how long the order takes to prepare?**

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

**4. Is there any relationship between the number of pizzas and how long the order takes to prepare?**

**5. What was the difference between the longest and shortest delivery times for all orders?**

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

**6. What was the average speed for each runner for each delivery and do you notice any trend for these values?**

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

**7. What is the successful delivery percentage for each runner?**

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

## C. Ingredient Optimisation

**1. What are the standard ingredients for each pizza?**

```sql
WITH pizza_toppings_cte AS
	(SELECT
		pizza_id,
		REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+')::INTEGER AS topping_id
	FROM
		pizza_runner.pizza_recipes)

SELECT
	ptc.pizza_id,
	pt.topping_name
FROM
	pizza_toppings_cte ptc
	INNER JOIN pizza_runner.pizza_toppings pt ON ptc.topping_id = pt.topping_id
ORDER BY
	ptc.pizza_id
```

**2. What was the most commonly added extra?**

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

**3. What was the most common exclusion?**

```sql
WITH exclusions_cte AS
	(SELECT
		REGEXP_SPLIT_TO_TABLE(exclusions, '[,\s]+') exclusions
	FROM
		customer_orders_temp)

SELECT
	exclusions,
	COUNT(*) exclusions_count
FROM
	exclusions_cte
WHERE
	exclusions <> ''
GROUP BY
	exclusions
ORDER BY
	exclusions_count DESC
LIMIT 1
```

**4. Generate an order item for each record in the customers_orders table in the format of one of the following: Meat Lovers, Meat Lovers - Exclude Beef, Meat Lovers - Extra Bacon, Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers**

```sql
WITH exclusions_cte AS
	(SELECT
	 	order_id,
	 	pizza_id,
	 	exclusions,
		REGEXP_SPLIT_TO_TABLE(exclusions, '[,\s]+')::INTEGER AS split_exclusion
	FROM
		customer_orders_temp
	WHERE exclusions != ''
	GROUP BY
		order_id, pizza_id, exclusions),
exclusion_name_cte AS
	(SELECT order_id, pizza_id, exclusions, STRING_AGG(pt.topping_name, ', ') AS exclusions_names
	FROM
	 	exclusions_cte ec
	 	INNER JOIN pizza_runner.pizza_toppings pt ON ec.split_exclusion = pt.topping_id
		GROUP BY order_id, pizza_id, exclusions),
extras_cte AS
	(SELECT
	 	order_id,
	 	pizza_id,
	 	extras,
		REGEXP_SPLIT_TO_TABLE(extras, '[,\s]+')::INTEGER AS split_extras
	FROM
		customer_orders_temp
	WHERE extras != ''
	GROUP BY
		order_id, pizza_id, extras),
extras_name_cte AS
	(SELECT order_id, pizza_id, extras, STRING_AGG(pt.topping_name, ', ') AS extras_names
	FROM
	 	extras_cte ec
	 	INNER JOIN pizza_runner.pizza_toppings pt ON ec.split_extras = pt.topping_id
		GROUP BY order_id, pizza_id, extras)

SELECT
	cot.order_id, cot.customer_id, cot.pizza_id,
	CASE
		WHEN enc.exclusions_names <> '' AND etnc.extras_names <> '' THEN pn.pizza_name || ' - Exclude ' || enc.exclusions_names || ' - Extra ' || etnc.extras_names
		WHEN enc.exclusions_names <> '' THEN pn.pizza_name || ' - Exclude ' || enc.exclusions_names
		WHEN etnc.extras_names <> '' THEN pn.pizza_name || ' - Extra ' || etnc.extras_names
		ELSE pn.pizza_name END AS pizza_full_names
FROM
	customer_orders_temp cot
	INNER JOIN pizza_runner.pizza_names pn ON pn.pizza_id = cot.pizza_id
	LEFT JOIN exclusion_name_cte enc ON cot.order_id = enc.order_id AND cot.pizza_id = enc.pizza_id AND cot.exclusions = enc.exclusions
	LEFT JOIN extras_name_cte etnc ON cot.order_id = etnc.order_id AND cot.pizza_id = etnc.pizza_id AND cot.extras = etnc.extras
ORDER BY
	cot.order_id

-- UPDATE customer_orders_temp
-- SET extras = CASE WHEN extras = ' ' AND extras = '' THEN NULL ELSE extras END
```

**5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients**

**6. For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"**

**7. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?**

```sql
WITH topping_cte AS
	(SELECT
		pizza_id,
		REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+')::INTEGER AS topping_id
	FROM
		pizza_runner.pizza_recipes)


SELECT
	topping_id,
	COUNT(*) topping_count
FROM
	customer_orders_temp cot
	INNER JOIN topping_cte tc ON cot.pizza_id = tc.pizza_id
	INNER JOIN runner_orders_temp rot ON rot.order_id = cot.order_id
WHERE
	rot.distance > 0
GROUP BY
	topping_id
ORDER BY
	topping_count DESC
```
