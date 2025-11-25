-- Par Employe et Annee je veux le nombre de commmandes géré avec cumuls
-- | Nom | Prenom | Annee | NbCommandes | NbPays| 

-- Tables :		HR.Employees => Nom Prenom empid
--				Sales.orders => Annee ShipCountry empid


-- Liaison d'abord, regroupement ensuite


WITH Etape1 AS (
-- Selection des données utilisées par la suite
SELECT YEAR(Orderdate) As Annee,
		HE.empid AS IdEmploye,
		HE.firstname AS Prenom,
		HE.lastname AS Nom,
		SOD.orderid   AS IDCommande,
		SOD.shipcountry AS Pays	
FROM
[Sales].[Orders] SOD INNER JOIN [HR].[Employees] AS HE
ON SOD.empid=HE.empid
)
SELECT Annee, 
		IdEmploye,
		Nom,
		Prenom,
		COUNT(*) AS nbCommandes,
		COUNT(DISTINCT pays) AS NbPays
		
		 FROM Etape1
GROUP BY GROUPING SETS(
	(),
	(Annee),
	(IdEmploye,Nom,Prenom),
	(Annee, IdEmploye,Nom,Prenom)
)
ORDER BY idEmploye,Annee

-- Regroupement d'abord, liaison ensuite 
;WITH Etape1 AS (
-- Selection des données de commande
SELECT YEAR(orderdate) AS Annee,
		Empid AS IdEmploye,
		shipcountry AS Pays
FROM Sales.Orders
),
ETAPE2 AS (
-- Group by sur IdEmploye et Annee
SELECT  Annee,IdEmploye, 
	count(*) AS NbCommandes,
	COUNT(DISTINCT pays) AS NbPays
 FROM Etape1
GROUP BY IdEmploye, Annee WITH CUBE)
-- Ajout du nom et prenom de l'employé au resultat de Etape2
SELECT ETAPE2.*, 
		HE.firstname  AS Prenom,
		HE.lastname AS Nom FROM Etape2
INNER JOIN HR.Employees HE ON ETAPE2.IdEmploye=HE.empid