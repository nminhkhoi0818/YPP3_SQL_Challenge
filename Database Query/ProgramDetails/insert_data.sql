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
    ID SERIAL PRIMARY KEY,
    CategoryName VARCHAR
);

CREATE TABLE Program (
    ID SERIAL PRIMARY KEY,
    MentorID INT REFERENCES "User"(ID),
    ProgramName VARCHAR,
    Description VARCHAR,
    Price FLOAT,
    CategoryID INT REFERENCES Category(ID)
);

CREATE TABLE Course (
    ID SERIAL PRIMARY KEY,
    CourseName VARCHAR,
    Description VARCHAR,
    MentorID INT REFERENCES "User"(ID)
);

CREATE TABLE Challenge (
    ID SERIAL PRIMARY KEY,
    ChallengeName VARCHAR,
    Description VARCHAR,
    MentorID INT REFERENCES "User"(ID)
);

CREATE TABLE SourceType (
    ID INT PRIMARY KEY,
    SourceName VARCHAR
);

CREATE TABLE Review (
    SourceID INT,
    MenteeID INT REFERENCES "User"(ID),
    SourceTypeID INT REFERENCES SourceType(ID),
    RatingStar FLOAT,
    Content VARCHAR,
    PRIMARY KEY (SourceID, MenteeID, SourceTypeID)
);

CREATE TABLE ProgramSource (
    ProgramID INT REFERENCES Program(ID),
    SourceID INT,
    SourceTypeID INT REFERENCES SourceType(ID),
    SourceOrder INT,
    PRIMARY KEY (ProgramID, SourceID, SourceTypeID)
);

CREATE TABLE ProgramMentor (
    ProgramID INT REFERENCES Program(ID),
    MentorID INT REFERENCES "User"(ID),
    PRIMARY KEY (ProgramID, MentorID)
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

INSERT INTO Category (ID, CategoryName) VALUES
(1, 'Information Technology'),
(2, 'UI/UX Design'),
(3, 'Marketing'),
(4, 'Lifestyle'),
(5, 'Photography'),
(6, 'Video');

INSERT INTO Program (ID, MentorID, ProgramName, Description, Price, CategoryID) VALUES
(1, 1, 'Software Engineering Fundamentals', 'Essential software engineering concepts', 33.99, 6),
(2, 2, 'Data Science', 'Data analysis and machine learning mastery', 12.99, 5),
(3, 3, 'Web Development Mastery', 'Interactive e-learning platform', 17.77, 4),
(4, 4, 'Mentoring Hub', 'Personalized professional growth through mentorship', 19.99, 3),
(5, 5, 'Digital Marketing Bootcamp', 'Comprehensive training in digital marketing strategies and tools', 99.99, 2);

INSERT INTO Course (ID, CourseName, Description, MentorID) VALUES
(1, 'Grow Your Video Editing Skills from Experts', 'Essential software engineering concepts', 1),
(2, 'Easy and Creative Food Art Ideas Decoration', 'Data analysis and machine learning mastery', 2),
(3, 'Create Your Own Sustainable Fashion Style', 'Interactive e-learning platform', 3),
(4, 'Grow Your Skills Fashion Marketing', 'Personalized professional growth through mentorship', 4),
(5, 'UI Design, a User-Centered Approach', 'Comprehensive training in digital marketing strategies and tools', 5);

INSERT INTO Challenge (ID, ChallengeName, Description, MentorID) VALUES
(1, 'Image Classification', 'The challenge is to develop a deep learning model', 2),
(2, 'Fraud Detection Kaggle', 'Participate in a Kaggle competition', 1),
(3, 'Short Story Writing', 'Writing a compelling short story', 1),
(4, 'Data Prediction', 'Predicting data trends using ML', 2),
(5, 'Recipe Development', 'Creating new and innovative recipes', 5);

INSERT INTO SourceType (ID, SourceName) VALUES
(1, 'Course'),
(2, 'Challenge'),
(3, 'Program');

INSERT INTO Review (SourceID, MenteeID, SourceTypeID, RatingStar, Content) VALUES
(2, 1, 3, 4.5, 'Excellent tool for tracking environmental impact.'),
(2, 2, 3, 4, 'Very helpful for managing patient records.'),
(2, 3, 3, 4.75, 'Great platform for learning new skills.'),
(4, 4, 3, 4.2, 'Useful for financial planning.'),
(5, 5, 3, 4.7, 'Perfect place to showcase handmade products.'),
(1, 1, 2, 4.5, 'Very insightful introduction to quantum computing.'),
(2, 2, 2, 4, 'Comprehensive digital marketing strategies.'),
(1, 3, 2, 4.8, 'Great exercises and peer reviews.'),
(2, 4, 2, 4.2, 'Good coverage of data science techniques.'),
(2, 5, 2, 4.7, 'Excellent culinary skills development.'),
(1, 1, 1, 4.5, 'Challenging yet rewarding.'),
(2, 2, 1, 4, 'Learned a lot about social media marketing.'),
(2, 3, 1, 4.8, 'Fun and engaging short story writing tasks.'),
(1, 4, 1, 4.2, 'Useful for improving data prediction skills.'),
(1, 5, 1, 4.7, 'Inspired me to create new recipes.');

INSERT INTO ProgramSource (ProgramID, SourceID, SourceTypeID, SourceOrder) VALUES
(2, 1, 1, 1),
(2, 2, 1, 3),
(3, 3, 1, 3),
(4, 4, 1, 4),
(5, 5, 1, 5),
(2, 1, 2, 2),
(2, 2, 2, 4),
(3, 3, 2, 8),
(4, 4, 2, 9),
(5, 5, 2, 10);

INSERT INTO ProgramMentor (ProgramID, MentorID) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 6),
(3, 4),
(3, 5);

