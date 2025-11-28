SELECT TOP 100 * FROM Contacts WHERE nom='714E251A-A742-4FBD-996D-4D402781DE07'

DROP INDEX IX_Nom ON Contacts
CREATE NONCLUSTERED INDEX IX_Nom ON Contacts(Nom)

SELECT TOP 100 * FROM Contacts
ORDER BY Nom DESC

SELECT Nom,Prenom,credit
FROM Contacts
WHERE Prenom BETWEEN 'A' AND 'D' -- 0123456789ABCDEF
ORDER BY prenom ASC

-- Colonnes Prenom + Nom car c'est la clé de l'index en cluster

DROP INDEX IX_Contacts_Prenom ON Contacts
CREATE INDEX IX_Contacts_Prenom ON Contacts(Prenom)
INCLUDE (Credit)

-- Optimisation
SELECT * FROM Factures WHERE Date BETWEEN '01/01/2024' AND '01/01/2025'
-- Index cluster => Optimiser une recherche large
-- Index non cluster => Optimise une recherche tres selective


SELECT date, idclient,credit FROM Factures WHERE idclient BETWEEN 1 AND 2000
-- Index non cluster optimise meme si pas selectif
-- s'il est couvrant => il contient les données des colonnes demandées