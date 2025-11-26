-- Le CA realisé sur ventes par mois sans cumuls
-- pour les produits de la catégorie 4 , annee 2007
-- |  IdCategorie | Annee | Mois | MontantVentes |
-- |            4 |  2006 |   06 |       7868767 |
-- |            4 |  2006 |   07 |       9879798 |
-- ...

-- Id de la catégorie recherchée
DECLARE @IdCategorie INT =4
-- Année de la recherche
DECLARE @Annee INT =2007
-- Pays
DECLARE @Pays NVARCHAR(15)='USA'

;WITH 
SelectMois AS (
		-- Liste des mois de 1 à 12
		SELECT n AS Mois FROM dbo.nums WHERE n BETWEEN 1 AND 12
		),
Etape1 AS (
		-- Données avant regroupement
		SELECT PP.categoryid AS IdCategorie, 
			YEAR(SO.orderdate) AS Annee, 
			MONTH(orderdate) AS Mois,
			SOD.unitprice*(1-SOD.discount)*SOD.qty AS Montant
		FROM Sales.Orders SO
		INNER JOIN Sales.OrderDetails SOD ON SO.orderid=SOD.orderid
		INNER JOIN Production.Products PP ON SOD.productid=PP.productid
		WHERE PP.categoryid=@IdCategorie AND DATEPART(year,SO.orderdate)=@Annee
			AND SO.shipcountry=@Pays
),
Etape2 AS (
		-- Regroupement => Certains mois peuvent manque
		SELECT IdCategorie, Annee,Mois,
				SUM(Montant) AS MontantVentes
		 FROM Etape1
		GROUP BY IdCategorie, Annee,Mois
)
SELECT  ISNULL(IdCategorie,@IdCategorie) AS IdCategorie, 
		ISNULL(Annee,@Annee) AS Annee, 
		SM.Mois,
		ISNULL(MontantVentes,0) AS MontantVentes FROM 
SelectMois SM LEFT JOIN Etape2 E2 ON SM.Mois=E2.Mois
-- LEFT JOIN : Prendre toutes les lignes de la table de gauche même si 
-- pas de ligne correspondante dans la table de droite
-- RIGHT JOIN : Prendre toutes les lignes de la table de droite 
-- même si pas de ligne correspondante dans la table de gauche
-- FULL (OUTER) JOIN : Prendre toutes les lignes de la table de droite 
-- même si pas de ligne correspondante dans la table de gauche
-- Prendre toutes les lignes de la table de gauche même si 
-- pas de ligne correspondante dans la table de droite
