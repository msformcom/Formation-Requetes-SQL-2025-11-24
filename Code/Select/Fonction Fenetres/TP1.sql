-- Les meilleurs employes de L'année 2007
/*
Pour 2007
| IdEmploye | Nom | Prenom | CA |
*/
WITH Etape1 AS (
SELECT SO.empid AS IdEmploye,
		SUM(SOD.unitprice*(1-SOD.discount)*SOD.qty) AS Montant
FROM Sales.Orders SO 
INNER JOIN SaleS.OrderDetails SOD ON SOD.orderid=SO.orderid
WHERE YEAR(SO.orderdate)=2007
GROUP BY empid),
Etape2 AS (
SELECT	E1.IdEmploye, 
		HE.firstname AS Prenom,
		HE.lastname AS Nom, 
		E1.Montant FROM Etape1 E1
INNER JOIN HR.Employees HE ON HE.empid=E1.IdEmploye
) 
SELECT * ,
	-- Classement fonction du montant décroissant
	RANK() OVER (ORDER BY Montant DESC) AS Classement, 
	-- Pourcentage du CA total réalise par l'employe
	Montant / SUM(Montant) OVER() AS PercentDuTotal,
	Montant - LEAD(Montant) OVER(ORDER BY Montant DESC) AS DiffSuivant 
FROM Etape2
ORDER BY Nom, prenom