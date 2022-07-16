--CURSORS – DISCONTINUED ARTISTS

-- 1
DROP TABLE IF EXISTS DiscontinuedArtists
CREATE TABLE DiscontinuedArtists (
	DiscArtistID INT IDENTITY(1,1) PRIMARY KEY, --Indentity is auto-increment
	OriginalArtistID INT NOT NULL,
	ArtistName VARCHAR(120),
	DiscontinuedDate DATETIME NOT NULL);
GO

-- 2
CREATE OR ALTER PROC uspCheckForDiscontinuedArtists
AS
DECLARE a5_cursor CURSOR FOR  --Step 1
	SELECT a.ArtistId, a.Name, Album.Title, t.Name, Composer
	FROM Artist a
	LEFT JOIN Album ON a.ArtistId = Album.ArtistId
	LEFT JOIN Track t ON Album.AlbumId = t.AlbumId;
OPEN a5_cursor;  -- Step 2
DECLARE @ArtistID INT, @ArtistName nvarchar(120), @AlbumTitle nvarchar(160), @TrackName nvarchar(200), @Composer nvarchar(220), @Counter INT
SET @Counter = 1;
PRINT ('Report: ALL Artists By Album and Track');
PRINT ('');
PRINT ('# ID   Artist    Album                                 Track Name                      Composer');
PRINT ('---------------------------------------------------------------------------------------------------------------------------------');
-- Step 3 -- Fetch each record one at a time, and Do something with it
FETCH NEXT FROM a5_cursor INTO @ArtistID, @ArtistName, @AlbumTitle, @TrackName, @Composer --Go get data for first record.
BEGIN TRAN
BEGIN TRY
	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (@AlbumTitle IS NULL)
				PRINT (CAST(@Counter AS NVARCHAR) + ':  ' + CAST(@ArtistID AS NVARCHAR) + ' - ' + @ArtistName + ' - ' + 'NO ALBUMS OR TRACKS');
			ELSE IF (@Composer IS NULL)
				PRINT (CAST(@Counter AS NVARCHAR) + ':  ' + CAST(@ArtistID AS NVARCHAR) + ' - ' + @ArtistName + ' - ' + @AlbumTitle + ' - ' + @TrackName + ' - UNKNOWN COMPOSER');
			ELSE
				PRINT (CAST(@Counter AS NVARCHAR) + ':  ' + CAST(@ArtistID AS NVARCHAR) + ' - ' + @ArtistName + ' - ' + @AlbumTitle + ' - ' + @TrackName + ' - ' + @Composer);
			IF (@AlbumTitle IS NULL)
			BEGIN
				IF NOT EXISTS (SELECT DiscArtistID FROM DiscontinuedArtists WHERE OriginalArtistID = @ArtistID)
				BEGIN
					SET NOCOUNT ON; --suppress record counting messages
					INSERT INTO DiscontinuedArtists (OriginalArtistID, ArtistName, DiscontinuedDate) 
						VALUES (@ArtistID, @ArtistName, GETDATE()); -- GETDATE = auto-date
					DELETE FROM Artist WHERE ArtistId = @ArtistID;
				END
			END
			SET @Counter = @Counter + 1; -- Counting number 
			FETCH NEXT FROM a5_cursor INTO @ArtistID, @ArtistName, @AlbumTitle, @TrackName, @Composer
		END
END TRY	
BEGIN CATCH -- If an error occurs in TRY block
	PRINT ERROR_MESSAGE();
	IF @@TRANCOUNT > 0 
		ROLLBACK TRAN -- When an error occurrs, rollback the tran
END CATCH
IF @@TRANCOUNT > 0
	COMMIT TRAN --When no errors, Commit the tran
CLOSE a5_cursor;  -- Step 4
DEALLOCATE a5_cursor; -- Step 5 
GO

--Testing statements
--1
SELECT a.ArtistId, a.Name AS 'Artist Name', Album.Title AS 'Album Title', t.Name AS 'Track Name', Composer
FROM Artist a
INNER JOIN Album ON a.ArtistId = Album.ArtistId
INNER JOIN Track t ON Album.AlbumId = t.AlbumId;
GO

--2
SELECt * FROM DiscontinuedArtists;
GO

--Test 1
EXEC uspCheckForDiscontinuedArtists;
SELECT * FROM DiscontinuedArtists;
SELECT * FROM Artist a
LEFT JOIN Album ON a.ArtistId = Album.ArtistId
LEFT JOIN Track t ON Album.AlbumId = t.AlbumId;
GO

--Test 2
INSERT INTO Artist VALUES('Test1');
INSERT INTO Artist VALUES('Test2');
INSERT INTO Artist VALUES('Test3');
INSERT INTO Artist VALUES('Test4');
INSERT INTO Artist VALUES('Test5');
EXEC uspCheckForDiscontinuedArtists;
SELECT * FROM DiscontinuedArtists;
GO

--Clean up statements to remove all test records
DELETE FROM DiscontinuedArtists WHERE ArtistName = 'Test1';
DELETE FROM DiscontinuedArtists WHERE ArtistName = 'Test2';
DELETE FROM DiscontinuedArtists WHERE ArtistName = 'Test3';
DELETE FROM DiscontinuedArtists WHERE ArtistName = 'Test4';
DELETE FROM DiscontinuedArtists WHERE ArtistName = 'Test5';
GO





































































































