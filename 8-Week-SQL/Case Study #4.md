## A. Customer Nodes Exploration

**1. How many unique nodes are there on the Data Bank system?**

```sql
SELECT COUNT(DISTINCT node_id)
FROM data_bank.customer_nodes
```

**2. What is the number of nodes per region?**

```sql
SELECT region_id, COUNT(DISTINCT node_id)
FROM data_bank.customer_nodes
GROUP BY region_id
```

**3. How many customers are allocated to each region?**

```sql
SELECT region_id, COUNT(customer_id)
FROM data_bank.customer_nodes
GROUP BY region_id
ORDER BY region_id
```

**4. How many days on average are customers reallocated to a different node?**

- Khi kết thúc một node thì có 2 trường hợp là tiếp tục ở node đó hoặc reallocate sang node khác, vì vậy mà cần phải GROUP BY theo customer_id và node_id

```sql
WITH date_node AS
    (SELECT
        customer_id,
        node_id,
        (end_date - start_date) AS date_valid_node
    FROM
        data_bank.customer_nodes
    WHERE end_date <> '9999-12-31')
	, customer_date_node AS
	(SELECT customer_id, node_id, SUM(date_valid_node) AS date_per_customer
        FROM date_node
        GROUP BY customer_id, node_id
        ORDER BY customer_id)

SELECT AVG(date_per_customer)
FROM customer_date_node
```

**5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?**

## B. Customer Transactions

**1. What is the unique count and total amount for each transaction type?**

```sql
SELECT
	txn_type AS transaction_type,
    COUNT (*) AS transaction_count,
    SUM(txn_amount) AS transaction_amount
FROM
	data_bank.customer_transactions
GROUP BY
	txn_type
```

**2. What is the average total historical deposit counts and amounts for all customers?**

```sql
WITH deposit_table AS (
  SELECT customer_id,
      COUNT(customer_id) AS deposit_count,
      AVG(txn_amount) AS deposit_amount
  FROM
      data_bank.customer_transactions
  WHERE
      txn_type = 'deposit'
  GROUP BY
      customer_id
)

SELECT
	AVG(deposit_count) AS avg_deposit_count,
    AVG(deposit_amount) AS avg_deposit_amount
FROM
	deposit_table
```

**3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?**

```sql
WITH monthly_transactions AS (
  SELECT
    customer_id,
    DATE_PART('Month', txn_date) AS month_name,
    SUM(CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS deposit_count,
    SUM(CASE WHEN txn_type != 'deposit' THEN 1 ELSE 0 END) AS non_deposit_count
	FROM data_bank.customer_transactions
  GROUP BY customer_id, DATE_PART('Month', txn_date)
)

SELECT
  month_name,
  COUNT(DISTINCT customer_id) AS customer_count
FROM monthly_transactions
WHERE deposit_count > 1
  AND non_deposit_count >= 1
GROUP BY month_name
ORDER BY month_name;
```

**4. What is the closing balance for each customer at the end of the month? Also show the change in balance each month in the same table output.**

**5. What is the percentage of customers who increase their closing balance by more than 5%?**
