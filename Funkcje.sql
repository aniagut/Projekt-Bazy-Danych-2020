-- Zwraca MenuID obecnego menu danej restauracji
CREATE or ALTER FUNCTION GetRestaurantCurrentMenuID (
	@RestaurantID int
)
	RETURNS int
AS
BEGIN
	RETURN ( [dbo].GetRestaurantMenuID(@RestaurantID, GETDATE()))
END
GO

-- Zwraca MenuID dla menu danej restauracji w okreœlonym czasie 
CREATE or ALTER FUNCTION GetRestaurantMenuID (
	@RestaurantID int,
	@DataTime date
)
	RETURNS int
AS
BEGIN
	RETURN (
		SELECT MenuID
		FROM Menu
		WHERE CompanyID = @RestaurantID and (OutDate is null or OutDate > @DataTime) and InDate < @DataTime
	);
END
GO

--Zwraca CompanyID do której należy dane menu
CREATE OR ALTER FUNCTION GetCompanyWithMenuID(
	@MenuID int
)
	RETURNS int
AS
BEGIN
	RETURN (
		SELECT CompanyID FROM Menu WHERE MenuID = @MenuID
	)
END
GO

-- Zwraca IntervalID dla obecnego uk³adu stolików w danej restauracji
CREATE or ALTER FUNCTION GetRestaurantCurrentIntervalID (
	@RestaurantID int
)
	RETURNS int
AS
BEGIN
	RETURN [dbo].GetRestaurantIntervalID(@RestaurantID, GETDATE())
END
GO

-- Zwraca IntervalID dla  układu stolików w danej restauracji i okreœlonym czasie
CREATE or ALTER FUNCTION GetRestaurantIntervalID (
	@RestaurantID int,
	@DataTime date
)
	RETURNS int
AS
BEGIN
	RETURN (
		SELECT IntervalID
		FROM Intervals
		WHERE CompanyID = @RestaurantID and (EndDate is null or EndDate > @DataTime) and BeginningDate < @DataTime
	);
END
GO

--Zwrócenie ID klienta, który złożył zamówienie
CREATE OR ALTER FUNCTION GetCustomerID(
	@OrderID int
)
	RETURNS int
AS
BEGIN
	RETURN (
		SELECT CustomerID
		FROM Orders
		WHERE OrderID=@OrderID
	);
END
GO


--Zwraca minimalną kwotę do zamówienia potrzebną do złożenia rezerwacji
CREATE or ALTER FUNCTION MinReservationCost (
	@CustomerID int,
	@CompanyID int
)
	RETURNS int
AS
BEGIN
	IF	(
		SELECT count(*)
		FROM OrdersData
		WHERE CustomerID = @CustomerID and CompanyID = @CompanyID
		GROUP BY OrderID) > 5
			RETURN (SELECT ReservationMinAmount FROM Company WHERE CompanyID = @CompanyID)
	RETURN (SELECT ReservationMinAmountRegularClients FROM Company WHERE CompanyID = @CompanyID)
END
GO

--Zwraca łączną kwotę zamówienia
CREATE or ALTER FUNCTION TotalOrderCost(
	@OrderID int
)
	RETURNS int
AS
BEGIN
	RETURN (
		SELECT [Sum]
		FROM OrdersData
		where OrderID = @OrderID
	)
END
GO

--Sprawdza czy zamówienie spełnia warunki na rezerwację
CREATE or ALTER FUNCTION ReservationConditions(
	@OrderID int
)
	RETURNS int
AS
BEGIN
	DECLARE @CompanyID int = (SELECT CompanyID FROM Orders WHERE OrderID = @OrderID)
	DECLARE @CustomerID int = (SELECT CustomerID FROM Orders WHERE OrderID = @OrderID)
	IF ([dbo].TotalOrderCost(@OrderID) >= [dbo].MinReservationCost(@CustomerID, @CompanyID))
		RETURN 1
	RETURN 0
END
GO

