-- Get progress in programs of mentee 1 
SELECT 
	p.Name AS, 
    pp.Status, 
    pp.ProgressPercent
FROM 
	Program p 
    INNER JOIN ProgramProgress pp ON pp.ProgramID = p.ID
    INNER JOIN Mentee m ON pp.MenteeID = m.ID
WHERE m.ID = 1;

-- Get all challenge of mentee 1
SELECT 
	COUNT (*) AS all_challenge
FROM 
	Challenge ch
    INNER JOIN ChallengeSubmission cs ON cs.ChallengeID = ch.ID
    INNER JOIN Mentee m ON cs.MenteeID = m.ID
WHERE m.ID = 1;

-- Get passed challenge of mentee 1
SELECT 
	COUNT (*) AS passed_challenge
FROM 
	Challenge ch
    INNER JOIN ChallengeSubmission cs ON cs.ChallengeID = ch.ID
    INNER JOIN Mentee m ON cs.MenteeID = m.ID
    INNER JOIN ChallengeGrading cg ON cs.ID = cg.ChallengeSubmissionID
WHERE m.ID = 1 AND cg.Status = 'Passed'
