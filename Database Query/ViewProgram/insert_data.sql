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

CREATE TABLE ReviewProgram (
    ID SERIAL PRIMARY KEY,
    ProgramID INT REFERENCES Program(ID),
    MenteeID INT REFERENCES Mentee(ID),
    RatingStar FLOAT NOT NULL,
    Content VARCHAR
);

CREATE TABLE ProgramProgress (
    ID SERIAL PRIMARY KEY,
    ProgramID INT REFERENCES Program(ID),
    MenteeID INT REFERENCES Mentee(ID),
    ProgressPercent FLOAT,
    Status VARCHAR(50)
);

CREATE TABLE Category (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR NOT NULL
);

CREATE TABLE ProgramCategory (
    ProgramID INT REFERENCES Program(ID),
    CategoryID INT REFERENCES Category(ID),
    PRIMARY KEY (ProgramID, CategoryID)
);

CREATE TABLE MenteeActivity (
    ID SERIAL PRIMARY KEY,
    MenteeID INT REFERENCES Mentee(ID),
    ProgramID INT REFERENCES Program(ID),
    LastActivity TIMESTAMP NOT NULL
);

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

INSERT INTO ProgramProgress (ProgramID, MenteeID, ProgressPercent, Status) VALUES
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

INSERT INTO ProgramCategory (ProgramID, CategoryID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO MenteeActivity (MenteeID, ProgramID, LastActivity) VALUES
(1, 1, '2024-06-01 10:00:00'),
(1, 3, '2024-06-10 15:00:00'),
(2, 2, '2024-06-05 12:00:00'),
(3, 4, '2024-06-07 18:00:00'),
(4, 5, '2024-06-09 20:00:00');


