-- DROP TABLE Comptes
CREATE TABLE Comptes
( 
	Id INT PRIMARY KEY IDENTITY(1,1),
	Montant DECIMAL(18,2) NOT NULL
)
GO

DECLARE @i INT =0;
WHILE @i<100
BEGIN
	INSERT INTO Comptes (Montant)
	VALUES(RAND()*100)
	SET @i=@i+1
END

SELECT * FROM Comptes



/*
Atomicité => Tout valider ou rien
Cohérence => Avant la transaction => Données correctes , pareil après
Isolation
Durabilité
*/

--ALTER TABLE Comptes ADD Check(montant<=100) 

-- Je veux pouvoir lire deux fois les informations
-- et que les valeurs ne soient pas modifiées entretemps => 
-- Les SELECT placent des verrous contre écriture
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ


SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
-- virement
BEGIN TRAN
	-- SELECT * FROM Comptes WHERE id IN (45,76)
	SELECT * FROM Comptes WHERE id<200
	BEGIN TRY
	UPDATE Comptes SET Montant=Montant-50
	WHERE Id=45
	-- Erreur
	UPDATE Comptes SET Montant=Montant+50
	WHERE Id=76
	COMMIT
	END TRY 
	BEGIN CATCH
	-- Annulation 
		ROLLBACK
		;THROW 54000,'Erreur dans l''opération',1
	END CATCH

