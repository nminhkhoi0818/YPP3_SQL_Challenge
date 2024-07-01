CREATE FUNCTION dbo.GetRecommendPrograms (@user_id INT)
RETURNS TABLE
AS
RETURN
(
    WITH latest_category AS (
        SELECT TOP 1 
            p.category_id
        FROM
            event_log el
            JOIN [user] u ON el.user_id = u.id
            JOIN program p ON el.source_id = p.id
        WHERE 
            el.user_id = @user_id AND el.source_type_id = (
				SELECT setting_value
				FROM setting
				WHERE setting_type = 'SourceType' AND setting_name = 'program'
			)
        ORDER BY
            el.event_time DESC
    )
    SELECT
        p.program_name AS recommend_program,
        p.price,
        ISNULL(COUNT(r.source_id), 0) AS review_count,
        ISNULL(AVG(r.rating_star), 0) AS rating_star
    FROM 
        latest_category lc
        JOIN program p ON lc.category_id = p.category_id
        LEFT JOIN review r ON r.source_id = p.id AND r.source_type_id = (
			SELECT setting_value
			FROM setting
			WHERE setting_type = 'SourceType' AND setting_name = 'program'
		)
    GROUP BY p.program_name, p.price
);

SELECT * FROM dbo.GetRecommendPrograms(1);

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
