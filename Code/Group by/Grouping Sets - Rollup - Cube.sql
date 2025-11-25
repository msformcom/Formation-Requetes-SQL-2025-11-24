-- par annee, par pays, region, ville
-- COUNT(*) AS NbCommandes
-- avec cumuls intermédiaires

-- Problème Rollup : Pas possible cumul par Pays Quelque soit l'annee
-- Pas toutes les combinaisaons intéressantes de cumul
SELECT * FROM 
(SELECT  -- Les critères de regroupement
		YEAR(orderdate) AS ANNEE,
		 shipcountry AS Pays,
		 ISNULL(shipregion,'---') AS Region, 
		 shipcity AS Ville,
		-- Les fonctions aggrégation
		COUNT(*) AS NbCommandes
FROM Sales.Orders
GROUP BY YEAR(orderdate), shipcountry,ISNULL(shipregion,'---'), shipcity
WITH Rollup) AS T
WHERE Ville ='Reims'

-- CUBE : Cumul par nom de ville quel que soit Region ou le pays => incoherent
-- Trop de combinaisons
SELECT * FROM 
(SELECT  -- Les critères de regroupement
		YEAR(orderdate) AS ANNEE,
		 shipcountry AS Pays,
		 ISNULL(shipregion,'---') AS Region, 
		 shipcity AS Ville,
		-- Les fonctions aggrégation
		COUNT(*) AS NbCommandes
FROM Sales.Orders
GROUP BY YEAR(orderdate), shipcountry,ISNULL(shipregion,'---'), shipcity
WITH CUBE
) AS T
WHERE Ville ='Reims'


-- Grouping sets : Cumul spécifiés explicitement
SELECT * FROM 
(SELECT  -- Les critères de regroupement
		YEAR(orderdate) AS ANNEE,
		 shipcountry AS Pays,
		 ISNULL(shipregion,'---') AS Region, 
		 shipcity AS Ville,
		-- Les fonctions aggrégation
		COUNT(*) AS NbCommandes
FROM Sales.Orders
GROUP BY GROUPING SETS(
	(YEAR(orderdate)),
	(YEAR(orderdate),shipcountry),
	(YEAR(orderdate),shipcountry,ISNULL(shipregion,'---')),
	(YEAR(orderdate),shipcountry,ISNULL(shipregion,'---'),shipcity),
	(shipcountry),
	(shipcountry,ISNULL(shipregion,'---')),
	(shipcountry,ISNULL(shipregion,'---'),shipcity)
)
) AS T
WHERE Ville='Reims'
ORDER BY Annee, Pays,Region,Ville