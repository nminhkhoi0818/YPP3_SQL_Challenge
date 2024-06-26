CREATE TABLE Role (
    ID INT PRIMARY KEY,
    RoleName VARCHAR
);

CREATE TABLE Category (
    ID SERIAL PRIMARY KEY,
    CategoryName VARCHAR
);

CREATE TABLE Tag (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR
);

CREATE TABLE "Users" (
    ID INT PRIMARY KEY,
    Name VARCHAR,
    RoleID INT REFERENCES Role(ID)
);

CREATE TABLE SourceType (
    ID INT PRIMARY KEY,
    SourceName VARCHAR
);

CREATE TABLE EventType (
    ID INT PRIMARY KEY,
    TypeName VARCHAR
);

CREATE TABLE Program (
    ID INT PRIMARY KEY,
    MentorID INT REFERENCES "Users"(ID),
    Name VARCHAR,
    Description VARCHAR,
    Price FLOAT,
    CategoryID INT REFERENCES Category(ID)
);

CREATE TABLE Review (
    SourceID INT,
    MenteeID INT REFERENCES "Users"(ID),
    SourceTypeID INT REFERENCES SourceType(ID),
    RatingStar FLOAT,
    Content VARCHAR,
    PRIMARY KEY (SourceID, MenteeID, SourceTypeID)
);

CREATE TABLE ProgramUser (
    ProgramID INT REFERENCES Program(ID),
    UserID INT REFERENCES "Users"(ID),
    ProgressPercent FLOAT,
    Status VARCHAR(50),
    PRIMARY KEY (ProgramID, UserID)
);


CREATE TABLE SourceTag (
    SourceID INT,
    TagID INT REFERENCES Tag(ID),
    SourceTypeID INT REFERENCES SourceType(ID),
    PRIMARY KEY (SourceID, TagID, SourceTypeID)
);

CREATE TABLE EventLog (
    ID INT PRIMARY KEY,
    UserID INT REFERENCES "Users"(ID),
    SourceID INT,
    SourceTypeID INT REFERENCES SourceType(ID),
    EventTypeID INT REFERENCES EventType(ID),
    EventTime TIMESTAMP
);

CREATE TABLE AdsProgram (
    ProgramID INT REFERENCES Program(ID),
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    PRIMARY KEY (ProgramID, StartDate, EndDate)
);

-- Insert data into Role table
INSERT INTO Role (ID, RoleName) VALUES
(1, 'Admin'),
(2, 'Mentor'),
(3, 'Mentee');

-- Insert data into Users table
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

-- Insert data into Category table
INSERT INTO Category (ID, CategoryName) VALUES
(1, 'Information Technology'),
(2, 'UI/UX Design'),
(3, 'Marketing'),
(4, 'Lifestyle'),
(5, 'Photography'),
(6, 'Video');

-- Insert data into Program table
INSERT INTO Program (ID, MentorID, Name, Description, Price, CategoryID) VALUES
(1, 5, 'Software Engineering Fundamentals', 'Essential software engineering concepts', 33.99, 1),
(2, 6, 'Data Science', 'Data analysis and machine learning mastery', 12.99, 1),
(3, 5, 'Web Development Mastery', 'Interactive e-learning platform', 17.77, 1),
(4, 6, 'Mentoring Hub', 'Personalized professional growth through mentorship', 19.99, 3),
(5, 5, 'Digital Marketing Bootcamp', 'Comprehensive training in digital marketing strategies and tools', 99.99, 2);

-- Insert data into SourceType table
INSERT INTO SourceType (ID, SourceName) VALUES
(1, 'Course'),
(2, 'Challenge'),
(3, 'Program');

-- Insert data into Review table
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

-- Insert data into ProgramUser table
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

-- Insert data into EventType table
INSERT INTO EventType (ID, TypeName) VALUES
(1, 'Page View'),
(2, 'Add to Cart'),
(3, 'Purchase'),
(4, 'Ad Impression'),
(5, 'Ad Click'),
(6, 'View Category');

-- Insert data into EventLog table
INSERT INTO EventLog (ID, UserID, SourceID, SourceTypeID, EventTypeID, EventTime) VALUES
(1, 1, 1, 3, 1, '2024-03-02 00:00:00'),
(2, 1, 1, 1, 2, '2024-03-03 00:00:00'),
(3, 1, 2, 2, 3, '2024-03-04 00:00:00'),
(4, 1, 2, 3, 4, '2024-03-05 00:00:00'),
(5, 1, 2, 1, 5, '2024-03-06 00:00:00');

-- Insert data into AdsProgram table
INSERT INTO AdsProgram (ProgramID, StartDate, EndDate) VALUES
(1, '2024-06-01 00:00:00', '2024-06-30 00:00:00'),
(3, '2024-07-01 00:00:00', '2024-07-15 00:00:00'),
(5, '2024-06-15 00:00:00', '2024-07-15 00:00:00');

-- Insert data into Tag table
INSERT INTO Tag (ID, Name) VALUES
(1, 'Beginner Level'),
(2, 'Personal Growth'),
(3, 'Networking'),
(4, 'News'),
(5, 'Coding');

-- Insert data into SourceTag table
INSERT INTO SourceTag (SourceID, TagID, SourceTypeID) VALUES
(1, 4, 2),
(1, 1, 1),
(2, 2, 3),
(2, 1, 3);
