-- Liste des employés
-- Texte : CONCAT ISNULL
-- Date : DATEDIFF, DATEADD, DATEPART
SELECT TOP 10 
T.lastname+ ' '+ T.firstname AS 'Nom complet',
CONCAT(city , ' (',ISNULL(region,'---'),')') AS VilleRegion,
DATEDIFF(year,birthdate,GETDATE()) AS age,
DATEPART(year,birthdate) AS AnneeNaissance,
-- Anciennete (mois)
DATEDIFF(month,hiredate,GETDATE()) AS Anciennete,
DATEADD(quarter,170,hiredate),
-- adresse + ville + region + pays séparés par des '-' 
-- sans region si Null et sans double -
REPLACE(CONCAT(address,'-',city,'-',region,'-',country),'--','-') AS Adresse1,
CONCAT(address,'-',city,'-'+region,'-',country) AS Adresse2,
IIF(DATEDIFF(year,birthdate,GETDATE())>60,'A la retraite','Travaille encore !') AS Retraite,
CASE WHEN DATEPART(year,birthdate) <1946 THEN 'Grandiose'
	WHEN DATEPART(year,birthdate) <=1965 THEN 'Baby boomers'
	WHEN DATEPART(year,birthdate) <=1980 THEN 'X'
	WHEN DATEPART(year,birthdate) <=1996 THEN 'Y'
	WHEN DATEPART(year,birthdate) <=2012 THEN 'Z'
	WHEN DATEPART(year,birthdate) <=2024 THEN 'Alpha'
	ELSE 'Beta' END
 AS Generation
FROM [HR].[Employees] AS T