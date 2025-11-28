-- Niveau isolation de transaction
-- SET TRANSACTION ISOLATION LEVEL CHAOS pas pris en charge par SQL Server
-- SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED On lit les données même non committées
-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED  -- Je m'autorise  à lire uniquement les valeurs committes
-- SET TRANSACTION ISOLATION LEVEL SNAPSHOT -- Permet de lire la valeur validee des données en cours de modif
-- SET TRANSACTION ISOLATION LEVEL REPEATABLE READ --Place des verrous empechant la modification des données lues
-- SET TRANSACTION ISOLATION LEVEL Serializable --Place des verrous sur les tables lues 

-- Plus le niveau d'isolation est haut => Plus de verrous
-- Plus de blocage ou de connection en attente
-- Eviter les niveaux isolation haut
-- Isolation trop faibles => Chances d'avoir des "problemes"

SET TRANSACTION ISOLATION LEVEL SNAPSHOT -- Permet de lire la valeur validee même si elle est en cours de moduf
SELECT * FROM Comptes


UPDATE Comptes SET Montant=14
WHERE id=45

DELETE FROM Comptes WHERE id=47

-- Activation de l'insertion manuelle d'identité dans la table
-- Désactivation du compteur
SET IDENTITY_INSERT Comptes ON
INSERT INTO Comptes(id,montant) VALUES(210,100)
SET IDENTITY_INSERT Comptes OFF