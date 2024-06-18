A. High Level Sales Analysis

1. What was the total quantity sold for all products?

SELECT
	pt.product_name, SUM(qty)
FROM 
	balanced_tree.sales s
    INNER JOIN balanced_tree.product_details pt ON pt.product_id = s.prod_id
GROUP BY
	pt.product_id, pt.product_name

2. What is the total generated revenue for all products before discounts?

SELECT
	prod_id, 
    SUM(qty * price) AS total_revenue
FROM 
	balanced_tree.sales
GROUP BY 
	prod_id;

3. What was the total discount amount for all products?
SELECT
	prod_id, 
    SUM(qty * price * discount / 100) AS total_discount
FROM 
	balanced_tree.sales
GROUP BY 
	prod_id;

B. Transaction Analysis

1. How many unique transactions were there?
SELECT
	COUNT(DISTINCT txn_id) AS transaction_count
FROM
	balanced_tree.sales

2. What is the average unique products purchased in each transaction?
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

3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?

4. What is the average discount value per transaction?

5. What is the percentage split of all transactions for members vs non-members?

6. What is the average revenue for member transactions and non-member transactions?



