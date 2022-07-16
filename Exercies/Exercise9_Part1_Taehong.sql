-- Exercise
--#1,2
CREATE VIEW vwOrderData
AS
SELECT YEAR(InvoiceDate) AS 'InvoiceYear', BillingState,BillingCountry,Total,Track.Name 'TrackName',Album.Title 'AlbumName',Artist.Name 'ArtistName'
FROM Invoice
INNER JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
INNER JOIN Track ON InvoiceLine.TrackId = Track.TrackId
INNER JOIN Album ON Track.AlbumId = Album.AlbumId
INNER JOIN Artist ON Album.ArtistId = Artist.ArtistId;
GO
--#3
CREATE PROC spOrdersByYear @p_year Numeric(4,0) = NULL
AS
SELECT * FROM vwOrderData
WHERE vwOrderData.InvoiceYear = ISNULL(@p_year, vwOrderData.InvoiceYear);
Go

--#4
EXEC spOrdersByYear;
EXEC spOrdersByYear @p_year = 2010;
GO
--#5
CREATE PROC spOrdersByYear_ValidYear @p_year NUmeric(4,0) = NULL
AS
BEGIN 
	DECLARE @NumResults int;
	SELECT @numResults = COUNT(*) FROM vwOrderData
	WHERE vwOrderData.InvoiceYear = ISNULL(@p_year, InvoiceYear);

	IF @numResults > 0
	BEGIN
		SELECT *
		FROM vwOrderData
		WHERE InvoiceYear = ISNULL(@p_year, InvoiceYear);
	END
	ELSE
	BEGIN
		PRINT 'No records exist for that year'
	END
END
GO

--#6
EXEC spOrdersByYear_ValidYear;
EXEC spOrdersByYear_ValidYear @p_year = 2010;
EXEC spOrdersByYear_ValidYear @p_year = 2050;
GO

--#7
CREATE PROC spOrdersByCountryAndState @p_state varchar(30) = NULL, @p_country varchar(30)=NULL
AS
BEGIN
	DECLARE @numResults int;
	SELECT @numResults = COUNT(*) FROM vwOrderData
	WHERE BillingState = ISNULL(@p_state, BillingState);

	IF @numResults > 0
	BEGIN
		SELECT *
		FROM vwOrderData
		WHERE BillingState = ISNULL(@p_state, BillingState) AND BillingCountry = ISNULL(@p_country,BillingCountry);
	END
	ELSE
	BEGIN
		PRINT 'For Canada or the US, you must enter a province or state abbreviation.'
	END
END
GO

--#8
EXEC spOrdersByCountryAndState;














