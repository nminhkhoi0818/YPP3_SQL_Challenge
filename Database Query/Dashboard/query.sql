-- Get all program and completed program of user 2
SELECT
	*
FROM
	ProgramUser
WHERE 
	UserID = 2;
    
-- Get all challenge and completed challenge of user 2
SELECT
	*
FROM
	ChallengeUser
WHERE 
	UserID = 2
    
-- Get avarage hour activity