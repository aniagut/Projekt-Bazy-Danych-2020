--Dodanie klienta indywidualnego
CREATE or ALTER PROCEDURE AddNewIndividualCustomer
	@Address varchar(40),
	@City varchar(40),
	@PostalCode varchar(40),
	@Country varchar(40),
	@Phone varchar(11),
	@Email varchar(40),
	@Firstname varchar(35),
	@Lastname varchar(35),
	@BirthDate date,
	@PESEL varchar(11)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CustomerID int=(SELECT ISNULL(MAX(CustomerID),1) FROM Customers)
	DECLARE @CustomerType varchar(1)='I'
	BEGIN TRANSACTION
	INSERT INTO Customers (CustomerID,Address,City,PostalCode,Country,Phone,Email,CustomerType)
	VALUES (@CustomerID, @Address,@City,@PostalCode,@Country,@Phone,@Email,@CustomerType)
	INSERT INTO IndividualCustomers (CustomerID,FIrstname,Lastname,BirthDate,PESEL)
	VALUES (@CustomerID,@Firstname,@Lastname,@BirthDate,@PESEL)
	COMMIT TRANSACTION
END
GO

--Dodanie klienta firmowego
CREATE or ALTER PROCEDURE AddNewBusinessCustomer
	@Address varchar(40),
	@City varchar(40),
	@PostalCode	varchar(40),
	@Country varchar(40),
	@Phone varchar(11),
	@Email varchar(40),
	@CompanyName varchar(40),
	@NIP varchar(10),
	@Fax varchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CustomerID int=(SELECT ISNULL(MAX(CustomerID),1) FROM Customers)
	DECLARE @CustomerType varchar(1)='B'
	BEGIN TRANSACTION
	INSERT INTO Customers (CustomerID,Address,City,PostalCode,Country,Phone,Email,CustomerType)
	VALUES (@CustomerID, @Address,@City,@PostalCode,@Country,@Phone,@Email,@CustomerType)
	INSERT INTO BusinessCustomers (CustomerID,CompanyName,NIP,Fax)
	VALUES (@CustomerID,@CompanyName,@NIP,@Fax)
	COMMIT TRANSACTION
END
GO

--Zmiana danych klienta
CREATE or ALTER PROCEDURE ChangeCustomerData
	@CustomerID int,
	@Address varchar(40),
	@City varchar(40),
	@PostalCode	varchar(40),
	@Country varchar(40),
	@Phone varchar(11),
	@Email varchar(40)
AS
BEGIN
	SET NOCOUNT ON;
	IF @Address IS NOT NULL
		UPDATE Customers
		SET Address=@Address
		WHERE CustomerID=@CustomerID
	IF @City IS NOT NULL
		UPDATE Customers
		SET City=@City
		WHERE CustomerID=@CustomerID
	IF @PostalCode IS NOT NULL
		UPDATE Customers
		SET PostalCode=@PostalCode
		WHERE CustomerID=@CustomerID
	IF @Country IS NOT NULL
		UPDATE Customers
		SET Country=@Country
		WHERE CustomerID=@CustomerID
	IF @Phone IS NOT NULL
		UPDATE Customers
		SET Phone=@Phone
		WHERE CustomerID=@CustomerID
	IF @Email IS NOT NULL
		UPDATE Customers
		SET Email=@Email
		WHERE CustomerID=@CustomerID
END
GO

--Usuniêcie klienta z bazy
CREATE or ALTER PROCEDURE DeleteCustomer
	@CustomerID int
AS
BEGIN
	SET NOCOUNT ON;
	IF (SELECT CustomerType FROM Customers WHERE CustomerID=@CustomerID)='I'
		DELETE IndividualCustomers WHERE CustomerID=@CustomerID
	ELSE
		DELETE BusinessCustomers WHERE CustomerID=@CustomerID
	DELETE Customers WHERE CustomerID=@CustomerID
END
GO

--Utworzenie rabatów klienta w restauracji
CREATE or ALTER PROCEDURE CreateDiscountsData
	@CompanyID int,
	@CustomerID int
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO CustomersDiscounts (CompanyID,CustomerID)
	VALUES (@CompanyID,@CustomerID)
END
GO

--Usuniêcie rabatów klienta w restauracji
CREATE or ALTER PROCEDURE DeleteDiscountsData
	@CompanyID int,
	@CustomerID int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE CustomersDiscounts WHERE CompanyID=@CompanyID AND CustomerID=@CustomerID
END
GO

--Dodanie restauracji
CREATE or ALTER PROCEDURE AddCompany
	@CompanyName varchar(40),
	@FloorSpace int,
	@Address varchar(40),
	@City varchar(15),
	@Region varchar(20),
	@PostalCode varchar(10),
	@Phone varchar(20),
	@NIP varchar(11),
	@Fax varchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CompanyID int=(SELECT ISNULL(MAX(CompanyID),1) FROM Company)
	INSERT INTO Company(CompanyID,CompanyName,FloorSpace,Address,City,Region,PostalCode,Phone,NIP,Fax)
	VALUES(@CompanyID,@CompanyName,@FloorSpace,@Address,@City,@Region,@PostalCode,@Phone,@NIP,@Fax)
	INSERT INTO DiscountsData(CompanyID)
	VALUES (@CompanyID)
