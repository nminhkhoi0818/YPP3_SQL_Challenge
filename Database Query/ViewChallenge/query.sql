-- Get 24h Up Coming Challenge
SELECT 
	ch.Name AS challenge_name,
    ch.Description AS challenge_description,
    ch.StartTime AS challenge_start_time
FROM 
	Challenge ch
WHERE 
    ch.StartTime BETWEEN NOW() AND NOW() + INTERVAL '1 day';
    
-- Get all category
SELECT  c.Name
FROM 
	CategoryChallenge cc
    INNER JOIN Category c ON cc.ChallengeID = c.ID;
    
-- Get challenge by category
SELECT ch.Name AS challenge_name
FROM 
	CategoryChallenge cc
    INNER JOIN Category c ON cc.CategoryID = c.ID
    INNER JOIN Challenge ch ON cc.ChallengeID = ch.ID
WHERE c.Name = 'Technology'