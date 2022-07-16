

SELECT City, Country FROM Customer WHERE Country = 'USA'
UNION
SELECT City, Country FROM Customer WHERE Country = 'Brazil'

SELECT FirstName COLLATE DATABASE_DEFAULT, 
		LastName COLLATE DATABASE_DEFAULT 
		FROM AdventureWorks.Person.Person
UNION 
SELECT FirstName, LastName FROM Chinook.dbo.Customer;




--1.(Chinook DB) Create a query that lists the id and name of all tracks that have not yet been purchased at least once.  
--				Sort the results by track name in alphabetical order.
SELECT Track.Name, Track.TrackId 
FROM Track
LEFT OUTER JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
WHERE InvoiceLine.TrackId IS NULL
ORDER BY Track.Name ASC;

-- 1 solution
SELECT tra.TrackId, tra.Name
FROM Track tra
	LEFT JOIN InvoiceLine il ON tra.TrackId = il.InvoiceLineId
WHERE il.InvoiceLineId IS NULL
ORDER BY tra.Name;


--2.(Chinook DB) Create a query that lists the id and name of all playlists that do not have any tracks assigned to them. 
--				Alias the columns appropriately.
SELECT *
FROM Playlist
LEFT JOIN PlaylistTrack ON Playlist.PlaylistId = PlaylistTrack.PlaylistId
WHERE PlaylistTrack.PlaylistId IS NULL;

--2 Solution
SELECT pl.PlaylistId, pl.Name AS [Playlists With No Tracks]
FROM Track tra
	INNER JOIN PlayListTrack plt ON plt.TrackId = tra.TrackId
	RIGHT JOIN Playlist pl ON pl.PlaylistId = plt.PlaylistId
WHERE tra.TrackId IS NULL;

--3.(Numbers db) Using the Multiples_Of_Two and Multiples_Of_Three tables, show the results of a query that only displays numbers that 
--				have a matching value in the other table. Here’s the catch: You are not permitted to use a WHERE clause or joins for this query.
SELECT Twos FROM NumberDB.dbo.Multiples_Of_Two
INTERSECT
SELECT Threes FROM NumberDB.dbo.Multiples_Of_Three;

--4.(Chinook db) Create a query to find a list of all employees that have never served as a rep for any customers. Both the employee’s first and 
--				last names should only be displayed in a single field named “Employee Name”, and include the employee’s job title in your results.
SELECT CONCAT(Employee.FirstName, ' ', Employee.LastName) AS "Employee Name", Employee.Title
FROM Employee
LEFT JOIN Customer ON Employee.EmployeeId = Customer.SupportRepId
WHERE Customer.CustomerId IS NULL;

--4 Solution
SELECT emp.FirstName + ' ' + emp.LastName AS [Employee Name]
		, emp.Title 
FROM Employee emp
	LEFT JOIN Customer cus ON cus.SupportRepId = emp.EmployeeId
WHERE cus.CustomerId IS NULL;

--5.(Multiple DBs) Create a query to gather a list of all first & last names and the country of residence of people living in either Canada or France, 
--					from the Customer and Employee tables in Chinook and the Person.Person and Person.CountryRegion tables in AdventureWorks.

SELECT FirstName COLLATE DATABASE_DEFAULT AS 'FirstName', LastName COLLATE DATABASE_DEFAULT AS 'LastName', NULL AS 'Country' FROM AdventureWorks.Person.Person
UNION 
SELECT FirstName, LastName, Country FROM Chinook.dbo.Customer
UNION
SELECT FirstName, LastName, Country FROM Chinook.dbo.Employee
UNION
SELECT NULL, NULL, Name  COLLATE DATABASE_DEFAULT AS 'Country' FROM AdventureWorks.Person.CountryRegion
WHERE 'Country' = 'Canada' OR 'Country' = 'France';

-- 5 Geoff solution
SELECT FirstName COLLATE DATABASE_DEFAULT AS 'First Name'
		, LastName COLLATE DATABASE_DEFAULT AS 'Last Name'
		, Country COLLATE DATABASE_DEFAULT AS 'Country'
FROM Chinook.dbo.Customer 
WHERE Country IN ('Canada', 'France')
UNION
SELECT FirstName
		, LastName
		, Country 
FROM Chinook.dbo.Employee
WHERE Country IN ('Canada', 'France')
UNION
SELECT pp.FirstName
		, pp.LastName
		, cr.Name
FROM AdventureWorks.Person.Person pp
INNER JOIN AdventureWorks.Person.BusinessEntity be ON be.BusinessEntityID = pp.BusinessEntityID
INNER JOIN AdventureWorks.Person.BusinessEntityAddress bea  ON bea.BusinessEntityID = be.BusinessEntityID
INNER JOIN AdventureWorks.Person.Address a on a.AddressID = bea.AddressID
INNER JOIN AdventureWorks.Person.StateProvince sp ON sp.StateProvinceID = a.StateProvinceID
INNER JOIN AdventureWorks.Person.CountryRegion cr ON cr.CountryRegionCode = sp.CountryRegionCode
WHERE cr.Name IN ('Canada', 'France');











