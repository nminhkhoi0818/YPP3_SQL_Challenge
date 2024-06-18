-- Get recommended program
WITH LastActivity AS (
    SELECT 
        MenteeID,
        ProgramID,
        MAX(LastActivity) AS LastActivity
    FROM MenteeActivity
    WHERE MenteeID = 1
    GROUP BY MenteeID, ProgramID
),
LastCategory AS (
    SELECT 
        la.MenteeID,
        pc.CategoryID
    FROM 
        LastActivity la
    JOIN 
        ProgramCategory pc ON la.ProgramID = pc.ProgramID
),
RecommendedPrograms AS (
    SELECT 
        p.ID,
        p.Name,
        p.Description,
        p.Price
    FROM 
        Program p
    JOIN 
        ProgramCategory pc ON p.ID = pc.ProgramID
    WHERE 
        pc.CategoryID IN (SELECT CategoryID FROM LastCategory)
)
SELECT * FROM RecommendedPrograms;

-- Get popular program
WITH program_count_table AS 
    (SELECT 
        ProgramID,
        COUNT(MenteeID) program_count
    FROM 
        ProgramProgress pp
    GROUP BY 
        ProgramID
    ORDER BY 
    	program_count DESC
    LIMIT 2)

SELECT 
	p.ID, p.name, p.description, p.price
FROM 
	program_count_table pct
    INNER JOIN Program p ON pct.ProgramID = p.ID

-- Get trending program
