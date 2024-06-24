## A. High Level Sales Analysis

**1. What was the total quantity sold for all products?**

```sql
SELECT
	pt.product_name, SUM(qty)
FROM
	balanced_tree.sales s
    INNER JOIN balanced_tree.product_details pt ON pt.product_id = s.prod_id
GROUP BY
	pt.product_id, pt.product_name
```

**2. What is the total generated revenue for all products before discounts?**

```sql
SELECT
	prod_id,
    SUM(qty * price) AS total_revenue
FROM
	balanced_tree.sales
GROUP BY
	prod_id;
```

**3. What was the total discount amount for all products?**

```sql
SELECT
	prod_id,
    SUM(qty * price * discount / 100) AS total_discount
FROM
	balanced_tree.sales
GROUP BY
	prod_id;
```

## B. Transaction Analysis

**1. How many unique transactions were there?**

```sql
SELECT
	COUNT(DISTINCT txn_id) AS transaction_count
FROM
	balanced_tree.sales
```

**2. What is the average unique products purchased in each transaction?**

```sql
SELECT
	AVG(product_transaction_table.product_transaction_count)
FROM
    (SELECT
        txn_id,
        SUM(qty) product_transaction_count
    FROM
        balanced_tree.sales
    GROUP BY
        txn_id) product_transaction_table
```

**3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?**

```sql
WITH total_transaction_cte AS
    (SELECT
        txn_id,
        SUM(qty * price) AS total_transaction_revenue
    FROM
        balanced_tree.sales
    GROUP BY
        txn_id)

SELECT
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_transaction_revenue) AS percentile_25,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_transaction_revenue) AS percentile_50,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_transaction_revenue) AS percentile_75
FROM
	total_transaction_cte
```

**4. What is the average discount value per transaction?**

```sql
WITH discount_transaction_cte AS
    (SELECT
        txn_id,
        SUM(qty * price * discount / 100) AS discount_transaction_value
    FROM
        balanced_tree.sales
    GROUP BY
        txn_id)

SELECT AVG(discount_transaction_value)
FROM discount_transaction_cte
```

**5. What is the percentage split of all transactions for members vs non-members?**

```sql
SELECT
	sales.member,
    COUNT(DISTINCT txn_id) transaction_count,
    100 * COUNT(DISTINCT txn_id) / (SELECT COUNT(DISTINCT txn_id)
                                  FROM balanced_tree.sales)
FROM
	balanced_tree.sales
GROUP BY
	sales.member
```

**6. What is the average revenue for member transactions and non-member transactions?**

```sql
WITH revenue_cte AS
    (SELECT
        sales.member,
        SUM(qty * price) AS revenue
    FROM
        balanced_tree.sales
    GROUP BY
        sales.member, sales.txn_id)

SELECT AVG(revenue)
FROM revenue_cte
GROUP BY member
```

## C. Product Analysis

**1. What are the top 3 products by total revenue before discount?**

```sql
SELECT
	pd.product_name,
    SUM(s.qty * s.price) AS revenue
FROM
	balanced_tree.sales s
    INNER JOIN balanced_tree.product_details pd ON s.prod_id = pd.product_id
GROUP BY
	pd.product_name
ORDER BY
	revenue DESC
LIMIT 3
```

**2. What is the total quantity, revenue and discount for each segment?**

```sql
SELECT
	pd.segment_name,
    SUM(s.qty) AS total_quantity,
    SUM(s.qty * s.price) AS total_revenue,
    SUM(s.qty * s.price * s.discount / 100) AS total_discount
FROM
	balanced_tree.product_details pd
    INNER JOIN balanced_tree.sales s ON pd.product_id = s.prod_id
GROUP BY
	pd.segment_name
```

**3. What is the top selling product for each segment?**

```sql
WITH product_quantity_cte AS
    (SELECT
        pd.segment_name,
        pd.product_name,
        RANK() OVER(
            PARTITION BY segment_name
            ORDER BY SUM(s.qty) DESC
        ) AS quantity_rank
    FROM
        balanced_tree.sales s
        INNER JOIN balanced_tree.product_details pd ON s.prod_id = pd.product_id
    GROUP BY
        pd.segment_name, pd.product_name)

SELECT
	segment_name,
    product_name
FROM
	product_quantity_cte
WHERE
	quantity_rank = 1
```