END
GO

--Zmiana danych restauracji
CREATE or ALTER PROCEDURE ChangeCompanyData
	@CompanyID int,
	@CompanyName varchar(40),
	@FloorSpace int,
	@ReservationMinAmount int,
	@Address varchar(40),
	@City varchar(15),
	@Region varchar(20),
	@PostalCode	varchar(10),
	@Country varchar(15),
	@Phone varchar(20),
	@NIP varchar (11),
	@Fax varchar (20)
AS
BEGIN
	SET NOCOUNT ON;
	IF @CompanyName IS NOT NULL
		UPDATE Company
		SET CompanyName=@CompanyName
		WHERE CompanyID=@CompanyID
	IF @FloorSpace IS NOT NULL
		UPDATE Company
		SET FloorSpace=@FloorSpace
		WHERE CompanyID=@CompanyID
	IF @ReservationMinAmount IS NOT NULL
		UPDATE Company
		SET ReservationMinAmount=@ReservationMinAmount
		WHERE CompanyID=@CompanyID
	IF @Address IS NOT NULL
		UPDATE Company
		SET Address=@Address
		WHERE CompanyID=@CompanyID
	IF @City IS NOT NULL
		UPDATE Company
		SET City=@City
		WHERE CompanyID=@CompanyID
	IF @Region IS NOT NULL
		UPDATE Company
		SET Region=@Region
		WHERE CompanyID=@CompanyID
	IF @PostalCode IS NOT NULL
		UPDATE Company
		SET PostalCode=@PostalCode
		WHERE CompanyID=@CompanyID
	IF @Country IS NOT NULL
		UPDATE Company
		SET Country=@Country
		WHERE CompanyID=@CompanyID
	IF @Phone IS NOT NULL
		UPDATE Company
		SET Phone=@Phone
		WHERE CompanyID=@CompanyID
	IF @NIP IS NOT NULL
		UPDATE Company
		SET NIP=@NIP
		WHERE CompanyID=@CompanyID
	IF @Fax IS NOT NULL
		UPDATE Company
		SET Fax=@Fax
		WHERE CompanyID=@CompanyID
END
GO

--Usuniêcie restauracji
CREATE or ALTER PROCEDURE DeleteCompany
	@CompanyID int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE Company WHERE CompanyID=@CompanyID
END
GO

--Dodanie pracownika
CREATE or ALTER PROCEDURE AddNewEmployee
	@FirstName varchar(20),
	@LastName varchar(30),
	@Title varchar(30),
	@CompanyID int,
	@TitleOfCourtesy varchar(5),
	@BirthDate date,
	@HireDate date,
	@FireDate date,
	@Address varchar(40),
	@City varchar(20),
	@Region varchar(20),
	@PostalCode	varchar(10),
	@Country varchar(15),
	@Phone varchar(20),
	@Notes text
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @EmployeeID int=(SELECT ISNULL(MAX(EmployeeID),1) FROM Employees)
	INSERT INTO Employees (EmployeeID,FirstName,LastName,Title,CompanyID,TitleOfCourtesy,BirthDate,HireDate,FireDate,Address,City,Region,PostalCode,Country,Phone,Notes)
	VALUES(@EmployeeID,@FirstName,@LastName,@Title,@CompanyID,@TitleOfCourtesy,@BirthDate,@HireDate,@FireDate,@Address,@City,@Region,@PostalCode,@Country,@Phone,@Notes)	
END
GO

--Zmiana danych pracownika
CREATE or ALTER PROCEDURE ChangeEmployeeData
	@EmployeeID int,
	@Title varchar(30),
	@Address varchar(40),
	@City varchar(20),
	@Region varchar(20),
	@PostalCode	varchar(10),
	@Country varchar(15),
	@Phone varchar(20),
	@Notes text
AS
BEGIN
	SET NOCOUNT ON;
	IF @Title IS NOT NULL
		UPDATE Employees
		SET Title=@Title
		WHERE EmployeeID=@EmployeeID
	IF @Address IS NOT NULL
		UPDATE Employees
		SET Address=@Address
		WHERE EmployeeID=@EmployeeID
	IF @City IS NOT NULL
		UPDATE Employees
		SET City=@City
		WHERE EmployeeID=@EmployeeID
	IF @Region IS NOT NULL
		UPDATE Employees
		SET Region=@Region
		WHERE EmployeeID=@EmployeeID
	IF @PostalCode IS NOT NULL
		UPDATE Employees
		SET PostalCode=@PostalCode
		WHERE EmployeeID=@EmployeeID
	IF @Country IS NOT NULL
		UPDATE Employees
		SET Country=@Country
		WHERE EmployeeID=@EmployeeID
	IF @Phone IS NOT NULL
		UPDATE Employees
		SET Phone=@Phone
		WHERE EmployeeID=@EmployeeID
	IF @Notes IS NOT NULL
		UPDATE Employees
		SET Notes=@Notes
		WHERE EmployeeID=@EmployeeID
