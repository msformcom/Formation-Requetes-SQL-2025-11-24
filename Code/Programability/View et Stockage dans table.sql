-- VIew : Requete enregistrée
CREATE OR ALTER VIEW CAByContryRegion
AS
WITH Etape1 AS (
SELECT			SO.shipcountry AS Pays, 
				ISNULL(SO.shipregion,'---') AS Region, 
				SUM(SOD.unitprice * (1 - SOD.discount) * SOD.qty) AS CA, 
				COUNT(SOD.orderid) AS NBCommandes
FROM            Sales.OrderDetails AS SOD RIGHT OUTER JOIN
                         Sales.Orders AS SO ON SOD.orderid = SO.orderid
GROUP BY SO.shipcountry, SO.shipregion),
ETAPE2 AS (
	SELECT * ,
		SUM(CA) OVER (PARTITION BY Pays) AS CAPays,
		SUM(NbCommandes) OVER (PARTITION BY Pays) AS NbCommandesPays,
		SUM(CA) OVER () AS CATotal
	fROM Etape1
)
SELECT * ,
	CAPays/CaTotal  AS PercentCAPAys,
	NTILE(5) OVER(ORDER BY CA DESC) AS Classement5GroupesCA,
	DENSE_RANK() OVER (ORDER BY CAPays DESC) AS ClassemntPaysCA,
	DENSE_RANK() OVER (ORDER BY NbCommandesPays DESC) AS ClassemntPaysNbCommandes,
	RANK() OVER(PARTITION BY Pays ORDER BY CA DESC) AS ClassementRegionDansPAys,
	CA/CAPays AS PercentCARegionPourPays,
	RANK() OVER( ORDER BY CA DESC) AS ClassementRegionGlobal,
	CA/CATotal AS CARegionGlobal
	
FROM Etape2



-- Utilisation comme une table mais la selection est exécutée à chaque exécution de la requete
SELECT * FROM CAByContryRegion
ORDER BY CA

SELECT * 
-- INTO => Stocke les résultats du SELECT dans une table (Il la crée)
INTO CABYCountryRegion20251127
FROM CAByContryRegion

SELECT * FROM CABYCountryRegion20251127

-- INSERTION DE DONNEES DANS UNE TABLE EXISTANTE
INSERT INTO CABYCountryRegion20251127
-- Les colonnes doivent matcher en ordre, nombre et type
SELECT * FROM CAByContryRegion
