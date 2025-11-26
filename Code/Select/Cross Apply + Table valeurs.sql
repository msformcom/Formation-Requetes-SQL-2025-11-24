-- Chiffre d'affaire et le nombre de ventes par vacances scolaires
-- 
SET DATEFORMAT DMY
SELECT * FROM (VALUES
(CONVERT(DATE,'25/10/2006'),CONVERT(DATE,'05/11/2006')),
('23/12/2006','07/01/2007'),
('10/02/2007','25/02/2007'),
('31/03/2007','15/04/2007'),
('04/07/2007','03/09/2007')
)
AS Dates(Debut,Fin)
CROSS APPLY (SELECT	ISNULL(SUM(SOD.unitprice*(1-SOD.discount)*qty),0) AS MontantVentes, 
		ISNULL(SUM(qty),0) AS QuantiteVentes
FROM Sales.Orders SO
INNER JOIN Sales.OrderDetails SOD ON SO.orderid=SOD.orderid
WHERE SO.orderdate BETWEEN Dates.Debut AND Dates.Fin) AS Calculs

SET DATEFORMAT DMY
-- CAlcul du Montant et Qte entre deux dates
SELECT	SUM(SOD.unitprice*(1-SOD.discount)*qty) AS MontantVentes, 
		SUM(qty) AS QuantiteVentes
FROM Sales.Orders SO
INNER JOIN Sales.OrderDetails SOD ON SO.orderid=SOD.orderid
WHERE SO.orderdate BETWEEN '25/10/2006' AND '05/11/2006'