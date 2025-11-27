-- Fonction dbo.range(1,12)
-- | n		|
-- |      1	|
-- |      2	|

-- |     12 |

SELECT * FROM dbo.range(1,12,1) AS Mois

-- Fonction de type table complexe (avec code)
CREATE OR ALTER FUNCTION dbo.range(
@Debut INT,
@Fin INT,
@Pas INT)
RETURNS @resultat TABLE(n INT) -- Structure de l'ensemble renvoye
AS
BEGIN
	-- Remplir la table avec les données
	WHILE @debut <= @fin
	BEGIN
		-- Insertion de la valeur du debut dans la colonne n de la table
		INSERT INTO @resultat(n)
		VALUES(@debut)
		SET @debut=@debut+@pas
	END
	RETURN
END

-- Liste des semaine qui suivent
SELECT DATEADD(week,n, GETDATE()),n
FROM dbo.range(0,10,1)