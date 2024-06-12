SELECT 
    p.Name AS program_name, 
    p.Description AS program_description,  
    p.Price AS program_price, 
    AVG(rp.RatingStar) AS avg_rating, 
    COUNT(rp.RatingStar) AS review_count
FROM 
    Program p
    INNER JOIN ProgramMentor pm ON p.ID = pm.ProgramID
    INNER JOIN ReviewProgram rp ON rp.ProgramID = p.ID
WHERE 
    p.Name = 'Data Science'
GROUP BY 
    p.ID, p.Name, p.Description, p.Price;


SELECT 
	m.Name AS mentor_name
FROM
	Program p
    INNER JOIN ProgramMentor pm ON pm.ProgramID = p.ID
    INNER JOIN Mentor m ON pm.MentorID = m.ID
WHERE 
	p.Name = 'Data Science';

SELECT 
	b.Name AS benefit_name
FROM 
	Program p 
    INNER JOIN ProgramBenefit pm ON pm.ProgramID = p.ID 
	INNER JOIN Benefit b ON pm.BenefitID = b.ID
WHERE p.Name = 'Data Science';

SELECT 
    c.Name AS course_name, 
    c.Description AS course_description, 
    AVG(rc.RatingStar) AS avg_rating, 
    COUNT(rc.RatingStar) AS review_count
FROM 
    Program p
    INNER JOIN ProgramCourse pc ON p.ID = pc.ProgramID
    INNER JOIN Course c ON pc.CourseID = c.ID
    INNER JOIN ReviewCourse rc ON rc.CourseID = c.ID
WHERE 
    p.Name = 'Data Science'
GROUP BY 
    c.Name, c.Description;


SELECT 
    ch.Name AS challenge_name, 
    ch.Description AS challenge_description, 
    AVG(rch.RatingStar) AS avg_rating, 
    COUNT(rch.RatingStar) AS review_count
FROM 
    Program p
    INNER JOIN ProgramChallenge pch ON p.ID = pch.ProgramID
    INNER JOIN Challenge ch ON pch.ChallengeID = ch.ID
    INNER JOIN ReviewChallenge rch ON rch.ChallengeID = ch.ID
WHERE 
    p.Name = 'Data Science'
GROUP BY 
    ch.Name, ch.Description;