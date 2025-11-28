-- Créer une PS qui 
-- 2 parametres AugmenterPrix @catid=1, @percent=0.1 , @minAugmentation=3
-- Enregistrement dans journal
-- SI table journal inexistante => créée
-- Table journal : Date,User,Message
-- 1 seule table pour tous les messages 

-- Message => NVARCHAR(100) => Type défini par l'utilisateur
CREATE TYPE MessageType FROM NVARCHAR(300)

-- PS qui crée la table des messages si elle n'exixte pas
CREATE OR ALTER PROCEDURE CreateMessageLog
AS 
BEGIN
	IF OBJECT_ID('dbo.Journal') IS NULL
	BEGIN
		CREATE TABLE Journal (
		Date DATETIME NOT NULL DEFAULT GETDATE(),
		[User] NVARCHAR(100) NOT NULL DEFAULT SUSER_NAME(),
		Message MessageType NOT NULL)
		PRINT 'Création de la table journal'
	END
	DELETE FROM dbo.journal WHERE Date < DATEADD(month,-1,GETDATE())
END

-- Test
EXEC CreateMessageLog



CREATE OR ALTER PROCEDURE DropLog
AS
BEGIN
	DROP TABLE dbo.journal
END 

-- Test
 EXEC DropLog

CREATE OR ALTER PROCEDURE AddMessageToLog(
@message MessageType
) AS
BEGIN
	EXEC CreateMessageLog
	BEGIN TRY
		INSERT INTO dbo.journal(message) 
		VALUES(@message)
	END TRY
	BEGIN CATCH
		;THROW 54000,'Impossible',1
	END CATCH
END
-- Text
EXEC AddMessageToLog 'Toto est en forme ce matin'

-- Je crée un type qui correspond à une structure d'ensemble
CREATE TYPE MessageSetType AS TABLE (
	message MessageType
)

-- Procédure qui recoit un ensemble de messages => Table de type MessageSetType
CREATE OR ALTER PROCEDURE AddMessagesToLog(
@messages MessageSetType READONLY
) AS
BEGIN
	EXEC CreateMessageLog
	INSERT INTO dbo.journal(message) 
	SELECT message FROM @messages
END


CREATE OR ALTER PROCEDURE AugmenterPrix (
	@catid INT, 
	@percent DECIMAL(18,2) , 
	@minAugmentation DECIMAL(18,2)
	)
	AS 
BEGIN
    DECLARE @messages MessageSetType
	UPDATE Production.Products
	SET unitprice=unitprice + IIF(unitprice*@percent<@minAugmentation,@minAugmentation,unitprice*@percent)
	OUTPUT CONCAT('Produit ',DELETED.productid,' prix de ',DELETED.unitprice,' à ',INSERTED.unitprice)
	INTO @messages(message)
	WHERE categoryid=@catid

	EXEC AddMessagesToLog @messages
END

EXEC AugmenterPrix 1,0.1, 1

SELECT * FROM Dbo.journal