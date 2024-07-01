-- Get all programs and completed programs of user 2
SELECT
	COUNT(program_id) AS total_program,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_program
FROM
	program_user
WHERE 
	user_id = 2;

-- Get all challenges and completed challenges of user 2
SELECT
	COUNT(challenge_id) AS total_challenge,
    SUM(CASE WHEN status = 'Passed' THEN 1 ELSE 0 END) AS completed_challenge
FROM
	challenge_user
WHERE 
	user_id = 2;
    
-- Get program progress
SELECT TOP 3
	p.program_name AS program_name, 
    u.full_name AS mentor_name,
    pu.progress_percent AS program_progress,
    pu.status AS program_status
FROM 
	program_user pu 
    JOIN program p ON pu.program_id = p.id
    JOIN [user] u ON p.user_id = u.id
WHERE 
	pu.user_id = 2;

-- Get recent challenges
SELECT
	c.challenge_name AS challenge_name,
    c.location AS challenge_location
FROM 
	challenge_user cu 
    JOIN challenge c ON cu.challenge_id = c.id
WHERE 
	cu.user_id = 2
ORDER BY
	cu.date_submission;

-- Get sum hour activity of user 2
SELECT 
	DATENAME(month, event_time) AS month_name,
    SUM(duration) AS monthly_duration,
	AVG(duration) AS average_duration
FROM 
	event_log
WHERE 
	user_id = 2
GROUP BY
	DATENAME(month, event_time);
