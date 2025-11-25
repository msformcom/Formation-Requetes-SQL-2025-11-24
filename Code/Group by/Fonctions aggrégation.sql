SELECT COUNT(*) AS NBCommandes,
		MIN(orderdate) MinDateCommande,
		MAX(orderdate) MaxDateCommande,
		AVG(freight) MoyenneFraisDeport,
		AVG(DATEDIFF(hour,orderdate,shippeddate)),
		COUNT(DISTINCT custid) -- Nombre de fois ou custid est non nul dans les lignes
FROM Sales.Orders -- Ensemble de lignes

SELECT COUNT(*) FROM Sales.Customers

-- Nombre de commandes qui ont au moins un produit à prix reduit
SELECT COUNT(DISTINCT orderid)
FROM Sales.OrderDetails
WHERE discount>0
-- Nombre de commandes total
SELECT COUNT(*)
FROM Sales.Orders

SELECT 380*1.0/830

SELECT CONVERT(DECIMAL,(SELECT COUNT(DISTINCT orderid)
FROM Sales.OrderDetails
WHERE discount>0))/ (SELECT COUNT(*)
FROM Sales.Orders)

-- Nombre de produits qui ont été vendus avec une reduction de plus de 10%
SELECT COUNT(DISTINCT(productid)) FROM Sales.OrderDetails
WHERE discount>0.1
-- Somme du CA perdu à cause des reductions
SELECT SUM(unitprice*discount*qty) MontantReduc, 
		SUM(unitprice*qty) MontantAvantReduc,
		SUM(unitprice*discount*qty)/SUM(unitprice*qty) AS PercentEurosPerdus
FROM Sales.OrderDetails
WHERE discount>0