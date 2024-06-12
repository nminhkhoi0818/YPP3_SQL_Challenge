CREATE TABLE Challenge (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR NOT NULL,
    Description VARCHAR NOT NULL,
    Location VARCHAR NOT NULL,
    StartTime TIMESTAMP NOT NULL,
    EndTime TIMESTAMP NOT NULL
);

CREATE TABLE TrendingChallenge (
    ID SERIAL PRIMARY KEY,
    ChallengeID INT REFERENCES Challenge(ID)
);

CREATE TABLE Category (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR NOT NULL
);

CREATE TABLE CategoryChallenge (
    ID SERIAL PRIMARY KEY,
    ChallengeID INT REFERENCES Challenge(ID),
    CategoryID INT REFERENCES Category(ID)
);

INSERT INTO Challenge (Name, Description, Location, StartTime, EndTime) VALUES
('AI Hackathon', 'A 48-hour hackathon focused on AI solutions.', 'San Francisco, CA', '2024-06-12 23:00:00', '2024-07-17 09:00:00'),
('Data Science Bootcamp', 'An intensive bootcamp on data science.', 'New York, NY', '2024-08-01 10:00:00', '2024-08-05 16:00:00'),
('Web Development Contest', 'A contest for developing innovative web applications.', 'Austin, TX', '2024-09-10 08:00:00', '2024-09-12 20:00:00'),
('Machine Learning Marathon', 'A marathon event to build machine learning models.', 'Chicago, IL', '2024-10-05 08:00:00', '2024-10-07 18:00:00'),
('Cybersecurity Challenge', 'A challenge to solve cybersecurity issues.', 'Los Angeles, CA', '2024-11-20 09:00:00', '2024-11-22 17:00:00');

INSERT INTO TrendingChallenge (ChallengeID) VALUES
(1),
(2),
(4);

INSERT INTO Category (Name) VALUES
('Technology'),
('Health'),
('Education'),
('Environment'),
('Finance');

INSERT INTO CategoryChallenge (ChallengeID, CategoryID) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1), 
(1, 3),
(2, 3),
(3, 3),
(4, 3),
(5, 3);

