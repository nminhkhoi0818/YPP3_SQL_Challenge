-- Get all program and completed program of user 2
SELECT
	COUNT(ProgramID) AS total_program,
    SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS completed_program
FROM
	ProgramUser
WHERE 
	UserID = 2;

-- Get all challenge and completed challenge of user 2
SELECT
	COUNT(ChallengeID) AS total_challenge,
    SUM(CASE WHEN Status = 'Passed' THEN 1 ELSE 0 END) AS completed_challenge
FROM
	ChallengeUser
WHERE 
	UserID = 2;
    
-- Get program progress
SELECT
	p.Name AS program_name, 
    u.Name AS mentor_name,
    pu.ProgressPercent AS program_progress,
    pu.Status AS program_status
FROM 
	ProgramUser pu 
    JOIN Program p ON pu.ProgramID = p.ID
    JOIN "User" u ON p.MentorID = u.ID
WHERE 
	UserID = 2
LIMIT 3;

-- Get recent challenge
SELECT
	c.ChallengeName AS challenge_name,
    c.Location AS challenge_location
FROM 
	ChallengeUser cu 
    JOIN Challenge c ON cu.ChallengeID = c.ID
WHERE 
	UserID = 2
ORDER BY
	cu.DateSubmission;
    
-- Get sum hour activity of user 2
SELECT 
	TO_CHAR(EventTime, 'Month') AS month_name,
    SUM(duration) AS monthly_duration,
	AVG(duration) AS average_duration
FROM 
	EventLog
WHERE 
	UserID = 2
GROUP BY
	TO_CHAR(EventTime, 'Month')