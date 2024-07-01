-- Get order 1
SELECT
	o.id AS order_id,
	up.card_number AS user_card_number,
	pm.method AS user_card_method
FROM
	[order] o
    JOIN user_payment up ON o.user_payment_id = up.id
    JOIN payment_method pm ON up.payment_method_id = pm.id
WHERE 
	o.id = 1;

-- Get order details of order 1
SELECT
	p.program_name AS program_name,
    p.price AS program_price,
    u.full_name AS mentor_name
FROM 
	[order] o
    JOIN order_details od ON o.id = od.order_id
    JOIN program p ON p.id = od.source_id AND od.source_type_id = 3
    JOIN [user] u ON u.id = p.user_id
WHERE
	o.id = 1;

SELECT
	c.course_name AS course_name,
    u.full_name AS mentor_name
FROM 
	[order] o
    JOIN order_details od ON o.id = od.order_id
    JOIN course c ON c.id = od.source_id AND od.source_type_id = 1
    JOIN [user] u ON u.id = c.user_id
WHERE
	o.id = 1;

-- Get price of order 1
WITH order_details_cte AS (
    SELECT
        od.order_id,
        p.program_name AS name,
        od.source_type_id,
        p.price,
        u.full_name AS mentor_name
    FROM 
        [order] o
        JOIN order_details od ON o.id = od.order_id
        JOIN program p ON p.id = od.source_id AND od.source_type_id = 3
        JOIN [user] u ON u.id = p.user_id
    WHERE
        o.id = 1
    UNION
    SELECT
        od.order_id,
        c.course_name AS name,
        od.source_type_id,
        c.price,
        u.full_name AS mentor_name
    FROM 
        [order] o
        JOIN order_details od ON o.id = od.order_id
        JOIN course c ON c.id = od.source_id AND od.source_type_id = 1
        JOIN [user] u ON u.id = c.user_id
    WHERE
        o.id = 1
)
SELECT
    v.discount,
    odc.order_id AS order_id,
    SUM(odc.price) AS subtotal_price,
    (SUM(odc.price) - v.discount * SUM(odc.price) / 100) AS total_price
FROM
    order_details_cte odc 
    JOIN [order] o ON odc.order_id = o.id
    JOIN voucher v ON v.id = o.voucher_id
GROUP BY
    odc.order_id, v.discount;
