-- Get progress in programs
SELECT 
	p.Name AS program_name, 
    pp.ProgressPercent AS program_progress_percent
FROM 
	Program p 
    INNER JOIN ProgramProgress pp ON pp.ProgramID = p.ID
    INNER JOIN Mentee m ON pp.MenteeID = m.ID
WHERE m.ID = 1;

-- Get progress statistic
SELECT 
    pp.Status AS program_status,
    COUNT(pp.Status) AS program_status_count
FROM 
	Program p 
    INNER JOIN ProgramProgress pp ON pp.ProgramID = p.ID
    INNER JOIN Mentee m ON pp.MenteeID = m.ID
WHERE m.ID = 1
GROUP BY pp.Status;

-- Get all challenge
SELECT (SELECT 
	COUNT (*) AS all_challenge
FROM 
	Challenge ch
    INNER JOIN ChallengeSubmission cs ON cs.ChallengeID = ch.ID
    INNER JOIN Mentee m ON cs.MenteeID = m.ID
WHERE m.ID = 1);

-- Get passed challenge
SELECT 
	COUNT (*) AS passed_challenge
FROM 
	Challenge ch
    INNER JOIN ChallengeSubmission cs ON cs.ChallengeID = ch.ID
    INNER JOIN Mentee m ON cs.MenteeID = m.ID
    INNER JOIN ChallengeGrading cg ON cs.ID = cg.ChallengeSubmissionID
WHERE m.ID = 1 AND cg.Status = 'Passed';

-- Statistic average hour activity
SELECT
	DATE_PART('month', al.ActivityDate) AS month, 
    SUM(al.duration) AS activity_time
FROM
	ActivityLog al 
    INNER JOIN Mentee m ON al.MenteeID = m.ID
WHERE m.ID = 1
GROUP BY DATE_PART('month', al.ActivityDate)