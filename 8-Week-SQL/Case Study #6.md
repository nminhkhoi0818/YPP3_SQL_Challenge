## A. Digital Analysis

**1. How many users are there?**

```sql
SELECT
	COUNT(DISTINCT user_id)
FROM
	clique_bait.users
```

**2. How many cookies does each user have on average?**

```sql
WITH cookie_count_table AS
    (SELECT
        user_id, COUNT(DISTINCT cookie_id) AS cookie_count
    FROM
        clique_bait.users
    GROUP BY
        user_id)

SELECT AVG(cookie_count)
FROM cookie_count_table
```

**3. What is the unique number of visits by all users per month?**

```sql
SELECT
	TO_CHAR(event_time, 'Month'), COUNT(DISTINCT visit_id)
FROM
	clique_bait.events
GROUP BY
	TO_CHAR(event_time, 'Month')
```

**4. What is the number of events for each event type?**

```sql
SELECT
	event_type, COUNT(visit_id)
FROM
	clique_bait.events
GROUP BY
	event_type
ORDER BY
	event_type
```

**5. What is the percentage of visits which have a purchase event?**

```sql
SELECT
	100 * COUNT(DISTINCT visit_id) / (SELECT COUNT(DISTINCT visit_id) FROM clique_bait.events) AS purchase_event_percentage
FROM
	clique_bait.events e
	INNER JOIN clique_bait.event_identifier ei ON e.event_type = ei.event_type
WHERE
	ei.event_name = 'Purchase'
```

**6. What is the percentage of visits which view the checkout page but do not have a purchase event? The strategy to answer this question is to breakdown the question into 2 parts.**

```sql
WITH view_checkout_purchase_cte AS
	(SELECT
		visit_id,
		MAX(CASE WHEN event_type = 1 AND page_id = 12 THEN 1 ELSE 0 END) AS view_checkout_count,
		MAX(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS purchase_event_count
	FROM
		clique_bait.events
	GROUP BY
		visit_id)

SELECT
	100 * COUNT(DISTINCT visit_id) / (SELECT COUNT(DISTINCT visit_id) FROM clique_bait.events)
FROM
	view_checkout_purchase_cte
WHERE
	view_checkout_count = 1 AND purchase_event_count = 0
```

**7. What are the top 3 pages by number of views?**

```sql
SELECT
	COUNT(DISTINCT visit_id) visit_count
FROM
	clique_bait.events
WHERE
	event_type = 1
GROUP BY
	page_id
ORDER BY
	visit_count DESC
LIMIT 3
```

**8. What is the number of views and cart adds for each product category?**

```sql
SELECT
	product_category,
	SUM(CASE WHEN e.event_type = 1 THEN 1 ELSE 0 END) AS views_count,
	SUM(CASE WHEN e.event_type = 2 THEN 1 ELSE 0 END) AS cart_count
FROM
	clique_bait.events e
	INNER JOIN clique_bait.page_hierarchy ph ON e.page_id = ph.page_id
WHERE product_category IS NOT NULL
GROUP BY
	product_category
```

## B. Product Funnel Analysis

```sql
WITH view_cart_cte AS
	(SELECT
		e.visit_id,
		ph.product_id,
		ph.page_name AS product_name,
		SUM(CASE WHEN ei.event_name = 'Page View' THEN 1 ELSE 0 END) AS total_view,
		SUM(CASE WHEN ei.event_name = 'Add to Cart' THEN 1 ELSE 0 END) AS total_cart
	FROM
		clique_bait.events e
		INNER JOIN clique_bait.event_identifier ei ON e.event_type = ei.event_type
		INNER JOIN clique_bait.page_hierarchy ph ON ph.page_id = e.page_id
	WHERE
		ph.product_id IS NOT NULL
	GROUP BY
		e.visit_id, ph.product_id, ph.page_name),

purchase_cte AS
	(SELECT
		DISTINCT visit_id
	FROM
		clique_bait.events
	WHERE
		event_type = 3),

purchase_product_cte AS
	(SELECT
	 	*,
		(CASE WHEN pc.visit_id IS NOT NULL THEN 1 ELSE 0 END) AS total_purchase
	FROM
		view_cart_cte vcc
		LEFT JOIN purchase_cte pc ON vcc.visit_id = pc.visit_id)

SELECT
	product_id,
	product_name,
	SUM(total_view) AS total_view,
	SUM(total_cart) AS total_cart,
	SUM(CASE WHEN total_cart = 1 AND total_purchase = 0 THEN 1 ELSE 0 END) AS total_abandon,
	SUM(CASE WHEN total_cart = 1 AND total_purchase = 1 THEN 1 ELSE 0 END) AS total_purchase
FROM purchase_product_cte
GROUP BY
	product_id, product_name
```
