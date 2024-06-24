-- Get Program
SELECT * 
FROM 
	Program p
    JOIN Category c ON p.CategoryID = c.ID;
    
-- Get Popular Program
SELECT
	pu.ProgramID,
    COUNT(*) AS ProgramCount
FROM
	ProgramUser pu
    JOIN Program p ON pu.ProgramID = p.ID
GROUP BY
	pu.ProgramID
ORDER BY
	ProgramCount DESC