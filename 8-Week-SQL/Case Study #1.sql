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
SELECT customer_id, menu.product_name
FROM 
    (SELECT
        customer_id,
        product_id,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
        ) AS product_order
    FROM
        dannys_diner.sales) customer_product
    INNER JOIN dannys_diner.menu ON customer_product.product_id = menu.product_id
WHERE customer_product.product_order = 1

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
SELECT sales.customer_id, SUM(product_point.point) AS customer_point
FROM (SELECT menu.product_id, 
          CASE
              WHEN menu.product_id = 1 THEN price * 20
              ELSE price * 10 END AS point
      FROM 
          dannys_diner.menu) AS product_point
    INNER JOIN dannys_diner.sales ON sales.product_id = product_point.product_id
GROUP BY sales.customer_id
ORDER BY sales.customer_id

10.
SELECT sales.customer_id, SUM(
	CASE
  		WHEN sales.order_date <= member_date.valid_date THEN menu.price * 20
  		WHEN menu.product_name = 'sushi' THEN menu.price * 20
  		ELSE menu.price * 10 END
	) AS customer_point
FROM
    (SELECT
        m.customer_id,
        m.join_date,
        m.join_date + 6 AS valid_date,
        DATE_TRUNC(
            'month', '2021-01-31'::DATE)
            + interval '1 month' 
            - interval '1 day' AS last_date
    FROM 
        dannys_diner.members m) member_date
    INNER JOIN dannys_diner.sales ON sales.customer_id = member_date.customer_id
  	INNER JOIN dannys_diner.menu ON sales.product_id = menu.product_id
WHERE 
	sales.order_date >= member_date.join_date AND sales.order_date <= member_date.last_date
GROUP BY sales.customer_id
ORDER BY sales.customer_id