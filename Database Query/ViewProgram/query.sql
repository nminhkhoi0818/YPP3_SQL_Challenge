-- Get latest category that user 1 search
WITH latest_category AS
    (SELECT 
        CategoryID
    FROM
        EventLog el
        JOIN "Users" u ON el.UserID = u.ID
        JOIN Program p ON el.SourceID = p.ID
    WHERE 
        el.SourceTypeID = 3 AND el.UserID = 1
    ORDER BY
        el.EventTime DESC
    LIMIT 1)

-- Get program with latest category
SELECT
	p.Name AS recommend_program,
    p.Price
FROM 
	latest_category lc
    JOIN Program p ON lc.CategoryID = p.CategoryID
;
-- Get popular program (program that having most user take part in)
SELECT
	pu.ProgramID AS program_id,
	p.Name AS program_name, 
   	p.Price,
    COUNT(*) AS program_member_count
FROM
	ProgramUser pu
    JOIN Program p ON pu.ProgramID = p.ID
GROUP BY
	pu.ProgramID, p.Name, p.Price
ORDER BY
	program_member_count DESC
LIMIT 4;

-- Get Review Program
SELECT 
	SourceID AS program_id, 
    COUNT(SourceID) AS review_count,
    AVG(RatingStar) AS rating_star
FROM Review
WHERE SourceID = 2 AND SourceTypeID = 3
GROUP BY SourceID, SourceTypeID