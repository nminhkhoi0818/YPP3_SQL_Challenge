-- Get order 1
SELECT
	o.ID AS order_id,
	up.CardNumber AS user_card_number,
	pm.method AS user_card_method
FROM
	"Order" o
    JOIN UserPayment up ON o.UserPaymentID = up.ID
    JOIN PaymentMethod pm ON up.PaymentMethodID = pm.ID
WHERE 
	o.ID = 1;

-- Get order details of order 1
SELECT
	p.ProgramName AS program_name,
    p.Price AS program_price,
    u.Name AS mentor_name
FROM 
	"Order" o
    JOIN OrderDetails od ON o.ID = od.OrderID
    JOIN Program p ON p.ID = od.SourceID AND od.SourceTypeID = 3
    JOIN "User" u ON u.ID = p.MentorID
WHERE
	o.ID = 1;
    
SELECT
	c.CourseName course_name,
    c.Price AS course_price,
    u.Name AS mentor_name
FROM 
	"Order" o
    JOIN OrderDetails od ON o.ID = od.OrderID
    JOIN Course c ON c.ID = od.SourceID AND od.SourceTypeID = 1
    JOIN "User" u ON u.ID = c.MentorID
WHERE
	o.ID = 1
    
