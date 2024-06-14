-- Get program in order 1
SELECT
	p.Name AS program_name,
    p.Price AS program_price
FROM 
	OrderProgram o
    INNER JOIN OrderProgramItems opi ON o.ID = opi.OrderProgramID
	INNER JOIN Program p ON p.ID = opi.ProgramID
WHERE
	o.ID = 1
;

-- Check if voucher valid


-- SELECT 
-- 	o.
-- FROM 
-- 	OrderProgram o
--     INNER JOIN Voucher v ON o.VoucherID = v.ID
