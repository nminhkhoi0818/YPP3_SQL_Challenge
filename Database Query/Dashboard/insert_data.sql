CREATE TABLE Mentor (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR NOT NULL
);

CREATE TABLE Mentee (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR NOT NULL
);

CREATE TABLE Program (
    ID SERIAL PRIMARY KEY,
    MentorID INT REFERENCES Mentor(ID),
    Name VARCHAR NOT NULL,
    Description VARCHAR NOT NULL,
  	Price Float
);

CREATE TABLE Challenge (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR NOT NULL,
    Description VARCHAR NOT NULL
);

CREATE TABLE ActivityLog (
    ID SERIAL PRIMARY KEY,
    MenteeID INT REFERENCES Mentee(ID),
    Activity VARCHAR(255),
    ActivityDate TIMESTAMP,
    Duration INTERVAL
);

CREATE TABLE ProgramProgress (
    ID SERIAL PRIMARY KEY,
    ProgramID INT REFERENCES Program(ID),
    MenteeID INT REFERENCES Mentee(ID),
    ProgressPercent FLOAT,
    Status VARCHAR(50)
);

CREATE TABLE ProgramMentor (
    ID SERIAL PRIMARY KEY,
    MentorID INT REFERENCES Mentor(ID),
    ProgramID INT REFERENCES Program(ID)
);

CREATE TABLE ChallengeSubmission (
    ID SERIAL PRIMARY KEY,
    ChallengeID INT REFERENCES Challenge(ID),
    MenteeID INT REFERENCES Mentee(ID),
    DateSubmission TIMESTAMP
);

CREATE TABLE ChallengeGrading (
    ID SERIAL PRIMARY KEY,
    ChallengeSubmissionID INT REFERENCES ChallengeSubmission(ID),
    MentorID INT REFERENCES Mentor(ID),
  	Status VARCHAR(50)
);

INSERT INTO Mentor (ID, Name) VALUES
(1, 'Alice Johnson'),
(2, 'Bob Smith'),
(3, 'Charlie Davis'),
(4, 'Diana Garcia'),
(5, 'Evan Martinez');

INSERT INTO Program (ID, MentorID, Name, Description, Price) VALUES
(1, 1, 'Software Engineering Fundamentals', 'Essential software engineering concepts', 33.99),
(2, 2, 'Data Science', 'Data analysis and machine learning mastery', 12.99),
(3, 3, 'Web Development Mastery', 'Interactive e-learning platform', 17.77),
(4, 4, 'Mentoring Hub', 'Personalized professional growth through mentorship', 19.99),
(5, 5, 'Digital Marketing Bootcamp', 'Comprehensive training in digital marketing strategies and tools', 99.99);


INSERT INTO Challenge (ID, Name, Description) VALUES
(1, 'Image Classification', 'The challenge is to develop a deep learning model using convolutional neural networks'),
(2, 'Fraud Detection Kaggle', 'Participate in a Kaggle competition focused on fraud detection in financial transactions.'),
(3, 'Short Story Writing', 'Writing a compelling short story'),
(4, 'Data Prediction', 'Predicting data trends using ML'),
(5, 'Recipe Development', 'Creating new and innovative recipes');


INSERT INTO Mentee (ID, Name) VALUES
(1, 'Fiona Brown'),
(2, 'George Clark'),
(3, 'Hannah Evans'),
(4, 'Ian Foster'),
(5, 'Julia Green');
    
INSERT INTO ProgramProgress (ProgramID, MenteeID, ProgressPercent, Status) VALUES
    (1, 1, 50.0, 'In Progress'),
    (2, 1, 30.0, 'In Progress'),
    (3, 1, 80.0, 'Completed');
    
INSERT INTO ChallengeSubmission (ChallengeID, MenteeID, DateSubmission) VALUES
    (1, 1, CURRENT_TIMESTAMP),
    (2, 1, CURRENT_TIMESTAMP),
    (3, 2, CURRENT_TIMESTAMP),
    (4, 2, CURRENT_TIMESTAMP),
    (1, 2, CURRENT_TIMESTAMP);

INSERT INTO ChallengeGrading (ChallengeSubmissionID, MentorID, Status) VALUES
    (1, 1, 'Passed'),
    (2, 2, 'Failed'),
    (3, 1, 'Passed');