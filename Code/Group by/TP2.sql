/* JOINTURE entre plusieurs tables

*/

SELECT * 
FROM Table1 T1 
INNER JOIN Table2 T2 ON -- Condition de jointure entre T1 et T2
INNER JOIN Table3 T3 ON -- Condition de jointure entre T2 et T3
INNER JOIN Table4 T4 ON -- Condition de jointure entre T3 et T4

-- On évite plus e 4 sauts
-- Essayer de mettre les tables dans l'ordre des jointures
-- Essayer de mettre les tables toujours dans le même ordre

-- les ventes par categorie produit et produit
-- pour l'annee 2008
-- | Nom catégorie | Nom Produit | QuantiteVendue | MontantVentes
-- avec group by coherent

SELECT PC.categoryid,
		categoryname, 
		PP.productid, 
		ProductName,
		SUM(SOD.qty) AS QuantiteVendue,
		SUM(SOD.unitprice*(1-SOD.discount)*SOD.qty) AS Montant
FROM Production.Categories PC
INNER JOIN Production.Products PP  ON  PC.categoryid=PP.categoryid
INNER JOIN Sales.OrderDetails SOD ON SOD.productid=PP.productid
INNER JOIN Sales.Orders SO ON SOD.orderid=SO.orderid
WHERE YEAR(Orderdate)=2008
GROUP BY GROUPING SETS (
	(),
	(PC.categoryid, categoryname),
	(PC.categoryid, categoryname,PP.productid, ProductName)
)

;WITH Regroupement AS (
-- Ventes par id produit
SELECT productid, 
		 SUM(Qty) AS QuantiteVendue,
		 SUM(unitprice*(1-discount)*Qty) AS Montant
FROM Sales.OrderDetails SOD
INNER JOIN Sales.Orders SO ON So.orderid=SOD.orderid
WHERE YEAR(orderdate)=2008
GROUP BY productid
)
SELECT R.*, PP.productname, PC.categoryname FROM Regroupement R
INNER JOIN Production.Products PP ON PP.productid=R.productid
INNER JOIN Production.Categories PC ON PC.categoryid=PP.categoryid