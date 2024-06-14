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
    Price NUMERIC(10, 2)
);

CREATE TABLE Voucher (
    ID SERIAL PRIMARY KEY,
    VoucherCode VARCHAR NOT NULL,
    PercentageDiscount FLOAT NOT NULL,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP NOT NULL
);

CREATE TABLE PaymentMethod (
    ID SERIAL PRIMARY KEY,
    Name VARCHAR NOT NULL
);

CREATE TABLE OrderProgram (
    ID SERIAL PRIMARY KEY,
    MenteeID INT REFERENCES Mentee(ID),
  	Total DECIMAL,
    VoucherID INT REFERENCES Voucher(ID)
);

CREATE TABLE Payment (
    ID SERIAL PRIMARY KEY,
    OrderProgramID INT REFERENCES OrderProgram(ID),
    PaymentMethodID INT REFERENCES PaymentMethod(ID)
);

CREATE TABLE OrderProgramItems (
    ID SERIAL PRIMARY KEY,
    OrderProgramID INT REFERENCES OrderProgram(ID),
    ProgramID INT REFERENCES Program(ID)
);

CREATE TABLE ProgramMentor (
    ID SERIAL PRIMARY KEY,
    ProgramID INT REFERENCES Program(ID),
    MentorID INT REFERENCES Mentor(ID)
);


INSERT INTO Mentor (Name) VALUES
('Alice Johnson'),
('Bob Smith'),
('Charlie Davis'),
('Diana Garcia'),
('Evan Martinez');

INSERT INTO Program (MentorID, Name, Description, Price) VALUES
(1, 'Software Engineering Fundamentals', 'Essential software engineering concepts', 33.99),
(2, 'Data Science', 'Data analysis and machine learning mastery', 12.99),
(3, 'Web Development Mastery', 'Interactive e-learning platform', 17.77),
(4, 'Mentoring Hub', 'Personalized professional growth through mentorship', 19.99),
(5, 'Digital Marketing Bootcamp', 'Comprehensive training in digital marketing strategies and tools', 99.99);

INSERT INTO Mentee (Name) VALUES
('Fiona Brown'),
('George Clark'),
('Hannah Evans'),
('Ian Foster'),
('Julia Green');

INSERT INTO PaymentMethod (Name) VALUES
('Credit Card'),
('PayPal'),
('Bank Transfer'),
('Cryptocurrency'),
('Cash');

INSERT INTO Voucher (VoucherCode, PercentageDiscount, StartDate, EndDate) VALUES
('DISCOUNT10', 10.0, '2024-01-01 00:00:00', '2024-12-31 23:59:59'),
('DISCOUNT20', 20.0, '2024-01-01 00:00:00', '2024-06-30 23:59:59'),
('SUMMER25', 25.0, '2024-06-01 00:00:00', '2024-08-31 23:59:59'),
('WINTER30', 30.0, '2024-12-01 00:00:00', '2024-12-31 23:59:59'),
('SPRING15', 15.0, '2024-03-01 00:00:00', '2024-05-31 23:59:59');

INSERT INTO OrderProgram (MenteeID, Total, VoucherID) VALUES
(1, 99.99, 1);

INSERT INTO Payment (OrderProgramID, PaymentMethodID) VALUES
(1, 1);

INSERT INTO OrderProgramItems (OrderProgramID, ProgramID) VALUES
(1, 1),
(1, 2);

INSERT INTO ProgramMentor (ID, ProgramID, MentorID) VALUES
(1, 2, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);