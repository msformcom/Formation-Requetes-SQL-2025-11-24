-- MontantTotal des ventes pour 2007 pour les produits vendus 
-- avec un prix entre 0 compris et 10 euros non compris

SELECT	SUM(SOD.unitprice*(1-SOD.discount)*qty) AS MontantVentes, 
		SUM(qty) AS QUantiteVentes
FROM Sales.Orders SO
INNER JOIN Sales.OrderDetails SOD ON SO.orderid=SOD.orderid
WHERE DATEPART(year,orderdate)=2007
AND SOD.unitprice*(1-SOD.discount)>=0 AND SOD.unitprice*(1-SOD.discount)<10

-- Savoir quel budget mes clients ont pour les produits qu'ils achêtent
/*
| Min		|	  Max	|		CA			|
| 0			|		5	|		78688    	|
| 5			|	10		|		67555   	|
| 10		|	30		|		786868		|
| 30		|	100		|		1897981		|

*/

SELECT	T.Min,
		T.Max, 
		(		-- Calcul des Montants des venetes pour 2007 pour les produits
				-- vendus avec un prixdevente entre T.Min et T.MAx
				SELECT SUM(SOD.unitprice*(1-SOD.discount)*qty) 
				FROM Sales.Orders SO
				INNER JOIN Sales.OrderDetails SOD ON SO.orderid=SOD.orderid
				WHERE DATEPART(year,orderdate)=2007
				AND SOD.unitprice*(1-SOD.discount)>=T.Min AND SOD.unitprice*(1-SOD.discount)<T.Max
		) AS MontantVentes,
		(		-- Calcul des quantites des venetes pour 2007 pour les produits
				-- vendus avec un prixdevente entre T.Min et T.MAx
				SELECT SUM(qty) 
				FROM Sales.Orders SO
				INNER JOIN Sales.OrderDetails SOD ON SO.orderid=SOD.orderid
				WHERE DATEPART(year,orderdate)=2007
				AND SOD.unitprice*(1-SOD.discount)>=T.Min AND SOD.unitprice*(1-SOD.discount)<T.Max
		) AS Quantite
FROM (VALUES (0,5),(5,10),(10,30),(30,100),(100,1000)) AS T(Min,Max)

SELECT	T.Min,
		T.Max,
		T2.MontantVentes,
		T2.QuantiteVentes

FROM (VALUES (0,5),(5,10),(10,30),(30,100),(100,1000)) AS T(Min,Max)
CROSS APPLY (
			-- J'intègre les 2 colonnes de cette sélection dans la sélection principale
			SELECT	SUM(SOD.unitprice*(1-SOD.discount)*qty) AS MontantVentes, 
					SUM(qty) AS QuantiteVentes
			FROM Sales.Orders SO
			INNER JOIN Sales.OrderDetails SOD ON SO.orderid=SOD.orderid
			WHERE DATEPART(year,orderdate)=2007
			AND SOD.unitprice*(1-SOD.discount)>=T.Min AND SOD.unitprice*(1-SOD.discount)<T.Max
) AS T2