END
GO

--Zwolnienie pracownika
CREATE or ALTER PROCEDURE FireEmployee
	@EmployeeID int,
	@FireDate date
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Employees
	SET FireDate=@FireDate
	WHERE EmployeeID=@EmployeeID
END
GO

--Dodanie kategorii
CREATE or ALTER PROCEDURE AddNewCategory
	@CategoryName varchar(15),
	@Description text
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CategoryID int=(SELECT ISNULL(MAX(CategoryID),1) FROM Categories)
	INSERT INTO Categories (CategoryID,CategoryName,Description)
	VALUES(@CategoryID,@CategoryName,@Description)
END
GO

--Zmiana danych kategorii
CREATE or ALTER PROCEDURE ChangeCategoryData
	@CategoryID int,
	@CategoryName varchar(15),
	@Description text
AS
BEGIN
	SET NOCOUNT ON;
	IF @CategoryName IS NOT NULL
		UPDATE Categories
		SET CategoryName=@CategoryName
		WHERE CategoryID=@CategoryID
	IF @CategoryName IS NOT NULL
		UPDATE Categories
		SET Description=@Description
		WHERE CategoryID=@CategoryID
END
GO

--Usuniêcie kategorii
CREATE or ALTER PROCEDURE DeleteCategory
	@CategoryID int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE Categories WHERE CategoryID=@CategoryID
END
GO

--Dodanie sk³adnika
CREATE or ALTER PROCEDURE AddNewIngredient
	@IngredientName varchar(15)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IngredientID int=(SELECT ISNULL(MAX(IngredientID),1) FROM Ingredients)
	INSERT INTO Ingredients(IngredientID,IngredientName)
	VALUES(@IngredientID,@IngredientName)
END
GO

--Dodanie potrawy
CREATE or ALTER PROCEDURE AddNewCourse
	@CourseName varchar(50),
	@Description text
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CourseID int=(SELECT ISNULL(MAX(CourseID),1) FROM Course)
	INSERT INTO Courses(CourseID,CourseName,Description)
	VALUES(@CourseID,@CourseName,@Description)
END
GO

--Dodanie sk³adnika do potrawy
CREATE or ALTER PROCEDURE AddIngredientToCourse
	@CourseID int,
	@IngredientID int
AS
BEGIN
	SET NOCOUNT ON;
	IF (SELECT COUNT(*) FROM [Contains] WHERE CourseID = @CourseID AND IngredientID = @IngredientID) = 0 
		INSERT INTO [Contains](CourseID,IngredientID)
		VALUES (@CourseID,@IngredientID)
	ELSE
		PRINT 'Danie już posiada ten składnik'
END
GO

--Usuniêcie sk³adnika z potrawy
CREATE or ALTER PROCEDURE DeleteIngredientFromCourse
	@CourseID int,
	@IngredientID int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE [Contains] WHERE CourseID=@CourseID AND IngredientID=@IngredientID
END
GO
--Modyfikacja danych potrafy
CREATE or ALTER PROCEDURE ChangeCourseData
	@CourseID int,
	@CourseName varchar(50),
	@Description text
AS
BEGIN
	SET NOCOUNT ON;
	IF @CourseName IS NOT NULL
		UPDATE Courses
		SET CourseName=@CourseName
		WHERE CourseID=@CourseID
	IF @CourseName IS NOT NULL
		UPDATE Courses
		SET Description=@Description
		WHERE CourseID=@CourseID
END
GO
--Utworzenie menu
CREATE or ALTER PROCEDURE CreateNewMenu
	@CompanyID int,
	@InDate date
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MenuID int=(SELECT ISNULL(MAX(MenuID),1) FROM Menu)
	INSERT INTO Menu (MenuID,CompanyID,InDate,OutDate)
	VALUES(@MenuID,@CompanyID,@InDate,NULL)
END
GO

--Data zakoñczenia menu
CREATE or ALTER PROCEDURE AddMenuEndDate
	@MenuID int,
	@CompanyID int,
	@OutDate date
AS
BEGIN
	SET NOCOUNT ON;
	IF (SELECT COUNT(*) FROM Menu WHERE MenuID = @MenuID AND OutDate is null) = 1
		UPDATE Menu
		SET OutDate=@OutDate
		WHERE MenuID=@MenuID AND CompanyID=@CompanyID
	ELSE
		THROW 50005, 'OutDate is already set', 1;
END
GO

--Dodanie potrawy do menu
CREATE or ALTER PROCEDURE AddCourseToMenu
	@MenuID int,
	@CourseID int,
	@CategoryID int,
	@UnitPrice int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CompanyID int=(SELECT CompanyID FROM Menu WHERE MenuID=@MenuID)
	IF ([dbo].CanAddCourse(@CompanyID,@CourseID)=1)
		INSERT INTO MenuDetails(MenuID,CourseID,CategoryID,UnitPrice)
		VALUES (@MenuID,@CourseID,@CategoryID,@UnitPrice)
	ELSE
		THROW 50005, 'Cannot add this course', 1;
