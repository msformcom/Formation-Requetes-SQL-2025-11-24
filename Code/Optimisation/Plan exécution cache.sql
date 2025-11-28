SELECT Credit,COUNT(*) NB FROM contacts
GROUP BY Credit
ORDER BY Nb DESC

CREATE INDEX Ix_Credit ON Contacts(Credit)

SELECT * FROM Contacts WHERE Credit=709.82 OPTION(RECOMPILE)  -- => Tres selectif
SELECT * FROM Contacts WHERE Credit=144.07 OPTION(RECOMPILE) -- Avec cette valeur l'index n'est plus valable
-- OPTION(RECOMPILE) => ne réutilise pas le plan d'exécution pour cette requète

-- Plan exécution pour 
SELECT * FROM Contacts WHERE Credit=@1 -- => On utilise l'index


