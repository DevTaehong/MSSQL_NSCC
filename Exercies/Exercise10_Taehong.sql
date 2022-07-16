CREATE OR ALTER TRIGGER trgGenre_AfterInsert
ON Genre
FOR INSERT
AS
BEGIN
	DECLARE @recordId INT
	INSERT INTO RecordLogging (ActionType, IsError, LogDate)
						VALUES ('INSERT', 0, GetDate())
	SET @recordId = SCOPE_IDENTITY()
	EXEC uspAddRecordLog 'Genre', @recordId, 'INSERT', 0, 0;
END
GO

CREATE OR ALTER TRIGGER trgInvoiceLine_AfterDelete
ON InvoiceLine
FOR DELETE
AS
BEGIN
	INSERT INTO RecordLogging (ActionType, IsError, LogDate)
						VALUES ('DELETE', 0, GetDate())
END
GO

CREATE OR ALTER TRIGGER trgMediaType
ON MediaType
FOR INSERT, DELETE, UPDATE
AS
BEGIN
	DECLARE @InsertedId int, @DeletedId int

	SELECT @InsertedId = MediaTypeId FROM inserted
	IF (@InsertedId > 0)
		BEGIN
			INSERT INTO RecordLogging (ActionType, IsError, LogDate)
								VALUES ('INSERT', 0, GetDate())
		END
	
	SELECT @DeletedId = MediaTypeId FROM deleted
	IF (@DeletedId > 0)
		BEGIN
			INSERT INTO RecordLogging (ActionType, IsError, LogDate)
								VALUES ('DELETE', 0, GetDate())
		END
END
GO

--TEST
INSERT INTO Genre VALUES ('Taehong2') ;
DELETE FROM InvoiceLine WHERE InvoiceLineId = 123123;

INSERT INTO MediaType VALUES ('Taehong') ;
DELETE FROM MediaType WHERE Name = 'Taehong';

SELECT * FROM Genre
SELECT * FROM RecordLogging







