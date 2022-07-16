-- Assignment 4 TRIGGERS – EMPLOYEE COMMISSIONS & CUSTOMER BONUSES

-- 1
DROP TABLE IF EXISTS EmployeeCommission
CREATE TABLE EmployeeCommission (
	CommissionID INT IDENTITY(1,1) PRIMARY KEY, --Indentity is auto-increment 
	EmployeeID INT FOREIGN KEY REFERENCES Employee(EmployeeID) NOT NULL,
	InvoiceID INT NOT NULL,
	CommMonth INT NOT NULL,
	CommYear INT NOT NULL,
	CommAmount numeric(10,2) NOT NULL
);
GO

-- 2
ALTER TABLE Employee
	ADD CommissionAmountToDate numeric(10,2) DEFAULT 0; -- Set this value = 0
GO --Using Go command to separate statements

-- 3
ALTER TABLE Customer
	ADD NumBonusesToDate INT DEFAULT 0;  -- Set this value = 0
GO

-- 4
INSERT INTO Track (Name, MediaTypeId, Milliseconds, UnitPrice) VALUES ('Chinook Bonus Track Voucher', 2, 777777, 2.99);
GO

-- 5
CREATE OR ALTER TRIGGER trgInvoice_AddEmployeeCommission --Making a trigger
ON Invoice
FOR INSERT -- Only for inserting
AS
BEGIN TRAN
	BEGIN TRY
	DECLARE @CustomerID INT, 
			@InvoiceID INT,
			@CommMonth INT,
			@CommYear INT,
			@CommAmount numeric(10,2),
			@EmployeeID INT;
			--@CommAmount is %10 of total
	SELECT @CommAmount =Total*0.1, @CommYear = YEAR(InvoiceDate) ,@CommMonth = MONTH(InvoiceDate) ,@CustomerID = CustomerID, @InvoiceID = InvoiceId
			FROM inserted;	--Get ID and etc. from inserted logical table
	SELECT @EmployeeID = SupportRepId
			FROM Invoice 
			INNER JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
			WHERE InvoiceId = @InvoiceID;
	--Make the EmployeeCommission record
	INSERT INTO EmployeeCommission (EmployeeID, InvoiceID, CommMonth, CommYear, CommAmount)
		VALUES (@EmployeeID, @InvoiceID, @CommMonth, @CommYear, @CommAmount);
	END TRY
	BEGIN CATCH -- If an error occurs in TRY block
		PRINT 'An error occurs';
		IF @@TRANCOUNT > 0 
			ROLLBACK TRAN -- When an error occurrs, rollback the tran
	END CATCH
IF @@TRANCOUNT > 0
	COMMIT TRAN --When no errors, Commit the tran
GO

-- 6
CREATE OR ALTER TRIGGER trgInvoice_DeleteEmployeeCommission
ON Invoice
FOR DELETE -- Only Executing for delete
AS
BEGIN TRAN
	BEGIN TRY
	DECLARE @InvoiceID INT
	SELECT  @InvoiceID = InvoiceId FROM deleted;	--Get ID from deleted logical table
	--delete the EmployeeCommission record
	DELETE EmployeeCommission WHERE InvoiceID = @InvoiceID;
	END TRY
	BEGIN CATCH -- If an error occurs in TRY block
		PRINT 'An error occurs';
		IF @@TRANCOUNT > 0 
			ROLLBACK TRAN -- When an error occurrs, rollback the tran
	END CATCH
IF @@TRANCOUNT > 0
	COMMIT TRAN --When no errors, Commit the tran
GO

-- 7
CREATE OR ALTER TRIGGER trgEmpComm_CreditEmployeeCommToDate
ON EmployeeCommission
FOR INSERT
AS
BEGIN TRAN
	BEGIN TRY
	DECLARE @EmployeeID INT,
			@CommAmount numeric(10,2)
	SELECT @EmployeeID = EmployeeID FROM inserted; 	
	SELECT @CommAmount = SUM(CommAmount) 
	FROM EmployeeCommission 
	WHERE @EmployeeID = EmployeeID 
	GROUP BY EmployeeID;	 
	UPDATE Employee SET CommissionAmountToDate = @CommAmount WHERE EmployeeId = @EmployeeID;
	END TRY
	BEGIN CATCH -- If an error occurs in TRY block
		PRINT 'An error occurs';
		IF @@TRANCOUNT > 0 
			ROLLBACK TRAN -- When an error occurrs, rollback the tran
	END CATCH
