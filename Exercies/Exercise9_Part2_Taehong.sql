--Exercise 9 Part2

--#1
CREATE OR ALTER PROC  spOrdersByYearAndCountryAndArtistAndAlbum 
@p_year int, 
@p_country varchar(200) =NULL,
@p_Artist varchar(200)=NULL,
@p_Album varchar(200)=NuLL
AS
SELECT * FROM vwOrderData
WHERE InvoiceYear = @p_year 
AND vwOrderData.AlbumName LIKE '%'+ISNULL (@p_Album, AlbumName)+'%' 
AND vwOrderData.ArtistName = ISNULL (@p_Artist, ArtistName)
AND vwOrderData.BillingCountry = ISNULL (@p_country, BillingCountry);
Go

EXEC spOrdersByYearAndCountryAndArtistAndAlbum @p_year = 2010;
EXEC spOrdersByYearAndCountryAndArtistAndAlbum @p_year = 2010, @p_country = 'United Kingdom';
EXEC spOrdersByYearAndCountryAndArtistAndAlbum @p_year = 2010, @p_country = 'Canada', @p_Artist = 'Led Zeppelin'
GO

CREATE PROC spOrdersByYearAndCountryAndArtistAndAlbum_SUMMARY 
@p_year numeric(4,0), 
@p_country varchar(30) =NULL,
@p_Artist varchar(30)=NULL,
@p_Album varchar(30)=NuLL
AS
SELECT * FROM vwOrderData
WHERE vwOrderData.InvoiceYear = @p_year 
OR vwOrderData.AlbumName LIKE '%'+@p_Album+'%' 
OR vwOrderData.ArtistName = @p_Artist 
OR vwOrderData.BillingCountry = @p_country;
Go

