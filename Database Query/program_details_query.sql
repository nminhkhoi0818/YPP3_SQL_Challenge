-- Get information of program 2
SELECT 
	p.ProgramName AS program_name,
    p.Description AS program_description,
    p.Price,
    u.Name AS mentor_name
FROM 
	Program p
    JOIN "User" u ON p.MentorID = u.ID
WHERE 
	p.ID = 2;

-- Get reviews of program 2
SELECT 
	SourceID AS program_id, 
    COUNT(SourceID) AS review_count,
    AVG(RatingStar) AS rating_star
FROM Review
WHERE SourceID = 2 AND SourceTypeID = 3
GROUP BY SourceID, SourceTypeID;

-- Get challenges of program 2
SELECT
	cl.ID,
	cl.ChallengeName AS challenge_name,
    cl.Description AS challenge_description,
    ps.SourceOrder AS source_order
FROM
	Challenge cl
    JOIN ProgramSource ps ON cl.ID = ps.SourceID
WHERE
	ps.ProgramID = 2 AND SourceTypeID = 2;
    
-- Get courses of program 2
SELECT
	c.CourseName AS course_name,
    c.Description AS course_description,
    ps.SourceOrder AS source_order
FROM
	Course c
    JOIN ProgramSource ps ON c.ID = ps.SourceID
WHERE 
	ps.ProgramID = 2 AND SourceTypeID = 1;