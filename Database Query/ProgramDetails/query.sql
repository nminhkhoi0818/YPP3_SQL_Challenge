-- Get source of program 2
SELECT
	*
FROM
	Challenge cl
    JOIN ProgramSource ps ON cl.ID = ps.SourceID
WHERE
	ps.ProgramID = 2 AND SourceTypeID = 2;
    
SELECT
	*
FROM
	Course c
    JOIN ProgramSource ps ON c.ID = ps.SourceID
WHERE 
	ps.ProgramID = 2 AND SourceTypeID = 1;