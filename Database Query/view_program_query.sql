-- Get latest category that user 1 search
WITH latest_category AS
    (SELECT 
        CategoryID
    FROM
        EventLog el
        JOIN "User" u ON el.UserID = u.ID
        JOIN Program p ON el.SourceID = p.ID
    WHERE 
        el.SourceTypeID = 3 AND el.UserID = 1
    ORDER BY
        el.EventTime DESC
    LIMIT 1)

-- Get program with latest category
SELECT
	p.Name AS recommend_program,
    p.Price,
    COUNT(SourceID) AS review_count,
    AVG(RatingStar) AS rating_star
FROM 
	latest_category lc
    JOIN Program p ON lc.CategoryID = p.CategoryID
    LEFT JOIN Review r ON r.SourceID = p.ID AND r.SourceTypeID = 3
GROUP BY p.Name, p.Price, r.SourceID, r.SourceTypeID
;

-- Get popular program (program that having most user take part in)
SELECT
	p.Name AS program_name, 
   	p.Price,
    COUNT(r.SourceID) AS review_count,
    AVG(r.RatingStar) AS rating_star,
    COUNT(*) AS program_member_count
FROM
	ProgramUser pu
    JOIN Program p ON pu.ProgramID = p.ID
    LEFT JOIN Review r ON r.SourceID = p.ID AND r.SourceTypeID = 3
GROUP BY
	p.Name, p.Price, r.SourceID, r.SourceTypeID
ORDER BY
	program_member_count DESC
LIMIT 4;