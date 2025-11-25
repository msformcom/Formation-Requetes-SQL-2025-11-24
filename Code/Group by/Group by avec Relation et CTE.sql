WITH Etape1 AS  -- CTE : Selection à laquelle je donne un nom 
				-- avant de continuer la requète
(	SELECT SO.orderdate									AS DateVente,
			SOD.productid								AS IdProduit,
			SOD.qty										AS Quantite,
			SOD.unitprice*(1-SOD.discount)				AS PrixVente,
			SOD.unitprice*(1-SOD.discount)*SOD.qty		AS MontantVente
	FROM [Sales].[Orders] SO 
	INNER JOIN [Sales].[OrderDetails] SOD
	ON SO.orderid=SOD.orderid
),Etape2 AS (
	SELECT * FROM Etape1
	WHERE Quantite >10

)
-- CA PAr mois
SELECT  YEAR(datevente)							AS Annee, 
		MONTH(DateVente)						AS Mois,
		SUM(quantite)							AS TotalQuantite,
		AVG(prixvente)							AS MoyennePrixVente,
		SUM(MontantVente)						AS CA 				
FROM Etape2
GROUP BY YEAR(datevente), MONTH(DateVente)
WITH ROLLUP