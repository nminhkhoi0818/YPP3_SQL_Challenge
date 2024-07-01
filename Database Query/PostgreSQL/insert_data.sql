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

CREATE TABLE Tag (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR
);

CREATE TABLE SourceType (
    ID INT PRIMARY KEY,
    SourceName VARCHAR
);

CREATE TABLE SourceTag (
    SourceID INT,
    TagID INT REFERENCES Tag(ID),
    SourceTypeID INT REFERENCES SourceType(ID),
    PRIMARY KEY (SourceID, TagID, SourceTypeID)
);

CREATE TABLE EventType (
    ID INT PRIMARY KEY,
    TypeName VARCHAR
);

CREATE TABLE Program (
    ID INT PRIMARY KEY,
    MentorID INT REFERENCES "User"(ID),
    Name VARCHAR,
    Description VARCHAR,
    Price FLOAT,
    CategoryID INT REFERENCES Category(ID)
);

CREATE TABLE ProgramUser (
    ProgramID INT REFERENCES Program(ID),
    UserID INT REFERENCES "User"(ID),
    ProgressPercent FLOAT,
    Status VARCHAR(50),
    PRIMARY KEY (ProgramID, UserID)
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

CREATE TABLE Course (
    ID SERIAL PRIMARY KEY,
    CourseName VARCHAR,
    Description VARCHAR,
    MentorID INT REFERENCES "User"(ID)
);

CREATE TABLE Review (
    SourceID INT,
    MenteeID INT REFERENCES "User"(ID),
    SourceTypeID INT REFERENCES SourceType(ID),
    RatingStar FLOAT,
    Content VARCHAR,
    PRIMARY KEY (SourceID, MenteeID, SourceTypeID)
);

CREATE TABLE EventLog (
    ID INT PRIMARY KEY,
    UserID INT REFERENCES "User"(ID),
    SourceID INT,
    SourceTypeID INT REFERENCES SourceType(ID),
    EventTypeID INT REFERENCES EventType(ID),
    EventTime TIMESTAMP,
  	Duration INT
);

CREATE TABLE AdsProgram (
    ProgramID INT REFERENCES Program(ID),
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    PRIMARY KEY (ProgramID, StartDate, EndDate)
);

CREATE TABLE PaymentMethod (
    ID INT PRIMARY KEY,
    Method VARCHAR
);

CREATE TABLE Voucher (
    ID INT PRIMARY KEY,
    Code VARCHAR,
    Discount FLOAT
);

CREATE TABLE UserPayment (
    ID INT PRIMARY KEY,
    UserID INT REFERENCES "User"(ID),
    CardName VARCHAR,
    CardNumber VARCHAR,
    ExpireDate TIMESTAMP,
    PaymentMethodID INT REFERENCES PaymentMethod(ID)
);

CREATE TABLE "Order" (
    ID INT PRIMARY KEY,
    UserID INT REFERENCES "User"(ID),
    UserPaymentID INT REFERENCES UserPayment(ID),
    VoucherID INT REFERENCES Voucher(ID),
    Status VARCHAR,
    CreateAt TIMESTAMP
);

CREATE TABLE OrderDetails (
    ID INT PRIMARY KEY,
    OrderID INT REFERENCES "Order"(ID),
    Price FLOAT,
    SourceID INT,
    SourceTypeID INT REFERENCES SourceType(ID)
);

INSERT INTO Role (ID, RoleName) VALUES
(1, 'Admin'),
(2, 'Mentor'),
(3, 'Mentee');

INSERT INTO "User" (ID, Name, RoleID) VALUES
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
(1, 5, 'Software Engineering Fundamentals', 'Essential software engineering concepts', 33.99, 1),
(2, 6, 'Data Science', 'Data analysis and machine learning mastery', 12.99, 1),
(3, 5, 'Web Development Mastery', 'Interactive e-learning platform', 17.77, 1),
(4, 6, 'Mentoring Hub', 'Personalized professional growth through mentorship', 19.99, 3),
(5, 5, 'Digital Marketing Bootcamp', 'Comprehensive training in digital marketing strategies and tools', 99.99, 2);

INSERT INTO Course (ID, CourseName, Description, MentorID) VALUES
(1, 'Grow Your Video Editing Skills from Experts', 'Essential software engineering concepts', 1),
(2, 'Easy and Creative Food Art Ideas Decoration', 'Data analysis and machine learning mastery', 2),
(3, 'Create Your Own Sustainable Fashion Style', 'Interactive e-learning platform', 3),
(4, 'Grow Your Skills Fashion Marketing', 'Personalized professional growth through mentorship', 4),
(5, 'UI Design, a User-Centered Approach', 'Comprehensive training in digital marketing strategies and tools', 5);

INSERT INTO Challenge (ID, CategoryID, ChallengeName, Description, Location, Phase, StartDate) VALUES
(1, 1, 'Image Classification', 'The challenge is to develop a deep learning model', 'Remote', 'Starting Phase', '2024-06-26'),
(2, 1, 'Fraud Detection Kaggle', 'Participate in a Kaggle competition', 'HCM', 'Starting Phase', '2024-06-27'),
(3, 5, 'Short Story Writing', 'Writing a compelling short story', 'Remote', 'Starting Phase', '2024-06-23'),
(4, 1, 'Data Prediction', 'Predicting data trends using ML', 'Remote', 'Ending Phase', '2024-06-27'),
(5, 5, 'Recipe Development', 'Creating new and innovative recipes', 'Remote', 'Ending Phase', '2024-06-23');

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

INSERT INTO ChallengeUser (ChallengeID, UserID, Score, Status, DateSubmission) VALUES
(1, 1, 8, 'Passed', '2024-06-10'),
(2, 1, 6, 'Passed', '2024-05-08'),
(3, 2, 7, 'Passed', '2024-01-23'),
(4, 2, 3, 'Failed', '2024-02-04'),
(5, 3, 5, 'Passed', '2024-08-14'),
(3, 3, 4, 'Failed', '2024-12-17');

INSERT INTO EventType (ID, TypeName) VALUES
(1, 'Page View'),
(2, 'Add to Cart'),
(3, 'Purchase'),
(4, 'Ad Impression'),
(5, 'Ad Click'),
(6, 'View Category');

INSERT INTO EventLog (ID, UserID, SourceID, SourceTypeID, EventTypeID, EventTime, Duration) VALUES
(1, 1, 1, 3, 1, '2024-03-02 00:00:00', 20),
(2, 2, 1, 1, 2, '2024-03-03 00:00:00', 15),
(3, 1, 2, 2, 3, '2024-04-04 00:00:00', 18),
(4, 2, 2, 3, 4, '2024-05-05 00:00:00', 3),
(5, 3, 2, 1, 5, '2024-06-06 00:00:00', 7);

INSERT INTO AdsProgram (ProgramID, StartDate, EndDate) VALUES
(1, '2024-06-01 00:00:00', '2024-06-30 00:00:00'),
(3, '2024-07-01 00:00:00', '2024-07-15 00:00:00'),
(5, '2024-06-15 00:00:00', '2024-07-15 00:00:00');

INSERT INTO Tag (ID, Name) VALUES
(1, 'Beginner Level'),
(2, 'Personal Growth'),
(3, 'Networking'),
(4, 'News'),
(5, 'Coding');

INSERT INTO SourceTag (SourceID, TagID, SourceTypeID) VALUES
(1, 4, 2),
(1, 1, 1),
(2, 2, 3),
(2, 1, 3);

INSERT INTO PaymentMethod (ID, Method) VALUES
(1, 'Visa'),
(2, 'Credit / Debit Card');

INSERT INTO Voucher (ID, Code, Discount) VALUES
(1, 'ABC', 15),
(2, 'DEF', 20);

INSERT INTO UserPayment (ID, UserID, CardName, CardNumber, ExpireDate, PaymentMethodID) VALUES
(1, 1, 'Mente2121', '****1234', '2024-06-10', 1),
(2, 1, 'Mente2121', '****3232', '2024-06-10', 2);

INSERT INTO "Order" (ID, UserID, UserPaymentID, VoucherID, Status, CreateAt) VALUES
(1, 1, 1, 1, 'Success', '2024-06-10 13:36:00'),
(2, 2, 2, NULL, 'Fail', '2024-06-10 13:40:00');

INSERT INTO OrderDetails (ID, OrderID, Price, SourceID, SourceTypeID) VALUES
(1, 1, 12, 1, 1),
(2, 1, 15, 2, 1),
(3, 1, 12, 1, 3);