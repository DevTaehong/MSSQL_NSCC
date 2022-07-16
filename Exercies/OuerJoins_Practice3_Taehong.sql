/* 1.a*/
INSERT INTO Track (Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, UnitPrice)
VALUES ('Track of Taehong', 2, 3, 1, 'Taehong', 123356, 0.98);

/* 1.b*/
SELECT *
FROM Track
LEFT OUTER JOIN PlaylistTrack ON Track.TrackId = PlaylistTrack.TrackId
WHERE PlaylistTrack.TrackId IS NULL;

/*2*/
SELECT Track.Name, count(InvoiceLine.TrackId) 'The number of times that the track has been included as part of an order'
FROM Track
LEFT OUTER JOIN InvoiceLine ON Track.TrackId = InvoiceLine.InvoiceLineId
WHERE InvoiceLineId IS NOT NULL
GROUP BY Track.TrackId, Track.name;

--2 Geoff Solution
SELECT t.Name, COUNT(il.InvoiceLineID) AS "TimesPurchased"
FROM Track t
LEFT JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY t.Name
HAVING COUNT(il.InvoiceLineId) = 0
ORDER BY "TimesPurchased" DESC;

/*3*/
SELECT Track.TrackId 'TrackIDs that have not yet been purchased', Name 'Track Name'
FROM Track
LEFT OUTER JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
WHERE InvoiceLine.TrackId IS NULL;

--3 Geoff Solution
SELECT t.TrackId, t.Name
FROM InvoiceLine il
RIGHT JOIN Track t ON T.TrackId = il.TrackId
WHERE il.InvoiceLineId IS NULL;

