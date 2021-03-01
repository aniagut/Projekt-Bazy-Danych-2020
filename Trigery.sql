CREATE OR ALTER TRIGGER UptadeCustomerDiscounts
ON Orders 
AFTER UPDATE 
AS
BEGIN
	IF UPDATE(CompletionDate) 
	BEGIN
		DECLARE @OrderID int = (SELECT OrderID FROM inserted)
		DECLARE @CompanyID int = (SELECT CompanyID FROM Orders WHERE OrderID=@OrderID)
		DECLARE @CustomerID int = (SELECT CustomerID FROM Orders WHERE OrderID=@OrderID)
		IF ((SELECT CustomerID FROM CustomersDiscounts WHERE CustomerID=@CustomerID AND CompanyID=@CompanyID) IS NULL AND @CustomerID IS NOT NULL)
			INSERT INTO CustomersDiscounts (CompanyID,CustomerID) VALUES (@CompanyID,@CustomerID)
		IF (SELECT CustomerType FROM Customers WHERE CustomerID=@CustomerID) = 'I' 
		BEGIN
			DECLARE @Cost money = (SELECT [Sum] FROM OrdersData WHERE OrderID=@OrderID)
			IF (@Cost > (SELECT K1 FROM DiscountsData WHERE CompanyID=@CompanyID))
				UPDATE CustomersDiscounts -- update zamówieñ za okreœlon¹ kwotê
					SET OrdersWithK1 = OrdersWithK1+1
					WHERE CompanyID = @CompanyID AND CustomerID = @CustomerID

			DECLARE @ValidTillR2 datetime = 
				(SELECT ValidTillR2 FROM CustomersDiscounts WHERE CustomerID=@CustomerID AND CompanyID=@CompanyID)
			
			DECLARE @CostFromLastR2Discount money
			IF (@ValidTillR2 is null)
				SET @CostFromLastR2Discount = 
					(SELECT SUM([Sum]) FROM OrdersData WHERE CustomerID=@CustomerID AND CompanyID=@CompanyID)
			ELSE
				SET @CostFromLastR2Discount = 
					(SELECT SUM([Sum]) FROM OrdersData WHERE CustomerID=@CustomerID AND CompanyID=@CompanyID AND OrderDate > @ValidTillR2)
			DECLARE @K2 money = (SELECT K2 FROM DiscountsData WHERE CompanyID=@CompanyID)
			IF (@K2 <= @CostFromLastR2Discount)
			BEGIN
				DECLARE @R2 int = (SELECT R2 FROM DiscountsData WHERE CompanyID=@CompanyID)
				UPDATE CustomersDiscounts -- update 1 rabatu czasowego 
					SET ValidTillR2 = DATEADD(day,@R2,GETDATE())
					WHERE CompanyID = @CompanyID AND CustomerID = @CustomerID
			END
							DECLARE @ValidTillR3 datetime = 
				(SELECT ValidTillR2 FROM CustomersDiscounts WHERE CustomerID=@CustomerID AND CompanyID=@CompanyID)
			
			DECLARE @CostFromLastR3Discount money
			IF (@ValidTillR3 is null)
				SET @CostFromLastR3Discount = 
					(SELECT SUM([Sum]) FROM OrdersData WHERE CustomerID=@CustomerID AND CompanyID=@CompanyID)
			ELSE
				SET @CostFromLastR2Discount = 
					(SELECT SUM([Sum]) FROM OrdersData WHERE CustomerID=@CustomerID AND CompanyID=@CompanyID AND OrderDate > @ValidTillR3)
			DECLARE @K3 money = (SELECT K3 FROM DiscountsData WHERE CompanyID=@CompanyID)
			IF (@K3 <= @CostFromLastR3Discount)
			BEGIN
				DECLARE @R3 int = (SELECT R3 FROM DiscountsData WHERE CompanyID=@CompanyID)
				UPDATE CustomersDiscounts -- update 2 rabatu czasowego 
					SET ValidTillR3 = DATEADD(day,@R3,GETDATE())
					WHERE CompanyID = @CompanyID AND CustomerID = @CustomerID
			END
		END
	END
END
GO
