/* Types
Charactères ASCII
	CHAR(10) => Dom => 'Dom       '  => 10 octets
	VARCHAR(10) => Dom => Dom**  => n+2 octet
	VARCHAR(MAX)
	Encodege ASCII
	René => FR =>  82 101 110 233 => DK => Renô
	瘁戶

Caractères Unicode
	NCHAR(10) => Dom => 'Dom       '  => 10 octets
	NVARCHAR(10) => Dom => Dom**  => n+2 octet
	瘁戶 =>( 145 165 156) (17 678 198)
	NVARCHAR(MAX) si nécessaire

	Dates
	SET DATEFORMAT DMY => Spécification de l'ordre des information date

	DATE => 11/09/1968
	SMALLDATETIME
	DATETIME


	Numeric entiers
	BIT 0 1
	TINYINT 0-255    1+2 => 1 cycle microprocesseur
	SMALLINT -32,768 to 32,767
	INT -2147483647 to 2147483647 32 bit   1+2 => 1 cycle microprocesseur
	BIGINT -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 1+2 => 1 cycle microprocesseur

	Nombres décimaux => Exacts
	DECIMAL(18,2) => 1234567890123456.12
	DECIMAL(18,6) => 123456789012.345612
	DECIMAL(18,1) => 12345678901234567.1  

	Types non exacts
	Float(53) = > 25 chiffres après la virgule 
	real - 3.40E + 38 to -1.18E - 38, 0 and 1.18E - 38 to 3.40E + 38
*/


DECLARE @Chaine NVARCHAR(10) =N'DOMi瘁戶ulejfozeje'
SELECT @chaine+@chaine


-- Server : US
-- Toujours quand on précise des dates => SET DATEFORMAT DMY
SET DATEFORMAT MDY
DECLARE @date DATE ='11/09/1968'
SELECT @date

