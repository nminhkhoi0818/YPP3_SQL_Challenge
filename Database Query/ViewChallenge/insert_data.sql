CREATE TABLE Role (
    ID INT PRIMARY KEY,
    RoleName VARCHAR
);

CREATE TABLE "User" (
    ID INT PRIMARY KEY,
    Name VARCHAR,
    RoleID INT REFERENCES Role(ID)
);

CREATE TABLE Category (
    ID INT PRIMARY KEY,
    Name VARCHAR
);

CREATE TABLE Challenge (
    ID INT PRIMARY KEY,
    CategoryID INT REFERENCES Category(ID),
    ChallengeName VARCHAR,
    Description VARCHAR,
    Location VARCHAR,
    Phase VARCHAR,
    StartDate TIMESTAMP
);

CREATE TABLE ChallengeUser (
    ChallengeID INT REFERENCES Challenge(ID),
    UserID INT REFERENCES "User"(ID),
    Score FLOAT,
    Status VARCHAR,
    DateSubmission TIMESTAMP
);

INSERT INTO Role (ID, RoleName) VALUES
(1, 'Mentee'),
(2, 'Mentor'),
(3, 'Admin');

INSERT INTO "User" (ID, Name, RoleID) VALUES
(1, 'Mark Johnson', 1),
(2, 'Lisa Chen', 2),
(3, 'David Lee', 2),
(4, 'Emily Brown', 1),
(5, 'Michael Smith', 2),
(6, 'Jessica Wang', 2);

INSERT INTO Category (ID, Name) VALUES
(1, 'Information Technology'),
(2, 'UI/UX Design'),
(3, 'Marketing'),
(4, 'Lifestyle'),
(5, 'Photography'),
(6, 'Video');

INSERT INTO Challenge (ID, CategoryID, ChallengeName, Description, Location, Phase, StartDate) VALUES
(1, 1, 'Image Classification', 'The challenge is to develop a deep learning model', 'Remote', 'Starting Phase', '2024-06-26'),
(2, 1, 'Fraud Detection Kaggle', 'Participate in a Kaggle competition', 'HCM', 'Starting Phase', '2024-06-27'),
(3, 5, 'Short Story Writing', 'Writing a compelling short story', 'Remote', 'Starting Phase', '2024-06-23'),
(4, 1, 'Data Prediction', 'Predicting data trends using ML', 'Remote', 'Ending Phase', '2024-06-27'),
(5, 5, 'Recipe Development', 'Creating new and innovative recipes', 'Remote', 'Ending Phase', '2024-06-23');

INSERT INTO ChallengeUser (ChallengeID, UserID, Score, Status, DateSubmission) VALUES
(1, 1, 8, 'Passed', '2024-06-10'),
(2, 1, 6, 'Passed', '2024-05-08'),
(3, 2, 7, 'Passed', '2024-01-23'),
(4, 2, 3, 'Failed', '2024-02-04'),
(5, 3, 5, 'Passed', '2024-08-14'),
(3, 3, 4, 'Failed', '2024-12-17');

