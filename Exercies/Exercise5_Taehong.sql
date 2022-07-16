--Working with views - Practice

--1.In T-SQL, create a new VIEW called PersonsByCountry that displays a list of all Persons’ names and the country they live in.
CREATE VIEW vwPersonsByCountry AS 
SELECT pp.FirstName
		, pp.LastName
		, cr.Name 
FROM AdventureWorks.Person.Person pp
INNER JOIN AdventureWorks.Person.BusinessEntity be ON be.BusinessEntityID = pp.BusinessEntityID
INNER JOIN AdventureWorks.Person.BusinessEntityAddress bea  ON bea.BusinessEntityID = be.BusinessEntityID
INNER JOIN AdventureWorks.Person.Address a on a.AddressID = bea.AddressID
INNER JOIN AdventureWorks.Person.StateProvince sp ON sp.StateProvinceID = a.StateProvinceID
INNER JOIN AdventureWorks.Person.CountryRegion cr ON cr.CountryRegionCode = sp.CountryRegionCode;
GO

--2.Write a SELECT query to display all the data from the PersonsByCountry view, sorted by country name, person’s last name, then first name.
SELECT *
FROM vwPersonsByCountry
ORDER BY Name, LastName, FirstName
GO
--3.In the SSMS GUI Editor, create a second VIEW, called PersonAndEmailsByCountry, based on the view from part 1, 
--	that displays all data and includes each person’s email address. Note: This isn’t a copy-paste-SQL job! Reference the other view in the new view, 
--	which may require you to make some changes to the original PersonsByCountry view.

-- DONE in the SSMS GUI Editor

--4.Script your GUI-created VIEW and add the CREATE VIEW part to the T-SQL script you’re writing for the other steps. 
--	(Right-click the PersonAndEmailsByCountry view, choose Script View AS… Create…)
CREATE VIEW dbo.vwPersonAndEmailsByCountry AS
SELECT pp.FirstName, pp.LastName, cr.Name, Person.EmailAddress.EmailAddress
FROM  Person.Person AS pp 
INNER JOIN Person.BusinessEntity AS be ON be.BusinessEntityID = pp.BusinessEntityID 
INNER JOIN Person.BusinessEntityAddress AS bea ON bea.BusinessEntityID = be.BusinessEntityID 
INNER JOIN Person.Address AS a ON a.AddressID = bea.AddressID 
INNER JOIN Person.StateProvince AS sp ON sp.StateProvinceID = a.StateProvinceID 
INNER JOIN Person.CountryRegion AS cr ON cr.CountryRegionCode = sp.CountryRegionCode 
INNER JOIN Person.EmailAddress ON pp.BusinessEntityID = Person.EmailAddress.BusinessEntityID
GO

--5.Write a SELECT query to display data from the PersonAndEmailsByCountry view, for persons residing in the USA, 
--	and whose email addresses start with ‘P’, sorted by person’s last name, then first name, and hiding any non-user-friendly columns of data.
SELECT FirstName, LastName, Name AS 'Country', EmailAddress, PersonType
FROM vwPersonAndEmailsByCountry
WHERE Name = 'United States' AND EmailAddress LIKE 'P%'
ORDER BY LastName, FirstName;
GO

--6.In T-SQL, create a new view called PersonEmployees, based on the view from part 3, 
--	that displays all the person data for anyone who is an employee of the AdventureWorks company, and includes their job title and hire date.
CREATE VIEW vwPersonEmployees AS
SELECT FirstName, LastName, Name AS 'Country', EmailAddress, JobTitle, HireDate
FROM vwPersonAndEmailsByCountry
INNER JOIN HumanResources.Employee ON vwPersonAndEmailsByCountry.BusinessEntityID = HumanResources.Employee.BusinessEntityID

--7.Write a SELECT query to display data from the PersonEmployees view, showing the employee’s full name (in a single field), 
--	their job title, hire date, email address and country, for any employee hired in 2012 or later. Sort the data from most recent hire date, 
--	then by job title, then employee name. (Note: Remember that in AdventureWorks, you have to include the schema in the table name. 
--	The Employee table is in a schema called HumanResources).
SELECT CONCAT(FirstName, ' ', LastName) AS 'Full name', JobTitle, HireDate, EmailAddress, Country
FROM vwPersonEmployees
WHERE YEAR(HireDate) >= 2012
ORDER BY HireDate DESC, JobTitle, 'Full name'


















