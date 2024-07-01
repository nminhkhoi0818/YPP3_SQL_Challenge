-- Get latest category that user 1 searched
WITH latest_category AS (
    SELECT TOP 1 
        p.category_id
    FROM
        event_log el
        JOIN [user] u ON el.user_id = u.id
        JOIN program p ON el.source_id = p.id
    WHERE 
        el.source_type_id = 3 AND el.user_id = 1
    ORDER BY
        el.event_time DESC
)

-- Get program with latest category
SELECT
	p.program_name AS recommend_program,
    p.price,
    COUNT(r.source_id) AS review_count,
    AVG(r.rating_star) AS rating_star
FROM 
	latest_category lc
    JOIN program p ON lc.category_id = p.category_id
    LEFT JOIN review r ON r.source_id = p.id AND r.source_type_id = 3
GROUP BY p.program_name, p.price, r.source_id, r.source_type_id;

-- Get popular program (program that has most users participating)
SELECT TOP 4
	p.program_name AS program_name, 
   	p.price,
    COUNT(r.source_id) AS review_count,
    AVG(r.rating_star) AS rating_star,
    COUNT(*) AS program_member_count
FROM
	program_user pu
    JOIN program p ON pu.program_id = p.id
    LEFT JOIN review r ON r.source_id = p.id AND r.source_type_id = 3
GROUP BY
	p.program_name, p.price, r.source_id, r.source_type_id
ORDER BY
	program_member_count DESC;

-- Get trending program (program that has most users participating this month)
SELECT TOP 4
	p.program_name AS program_name, 
   	p.price,
    COUNT(r.source_id) AS review_count,
    AVG(r.rating_star) AS rating_star,
    COUNT(*) AS program_member_count
FROM
	program_user pu
    JOIN program p ON pu.program_id = p.id
    LEFT JOIN review r ON r.source_id = p.id AND r.source_type_id = 3
WHERE
    DATEADD(month, -1, GETDATE()) <= GETDATE()
GROUP BY
	p.program_name, p.price, r.source_id, r.source_type_id
ORDER BY
	program_member_count DESC;
