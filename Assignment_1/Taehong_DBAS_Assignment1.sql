--Query 1
SELECT CONCAT(Customer.FirstName,' ', Customer.LastName) AS 'The names of customers', CONCAT(Employee.FirstName,' ', Employee.LastName) AS 'The names of Support rep'
FROM Customer
LEFT JOIN Employee ON Customer.SupportRepId = Employee.EmployeeId
ORDER BY Customer.LastName, Customer.FirstName;

--Query 2
SELECT Track.Name 'Track Name', Genre.Name 'Gnere Name', MediaType.Name 'MediaType Name'
FROM Track
INNER JOIN MediaType ON Track.MediaTypeId = MediaType.MediaTypeId
INNER JOIN Genre ON Track.GenreId = Genre.GenreId
ORDER BY Track.Name;

--Query 3
SELECT Artist.Name AS 'Artist Name', COUNT(Album.ArtistId) AS 'The total number of albums'
FROM Artist
LEFT JOIN Album ON Artist.ArtistId = Album.ArtistId
GROUP BY Artist.Name
ORDER BY 'The total number of albums' DESC;

--Query 4
SELECT DISTINCT Customer.FirstName, Customer.LastName, Mediatype.Name 'Media Type'
FROM Customer
INNER JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
INNER JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
INNER JOIN Track ON Track.TrackId = InvoiceLine.TrackId
INNER JOIN MediaType ON MediaType.MediaTypeId = Track.MediaTypeId;

--Query 5
SELECT TOP 1 c.FirstName, c.LastName, COUNT(Invoice.InvoiceId) AS 'The number of tracks that they have purchased'
FROM Customer c
INNER JOIN Invoice ON C.CustomerId = Invoice.CustomerId
INNER JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
INNER JOIN Track ON Track.TrackId = InvoiceLine.TrackId
INNER JOIN MediaType ON MediaType.MediaTypeId = Track.MediaTypeId
WHERE MediaType.MediaTypeId = 3
GROUP BY c.FirstName, c.LastName
ORDER BY 'The number of tracks that they have purchased' DESC;

--Query 6
SELECT Top 1 Artist.Name, COUNT(InvoiceLine.InvoiceLineId) AS 'The number of orders'
FROM Artist
INNER JOIN Album ON Album.ArtistId = Artist.ArtistId
INNER JOIN Track ON Track.AlbumId = Track.AlbumId
INNER JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Artist.Name
ORDER BY 'The number of orders' DESC;

--Query 7
SELECT Track.TrackId, Track.Name
FROM Track
LEFT JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
WHERE InvoiceLine.TrackId IS NULL;

--Qeury 8
SELECT CONCAT(Fname,' ', Lname) AS 'Author Name'
FROM B_AUTHOR
LEFT JOIN B_BOOKAUTHOR ON B_AUTHOR.AuthorID = B_BOOKAUTHOR.AUTHORid
WHERE B_BOOKAUTHOR.AUTHORid IS NULL
ORDER BY Lname, Fname;

--Query 9
SELECT bc.Customer#, bc.FirstName, bc.LastName
FROM B_CUSTOMERS bc
LEFT JOIN B_ORDERS bo ON bc.Customer# = bo.Customer#
WHERE bo.Customer# IS NULL
ORDER BY bc.LastName, bc.FirstName;

--Query 10
SELECT *
FROM CARS_CAR_TYPES 
CROSS JOIN CARS_COLORS, CARS_NUMBER_OF_DOORS;

--Query 11
SELECT le.EMPLOYEE_ID
		, le.LAST_NAME, le.PHONE_NUMBER
		, le2.LAST_NAME AS 'The name of their manager'
		, le2.PHONE_NUMBER AS 'The phone number of their manager'
FROM L_EMPLOYEES le
LEFT JOIN L_EMPLOYEES le2 ON le.MANAGER_ID = le2.EMPLOYEE_ID
ORDER BY le.EMPLOYEE_ID;

--Query 12
SELECT c.FirstName COLLATE DATABASE_DEFAULT AS 'First Name', c.LastName COLLATE DATABASE_DEFAULT AS 'Last Name'
FROM Chinook.dbo.Customer c
UNION
SELECT ba.Fname, ba.Lname
FROM Bookstore.dbo.B_AUTHOR ba
UNION
SELECT bc.FirstName, bc.LastName
FROM Bookstore.dbo.B_CUSTOMERS bc
UNION
SELECT le.FIRST_NAME, le.LAST_NAME
FROM LunchesDB.dbo.L_EMPLOYEES le
ORDER BY 'Last Name', 'First Name';

--Query 13
SELECT MULTIPLE_OF_2 AS 'Numbers'
FROM NUMBERS_TWOS tw
LEFT JOIN NUMBERS_THREES th ON tw.MULTIPLE_OF_2 = th.MULTIPLE_OF_3
WHERE th.MULTIPLE_OF_3 IS NULL
UNION ALL
SELECT MULTIPLE_OF_3 'Numbers'
FROM NUMBERS_THREES th
LEFT JOIN NUMBERS_TWOS tw ON th.MULTIPLE_OF_3 = tw.MULTIPLE_OF_2
WHERE tw.MULTIPLE_OF_2 IS NULL
ORDER BY 'Numbers';

--Query 14
SELECT MULTIPLE_OF_3 AS 'Numbers that have a matching value'
FROM NUMBERS_THREES
INTERSECT
SELECT MULTIPLE_OF_2
FROM NUMBERS_TWOS;



































