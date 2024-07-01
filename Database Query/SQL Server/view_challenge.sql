-- Get top trending challenges
SELECT TOP 3
	cl.challenge_name AS challenge_name,
    cl.location AS challenge_location,
    cl.start_date AS challenge_date,
    COUNT(cu.user_id) AS challenge_member_count
FROM
	challenge cl
    JOIN challenge_user cu ON cl.id = cu.challenge_id
GROUP BY
	cl.id, cl.challenge_name, cl.location, cl.start_date
ORDER BY
	challenge_member_count DESC;

-- Get challenges from category "Information Technology"
SELECT
	cl.challenge_name AS challenge_name,
    cl.location AS challenge_position,
    cl.start_date AS challenge_date,
	c.category_name AS challenge_category
FROM
	challenge cl
    JOIN category c ON cl.category_id = c.id
WHERE 
	c.category_name = 'Information Technology';
    
-- Upcoming in 24 hours
SELECT
	cl.challenge_name AS challenge_name,
    cl.location AS challenge_position,
    cl.start_date AS challenge_date,
	c.category_name AS challenge_category
FROM
	challenge cl
    JOIN category c ON cl.category_id = c.id
WHERE 
	cl.start_date BETWEEN CURRENT_TIMESTAMP AND DATEADD(day, 1, CURRENT_TIMESTAMP);
