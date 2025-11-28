-- SET OPERATORS
SELECT * FROM dbo.range(1,10,1)
UNION -- Les éléments des deux ensembles sans les doublons
SELECT * FROM dbo.range(5,14,1)

SELECT * FROM dbo.range(1,10,1)
UNION ALL -- Les éléments des deux ensembles avec les doublons
SELECT * FROM dbo.range(5,14,1)

SELECT * FROM dbo.range(1,10,1)
INTERSECT  -- Les éléments présents dans les deux ensembles
SELECT * FROM dbo.range(5,14,1)

SELECT * FROM dbo.range(1,10,1)
EXCEPT -- Les éléments de l'ensemble 1 sans les éléments de l'ensemble 2
SELECT * FROM dbo.range(5,14,1)

-- Commandes avec le produit 14
SELECT SO.* FROM Sales.Orders SO
INNER JOIN Sales.OrderDetails SOD ON SO.orderid=SOD.OrderId
WHERE SOD.productid=14

-- Commandes sans le produit 14
SELECT * FROM Sales.Orders
EXCEPT
SELECT SO.* FROM Sales.Orders SO
INNER JOIN Sales.OrderDetails SOD ON SO.orderid=SOD.OrderId
WHERE SOD.productid=15

-- Liste des clients qui ont achete le produit 14 (par ex vélo)
-- sans acheter le produit 15 (pompe à vélo)
;WITH Clients14 AS (
	SELECT SO.custid FROM Sales.Orders SO
	INNER JOIN Sales.OrderDetails SOD ON SO.orderid=SOD.OrderId
	WHERE SOD.productid=14
),
Clients15 AS (
	SELECT SO.* FROM Sales.Orders SO
	INNER JOIN Sales.OrderDetails SOD ON SO.orderid=SOD.OrderId
	WHERE SOD.productid=15
	)
, IdClients AS(
SELECT custid FROM Clients14
EXCEPT 
SELECT custid FROM  Clients15)
SELECT * FROM Sales.Customers
WHERE custid IN (SELECT DISTINCT custid FROM IdClients)



