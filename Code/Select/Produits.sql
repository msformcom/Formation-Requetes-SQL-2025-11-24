-- Liste des produits
-- | Nom produit (prixunitaire) | Ordre de prix

-- <50 => Bon marché
-- 50 et <80 Cher
-- >=80 Hors de prix

-- SQL Strutured query language
-- Conçu pour se rapprocher du langage parlé
-- Ordre des instruction écrites => SELECT => Alias => FROM => WHERE => ORDER BY
-- Ordre des traitements => FROM => WHERE => SELECT => Alias => ORDER BY
SELECT TOP 10
	CONCAT(productname, ' (',FORMAT(unitprice,'C','fr-FR'),')') as Produit,
	CASE	WHEN unitprice<50 THEN 'Bon marché'
			WHEN unitprice<80 THEN 'Cher'
			ELSE 'Hors de prix' END AS Indicateur_Prix
FROM Production.Products
WHERE unitprice<11
ORDER BY Produit ASC