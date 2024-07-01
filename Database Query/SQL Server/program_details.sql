-- Get information of program 2
SELECT 
	p.program_name,
    p.description,
    p.price,
    u.full_name AS mentor_name,
    COUNT(r.source_id) AS review_count,
    AVG(r.rating_star) AS rating_star
FROM 
	program p
    JOIN [user] u ON p.user_id = u.id
    LEFT JOIN review r ON r.source_id = p.id AND r.source_type_id = 3
WHERE 
	p.id = 2
GROUP BY
	p.program_name, p.description, p.price, u.full_name;

-- Create function to get program information
CREATE FUNCTION dbo.GetProgramInfo
(
    @program_id INT,
    @source_type_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.program_name,
        p.description,
        p.price,
        u.full_name AS mentor_name,
        COUNT(r.source_id) AS review_count,
        AVG(r.rating_star) AS rating_star
    FROM 
        program p
        JOIN [user] u ON p.user_id = u.id
        LEFT JOIN review r ON r.source_id = p.id AND r.source_type_id = @source_type_id
    WHERE 
        p.id = @program_id
    GROUP BY
        p.program_name, p.description, p.price, u.full_name
);

-- Call function to get program information
SELECT * FROM dbo.GetProgramInfo(2, 3)


CREATE FUNCTION dbo.GetProgramInfo
(
    @program_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.program_name,
        p.description,
        p.price,
        u.full_name AS mentor_name,
        COUNT(r.source_id) AS review_count,
        AVG(r.rating_star) AS rating_star
    FROM 
        program p
        JOIN [user] u ON p.user_id = u.id
        LEFT JOIN review r ON r.source_id = p.id
		LEFT JOIN setting s ON s.setting_value = r.source_type_id  AND s.setting_type = 'SourceType' AND s.setting_name = 'program'
    WHERE 
        p.id = @program_id
    GROUP BY
        p.program_name, p.description, p.price, u.full_name
);

SELECT * FROM dbo.GetProgramInfo(2)

-- Get source of program 2
CREATE FUNCTION dbo.GetProgramInfo
(
    @program_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.program_name,
        p.description,
        p.price,
        u.full_name AS mentor_name,
        COUNT(r.source_id) AS review_count,
        AVG(r.rating_star) AS rating_star
    FROM 
        program p
        JOIN [user] u ON p.user_id = u.id
        LEFT JOIN review r ON r.source_id = p.id AND r.source_type_id = (
			SELECT setting_value
			FROM setting
			WHERE setting_type = 'SourceType' AND setting_name = 'program'
		)
    WHERE 
        p.id = @program_id
    GROUP BY
        p.program_name, p.description, p.price, u.full_name
);

-- Get challenges of a program
CREATE FUNCTION dbo.GetProgramChallenges
(
    @program_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        cl.id,
        cl.challenge_name,
        cl.description,
        ps.source_order
    FROM
        challenge cl
        JOIN program_source ps ON cl.id = ps.source_id AND ps.source_type_id = (
			SELECT setting_value
			FROM setting
			WHERE setting_type = 'SourceType' AND setting_name = 'challenge'
		)
    WHERE
        ps.program_id = @program_id
);

-- Call function to get challenges of program 2
SELECT * FROM dbo.GetProgramChallenges(2)

-- Get courses of a program
CREATE FUNCTION dbo.GetProgramCourses
(
    @program_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
		c.id,
        c.course_name,
        c.description,
        ps.source_order
    FROM
        course c
        JOIN program_source ps ON c.id = ps.source_id AND ps.source_type_id = (
			SELECT setting_value
			FROM setting
			WHERE setting_type = 'SourceType' AND setting_name = 'course'
		)
    WHERE 
        ps.program_id = @program_id
);

-- Call function to get courses of program 2
SELECT * FROM dbo.GetProgramCourses(2)