END
GO

--Dodanie stolika do restauracji
CREATE or ALTER PROCEDURE AddTable
	@CompanyID int,
	@NumberOfChairs int,
	@Description varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @TableID int=(SELECT ISNULL(MAX(TableID),1) FROM Tables)
	INSERT INTO Tables(TableID,CompanyID,NumberOfChairs,Description)
	VALUES(@TableID,@CompanyID,@NumberOfChairs,@Description)
END
GO

--Zmiana opisu stolika
CREATE or ALTER PROCEDURE ChangeTableDescription
	@TableID int,
	@CompanyID int,
	@Description varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Tables
	SET Description=@Description
	WHERE TableID=@TableID AND CompanyID=@CompanyID
END
GO

--Dodanie planu restauracji
CREATE or ALTER PROCEDURE AddInterval
	@CompanyID int,
	@BeginningDate date
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IntervalID int=(SELECT ISNULL(MAX(IntervalID),1) FROM Intervals)
	INSERT INTO Intervals(IntervalID,CompanyID,BeginningDate,EndDate)
	VALUES(@IntervalID,@CompanyID,@BeginningDate,NULL)
END
GO

--Ustalenie daty zakoñczenia planu
CREATE  or ALTER PROCEDURE AddIntervalEndDate
	@IntervalID int,
	@CompanyID int,
	@EndDate date
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Intervals
	SET EndDate=@EndDate
	WHERE IntervalID=@IntervalID AND CompanyID=@CompanyID
END
GO

--Dodanie stolika do planu restauracji
CREATE or ALTER PROCEDURE AddTableToInterval
	@TableID int,
	@IntervalID int,
	@AvailableChairs int
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO IntervalDetails(TableID,IntervalID,AvailableChairs)
	VALUES(@TableID,@IntervalID,@AvailableChairs)
END
GO

--Dodanie zamówienia
CREATE or ALTER PROCEDURE AddNewOrder
	@EmployeeID int,
	@CustomerID int,
	@CompanyID int,
	@TakeAway varchar(1)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @OrderID int=(SELECT ISNULL(MAX(OrderID),0) FROM Orders)
	DECLARE @OrderDate date=GETDATE()
	INSERT INTO Orders(OrderID,EmployeeID,CustomerID,CompanyID,OrderDate,TakeAway)
	VALUES(@OrderID,@EmployeeID,@CustomerID,@CompanyID,@OrderDate,@TakeAway)
END
GO

--Dodanie pozycji do zamówienia
CREATE or ALTER PROCEDURE AddCoursesToOrder
	@OrderdID int,
	@CourseID int,
	@MenuID int
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO OrderDetails(OrderID,CourseID,MenuID)
	VALUES(@OrderdID,@CourseID,@MenuID)
END
GO

--Zmiana danych zamówienia
CREATE or ALTER PROCEDURE ChangeOrderData
	@OrderID int,
	@EmployeeID int,
	@CompletionDate date
AS
BEGIN
	SET NOCOUNT ON;
	IF @EmployeeID IS NOT NULL
		UPDATE Orders
		SET EmployeeID=@EmployeeID
		WHERE OrderID=@OrderID
	IF @CompletionDate IS NOT NULL
		UPDATE Orders
		SET CompletionDate=@CompletionDate
		WHERE OrderID=@OrderID
END
GO

--Wlicza rabat w zamówienie jeśli klient spełnia warunki, oraz aktualizuje rabaty klienta
--Pozwala na wybranie tylko tych rabatów których chce użyć klient
CREATE OR ALTER PROCEDURE AddDiscountsToOrder
	@OrderID int,
	@R1Disc varchar(1),
	@ValidTillR2Disc varchar(1),
	@ValidTillR3Disc varchar(1),
	@FR1Disc varchar(1),
	@FK2Disc varchar(2)
