-- Changement de contexte de BDD
USE TSQL
GO

-- SELECT Dans une table
SELECT * FROM Production.Products

-- Il existe des vues systeme
SELECT * 
FROM sys.tables 

SELECT * 
FROM sys.databases

-- Projection => Je sélectionne seulement certaines colonnes
-- Arranger l'instruction pour plus de lisibilité
-- Noms des objets : lettres A-Z + _
SELECT TOP 20 PERCENT	lastname AS 'Nom Employe',
						firstname AS [Prenom Employe],
						city AS "Ville Employe",
						postalcode AS Code_Postal,
						firstname AS Prénom
FROM HR.Employees


DELETE FROM HR.Employees