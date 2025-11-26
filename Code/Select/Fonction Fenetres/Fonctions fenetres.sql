SELECT * FROM (
SELECT * ,
	--ROW_NUMBER() OVER (ORDER BY productname ASC) AS RowNumberNom,
	--ROW_NUMBER() OVER (ORDER BY unitprice ASC) AS RowNumberPrix,
	--RANK()  OVER (ORDER BY unitprice ASC) AS RankPrix,
	--DENSE_RANK()  OVER (ORDER BY unitprice ASC) AS DenseRankPrix,
	RANK()  OVER (PARTITION BY Categoryid ORDER BY unitprice ASC ) AS RankPrixParCategorie,
	MIN(unitprice)  OVER (PARTITION BY Categoryid  ) AS MinPrixParCategorie,
	--MAX(unitprice)  OVER (PARTITION BY Categoryid  ) AS MaxPrixParCategorie,
	--AVG(unitprice)  OVER (PARTITION BY Categoryid  ) AS MoyennePrixParCategorie,
	--COUNT(*) OVER (PARTITION BY Categoryid  ) AS NbProduitParCategorie,
	--SUM(unitprice) OVER (PARTITION BY Categoryid  ) ASSommePrixParCategorie
		LAG(unitprice) OVER (PARTITION BY Categoryid ORDER BY unitprice ASC ) AS PrixduPrecedent,
		LEAD(unitprice) OVER (PARTITION BY Categoryid ORDER BY unitprice ASC ) AS PrixduSuivant,
		AVG(unitprice) OVER (PARTITION BY Categoryid ORDER BY unitprice ASC ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING ) AS TT
FROM Production.Products) AS T
-- WHERE RowNumberPrix<=5
ORDER BY categoryid, unitprice