AS
BEGIN
	DECLARE @CustomerID int = (SELECT [dbo].GetCustomerID(@OrderID))
	DECLARE @CompanyID int = (SELECT CompanyID FROM Orders WHERE OrderID = @OrderID)
	DECLARE @CustomerType int = (SELECT CustomerType FROM Customers WHERE CustomerID = @CustomerID)
	DECLARE @OrderDate datetime = (SELECT OrderID FROM Orders WHERE OrderID = @OrderID)
	-- naliczanie rabatu za określoną ilość zamówień
	IF @R1Disc = 'Y' AND @CustomerType='I'
	BEGIN
		DECLARE @OrdersWithK1 int = (SELECT OrdersWithK1 FROM CustomersDiscounts 
			WHERE CompanyID = @CompanyID AND CustomerID = @CustomerID)
		DECLARE @R1 decimal(3,2) = (SELECT R1 FROM DiscountsData WHERE CompanyID = @CompanyID)
		DECLARE @Z1 decimal(3,2) = (SELECT Z1 FROM DiscountsData WHERE CompanyID = @CompanyID)
		UPDATE Orders
		SET PercentageDiscount = PercentageDiscount + CAST(@OrdersWithK1/@Z1 AS int)*@R1
		WHERE OrderID = @OrderID
	END
	--naliczanie rabatów czasowych dla indywidualnego klienta
	IF @ValidTillR2Disc = 'Y' AND @CustomerType='I'
	BEGIN
		DECLARE @R2 decimal(3,2) = (SELECT R2 FROM DiscountsData WHERE CompanyID = @CompanyID)
		DECLARE @Date datetime = (SELECT ValidTillR2 FROM CustomersDiscounts 
			WHERE CompanyID = @CompanyID AND CustomerID = @CustomerID)
		IF @OrderDate < @Date
		BEGIN
			UPDATE Orders
				SET PercentageDiscount = PercentageDiscount + @R2
				WHERE OrderID = @OrderID
			UPDATE CustomersDiscounts
				SET ValidTillR2 = @OrderDate
				WHERE CustomerID = @CustomerID AND CompanyID = @CompanyID
		END
		ELSE
			PRINT('Zabat R2 jest nieaktywny')
	END

	--naliczanie rabatów czasowych dla indywidualnego klienta
	IF @ValidTillR3Disc = 'Y' AND @CustomerType='I'
	BEGIN
		DECLARE @R3 decimal(3,2) = (SELECT R3 FROM DiscountsData WHERE CompanyID = @CompanyID)
		DECLARE @Date2 datetime = (SELECT ValidTillR3 FROM CustomersDiscounts 
			WHERE CompanyID = @CompanyID AND CustomerID = @CustomerID)
		IF @OrderDate < @Date2
		BEGIN
			UPDATE Orders
				SET PercentageDiscount = PercentageDiscount + @R3
				WHERE OrderID = @OrderID
			UPDATE CustomersDiscounts
				SET ValidTillR3 = @OrderDate
				WHERE CustomerID = @CustomerID AND CompanyID = @CompanyID
		END
		ELSE
			PRINT('Zabat R3 jest nieaktywny')
	END

	--naliczanie rabatu procentowego dla firm
	IF @FR1Disc = 'Y' AND @CustomerType = 'B'
	BEGIN
		DECLARE @FR1 decimal(3,2) = (SELECT FR1 FROM DiscountsData WHERE CompanyID = @CompanyID)
		DECLARE @MonthsWithFK1 int = (SELECT MonthsWithFK1 FROM CustomersDiscounts 
			WHERE CompanyID = @CompanyID AND CustomerID = @CustomerID)
		UPDATE Orders
			SET PercentageDiscount = PercentageDiscount + @FR1*@MonthsWithFK1
			WHERE OrderID = @OrderID
	END

	--naliczenie rabatu kwotowego dla firm
	IF @FR1Disc = 'Y' AND @CustomerType = 'B'
	BEGIN
		DECLARE @QuarterDiscount int = (SELECT QuarterDiscount FROM CustomersDiscounts 
			WHERE CompanyID = @CompanyID AND CustomerID = @CustomerID)
		IF @QuarterDiscount < (SELECT [Sum] FROM OrdersData WHERE OrderID = @OrderID)
			SET @QuarterDiscount = (SELECT [Sum] FROM OrdersData WHERE OrderID = @OrderID)
		UPDATE Orders
			SET DisposableDiscount = 
				DisposableDiscount + @QuarterDiscount
		UPDATE CustomersDiscounts
			SET QuarterDiscount = 0
			WHERE CustomerID = @CustomerID AND CompanyID = @CompanyID
	END
END
GO


--Złożenie rezerwacji
CREATE or ALTER PROCEDURE AddNewReservation
	@ReservationDate datetime,
	@NumberOfPeople int,
	@OrderID int,
	@CustomerID int,
	@CompanyID int,
	@EmployeeID int,
	@TakeAway varchar(1)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ReservationID int=(SELECT ISNULL(MAX(ReservationID),0) FROM Reservations)
	IF (@NumberOfPeople>=2 AND [dbo].ReservationConditions(@OrderID)=1 AND [dbo].AvailablePlace(@CompanyID,@ReservationDate)>=@NumberOfPeople
	AND [dbo].ContainsSeaFoodOrder(@OrderID)=1 AND DATEPART(weekday,@ReservationDate)>=4
	AND DATEDIFF(day,(SELECT OrderDate FROM Orders WHERE OrderID=@OrderID),@ReservationDate)>=3+DATEPART(weekday,@ReservationDate)-4)
		INSERT INTO Reservations(ReservationID,OrderID,ReservationDate)
		VALUES(@ReservationID,@OrderID,@ReservationDate)
	ELSE
		THROW 50005, N'An error occurred', 1;
END
GO

--Dodanie uczestników rezerwacji
CREATE or ALTER PROCEDURE AddParticipantsToReservation
	@ReservationID int,
	@Name varchar(40),
	@Surname varchar(40)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @GuestID int=(SELECT ISNULL(MAX(GuestID),1) FROM ReservationDetails)
	INSERT INTO ReservationDetails(ReservationID,GuestID,Name,Surname)
	VALUES(@ReservationID,@GuestID,@Name,@Surname)
END
GO

