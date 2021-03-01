--widok zawierający informacje o zamówieniu, kto zamawiał, kiedy, gdzie, ile zapłacił, rabaty naliczone do zamówienia i informacje czy zamówienie jest ważne 
CREATE or ALTER VIEW OrdersData 
AS
	SELECT O.OrderID, CustomerID, CompanyID, OrderDate, sum(MD.UnitPrice*OD.Quantity) as Sum, DisposableDiscount, PercentageDiscount, Valid
	FROM Orders as O
	INNER JOIN OrderDetails as OD
	ON O.OrderID = OD.orderID
	INNER JOIN MenuDetails as MD
	ON OD.MenuID = MD.MenuId and OD.CourseId = MD.courseID
	GROUP BY O.OrderID, CustomerID, CompanyID, OrderDate, disposableDiscount, PercentageDiscount, Valid
GO

--danie, restauracja, czas w jakim danie jest dostępne
CREATE or ALTER VIEW CoursesAvailability
AS
	SELECT MD.CourseID,M.MenuID, M.CompanyID, M.InDate, M.OutDate 
	FROM MenuDetails as MD
	INNER JOIN Menu as M
	ON MD.MenuID = M.MenuID
GO
--wyswietlenie rabatów z których korzystali stali klienci
CREATE or ALTER VIEW ShowUsedDiscounts
AS
	SELECT CustomerID,CompanyID,OrderID,DisposableDiscount,PercentageDiscount
	FROM Orders
	WHERE CustomerID IS NOT NULL AND Valid='Y' AND (DisposableDiscount IS NOT NULL OR PercentageDiscount!=0)
GO
