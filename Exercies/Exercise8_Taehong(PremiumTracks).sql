DECLARE @Counter int

DECLARE @Rating int
DECLARE @newPrice float

SET @Counter = 1;

DECLARE @HighTrackID varchar(40)
SET @HighTrackID = (SELECT TOP 1 MAX(Milliseconds) 'Highest Milliseconds'
FROM Track 
GROUP BY TrackId
ORDER BY 'Highest Milliseconds' DESC)

WHILE @Counter <= @HighTrackID
	BEGIN TRANSACTION
		BEGIN TRY
			DECLARE @trackLength int
			SELECT @trackLength = COUNT(track.Milliseconds) FROM Track WHERE TrackId = @Counter

			IF @trackLength > 500000
				BEGIN 
					SELECT @Rating = 
		END TRY
		BEGIN CATCH

			IF @@TRANCOUNT>0
				ROLLBACK TRANSACTION;
		END CATCH
	IF @@TRANCOUNT>0
		COMMIT TRANSACTION;







































