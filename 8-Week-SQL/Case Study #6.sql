1.
SELECT
	COUNT(DISTINCT user_id) 
FROM 
	clique_bait.users

2.
WITH cookie_count_table AS
    (SELECT
        user_id, COUNT(DISTINCT cookie_id) AS cookie_count
    FROM 
        clique_bait.users
    GROUP BY
        user_id)
        
SELECT AVG(cookie_count)
FROM cookie_count_table

3.
SELECT
	TO_CHAR(event_time, 'Month'), COUNT(DISTINCT visit_id)
FROM
	clique_bait.events
GROUP BY 
	TO_CHAR(event_time, 'Month')