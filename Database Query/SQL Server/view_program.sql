-- Get recommend program
WITH latest_program_view AS (
    SELECT TOP 1 p.id
    FROM event_log el 
    JOIN program p ON el.source_id = p.id
    WHERE el.user_id = 1
    ORDER BY el.event_time DESC
),
latest_tags AS (
    SELECT st.tag_id
    FROM source_tag st 
    JOIN latest_program_view lpv ON st.source_id = lpv.id
)
SELECT
    p.id, p.program_name, p.price, p.description, COUNT(st.tag_id) AS tag_simlar_count
FROM latest_tags lt
JOIN source_tag st ON lt.tag_id = st.tag_id 
JOIN program p ON st.source_id = p.id
GROUP BY p.id, p.program_name, p.price, p.description
ORDER BY tag_simlar_count DESC

-- Get popular program
SELECT p.id, p.program_name, p.price, COUNT(el.user_id) view_count
FROM event_log el
	JOIN program p ON el.source_id = p.id
WHERE el.source_type_id = 3
GROUP BY p.id, p.program_name, p.price
ORDER BY view_count DESC

-- Get best-seller program
SELECT
	TOP 10 
	p.id, p.program_name, p.price, COUNT(order_id) AS program_purchase_count 
FROM
	[order] o
	JOIN order_details od ON o.id = od.order_id
	JOIN program p ON p.id = od.source_id
GROUP BY
	p.id, p.program_name, p.price
ORDER BY
	program_purchase_count DESC