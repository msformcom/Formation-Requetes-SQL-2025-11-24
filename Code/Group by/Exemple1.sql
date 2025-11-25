-- Group BY
SELECT * FROM production.Products
ORDER BY categoryid

SELECT categoryid, 
		COUNT(productid) AS NB, 
		AVG(unitprice) AS MoyennePrix FROM production.Products
GROUP BY categoryid

-- Par client => nombre de commandes
-- | Custid | Nombre commandes |
SELECT custid,
	COUNT(*) AS NbCommandes
 FROM Sales.Orders
GROUP BY custid


-- Par produit, CA généré, Pourcentage moyen de reduc , NbProduitVendus
-- Ordonné par montant total en monnaie de la reduc desc
SELECT * FROM (
SELECT Productid,

	 SUM(unitprice*qty*(1-discount)) AS CA,
	 SUM(unitprice*qty) AS CASansReduc,
	 --SUM(unitprice*qty)-SUM(unitprice*qty*(1-discount)) AS MontantReduc,
	 1-SUM(unitprice*qty*(1-discount))/SUM(unitprice*qty) AS MoyenneReduc,
	 SUM(qty) QteVendue

 FROM Sales.OrderDetails
GROUP BY productid
--ORDER BY SUM(unitprice*qty)-SUM(unitprice*qty*(1-discount))
) AS T
ORDER BY CASansReduc-CA DESC