-- Zwraca ilość dostępnych miejsc w danym czasie
CREATE or ALTER FUNCTION AvailablePlace(
	@CompanyID int,
	@Time datetime
)
	RETURNS int
AS
BEGIN
	DECLARE @PlacesInRestaurant int = (
		SELECT SUM(AvailableChairs)
		FROM IntervalDetails AS ID
		INNER JOIN Intervals AS I
		ON I.IntervalID = ID.IntervalID
		WHERE I.BeginningDate <= @Time and I.EndDate >= @Time and I.CompanyID = @CompanyID
		)
	DECLARE @OccupiedPlaces int = (
		SELECT SUM(OccupiedChairs)
		FROM OrderedTables as OT
		INNER JOIN Orders as O
		ON O.OrderID = OT.OrderID
		WHERE O.OrderDate <= @Time and O.CompletionDate >= @Time and O.CompanyID = @CompanyID and O.Valid = 'Y' and O.TakeAway = 'N'
	)
	RETURN @PlacesInRestaurant - @OccupiedPlaces
END
GO

--Zwraca date pojawienia się danej potrawy w restauracji
CREATE OR ALTER FUNCTION CourseInDate(
	@CourseID int,
	@MenuID int
)
	RETURNS date
AS
BEGIN
	DECLARE @InDate date = (SELECT InDate FROM Menu WHERE MenuID = @MenuID)
	DECLARE @PreviousCourseID int = (SELECT TOP 1 CourseID FROM CoursesAvailability 
			WHERE DATEDIFF(DD,OutDate,@InDate) = 1 and CompanyID = [dbo].GetCompanyWithMenuID(@MenuID) and CourseID = @CourseID)
	IF (@PreviousCourseID is null)
		RETURN @InDate
	DECLARE @PreviousMenuID int = (SELECT TOP 1 MenuID FROM CoursesAvailability 
			WHERE DATEDIFF(DD,OutDate,@InDate) = 1 and CompanyID = [dbo].GetCompanyWithMenuID(@MenuID) and CourseID = @CourseID)
	RETURN [dbo].CourseInDate(@CourseID, @PreviousMenuID)
END
GO

--Sprawdza czy menu spełnia warunki
CREATE OR ALTER FUNCTION MenuConditions(
	@MenuID int
)
	RETURNS int
AS
BEGIN
	DECLARE @StartDate date = (SELECT InDate FROM Menu WHERE MenuID = @MenuID)
	DECLARE @EndDate date = (SELECT OutDate FROM Menu WHERE MenuID = @MenuID)
	IF (@EndDate is null)
		SET @EndDate = GETDATE()
	IF (DATEDIFF(DD, @StartDate, @EndDate) > 14) 
		RETURN 0 --jeśli menu trwa dłużej niż dwa tygodnie nie można było zmienić potraw

	DECLARE @CoursesInMenu TABLE(CourseID int)
	INSERT INTO @CoursesInMenu SELECT CourseID FROM CoursesAvailability WHERE MenuID = @MenuID
	
	IF (SELECT COUNT(*) 
		FROM CoursesAvailability
		WHERE DATEDIFF(DD, OutDate, @StartDate) <= 31 and CourseID in (SELECT * FROM @CoursesInMenu)
			and DATEDIFF(DD, OutDate, @StartDate) > 1 and CompanyID = [dbo].GetCompanyWithMenuID(@MenuID)) > 0
		RETURN 0 -- istnieją dania które były zdjęte zbyt wcześnie
	
	DECLARE @MenuSize int = (SELECT COUNT(*) FROM @CoursesInMenu)
	DECLARE @CoursesWithMoreThanTwoWeeksIn int = 
		(SELECT COUNT(*) FROM @CoursesInMenu WHERE DATEDIFF(DD,[dbo].CourseInDate(CourseID,@MenuID),@EndDate) > 14)

	IF (@MenuSize < 2*@CoursesWithMoreThanTwoWeeksIn)
		RETURN 0 --połowa Menu nie jest wymieniona
	RETURN 1
