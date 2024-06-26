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
    ID INT PRIMARY KEY,
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
  	Price FLOAT,
    MentorID INT REFERENCES "User"(ID)
);

CREATE TABLE SourceType (
    ID INT PRIMARY KEY,
    SourceName VARCHAR
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

INSERT INTO Course (ID, CourseName, Description, Price, MentorID) VALUES
(1, 'Grow Your Video Editing Skills from Experts', 'Essential software engineering concepts', 12.99, 1),
(2, 'Easy and Creative Food Art Ideas Decoration', 'Data analysis and machine learning mastery', 11.99, 2),
(3, 'Create Your Own Sustainable Fashion Style', 'Interactive e-learning platform', 5.99, 3),
(4, 'Grow Your Skills Fashion Marketing', 'Personalized professional growth through mentorship', 6.88, 4),
(5, 'UI Design, a User-Centered Approach', 'Comprehensive training in digital marketing strategies and tools', 3.99, 5);

INSERT INTO SourceType (ID, SourceName) VALUES
(1, 'Course'),
(2, 'Challenge'),
(3, 'Program');

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
