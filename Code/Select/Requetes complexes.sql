/*

Les commandes livrées dont 
la date de livraison requise (requireddate)
a été devancée de 5 jour ou moins pour les 
pays UK, US, France
Ordonnes par Annee de commande, mois, pays , idclient
Les plus récentes en premier
select : Annee,Mois, pays, idclient, 
delai entre livraison et deadline livraison 
negatif => Loupé
0-2 => très limite
3-4 => Moyennement limite
5 => un peu limite 

*/

SELECT	DATEPART(year,orderdate) AS Annee,
		DATEPART(month,orderdate) AS Mois,
		shipcountry AS Pays,
		custid AS IdClient,
		DATEDIFF(day,shippeddate,requireddate) AS Avance,
		CASE WHEN DATEDIFF(day,shippeddate,requireddate) <0 THEN 'Loupé'
		WHEN DATEDIFF(day,shippeddate,requireddate) <=2 THEN 'Très limite'
		WHEN DATEDIFF(day,shippeddate,requireddate) <=4 THEN 'Moyennement limite'
		ELSE 'Un peu limite'
		END AS IndicateurLivraison

FROM Sales.Orders
WHERE shippeddate IS NOT NULL 
AND DATEDIFF(day,shippeddate,requireddate)<=5
AND shipcountry IN ('France','UK','USA')
ORDER BY DATEPART(year,orderdate) DESC,
DATEPART(month,orderdate) DESC,
shipcountry,
custid



-- En deux étapes
SELECT Annee,Mois, Pays , IdClient, Avance,
	CASE WHEN Avance <0 THEN 'Loupé'
		WHEN Avance <=2 THEN 'Très limite'
		WHEN Avance <=4 THEN 'Moyennement limite'
		ELSE 'Un peu limite'
		END AS IndicateurLivraison
FROM
					-- Etape 1 : Précalculer certaines infos
					-- Annee, Mois, Pays,IdClient, Avance
					(SELECT	DATEPART(year,orderdate) AS Annee,
							DATEPART(month,orderdate) AS Mois,
							shipcountry AS Pays,
							custid AS IdClient,
							DATEDIFF(day,shippeddate,requireddate) AS Avance
							FROM sales.orders WHERE shippeddate IS NOT NULL) AS T
WHERE avance<=5
AND Pays IN ('France','UK','USA')
ORDER BY Annee DESC,Mois DESC, Pays , IdClient



