-- Get challenge from category "Information Technology"
SELECT
	*
FROM
	Challenge cl
    JOIN Category c ON cl.CategoryID = c.ID
WHERE 
	c.Name = 'Information Technology'