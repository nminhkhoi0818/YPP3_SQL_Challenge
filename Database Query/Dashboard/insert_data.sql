CREATE TABLE Role (
    ID INT PRIMARY KEY,
    RoleName VARCHAR
);

CREATE TABLE EventType (
    ID INT PRIMARY KEY,
    TypeName VARCHAR
);

CREATE TABLE "Users" (
    ID INT PRIMARY KEY,
    Name VARCHAR,
    RoleID INT REFERENCES Role(ID)
);

CREATE TABLE Category (
    ID SERIAL PRIMARY KEY,
    CategoryName VARCHAR
);

CREATE TABLE Program (
    ID INT PRIMARY KEY,
    MentorID INT REFERENCES "Users"(ID),
    Name VARCHAR,
    Description VARCHAR,
    Price FLOAT,
    CategoryID INT REFERENCES Category(ID)
);

CREATE TABLE ProgramUser (
    ProgramID INT REFERENCES Program(ID),
    UserID INT REFERENCES "Users"(ID),
    ProgressPercent FLOAT,
    Status VARCHAR(50),
    PRIMARY KEY (ProgramID, UserID)
);

CREATE TABLE Challenge (
    ID INT PRIMARY KEY,
    CategoryID INT REFERENCES Category(ID),
    ChallengeName VARCHAR,
    Description VARCHAR,
    Location VARCHAR,
    Phase VARCHAR,
    SubmissionFiles INT
);

CREATE TABLE ChallengeUser (
    ChallengeID INT REFERENCES Challenge(ID),
    UserID INT REFERENCES "Users"(ID),
    Score FLOAT,
    Status VARCHAR,
    DateSubmission TIMESTAMP
);

CREATE TABLE SourceType (
    ID INT PRIMARY KEY,
    SourceName VARCHAR
);

CREATE TABLE EventLog (
    ID INT PRIMARY KEY,
    UserID INT REFERENCES "Users"(ID),
    SourceID INT,
    SourceTypeID INT REFERENCES SourceType(ID),
    EventTypeID INT REFERENCES EventType(ID),
    EventTime TIMESTAMP
);

INSERT INTO Role (ID, RoleName) VALUES
(1, 'Admin'),
(2, 'Mentor'),
(3, 'Mentee');

INSERT INTO "Users" (ID, Name, RoleID) VALUES
(1, 'Alice', 3),
(2, 'Bob', 3),
(3, 'Charlie', 3),
(4, 'David', 3),
(5, 'Eve', 2),
(6, 'Frank', 2),
(7, 'Grace', 3),
(8, 'Heidi', 3),
(9, 'Ivan', 3);

INSERT INTO Category (ID, CategoryName) VALUES
(1, 'Information Technology'),
(2, 'UI/UX Design'),
(3, 'Marketing'),
(4, 'Lifestyle'),
(5, 'Photography'),
(6, 'Video');

INSERT INTO Program (ID, MentorID, Name, Description, Price, CategoryID) VALUES
(1, 5, 'Software Engineering Fundamentals', 'Essential software engineering concepts', 33.99, 6),
(2, 6, 'Data Science', 'Data analysis and machine learning mastery', 12.99, 5),
(3, 5, 'Web Development Mastery', 'Interactive e-learning platform', 17.77, 4),
(4, 6, 'Mentoring Hub', 'Personalized professional growth through mentorship', 19.99, 3),
(5, 5, 'Digital Marketing Bootcamp', 'Comprehensive training in digital marketing strategies and tools', 99.99, 2);

INSERT INTO ProgramUser (ProgramID, UserID, ProgressPercent, Status) VALUES
(1, 1, 50, 'In Progress'),
(2, 2, 30, 'In Progress'),
(3, 3, 80, 'Completed'),
(2, 1, 69, 'In Progress'),
(4, 2, 61, 'In Progress'),
(4, 3, 99, 'Completed'),
(5, 6, 81, 'Completed'),
(5, 7, 72, 'In Progress'),
(1, 9, 85, 'Completed');

INSERT INTO EventType (ID, TypeName) VALUES
(1, 'Page View'),
(2, 'Add to Cart'),
(3, 'Purchase'),
(4, 'Ad Impression'),
(5, 'Ad Click'),
(6, 'View Category');

INSERT INTO Challenge (ID, CategoryID, ChallengeName, Description, Location, Phase, SubmissionFiles) VALUES
(1, 1, 'Image Classification', 'The challenge is to develop a deep learning model', 'Remote', 'Starting Phase', 2),
(2, 2, 'Fraud Detection Kaggle', 'Participate in a Kaggle competition', 'HCM', 'Starting Phase', 1),
(3, 3, 'Short Story Writing', 'Writing a compelling short story', 'Remote', 'Starting Phase', 1),
(4, 4, 'Data Prediction', 'Predicting data trends using ML', 'Remote', 'Ending Phase', 2),
(5, 5, 'Recipe Development', 'Creating new and innovative recipes', 'Remote', 'Ending Phase', 5);

INSERT INTO ChallengeUser (ChallengeID, UserID, Score, Status, DateSubmission) VALUES
(1, 1, 8, 'Passed', '2023-06-23'),
(2, 1, 6, 'Passed', '2024-06-23'),
(3, 2, 7, 'Passed', '2025-06-23'),
(4, 2, 3, 'Failed', '2026-06-23'),
(5, 3, 5, 'Passed', '2027-06-23'),
(3, 3, 4, 'Failed', '2027-06-23');

INSERT INTO SourceType (ID, SourceName) VALUES
(1, 'Course'),
(2, 'Challenge'),
(3, 'Program');

INSERT INTO EventLog (ID, UserID, SourceID, SourceTypeID, EventTypeID, EventTime) VALUES
(1, 1, 1, 3, 1, '2024-03-02 00:00:00'),
(2, 2, 1, 1, 2, '2024-03-03 00:00:00'),
(3, 1, 2, 2, 3, '2024-03-04 00:00:00'),
(4, 2, 2, 3, 4, '2024-03-05 00:00:00'),
(5, 3, 2, 1, 5, '2024-03-06 00:00:00');