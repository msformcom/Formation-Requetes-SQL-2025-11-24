-- Liste des produits
-- | Nom produit (prixunitaire) | Ordre de prix

-- <50 => Bon marché
-- 50 et <80 Cher
-- >=80 Hors de prix

SELECT TOP 10
	CONCAT(productname, ' (',FORMAT(unitprice,'C','fr-FR'),')') as Produit,
	CASE	WHEN unitprice<50 THEN 'Bon marché'
			WHEN unitprice<80 THEN 'Cher'
			ELSE 'Hors de prix' END AS Indicateur_Prix

FROM Production.Products