**4. What is the total quantity, revenue and discount for each category?**

```sql
SELECT
	pd.category_name,
    SUM(s.qty) AS total_quantity,
    SUM(s.qty * s.price) AS total_revenue,
    SUM(s.qty * s.price * s.discount / 100) AS total_discount
FROM
	balanced_tree.product_details pd
    INNER JOIN balanced_tree.sales s ON pd.product_id = s.prod_id
GROUP BY
	pd.category_name
```

**5. What is the top selling product for each category?**

```sql
WITH product_category_cte AS
(SELECT
	pd.category_name,
    pd.product_name,
    RANK() OVER(
    	PARTITION BY pd.category_name
      	ORDER BY SUM(s.qty) DESC
    ) quantity_rank
FROM
	balanced_tree.product_details pd
    INNER JOIN balanced_tree.sales s ON pd.product_id = s.prod_id
GROUP BY
	pd.category_name, pd.product_name)

SELECT
	category_name,
    product_name
FROM
	product_category_cte
WHERE
	quantity_rank = 1
```

**6. What is the percentage split of revenue by product for each segment?**

```sql
WITH segment_price_cte AS
	(SELECT
		segment_id,
		SUM(price) AS segment_price
	FROM
		balanced_tree.product_details
	GROUP BY
		segment_id),
product_segment_cte AS
	(SELECT
	 	segment_id,
	 	product_id,
	 	SUM(price) product_price
	 FROM balanced_tree.product_details
	 GROUP BY
	 	segment_id, product_id
	)

SELECT
	psc.segment_id,
	psc.product_id,
	100 * psc.product_price / spc.segment_price AS product_segment_percentage
FROM
	product_segment_cte psc
	INNER JOIN segment_price_cte spc ON psc.segment_id = spc.segment_id
ORDER BY
	psc.segment_id
```

**7. What is the percentage split of revenue by segment for each category?**

```sql
WITH category_price_cte AS
	(SELECT
		category_id,
		SUM(price) AS category_price
	FROM
		balanced_tree.product_details
	GROUP BY
		category_id),
category_segment_cte AS
	(SELECT
	 	segment_id,
	 	category_id,
	 	SUM(price) segment_category_price
	 FROM balanced_tree.product_details
	 GROUP BY
	 	segment_id, category_id
	)

SELECT
	cpc.category_id, csc.segment_id,
	100 * csc.segment_category_price / cpc.category_price AS segment_category_percentage
FROM
	category_price_cte cpc
	INNER JOIN category_segment_cte csc ON csc.category_id = cpc.category_id
ORDER BY
	cpc.category_id
```

**8. What is the percentage split of total revenue by category?**

```sql
SELECT
	category_id,
	ROUND(100 * SUM(price) / (SELECT SUM(price) FROM balanced_tree.product_details), 2)
FROM
	balanced_tree.product_details
GROUP BY
	category_id
ORDER BY
	category_id
```

**9. What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)**

```sql
WITH product_transactions AS (
  SELECT
    prod_id,
    COUNT(DISTINCT txn_id) AS txn_count
  FROM balanced_tree.sales
  GROUP BY prod_id
)
SELECT
  prod_id,
  txn_count,
  CAST(txn_count AS FLOAT) / (SELECT COUNT(DISTINCT txn_id) AS total_tnxs
							 FROM balanced_tree.sales) AS penetration
FROM
  product_transactions
```

**10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?**

```sql
WITH txn_product_combinations AS (
  SELECT
    txn_id,
    ARRAY_AGG(DISTINCT prod_id ORDER BY prod_id) AS product_combination
  FROM
    balanced_tree.sales
  GROUP BY
    txn_id
  HAVING
    COUNT(DISTINCT prod_id) = 3
)
SELECT
  product_combination,
  COUNT(*) AS combination_count
FROM
  txn_product_combinations
GROUP BY
  product_combination
ORDER BY
	combination_count DESC
```
