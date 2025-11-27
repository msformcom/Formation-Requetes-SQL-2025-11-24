-- SELECT * FROM dbo.dates('01/01/2007','31/12/2207',1)
-- Dernier paramètre :		0 uniquement lund- - vendredi	Ouvrés
--							1 samedi  compris				Ouvrables
--							2 samedi + dimanche  compris	Tous
-- | Date			|
-- | 01/01/2007		|

-- | 31/12/2207		|

-- 1) while 
--       point depart : DateDebut
--       condition DateDebut <= Datefin
--       ajouter un jour à datedbut
-- 2) insert à quelle condition ? 
		


CREATE FUNCTION dbo.dates(
@Debut DATE,
@Fin DATE,
@p SMALLINT)
RETURNS @resultat TABLE(Date DATE)
AS
BEGIN
	WHILE @Debut<=@Fin
	BEGIN
		INSERT INTO @resultat(DAte)
		VALUES(@Debut);
		-- On passe au jour suivant
		SET @Debut=DATEADD(day,1, @Debut)
	END
	IF @p<1
	BEGIN 
		DELETE FROM @resultat
		WHERE DATEPART(dw,Date)=7 
	END
	IF @p<2
	BEGIN 
		DELETE FROM @resultat
		WHERE DATEPART(dw,Date)=1
	END
	RETURN
END
-- Tests 
SELECT * FROM  dbo.dates(GETDATE(),DATEADD(Month,1,GETDATE()),0)
SELECT * FROM  dbo.dates(GETDATE(),DATEADD(Month,1,GETDATE()),1)
SELECT * FROM  dbo.dates(GETDATE(),DATEADD(Month,1,GETDATE()),2)

