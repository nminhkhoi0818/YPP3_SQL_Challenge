1.
SELECT sales.customer_id, SUM(menu.price)
FROM dannys_diner.sales
	INNER JOIN dannys_diner.menu ON sales.product_id = menu.product_id
GROUP BY sales.customer_id
ORDER BY sales.customer_id

2.
SELECT sales.customer_id, COUNT(DISTINCT sales.order_date)
FROM dannys_diner.sales
GROUP BY sales.customer_id

3.
SELECT rank.customer_id, menu.product_name
FROM (SELECT sales.customer_id, sales.product_id, RANK() OVER (
	PARTITION BY sales.customer_id
  	ORDER BY sales.order_date
)
FROM dannys_diner.sales) rank
	INNER JOIN dannys_diner.menu ON menu.product_id = rank.product_id
WHERE rank.rank = 1
GROUP BY rank.customer_id, menu.product_name

4. 
SELECT sales.product_id, COUNT(sales.product_id) AS most_purchased
FROM dannys_diner.sales INNER JOIN dannys_diner.menu
	ON sales.product_id = menu.product_id
GROUP BY sales.product_id
ORDER BY most_purchased DESC
LIMIT 1;

5. 
SELECT 
    sales.customer_id, 
    menu.product_name, 
    COUNT(menu.product_id) AS order_count,
    RANK() OVER (
      PARTITION BY sales.customer_id
      ORDER BY COUNT(sales.customer_id) DESC) AS rank
  FROM dannys_diner.menu
  INNER JOIN dannys_diner.sales
    ON menu.product_id = sales.product_id
  GROUP BY sales.customer_id, menu.product_name

6.
SELECT rank.customer_id, menu.product_name
FROM (SELECT
    members.customer_id, 
    sales.product_id,
    sales.order_date,
    RANK() OVER (
    	PARTITION BY sales.customer_id
      	ORDER BY sales.order_date
    )
  FROM dannys_diner.members
  INNER JOIN dannys_diner.sales
    ON members.customer_id = sales.customer_id
    AND sales.order_date > members.join_date) rank
    INNER JOIN dannys_diner.menu ON rank.product_id = menu.product_id
WHERE rank.rank = 1

7.
SELECT rank.customer_id, menu.product_name
FROM (SELECT sales.customer_id, sales.product_id, RANK() OVER(
	PARTITION BY sales.customer_id
  	ORDER BY sales.order_date DESC
)
FROM dannys_diner.sales
	INNER JOIN dannys_diner.members ON sales.customer_id = members.customer_id
WHERE sales.order_date < members.join_date) rank
	INNER JOIN dannys_diner.menu ON rank.product_id = menu.product_id
WHERE rank.rank = 1

8. 
SELECT sales.customer_id, 
	COUNT(*), 
    SUM(menu.price)
FROM 
	dannys_diner.sales
    INNER JOIN dannys_diner.members ON sales.customer_id = members.customer_id
    INNER JOIN dannys_diner.menu ON sales.product_id = menu.product_id
WHERE sales.order_date < members.join_date
GROUP BY sales.customer_id

9.
10.