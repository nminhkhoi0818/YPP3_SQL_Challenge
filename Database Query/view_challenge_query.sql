-- Get top trending challenge
SELECT
	cl.ChallengeName AS challenge_name,
    cl.Location AS challenge_location,
    cl.StartDate AS challenge_date,
    COUNT(cu.UserID) AS challenge_member_count
FROM
	Challenge cl
    JOIN ChallengeUser cu ON cl.ID = cu.ChallengeID
GROUP BY
	cl.ID, cl.ChallengeName, cl.Location, cl.StartDate
ORDER BY
	challenge_member_count DESC
LIMIT 3;

-- Get challenge from category "Information Technology"
SELECT
	cl.ChallengeName AS challenge_name,
    cl.Location AS challenge_position,
    cl.StartDate AS challenge_date,
	c.Name AS challenge_category
FROM
	Challenge cl
    JOIN Category c ON cl.CategoryID = c.ID
WHERE 
	c.Name = 'Information Technology';
    
-- Upcoming in 24h
SELECT
	cl.ChallengeName AS challenge_name,
    cl.Location AS challenge_position,
    cl.StartDate AS challenge_date,
	c.Name AS challenge_category
FROM
	Challenge cl
    JOIN Category c ON cl.CategoryID = c.ID
WHERE 
	cl.StartDate BETWEEN CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP + INTERVAL '1 day';

