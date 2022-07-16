-- Exercise 11 Fraud Ring!
CREATE TABLE FraudCustomer(
	customerID int,
	FirstName varchar(70),
	LastName varchar(70),
	address varchar(200),
	city varchar(60),
	country varchar(100),
	phone nvarchar(24),
	email nvarchar(60));

DECLARE fraud_cursor CURSOR  
	FOR SELECT EmployeeId FROM Employee WHERE LastName = 'Peacock';
OPEN fraud_cursor;  
DECLARE @customerID int, @FirstName varchar, @LastName varchar, @address varchar, @city varchar, @country varchar, @phone nvarchar,
	@email varchar, @employeeID int, @supportID int, @total numeric (10,2), @billingCountry varchar(100)
FETCH NEXT FROM fraud_cursor INTO @employeeID
WHILE @@FETCH_STATUS = 0

BEGIN TRAN
BEGIN TRY
BEGIN
	SELECT @supportID = SupportRepId  FROM Customer
	IF (@supportID =3)
	BEGIN 
		SELECT @total = Total, @billingCountry = BillingCountry FROM Invoice
		IF (@total  > 5.0 AND (@billingCountry = 'France' OR @billingCountry = 'United Kingdom' or @billingCountry = 'Norway'))
		BEGIN
			
		END
	END
	SELECT * FROm Invoice
	FETCH NEXT FROM fraud_cursor INTO @employeeID
	END	--End loop
		IF @@TRANCOUNT > 0
			COMMIT
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE()
	IF @@TRANCOUNT > 0
		ROLLBACK
END CATCH

CLOSE fraud_cursor;  
DEALLOCATE fraud_cursor; 


















































