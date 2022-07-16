USE Chinook;

/*BASIC 1*/
SELECT LastName, FirstName, Company
FROM Customer
WHERE Company is not null;

/*BASIC 2*/
SELECT *
FROM Track
WHERE Composer is null;

/*BASIC 3*/
SELECT *
FROM Track
WHERE Name LIKE '%Love%';

/*BASIC 4*/
SELECT *
FROM Track
WHERE Bytes Between 1000000 AND 2000000
ORDER BY Bytes DESC;

/*BASIC 5*/
SELECT CONCAT(FirstName,' ', LastName) Name, Email
FROM customer
WHERE Email LIKE '%ca%';

/*Aggregates 1*/
SELECT CAST(ROUND(AVG(Total),2) AS DEC(3,2)) 'Average amount'
FROM Invoice;

/*Aggregates 1-a*/
SELECT CustomerId, CAST(ROUND(AVG(Total),2) AS DEC(3,2)) 'Average amount'
FROM Invoice
GROUP BY CustomerId;

/*Aggregates 1-b*/
SELECT CustomerId, CAST(ROUND(AVG(Total),2) AS DEC(3,2)) 'Average amount'
FROM Invoice
WHERE 'Average amount' > 6
GROUP BY CustomerId
ORDER By avg(Total) DESC;

/*Aggregates 2*/
SELECT count(TrackId) 'Total track'
FROM Track;

/*Aggregates 2-a*/
SELECT AlbumId, count(TrackId) 'Total track'
FROM Track
GROUP BY AlbumId;

/*Aggregates 2-b*/
SELECT Composer, count(TrackId) 'Total track'
FROM Track
GROUP BY Composer;

/*Aggregates 2-c*/
SELECT Composer, max(TrackId) 'Total track'
FROM Track
GROUP BY Composer
ORDER BY 'Total track' DESC
;

/*Inner Joins 1*/
SELECT Track.Name 'Track Name', Genre.Name 'Genre Name', MediaType.Name 'MediaType Name'
FROM track
INNER JOIN MediaType ON MediaType.MediaTypeId = Track.TrackId
INNER JOIN Genre ON .Genre.GenreId = TrackId;

/*Inner Joins 2*/
SELECT FirstName, LastName, Track.Name 'Track Name that each customer have purchased', InvoiceDate 'The date the track was purchased on'
FROM Customer
INNER JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
INNER JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
INNER JOIN Track ON Track.TrackId = InvoiceLine.TrackId
ORDER BY LastName, FirstName, Track.Name;

/*Inner Joins 3*/
SELECT Track.Name 'Track name', Album.Title 'The name of album', Artist.Name 'Artist name'
FROM Track
INNER JOIN Album ON Album.AlbumId = Track.AlbumId
INNER JOIN Artist ON Artist.ArtistId = Album.ArtistId;