--Zatwierdzenie rezerwacji
CREATE or ALTER PROCEDURE SubmitReservation
	@ReservationID int,
	@SubmissionDate date
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Reservations
	SET SubmissionDate=@SubmissionDate
	WHERE ReservationID=@ReservationID
END
GO

--Odwolanie rezerwacji
CREATE or ALTER PROCEDURE DeleteReservation
	@ReservationID int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE Orders WHERE OrderID=(SELECT OrderID FROM Reservations WHERE ReservationID=@ReservationID)
	DELETE Reservations WHERE ReservationID=@ReservationID
END
GO

--Zatwierdzenie obecnosci uczestnika
CREATE or ALTER PROCEDURE ConfirmAttendance
	@ReservationID int,
	@Name varchar(40),
	@Surname varchar(40),
	@Presence varchar(1)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE ReservationDetails
	SET Presence=@Presence
	WHERE ReservationID=@ReservationID AND Name=@Name AND Surname=@Surname
END
GO

--Dodanie stolika do zamówienia
CREATE or ALTER PROCEDURE AddTableToOrder
	@OrderID int,
	@CompanyID int,
	@TableID int,
	@OrderedChairs int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @OrderDate datetime = (SELECT OrderDate FROM Orders WHERE OrderID = @OrderID)
	DECLARE @IntervalID int = [dbo].GetRestaurantIntervalID(@CompanyID, @OrderDate)
	DECLARE @ChairsInTable int = (SELECT AvailableChairs FROM IntervalDetails WHERE IntervalID = @IntervalID AND TableID = @TableID)
	DECLARE @OccupiedChairs int = (
		SELECT SUM(OccupiedChairs) 
		FROM OrderedTables as OT
		INNER JOIN Orders as O
		ON O.OrderID = OT.OrderID
		WHERE TableID = @TableID AND IntervalID = @IntervalID AND O.OrderDate > @OrderDate AND O.CompletionDate < @OrderDate AND O.Valid = 'Y')
	IF @OrderedChairs <= @ChairsInTable - @OccupiedChairs 
		INSERT INTO OrderedTables(OrderID,IntervalID,TableID,OccupiedChairs)
		VALUES(@OrderID,@IntervalID,@TableID,@OccupiedChairs)
	ELSE
		THROW 50005, 'Not enought chairs', 1
END
GO

--Zmiana wartosci zni¿ek w firmie
CREATE or ALTER PROCEDURE ChangeDiscountsData
	@CompanyID int,
	@Z1 int,
	@R1 decimal(3,2),
	@R2 decimal (3,2),
	@R3 decimal(3,2),
	@K1 money,
	@K2 money,
	@K3 money,
	@D1 int,
	@D2 int,
	@FZ int,
	@FK1 money,
	@FR1 decimal(3,2),
	@FM decimal(3,2),
	@FK2 money,
	@FR2 decimal(3,2)
AS
BEGIN
	SET NOCOUNT ON;
	IF @Z1 IS NOT NULL
		UPDATE DiscountsData
		SET Z1=@Z1
		WHERE CompanyID=@CompanyID
	IF @R1 IS NOT NULL
		UPDATE DiscountsData
		SET R1=@R1
		WHERE CompanyID=@CompanyID
	IF @R2 IS NOT NULL
		UPDATE DiscountsData
		SET R2=@R2
		WHERE CompanyID=@CompanyID
	IF @R3 IS NOT NULL
		UPDATE DiscountsData
		SET R3=@R3
		WHERE CompanyID=@CompanyID
	IF @K1 IS NOT NULL
		UPDATE DiscountsData
		SET K1=@K1
		WHERE CompanyID=@CompanyID
	IF @K2 IS NOT NULL
		UPDATE DiscountsData
		SET K2=@K2
		WHERE CompanyID=@CompanyID
	IF @K3 IS NOT NULL
		UPDATE DiscountsData
		SET K3=@K3
		WHERE CompanyID=@CompanyID
	IF @D1 IS NOT NULL
		UPDATE DiscountsData
		SET D1=@D1
		WHERE CompanyID=@CompanyID
	IF @D2 IS NOT NULL
		UPDATE DiscountsData
		SET D2=@D2
		WHERE CompanyID=@CompanyID
	IF @FZ IS NOT NULL
		UPDATE DiscountsData
		SET FZ=@FZ
		WHERE CompanyID=@CompanyID
	IF @FK1 IS NOT NULL
		UPDATE DiscountsData
		SET FK1=@FK1
		WHERE CompanyID=@CompanyID
	IF @FR1 IS NOT NULL
		UPDATE DiscountsData
		SET FR1=@FR1
		WHERE CompanyID=@CompanyID
	IF @FM IS NOT NULL
		UPDATE DiscountsData
		SET FM=@FM
		WHERE CompanyID=@CompanyID
	IF @FK2 IS NOT NULL
		UPDATE DiscountsData
		SET FK2=@FK2
		WHERE CompanyID=@CompanyID
	IF @FR2 IS NOT NULL
		UPDATE DiscountsData
		SET FR2=@FR2
		WHERE CompanyID=@CompanyID
END
GO

