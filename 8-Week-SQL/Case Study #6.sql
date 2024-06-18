1.
SELECT
	COUNT(DISTINCT user_id) 
FROM 
	clique_bait.users

2.
WITH cookie_count_table AS
    (SELECT
        user_id, COUNT(DISTINCT cookie_id) AS cookie_count
    FROM 
        clique_bait.users
    GROUP BY
        user_id)
        
SELECT AVG(cookie_count)
FROM cookie_count_table

3.
SELECT
	TO_CHAR(event_time, 'Month'), COUNT(DISTINCT visit_id)
FROM
	clique_bait.events
GROUP BY 
	TO_CHAR(event_time, 'Month')

4. 
SELECT 
	event_type, COUNT(visit_id)
FROM 
	clique_bait.events
GROUP BY
	event_type
ORDER BY
	event_type

5.
SELECT
	100 * COUNT(DISTINCT visit_id) / (SELECT COUNT(DISTINCT visit_id) FROM clique_bait.events) AS purchase_event_percentage
FROM
	clique_bait.events e
	INNER JOIN clique_bait.event_identifier ei ON e.event_type = ei.event_type
WHERE 
	ei.event_name = 'Purchase'

6.
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

7. What are the top 3 pages by number of views?
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

8. What is the number of views and cart adds for each product category?
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
