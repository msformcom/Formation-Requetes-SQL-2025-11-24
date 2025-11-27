-- Programibilté
-- Order de prix => 0 - Pas cher - 20 - Moyen - 40 Cher
SELECT * ,
	Sales.IndicPrix(unitprice) AS indicPrix -- Prend en paramètre un nombre => NVARCHAR,

FROM Production.Products

SELECT * ,
	Sales.IndicPrix(unitprice) AS indicPrix
FROM Sales.OrderDetails

DROP FUNCTION IndicPrix 


CREATE OR ALTER FUNCTION Sales.CalcDiscount (
	@montant DECIMAL(18,2),
	@reduc DECIMAL(18,3)
	 -- Le montant sur lequel on base le calcul
) RETURNS DECIMAL(18,2)
AS 
BEGIN 
	RETURN @montant*(1-@reduc)
END

SELECT Sales.CalcDiscount(1,0.2)
SELECT *, Sales.CalcDiscount(unitprice,discount) FROM Sales.OrderDetails

-- unitprice*(1-discount)
-- sales.calcDiscount(unitprice,discount)

CREATE OR ALTER FUNCTION Sales.IndicPrix (
	@montant DECIMAL(18,2) -- Le montant sur lequel on base le calcul
) RETURNS NVARCHAR(100)
AS 
BEGIN 
	RETURN  CASE WHEN @montant<20 THEN 'Pas Cher'
		WHEN @montant <40 THEN 'Moyen'
		ELSE 'Cher'
		END
END