IF @@TRANCOUNT > 0
	COMMIT TRAN --When no errors, Commit the tran
GO

-- 8 
CREATE OR ALTER TRIGGER trgEmpComm_DebitEmployeeCommToDate
ON EmployeeCommission
FOR DELETE, UPDATE
AS
BEGIN TRAN
	BEGIN TRY
	DECLARE @EmployeeID INT, @CommAmount numeric(10,2)
	SELECT @EmployeeID = EmployeeID FROM deleted; 
	SELECT @CommAmount = SUM(CommAmount) FROM EmployeeCommission 
	WHERE @EmployeeID = EmployeeID 
	GROUP BY EmployeeID;	 
	UPDATE Employee SET CommissionAmountToDate = @CommAmount WHERE EmployeeId = @EmployeeID;
	END TRY
	BEGIN CATCH -- If an error occurs in TRY block
		PRINT 'An error occurs';
		IF @@TRANCOUNT > 0 
			ROLLBACK TRAN -- When an error occurrs, rollback the tran
	END CATCH
IF @@TRANCOUNT > 0
	COMMIT TRAN --When no errors, Commit the tran
GO

-- 9 
CREATE OR ALTER TRIGGER trgInvoice_AddBonusTrackVoucher
ON Invoice
FOR INSERT
AS
BEGIN TRAN
	BEGIN TRY
		DECLARE @InvoiceID INT, @Total numeric(10,2), @CustomerId INT, @NumBonusesToDate INT, @UnitPrice numeric(10,2),
				@TrackId INT;
		SELECT @InvoiceID = InvoiceId, @Total = Total, @CustomerId = CustomerId FROM inserted;
		SELECT @UnitPrice = UnitPrice FROM Track WHERE TrackId = 3504; -- Track ID hard cord!
		IF (@Total > 20) -- Only when Total is greater than 20
		BEGIN
			INSERT INTO InvoiceLine (InvoiceId, TrackId, UnitPrice, Quantity) VALUES(@InvoiceID, 3504, @UnitPrice, 1);
			SELECT @NumBonusesToDate = SUM(Quantity) FROM Customer
			INNER JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
			INNER JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
			WHERE Invoice.CustomerId = @CustomerId AND InvoiceLine.TrackId = 3504
			GROUP BY TrackId
			UPDATE Customer SET NumBonusesToDate = @NumBonusesToDate WHERE CustomerId = @CustomerId;
		END
	END TRY
	BEGIN CATCH -- If an error occurs in TRY block
		PRINT 'An error occurs';
		IF @@TRANCOUNT > 0 
			ROLLBACK TRAN -- When an error occurrs, rollback the tran
	END CATCH
IF @@TRANCOUNT > 0
	COMMIT TRAN --When no errors, Commit the tran
GO

--Inserts statements
--Testing 5.trgInvoice_AddEmployeeCommission
INSERT INTO Invoice(CustomerId, InvoiceDate, Total) VALUES(1, GETDATE(), 21);
SELECT * FROM EmployeeCommission
--Testing 7.trgEmpComm_CreditEmployeeCommToDate
SELECT * FROM Employee
--Testing 9.trgInvoice_AddBonusTrackVoucher
SELECT * FROM InvoiceLine
SELECT * FROM Customer
GO

--Delete statements
--Testing 6.trgInvoice_DeleteEmployeeCommission
DELETE InvoiceLine WHERE InvoiceId = 463;
DELETE Invoice WHERE InvoiceId = 463;
SELECT * FROM EmployeeCommission
--Testing 8.trgEmpComm_DebitEmployeeCommToDate
SELECT * FROM Employee
GO