END
GO

--sprawdzenie czy danie moze byc umieszczone w menu
CREATE OR ALTER FUNCTION CanAddCourse(
	@MenuID int,
	@CourseID int
)
	RETURNS int
AS
BEGIN
	DECLARE @StartDate date = (SELECT InDate FROM Menu WHERE MenuID = @MenuID)  
	IF (SELECT COUNT(*)
		FROM CoursesAvailability
		WHERE DATEDIFF(DD, OutDate, @StartDate) <= 31 and CourseID = @CourseID and
			DATEDIFF(DD, OutDate, @StartDate) > 1 and CompanyID = [dbo].GetCompanyWithMenuID(@MenuID)) > 0	
		RETURN 0
	RETURN 1
END
GO

--sprawdzenie czy dostępny jest stolik o danej ilości miejsc i zwrócenie ID tego stolika
CREATE OR ALTER FUNCTION GetTableWithNPlaces(
	@Company int,
	@Places int,
	@Time datetime
)
	RETURNS int
AS
BEGIN
	DECLARE @IntervalID int = [dbo].GetRestaurantIntervalID(@Company,@Time)
	DECLARE @SearchTable int = (
		SELECT TOP 1 ID.TableID
		FROM IntervalDetails AS ID
		INNER JOIN Intervals AS I
		ON I.IntervalID = ID.IntervalID
		INNER JOIN OrderedTables AS OT
		ON ID.IntervalID = OT.IntervalID and ID.TableID = OT.TableID
		INNER JOIN Orders as O
		ON O.OrderID = OT.OrderID
		WHERE I.IntervalID = @IntervalID and O.Valid = 'Y'
		GROUP BY ID.IntervalID, ID.TableID, AvailableChairs
		HAVING AvailableChairs - SUM(OccupiedChairs)>= @Places
	)
	IF @SearchTable IS NULL
		RETURN -1
	RETURN @SearchTable
END
GO


--Wyświetlanie rabatów w restauracji
CREATE OR ALTER PROCEDURE ShowDiscounts
	@CompanyID int
AS
BEGIN
	SET NOCOUNT ON
	SELECT *
	FROM DiscountsData
	WHERE CompanyID=@CompanyID
END
GO

--sprawdzenie czy danie zawiera owoce morze
CREATE OR ALTER FUNCTION ContainsSeaFoodCourse(
	@CourseID int
)
	RETURNS int
AS
BEGIN
	IF((SELECT COUNT(*) FROM Ingredients
	INNER JOIN [Contains] ON Ingredients.IngredientID=[Contains].IngredientID AND CourseID=@CourseID
	WHERE SeaFood='Y')>0 )
		RETURN 1
	RETURN 0
END
GO

--sprawdzenie czy zamówienie zawiera owoce morza
CREATE OR ALTER FUNCTION ContainsSeaFoodOrder(
	@OrderID int
)
	RETURNS int
AS
BEGIN
	IF((SELECT COUNT(*) FROM OrderDetails WHERE OrderID=@OrderID AND [dbo].ContainsSeaFoodCourse(CourseID)='Y')>0)
		RETURN 1
	RETURN 0
END
GO

--funkcja zliczająca jaką kwotę wydał klient w restauracji począwszy od danej daty
CREATE OR ALTER FUNCTION OrdersSumFromDate(
	@CustomerID int,
	@CompanyID int,
	@Date datetime
)
	RETURNS money
AS
BEGIN
	RETURN (SELECT SUM(Quantity*UnitPrice) FROM Orders
	INNER JOIN OrderDetails ON Orders.OrderID=OrderDetails.OrderID
	INNER JOIN MenuDetails ON MenuDetails.MenuID=OrderDetails.MenuID AND MenuDetails.CourseID=OrderDetails.CourseID
	WHERE OrderDate>@Date AND CustomerID=@CustomerID AND CompanyID=@CompanyID)
END
GO


