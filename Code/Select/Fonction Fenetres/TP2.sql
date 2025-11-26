-- Par annee, Mois => CA 
-- + variation avec le mois précédent

-- pourcentage pour un mois par rapport au CA de l'année
-- classement des mois en terme de CA pour l'annee
-- Cumul total (somme des CA des mois qui précèdent)
-- Cumul total annuel (Remis à 0 en debut d'année)
-- Variation avec la moyenne glissante des 3 derniers mois


-- Utiliser CTE (with) => progression
-- 1) Jointures + selection colonnes utiles
-- Création d'une vue (Requete enregistree sous un nom) => Persiste dans la BDD
-- Droits de créer des objets
-- WITH => uniquement disponible dans la requète

--CREATE OR ALTER VIEW ResumeCA AS
--SELECT SO.orderdate AS Date,
--		Empid AS IDEmploye,
--		SOD.unitprice*(1-SOD.discount) PrixVente,
--		Qty AS Quantite,
--		SOD.unitprice*(1-SOD.discount)*qty AS Montant
--FROM Sales.Orders SO 
--INNER JOIN Sales.OrderDetails SOD ON SOD.orderid=SO.orderid
---- 2) Group By
--SELECT YEAR(Date) AS Annee, 
--		MONTH(Date) AS Mois,
--	SUM(Montant) AS CA
-- FROM ResumeCA V
--GROUP BY YEAR(Date), MONTH(Date)

-- Avoir les mois des années 2006,2007,2008

--DECLARE @Debut INT = (SELECT MIN(YEAR(orderdate)) FROM Sales.Orders)
--DECLARE @Fin INT = (SELECT MAX(YEAR(orderdate)) FROM Sales.Orders)
--SELECT @Debut, @Fin

DECLARE @Debut INT
DECLARE @Fin INT
SELECT @Debut=MIN(YEAR(orderdate)), @Fin=MAX(YEAR(orderdate)) FROM Sales.Orders


;WITH 
Annees AS (
	-- Selection des années
	SELECT n AS Annee FROM dbo.nums WHERE n BETWEEN @Debut AND @Fin
),
Mois AS (
	-- Selection des mois
	SELECT n AS Mois FROM dbo.nums WHERE n BETWEEN 1 AND 12
),
AnneesMois AS (
	-- Selection des années combinées aux mois
	SELECT * FROM Annees, Mois
),
Ventes AS (
	-- Ventes (Attention, peut-être avec des trous sur annees mois)
	SELECT YEAR(Date) AS Annee, 
			MONTH(Date) AS Mois,
		SUM(Montant) AS CA
	 FROM ResumeCA V
	GROUP BY YEAR(Date), MONTH(Date)
), 
VentesCompletes AS (
SELECT 
	AM.Annee, 
	AM.Mois, ISNULL(CA,0) AS CA FROM AnneesMois AM 
-- LEFT JOIN pour conserver tous les enregistrements de AnneesMois
LEFT JOIN Ventes V ON AM.Annee=V.Annee AND AM.Mois=V.mois
)
-- 3) Fenetres
SELECT * ,
	CA-LAG(CA) OVER(ORDER BY Annee,Mois) AS DeltaCAPrecedent,
	CA/SUM(CA) OVER (PARTITION BY Annee) AS PercentCAAnnee,
	DENSE_RANK() OVER (PARTITION BY Annee ORDER BY CA DESC) AS ClassementCA,
	SUM(CA) OVER(ORDER BY Annee,Mois ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) CumulCATotal,
	SUM(CA) OVER(PARTITION BY Annee ORDER BY Mois ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) CumulCAAnnee,
	CA-AVG(CA) OVER(ORDER BY Annee,Mois ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS DiffMoyenne3DerniersMois
FROM VentesCompletes VC
ORDER BY Annee,Mois

