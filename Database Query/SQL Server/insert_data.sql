CREATE TABLE [role] (
    id INT PRIMARY KEY,
    role_name VARCHAR(255)
);

CREATE TABLE [user] (
    id INT PRIMARY KEY,
    full_name VARCHAR(255),
    role_id INT FOREIGN KEY REFERENCES [role](id)
);

CREATE TABLE category (
    id INT PRIMARY KEY,
    category_name VARCHAR(255)
);

CREATE TABLE source_type (
    id INT PRIMARY KEY,
    source_type_name VARCHAR(255)
);

CREATE TABLE event_type (
    id INT PRIMARY KEY,
    event_type_name VARCHAR(255)
);

CREATE TABLE program (
    id INT PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES [user](id),
    program_name VARCHAR(255),
    description VARCHAR(255),
    price FLOAT,
    category_id INT FOREIGN KEY REFERENCES category(id)
);

CREATE TABLE program_user (
    program_id INT FOREIGN KEY REFERENCES program(id),
    user_id INT FOREIGN KEY REFERENCES [user](id),
    progress_percent FLOAT,
    status VARCHAR(50),
    PRIMARY KEY (program_id, user_id)
);

CREATE TABLE program_source (
    program_id INT FOREIGN KEY REFERENCES program(id),
    source_id INT,
    source_type_id INT FOREIGN KEY REFERENCES source_type(id),
    source_order INT,
    PRIMARY KEY (program_id, source_id, source_type_id)
);

CREATE TABLE program_mentor (
    program_id INT FOREIGN KEY REFERENCES program(id),
    user_id INT FOREIGN KEY REFERENCES [user](id),
    PRIMARY KEY (program_id, user_id)
);

CREATE TABLE challenge (
    id INT PRIMARY KEY,
    category_id INT FOREIGN KEY REFERENCES category(id),
    challenge_name VARCHAR(255),
    description VARCHAR(255),
    location VARCHAR(255),
    phase VARCHAR(255),
    start_date DATETIME
);

CREATE TABLE challenge_user (
    challenge_id INT FOREIGN KEY REFERENCES challenge(id),
    user_id INT FOREIGN KEY REFERENCES [user](id),
    score FLOAT,
    status VARCHAR(255),
    date_submission DATETIME
);

CREATE TABLE course (
    id INT PRIMARY KEY,
    course_name VARCHAR(255),
    description VARCHAR(255),
    price FLOAT,
    user_id INT FOREIGN KEY REFERENCES [user](id)
);

CREATE TABLE review (
    source_id INT,
    user_id INT FOREIGN KEY REFERENCES [user](id),
    source_type_id INT FOREIGN KEY REFERENCES source_type(id),
    rating_star FLOAT,
    content VARCHAR(255),
    PRIMARY KEY (source_id, user_id, source_type_id)
);

CREATE TABLE event_log (
    id INT PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES [user](id),
    source_id INT,
    source_type_id INT FOREIGN KEY REFERENCES source_type(id),
    event_type_id INT FOREIGN KEY REFERENCES event_type(id),
    event_time DATETIME,
    duration INT
);

CREATE TABLE ads_program (
    program_id INT FOREIGN KEY REFERENCES program(id),
    start_date DATETIME,
    end_date DATETIME,
    PRIMARY KEY (program_id, start_date, end_date)
);

CREATE TABLE payment_method (
    id INT PRIMARY KEY,
    method VARCHAR(255)
);

CREATE TABLE voucher (
    id INT PRIMARY KEY,
    code VARCHAR(255),
    discount FLOAT
);

CREATE TABLE user_payment (
    id INT PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES [user](id),
    card_name VARCHAR(255),
    card_number VARCHAR(255),
    expire_date DATETIME,
    payment_method_id INT FOREIGN KEY REFERENCES payment_method(id)
);

CREATE TABLE [order] (
    id INT PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES [user](id),
    user_payment_id INT FOREIGN KEY REFERENCES user_payment(id),
    voucher_id INT FOREIGN KEY REFERENCES voucher(id),
    status VARCHAR(255),
    created_at DATETIME
);

CREATE TABLE order_details (
    id INT PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES [order](id),
    price FLOAT,
    source_id INT,
    source_type_id INT FOREIGN KEY REFERENCES source_type(id)
);

INSERT INTO role (id, role_name) VALUES
(1, 'Admin'),
(2, 'Mentor'),
(3, 'Mentee');

INSERT INTO [user] (id, full_name, role_id) VALUES
(1, 'Alice', 3),
(2, 'Bob', 3),
(3, 'Charlie', 3),
(4, 'David', 3),
(5, 'Eve', 2),
(6, 'Frank', 2),
(7, 'Grace', 3),
(8, 'Heidi', 3),
(9, 'Ivan', 3);

INSERT INTO category (id, category_name) VALUES
(1, 'Information Technology'),
(2, 'UI/UX Design'),
(3, 'Marketing'),
(4, 'Lifestyle'),
(5, 'Photography'),
(6, 'Video');

INSERT INTO program (id, user_id, program_name, description, price, category_id) VALUES
(1, 5, 'Software Engineering Fundamentals', 'Essential software engineering concepts', 33.99, 1),
(2, 6, 'Data Science', 'Data analysis and machine learning mastery', 12.99, 1),
(3, 5, 'Web Development Mastery', 'Interactive e-learning platform', 17.77, 1),
(4, 6, 'Mentoring Hub', 'Personalized professional growth through mentorship', 19.99, 3),
(5, 5, 'Digital Marketing Bootcamp', 'Comprehensive training in digital marketing strategies and tools', 99.99, 2);