-- Wyswietla ID potraw znajduj¹cych siê w danym menu
CREATE or ALTER PROCEDURE MenuCourses
	@MenuID int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CourseID
	FROM MenuDetails
	WHERE MenuID = @MenuID
END
GO

-- Wywietla ID sk³adników dañ 
CREATE or ALTER PROCEDURE CoursesIngrediens
	@ListOfCourses CoursesList READONLY
AS
BEGIN
	SET NOCOUNT ON;
	SELECT IngredientID
	FROM [Contains]
	WHERE CourseID in (SELECT CourseID FROM @ListOfCourses)
END
GO

-- sk³adnik jakie dania
--TODO

-- Wywietla klientów którzy z³o¿yli jakie zamówienia w danej restauracji
CREATE or ALTER PROCEDURE RestaurantCustomers
	@RestaurantID int
AS
BEGIN
	SET NOCOUNT ON
	SELECT CustomerID
	FROM CustomersDiscounts
	WHERE CompanyID = @RestaurantID
END
GO

-- Wywietla ID zamówieñ w okrelonej restauracji które odbywaj¹ siê w okrelonym przedziale czasowym
CREATE or ALTER PROCEDURE RestaurantOrdersInTimeInterval
	@RestaurantID int,
	@StartTime datetime,
	@EndTime datetime
AS
BEGIN
	SET NOCOUNT ON
	SELECT OrderID
	FROM Orders
	WHERE CompanyID = @RestaurantID and (
	(OrderDate > @StartTime and OrderDate < @EndTime) or (CompletionDate > @StartTime and CompletionDate < @EndTime))
END
GO

-- Wywietla listê zaproszonych pracowników dla danego zamówienia
CREATE or ALTER PROCEDURE InvitedPeople
	@ReservationID int
AS
BEGIN
	SET NOCOUNT ON
	SELECT *
	FROM ReservationDetails
	where ReservationID = @ReservationID
END
GO

-- Zwraca przysz³e zamówiania z dan¹ pozycj¹ w Menu dla danej restauracji
CREATE or ALTER PROCEDURE FutureOrdersWithIngredient
	@RestaurantID int,
	@IngredientID int
AS
BEGIN
	SET NOCOUNT ON
	SELECT *
	FROM Orders as O
	INNER JOIN OrderDetails as OD
	on O.OrderID = OD.OrderID
	INNER JOIN Courses as C
	on C.CourseID = OD.OrderID
	INNER JOIN Ingredients as I
	on I.IngredientID = C.CourseID
	where O.OrderDate > GETDATE() and O.CompanyID = @RestaurantID and I.IngredientID = @IngredientID
END
GO

-- Zwraca szczegó³y zamówiania
CREATE or ALTER PROCEDURE GetOrderDetails
	@OrderID int
AS
BEGIN
	SET NOCOUNT ON
	SELECT *
	FROM OrderDetails 
	where OrderID = @OrderID
END
GO

-- Wywietla informacje o tym jakie dania jak czêsto by³y zamawiane w danym przedziale czasu
CREATE or ALTER PROCEDURE OrderedCoursesStats
	@RestaurantID int,
	@StartTime datetime,
	@EndTime datetime = GETDATE
AS
BEGIN
	SET NOCOUNT ON
	SELECT OD.CourseID, sum(OD.Quantity) as TotalQuantity
	FROM OrderDetails as OD
	INNER JOIN Orders as O
	on O.OrderID = OD.OrderID
	WHERE O.CompanyID = @RestaurantID and O.OrderDate > @StartTime and O.OrderDate < @EndTime
	GROUP BY OD.CourseID
END
GO

-- Wywietla informacje o tym jakie stoliki jak czêsto by³y zamawiane w danym przedziale czasu
CREATE or ALTER PROCEDURE OrderedTablesStats
	@RestaurantID int,
	@StartTime datetime,
	@EndTime datetime = GETDATE
AS
BEGIN
	SET NOCOUNT ON
	SELECT OD.TableID, count(*) as TotalTableReservation
	FROM OrderedTables as OD
	INNER JOIN Orders as O
	on O.OrderID = OD.OrderID
	where O.CompanyID = @RestaurantID and O.OrderDate > @StartTime and O.OrderDate < @EndTime
	group by OD.TableID
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
--Wyświetlenie danych klienta, który złożył zamówienie
CREATE OR ALTER PROCEDURE ShowCustomerData
	@CustomerID int
AS
BEGIN
	SET NOCOUNT ON
	IF (SELECT CustomerType FROM Customers WHERE CustomerID=@CustomerID)='I'
		SELECT Address,City,PostalCode,Country,Phone,Email,FirstName,LastName,BirthDate,PESEL
		FROM Customers,IndividualCustomers
		WHERE Customers.CustomerID=@CustomerID AND IndividualCustomers.CustomerID=@CustomerID
	ELSE
		SELECT Address,City,PostalCode,Country,Phone,Email,CompanyName,NIP,Fax
		FROM Customers,BusinessCustomers
		WHERE Customers.CustomerID=@CustomerID AND BusinessCustomers.CustomerID=@CustomerID
END
GO

