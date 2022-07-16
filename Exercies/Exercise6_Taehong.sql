BEGIN TRANSACTION
INSERT INTO Employee (FirstName, LastName)
VALUES ('Taehong', 'Min'),
		('Nat', 'Yay'),
		('Kat', 'Helo');
COMMIT

BEGIN TRANSACTION
INSERT INTO PhoneNumber(PhoneNumber, PhoneType, EmployeeID)
VALUES (01050093439, 'iPhone', 5), 
		(01023404039, 'iPhone', 6),
		(01050080972, 'iPhone', 3);
COMMIT

BEGIN TRANSACTION
DELETE FROM Employee WHERE FirstName = 'Taehong';
COMMIT

BEGIN TRANSACTION
DELETE FROM PhoneNumber WHERE PhoneID = 2;
DELETE FROM Employee WHERE EmployeeID = 5;
SAVE TRANSACTION Save1;
DELETE FROM PhoneNumber WHERE PhoneID = 11;
DELETE FROM Employee WHERE EmployeeID = 3;
ROLLBACK




















