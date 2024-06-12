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

CREATE TABLE Course (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR NOT NULL,
    Description VARCHAR NOT NULL
);

CREATE TABLE Challenge (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR NOT NULL,
    Description VARCHAR NOT NULL
);

CREATE TABLE ReviewProgram (
    ID SERIAL PRIMARY KEY,
    ProgramID INT REFERENCES Program(ID),
    MenteeID INT REFERENCES Mentee(ID),
    RatingStar FLOAT NOT NULL,
    Content VARCHAR
);

CREATE TABLE ReviewCourse (
    ID SERIAL PRIMARY KEY,
    CourseID INT REFERENCES Course(ID),
    MenteeID INT REFERENCES Mentee(ID),
    RatingStar FLOAT NOT NULL,
    Content VARCHAR
);

CREATE TABLE ReviewChallenge (
    ID SERIAL PRIMARY KEY,
    ChallengeID INT REFERENCES Challenge(ID),
    MenteeID INT REFERENCES Mentee(ID),
    RatingStar FLOAT NOT NULL,
    Content VARCHAR
);

CREATE TABLE ProgramCourse (
    ID SERIAL PRIMARY KEY,
    ProgramID INT REFERENCES Program(ID),
    CourseID INT REFERENCES Course(ID)
);

CREATE TABLE ProgramMentor (
    ID SERIAL PRIMARY KEY,
    ProgramID INT REFERENCES Program(ID),
    MentorID INT REFERENCES Mentor(ID)
);

CREATE TABLE ProgramChallenge (
    ID SERIAL PRIMARY KEY,
    ProgramID INT REFERENCES Program(ID),
    ChallengeID INT REFERENCES Challenge(ID)
);

CREATE TABLE Benefit (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR NOT NULL
);

CREATE TABLE ProgramBenefit (
    ID SERIAL PRIMARY KEY,
    ProgramID INT REFERENCES Program(ID),
    BenefitID INT REFERENCES Benefit(ID)
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


INSERT INTO Course (ID, Name, Description) VALUES
(1, 'Machine Learning Foundations', 'Explore the principles of machine learning'),
(2, 'Big Data Analytics', 'Master the tools and technologies for processing and analyzing large-scale datasets'),
(3, 'Creative Writing Workshop', 'Developing creative writing skills'),
(4, 'Data Science and ML', 'Data analysis and machine learning algorithms'),
(5, 'Culinary Arts', 'From basics to mastery in culinary arts');

INSERT INTO ProgramCourse (ID, ProgramID, CourseID) VALUES
(1, 2, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

INSERT INTO Challenge (ID, Name, Description) VALUES
(1, 'Image Classification', 'The challenge is to develop a deep learning model using convolutional neural networks'),
(2, 'Fraud Detection Kaggle', 'Participate in a Kaggle competition focused on fraud detection in financial transactions.'),
(3, 'Short Story Writing', 'Writing a compelling short story'),
(4, 'Data Prediction', 'Predicting data trends using ML'),
(5, 'Recipe Development', 'Creating new and innovative recipes');

INSERT INTO ProgramChallenge (ID, ProgramID, ChallengeID) VALUES
(1, 2, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);


INSERT INTO ReviewProgram (ID, ProgramID, MenteeID, RatingStar, Content) VALUES
(1, 2, 1, 4.5, 'Excellent tool for tracking environmental impact.'),
(2, 2, 2, 4.0, 'Very helpful for managing patient records.'),
(3, 2, 3, 4.75, 'Great platform for learning new skills.'),
(4, 4, 4, 4.2, 'Useful for financial planning.'),
(5, 5, 5, 4.7, 'Perfect place to showcase handmade products.');

INSERT INTO ReviewCourse (ID, CourseID, MenteeID, RatingStar, Content) VALUES
(1, 1, 1, 4.5, 'Very insightful introduction to quantum computing.'),
(2, 2, 2, 4.0, 'Comprehensive digital marketing strategies.'),
(3, 1, 3, 4.8, 'Great exercises and peer reviews.'),
(4, 2, 4, 4.2, 'Good coverage of data science techniques.'),
(5, 2, 5, 4.7, 'Excellent culinary skills development.');

INSERT INTO ReviewChallenge (ID, ChallengeID, MenteeID, RatingStar, Content) VALUES
(1, 2, 1, 4.5, 'Challenging yet rewarding.'),
(2, 2, 2, 4.0, 'Learned a lot about social media marketing.'),
(3, 2, 3, 4.8, 'Fun and engaging short story writing tasks.'),
(4, 1, 4, 4.2, 'Useful for improving data prediction skills.'),
(5, 1, 5, 4.7, 'Inspired me to create new recipes.');

INSERT INTO ProgramMentor (ID, ProgramID, MentorID) VALUES
(1, 2, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

INSERT INTO Benefit (ID, Name) VALUES
(1, 'Full lifetime access'),
(2, '24/7 support'),
(3, '100% free document'),
(4, 'Certificate of complete'),
(5, 'Global Marketplace Access');


INSERT INTO ProgramBenefit (ID, ProgramID, BenefitID) VALUES
(1, 2, 1),
(2, 2, 2),
(3, 2, 3),
(4, 1, 4),
(5, 5, 5);