--Wyświetlenie danych zamówienia 
CREATE OR ALTER PROCEDURE ShowOrderData
	@OrderID int
AS
BEGIN
	SET NOCOUNT ON
	SELECT * 
	FROM OrdersData
	where OrderID = @OrderID
END
GO

--Pokazuje kiedy można zamówić dane danie w restauracji
CREATE OR ALTER PROCEDURE WhenCourseCanBeOrdered
	@CourseID int,
	@CompanyID int
AS
BEGIN
	SET NOCOUNT ON
	SELECT InDate, OutDate
	FROM CoursesAvailability
	WHERE CourseID = @CourseID and CompanyID = @CompanyID
END
GO

--Wyświetlenie danych klienta, który złożył zamówienie
CREATE OR ALTER PROCEDURE ShowCustomerData
	@OrderID int
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CustomerID int=[dbo].GetCustomerID(@OrderID)
	IF (SELECT CustomerType FROM Customers WHERE CustomerID=@CustomerID)='I'
		SELECT Address,City,PostalCode,Country,Phone,Email,FirstName,LastName,BirthDate,PESEL
		FROM Customers,IndividualCustomers
		WHERE Customers.CustomerID=@CustomerID AND IndividualCustomers.CustomerID=@CustomerID
	ELSE
		SELECT Address,City,PostalCode,Country,Phone,Email,CompanyName,NIP,Fax
		FROM Customers,BusinessCustomers
		WHERE Customers.CustomerID=@CustomerID AND BusinessCustomers.CustomerID=@CustomerID
END
GO

--Aktualizacja rabatów miesięcznych
CREATE OR ALTER PROCEDURE UpdateBusinessMonthlyDiscount
	@CompanyID int,
	@MonthStart date
AS
BEGIN
	DECLARE @MonthEnd date = DATEADD(M,1,@MonthStart)
	DECLARE @ProfitableCustomers TABLE(CustomerID int) --klienci który zamówili za odpowiednią kwotę
	DECLARE @MinSum money = (SELECT FK1 FROM DiscountsData WHERE CompanyID = @CompanyID)
	DECLARE @MinOrders int = (SELECT FZ FROM DiscountsData WHERE CompanyID = @CompanyID)
	INSERT INTO @ProfitableCustomers 
		SELECT CustomerID
		FROM OrdersData 
		WHERE CompanyID = @CompanyID AND OrderDate >= @MonthStart AND OrderDate <= @MonthEnd
		GROUP BY CustomerID
		HAVING SUM([Sum]) >= @MinSum and COUNT(*) >= @MinOrders
	UPDATE CustomersDiscounts -- update dla zamawiających klientów 
		SET MonthsWithFK1 = MonthsWithFK1+1
		WHERE CustomerID IN (SELECT CustomerID FROM @ProfitableCustomers)
	UPDATE CustomersDiscounts -- update dla zamawiających klientów 
		SET MonthsWithFK1 = 0
		WHERE CustomerID NOT IN (SELECT CustomerID FROM @ProfitableCustomers)
END
GO

--Aktualizacja rabatów kwartalnych
CREATE OR ALTER PROCEDURE UpdateBusinessQuarterDiscount
	@CompanyID int,
	@QuarerStart date
AS
BEGIN
	DECLARE @QuarerEnd date = DATEADD(M,1,@QuarerStart)
	DECLARE @ProfitableCustomers TABLE(CustomerID int, [Sum] money) --klienci który zamówili za odpowiednią kwotę
	DECLARE @MinSum money = (SELECT FK2 FROM DiscountsData WHERE CompanyID = @CompanyID)
	DECLARE @FR2 decimal(3,2) = (SELECT FR2 FROM DiscountsData WHERE CompanyID = @CompanyID)
	INSERT INTO @ProfitableCustomers 
		SELECT CustomerID, SUM([Sum])
		FROM OrdersData 
		WHERE CompanyID = @CompanyID AND OrderDate >= @QuarerStart AND OrderDate <= @QuarerEnd
		GROUP BY CustomerID
		HAVING SUM([Sum]) >= @MinSum
	UPDATE CustomersDiscounts -- update dla zamawiających klientów 
		SET QuarterDiscount = [Sum]*@FR2
		FROM CustomersDiscounts as CD
		LEFT OUTER JOIN @ProfitableCustomers as PC
		ON PC.CustomerID = CD.CustomerID
		WHERE CD.CustomerID IN (SELECT CustomerID FROM @ProfitableCustomers)
	UPDATE CustomersDiscounts -- update dla zamawiających klientów 
		SET QuarterDiscount = 0
		WHERE CustomerID NOT IN (SELECT CustomerID FROM @ProfitableCustomers)
END
GO
--pokazuje statystyki zamówień klienta w firmie
CREATE OR ALTER PROCEDURE ShowCustomerOrdersData
	@CustomerID int,
	@CompanyID int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT OrderID, OrderDate, Sum,DisposableDiscount,PercentageDiscount, Valid
	FROM OrdersData
	WHERE CustomerID=@CustomerID AND CompanyID=@CompanyID
END
GO
