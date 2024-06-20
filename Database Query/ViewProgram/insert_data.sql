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

CREATE TABLE Review (
    SourceID INT,
    MenteeID INT REFERENCES Mentee(ID),
    RatingStar FLOAT NOT NULL,
    Content VARCHAR,
  	SourceType VARCHAR
);

CREATE TABLE MenteeProgram (
    ProgramID INT REFERENCES Program(ID),
    MenteeID INT REFERENCES Mentee(ID),
    ProgressPercent FLOAT,
    Status VARCHAR(50)
);

CREATE TABLE Category (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR NOT NULL
);

CREATE TABLE CategoryProgram (
    ProgramID INT REFERENCES Program(ID),
    CategoryID INT REFERENCES Category(ID),
    PRIMARY KEY (ProgramID, CategoryID)
);

CREATE TABLE EventIdentifier (
  ID SERIAL PRIMARY KEY,
  EventName VARCHAR(13)
);

CREATE TABLE MenteeEventLog (
    ID SERIAL PRIMARY KEY,
    MenteeID INT REFERENCES Mentee(ID),
    SourceID INT,
  	SourceType VARCHAR,
  	EventIndentifierID INT REFERENCES EventIdentifier(ID),
    EventTime TIMESTAMP NOT NULL
);

INSERT INTO EventIdentifier
  (ID, EventName)
VALUES
  (1, 'Page View'),
  (2, 'Add to Cart'),
  (3, 'Purchase'),
  (4, 'Ad Impression'),
  (5, 'Ad Click');


INSERT INTO Mentor (ID, Name) VALUES
(1, 'Alice Johnson'),
(2, 'Bob Smith'),
(3, 'Charlie Davis'),
(4, 'Diana Garcia'),
(5, 'Evan Martinez');

INSERT INTO Mentee (ID, Name) VALUES
(1, 'Fiona Brown'),
(2, 'George Clark'),
(3, 'Hannah Evans'),
(4, 'Ian Foster'),
(5, 'Julia Green');

INSERT INTO Program (ID, MentorID, Name, Description, Price) VALUES
(1, 1, 'Software Engineering Fundamentals', 'Essential software engineering concepts', 33.99),
(2, 2, 'Data Science', 'Data analysis and machine learning mastery', 12.99),
(3, 3, 'Web Development Mastery', 'Interactive e-learning platform', 17.77),
(4, 4, 'Mentoring Hub', 'Personalized professional growth through mentorship', 19.99),
(5, 5, 'Digital Marketing Bootcamp', 'Comprehensive training in digital marketing strategies and tools', 99.99);

INSERT INTO MenteeProgram (ProgramID, MenteeID, ProgressPercent, Status) VALUES
    (1, 1, 50.0, 'In Progress'),
    (2, 1, 30.0, 'In Progress'),
    (3, 1, 80.0, 'Completed'),
    (1, 2, 60.0, 'In Progress');
    

INSERT INTO Category (ID, Name) VALUES
(1, 'Software Engineering'),
(2, 'Data Science'),
(3, 'Web Development'),
(4, 'Professional Growth'),
(5, 'Digital Marketing');

INSERT INTO CategoryProgram (ProgramID, CategoryID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO Review (SourceID, MenteeID, RatingStar, Content, SourceType) VALUES
(2, 1, 4.5, 'Excellent tool for tracking environmental impact.', 'Program'),
(3, 2, 4.0, 'Very helpful for managing patient records.', 'Program'),

(4, 4, 4.2, 'Useful for financial planning.', 'Program'),
(5, 5, 4.7, 'Perfect place to showcase handmade products.', 'Program'),
(1, 1, 4.5, 'Very insightful introduction to quantum computing.', 'Challenge'),
(2, 2, 4.0, 'Comprehensive digital marketing strategies.', 'Challenge'),
(1, 3, 4.8, 'Great exercises and peer reviews.', 'Challenge'),
(2, 4, 4.2, 'Good coverage of data science techniques.', 'Challenge'),
(2, 5, 4.7, 'Excellent culinary skills development.', 'Challenge'),
(2, 1, 4.5, 'Challenging yet rewarding.', 'Course'),
(2, 2, 4.0, 'Learned a lot about social media marketing.', 'Course'),
(2, 3, 4.8, 'Fun and engaging short story writing tasks.', 'Course'),
(1, 4, 4.2, 'Useful for improving data prediction skills.', 'Course'),
(1, 5, 4.7, 'Inspired me to create new recipes.', 'Course');


INSERT INTO MenteeEventLog (MenteeID, SourceID, SourceType, EventIndentifierID, EventTime) VALUES
(1, 1, 'Program', 1, '2024-06-01 10:00:00'),
(1, 2, 'Program', 2, '2024-06-10 15:00:00'),
(1, 2, 'Program', 3, '2024-06-05 12:00:00'),
(1, 3, 'Course', 1, '2024-06-07 18:00:00'),
(1, 4, 'Challenge', 1, '2024-06-09 20:00:00');