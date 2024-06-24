CREATE TABLE Role (
    ID INT PRIMARY KEY,
    RoleName VARCHAR
);

CREATE TABLE "User" (
    ID INT PRIMARY KEY,
    Name VARCHAR,
    RoleID INT REFERENCES Role(ID)
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
(1, 1, 12, 1, 2),
(2, 1, 15, 2, 1);

