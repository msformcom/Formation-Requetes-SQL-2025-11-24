-- OUTPUT Lors des DML
BEGIN TRAN
UPDATE Production.Products SET unitprice=unitprice+1
-- Message dans le journal => Produit 4 => prix passé de 56.00 à 57.00
				OUTPUT CONCAT('Produit ',DELETED.productid,' prix de ',DELETED.unitprice,' à ',INSERTED.unitprice, ' par ', SUSER_NAME())
				INTO dbo.Journal(Message)
WHERE categoryid=1

DELETE FROM dbo.Journal
-- OUTPUT DELETED....
-- INTO ...
WHERE 1=1

INSERT INTO dbo.Journal
-- OUTPUT INSERTED....
-- INTO ...
SELECT 