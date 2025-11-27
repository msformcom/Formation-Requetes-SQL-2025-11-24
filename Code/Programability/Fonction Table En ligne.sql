-- fonction utilisable comme ceci
-- SELECT * FROM Sales.Last12Month(3)  -- 3 : Clientid
-- | Annee | Mois | CA			|
-- | 2008  |   06 | 101001		|
-- | 2008  |   05 | 98171		|
-- | 2008  |   04 | 8768		|
-- 

SELECT * FROM Sales.Last12Month(2) 
ORDER BY Annee DESC,Mois DESC

CREATE OR ALTER FUNCTION sales.Last12Month(
@custid INT 
)
RETURNS TABLE AS RETURN
WITH Mois AS (
-- Les mois à retrancher à partir de la date de dernière commande
SELECT n-1 AS n FROM dbo.Nums WHERE n BETWEEN 1 AND 12
),
Dates AS (
	-- Date de la dernière commandes
	SELECT MAx(orderdate) AS Max FROM Sales.Orders WHERE custid=@custid
),
DateMois AS
(
	SELECT DATEADD(month,-n,(SELECT max FROM Dates)) AS Date
	FROM Mois
),
AnneesMois AS(
	SELECT YEAR(date) Annee, 
	MONTH (Date) Mois
	FROM DateMois
)
SELECT	* ,
		ISNULL(				(
							SELECT SUM(sales.calcDiscount(unitprice,discount)*qty)
							FROM Sales.OrderDetails SOD
							INNER JOIN Sales.Orders SO ON SOD.orderid=SO.orderid
							WHERE YEAR(Orderdate)=annee AND MONTH(orderdate)=mois
							AND custid=@custid
							)	
		,0) AS CA
FROM AnneesMois



ORDER BY Annee DESC, mois DESC

SELECT SUM(sales.calcDiscount(unitprice,discount)*qty)
							FROM Sales.OrderDetails SOD
							INNER JOIN Sales.Orders SO ON SOD.orderid=SO.orderid
							WHERE YEAR(Orderdate)=2008 AND MONTH(orderdate)=3
							AND custid=2

SELECT MAx(orderdate) AS Max FROM Sales.Orders WHERE custid=2