INSERT INTO course (id, course_name, description, price, user_id) VALUES
(1, 'Grow Your Video Editing Skills from Experts', 'Essential software engineering concepts', 7.99, 1),
(2, 'Easy and Creative Food Art Ideas Decoration', 'Data analysis and machine learning mastery', 5.99, 2),
(3, 'Create Your Own Sustainable Fashion Style', 'Interactive e-learning platform', 6.29, 3),
(4, 'Grow Your Skills Fashion Marketing', 'Personalized professional growth through mentorship', 5.99, 4),
(5, 'UI Design, a User-Centered Approach', 'Comprehensive training in digital marketing strategies and tools', 6.39, 5);

INSERT INTO challenge (id, category_id, challenge_name, description, location, phase, start_date) VALUES
(1, 1, 'Image Classification', 'The challenge is to develop a deep learning model', 'Remote', 'Starting Phase', '2024-06-26'),
(2, 1, 'Fraud Detection Kaggle', 'Participate in a Kaggle competition', 'HCM', 'Starting Phase', '2024-06-27'),
(3, 5, 'Short Story Writing', 'Writing a compelling short story', 'Remote', 'Starting Phase', '2024-06-23'),
(4, 1, 'Data Prediction', 'Predicting data trends using ML', 'Remote', 'Ending Phase', '2024-06-27'),
(5, 5, 'Recipe Development', 'Creating new and innovative recipes', 'Remote', 'Ending Phase', '2024-06-23');

INSERT INTO source_type (id, source_type_name) VALUES
(1, 'Course'),
(2, 'Challenge'),
(3, 'Program');

INSERT INTO review (source_id, user_id, source_type_id, rating_star, content) VALUES
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

INSERT INTO program_source (program_id, source_id, source_type_id, source_order) VALUES
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

INSERT INTO program_mentor (program_id, user_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 6),
(3, 4),
(3, 5);

INSERT INTO program_user (program_id, user_id, progress_percent, status) VALUES
(1, 1, 50, 'In Progress'),
(2, 2, 30, 'In Progress'),
(3, 3, 80, 'Completed'),
(2, 1, 69, 'In Progress'),
(4, 2, 61, 'In Progress'),
(4, 3, 99, 'Completed'),
(5, 6, 81, 'Completed'),
(5, 7, 72, 'In Progress'),
(1, 9, 85, 'Completed');

INSERT INTO challenge_user (challenge_id, user_id, score, status, date_submission) VALUES
(1, 1, 8, 'Passed', '2024-06-10'),
(2, 1, 6, 'Passed', '2024-05-08'),
(3, 2, 7, 'Passed', '2024-01-23'),
(4, 2, 3, 'Failed', '2024-02-04'),
(5, 3, 5, 'Passed', '2024-08-14'),
(3, 3, 4, 'Failed', '2024-12-17');

INSERT INTO event_type (id, event_type_name) VALUES
(1, 'Page View'),
(2, 'Add to Cart'),
(3, 'Purchase'),
(4, 'Ad Impression'),
(5, 'Ad Click'),
(6, 'View Category');

INSERT INTO event_log (id, user_id, source_id, source_type_id, event_type_id, event_time, duration) VALUES
(1, 1, 1, 3, 1, '2024-03-02 00:00:00', 20),
(2, 2, 1, 1, 2, '2024-03-03 00:00:00', 15),
(3, 1, 2, 2, 3, '2024-04-04 00:00:00', 18),
(4, 2, 2, 3, 4, '2024-05-05 00:00:00', 3),
(5, 3, 2, 1, 5, '2024-06-06 00:00:00', 7);

INSERT INTO ads_program (program_id, start_date, end_date) VALUES
(1, '2024-06-01 00:00:00', '2024-06-30 00:00:00'),
(3, '2024-07-01 00:00:00', '2024-07-15 00:00:00'),
(5, '2024-06-15 00:00:00', '2024-07-15 00:00:00');

INSERT INTO payment_method (id, method) VALUES
(1, 'Visa'),
(2, 'Credit / Debit Card');

INSERT INTO voucher (id, code, discount) VALUES
(1, 'ABC', 15),
(2, 'DEF', 20);

INSERT INTO user_payment (id, user_id, card_name, card_number, expire_date, payment_method_id) VALUES
(1, 1, 'Mente2121', '****1234', '2024-06-10', 1),
(2, 1, 'Mente2121', '****3232', '2024-06-10', 2);

INSERT INTO [order] (id, user_id, user_payment_id, voucher_id, status, created_at) VALUES
(1, 1, 1, 1, 'Success', '2024-06-10 13:36:00'),
(2, 2, 2, NULL, 'Fail', '2024-06-10 13:40:00');

INSERT INTO order_details (id, order_id, price, source_id, source_type_id) VALUES
(1, 1, 12, 1, 1),
(2, 1, 15, 2, 1),
(3, 1, 12, 1, 3);

CREATE TABLE Setting (
    id INT PRIMARY KEY,
    setting_type VARCHAR(255),
    setting_name VARCHAR(255),
    setting_value INT
);

INSERT INTO Setting (id, setting_type, setting_name, setting_value) VALUES
(1, 'SourceType', 'course', 1),
(2, 'SourceType', 'challenge', 2),
(3, 'SourceType', 'program', 3),
(4, 'Role', 'Mentee', 1),
(5, 'Role', 'Mentor', 2),
(6, 'Role', 'Admin', 3);
