-- Get recommended program
WITH LastActivity AS (
    SELECT 
        MenteeID,
        SourceID,
        MAX(EventTime) AS last_react_program
    FROM MenteeEventLog
    WHERE MenteeID = 1 AND SourceType = 'Program'
    GROUP BY MenteeID, SourceID
),
LastCategory AS (
    SELECT 
        la.MenteeID,
        pc.CategoryID
    FROM 
        LastActivity la
    JOIN 
        CategoryProgram pc ON la.SourceID = pc.ProgramID
)
    
SELECT 
    p.ID,
    p.Name,
    p.Description,
  	mt.Name,
    p.Price,
    AVG(rp.RatingStar) AS avg_rating, 
    COUNT(rp.RatingStar) AS review_count
FROM 
    Program p
   	INNER JOIN CategoryProgram pc ON p.ID = pc.ProgramID
  	INNER JOIN Mentor mt ON p.MentorID = mt.ID
    LEFT JOIN Review rp ON rp.SourceID = p.ID
WHERE 
    pc.CategoryID IN (SELECT CategoryID FROM LastCategory)
    AND rp.SourceType = 'Program'
GROUP BY
	p.ID, p.Name, p.Description, mt.Name, p.Price

-- Get popular programs
WITH program_count_table AS 
    (SELECT 
        ProgramID,
        COUNT(MenteeID) program_count
    FROM 
        MenteeProgram
    GROUP BY 
        ProgramID
    ORDER BY 
    	program_count DESC
    LIMIT 2)

SELECT 
	p.Name,
    p.Description,
    mt.Name,
    p.Price
FROM 
	program_count_table pct
    INNER JOIN Program p ON pct.ProgramID = p.ID 
    INNER JOIN Mentor mt ON p.MentorID = mt.ID

-- Get trending program
