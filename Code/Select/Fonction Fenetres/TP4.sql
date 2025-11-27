-- Par pays et par region => CA , nombre de commandes, Moyenne du montant des ventes
-- Classement des pays par CA
-- Classement des pays par nbCommandes
-- 
-- percent de CA par Pays
-- Dans chaque Pays => Classement des régions + percent du CA d'un region / Pays
-- Pour chaque région => classement de la région + percent du CA de cette region (Independament du Pays)

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
ORDER BY Classement5GroupesCA 