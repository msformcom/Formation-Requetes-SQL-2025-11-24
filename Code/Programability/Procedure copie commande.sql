-- Duplication d'une commande avec details

EXEC Sales.DuplicateOrder 11011 


DROP PROCEDURE DuplicateOrder
CREATE OR ALTER PROCEDURE Sales.DuplicateOrder(
@orderid INT
)
AS BEGIN
BEGIN TRAN 
	IF NOT EXISTS(SELECT * FROM Sales.orders WHERE orderid=@orderid)
	BEGIN
		;THROW 56000,'La commande n''existe pas',1
	END
	BEGIN TRY
				-- Insertion de la copie de ligne de commande
		INSERT INTO Sales.Orders([custid]
		  ,[empid]
		  ,orderdate
		  ,requireddate
		  ,shippeddate
		  ,[shipperid]
		  ,[freight]
		  ,[shipname]
		  ,[shipaddress]
		  ,[shipcity]
		  ,[shipregion]
		  ,[shippostalcode]
		  ,[shipcountry])
		OUTPUT INSERTED.*
	SELECT [custid]
		  ,[empid]
		  ,GETDATE()
		  ,DATEADD(day,DATEDIFF(day, orderdate,requireddate),GETDATE())
		  ,null
		  ,[shipperid]
		  ,[freight]
		  ,[shipname]
		  ,[shipaddress]
		  ,[shipcity]
		  ,[shipregion]
		  ,[shippostalcode]
		  ,[shipcountry]
	  FROM [Sales].[Orders]
	  WHERE orderid=@orderid

		DECLARE @newOrderId INT =@@IDENTITY
		PRINT @newOrderId
		-- Insertion des produits
		INSERT INTO sales.Orderdetails( [orderid]
			  ,[productid]
			  ,[unitprice]
			  ,[qty]
			  ,[discount])
			  OUTPUT INSERTED.*
		SELECT @newOrderId
			  ,[productid]
			  ,[unitprice]
			  ,[qty]
			  ,[discount]
		  FROM [Sales].[OrderDetails]
		  WHERE orderid=@orderid
		COMMIT
	END TRY

	BEGIN CATCH
		-- En cas d'erreur dans le bloc try
		-- Annulation de l'opération
		ROLLBACK
		-- Lance un message erreur
		;THROW 56000,'Un problème est survenu',1
	END CATCH
END






