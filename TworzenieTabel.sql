
-- tables
-- Table: BusinessCustomers
CREATE TABLE BusinessCustomers (
    CustomerID int  NOT NULL,
    CompanyName varchar(50)  NOT NULL,
    NIP varchar(10)  NOT NULL,
    Fax varchar(20) NULL,
    CONSTRAINT BusinessCustomers_pk PRIMARY KEY  (CustomerID),
	CONSTRAINT NIPUnique unique (NIP),
	CONSTRAINT NIPCheck check (NIP NOT LIKE '%^[0-9]%' AND DATALENGTH(NIP)=10),
	INDEX companyname_index (CompanyName)
);

-- Table: Categories
CREATE TABLE Categories (
    CategoryID int  NOT NULL,
    CategoryName varchar(15)  NOT NULL,
    Description text NULL,
    CONSTRAINT Categories_pk PRIMARY KEY  (CategoryID),
	CONSTRAINT CN_Unique unique (CategoryName)
);

-- Table: Company
CREATE TABLE Company (
    CompanyID int  NOT NULL,
    CompanyName varchar(50)  NOT NULL,
    FloorSpace int NULL,
    Address varchar(40)  NOT NULL,
    City varchar(20)  NOT NULL,
    Region varchar(20) NULL,
    PostalCode varchar(10)  NOT NULL,
    Country varchar(20)  NOT NULL DEFAULT 'Poland',
    Phone varchar(20)  NOT NULL,
    NIP varchar(10)  NOT NULL,
    Fax varchar(20) NULL,
    ReservationMinAmount money  NOT NULL DEFAULT 200,
    ReservationMinAmountRegularClients money  NOT NULL DEFAULT 50,
    CONSTRAINT Company_pk PRIMARY KEY  (CompanyID),
	CONSTRAINT CompanyName_Unique unique(CompanyName),
	CONSTRAINT NIPUnique_1 unique(NIP),
	CONSTRAINT NIPCheck_1 check (NIP NOT LIKE '%^[0-9]%' AND DATALENGTH(NIP)=10),
	CONSTRAINT ReservationMinAmountCheck check (ReservationMinAmount>=0),
	CONSTRAINT ReservationMinAmountRegularClientsCheck check (ReservationMinAmountRegularClients>=0),
	INDEX companyname_index (CompanyName)
);

-- Table: Contains
CREATE TABLE "Contains" (
    CourseID int  NOT NULL,
    IngredientID int  NOT NULL,
    CONSTRAINT Contains_pk PRIMARY KEY  (CourseID,IngredientID),
    	INDEX course_index (CourseID),
	INDEX ingredient_index (IngredientID)
);

-- Table: Courses
CREATE TABLE Courses (
    CourseID int  NOT NULL,
    CourseName varchar(50)  NOT NULL,
    Description text NULL,
    CONSTRAINT Courses_pk PRIMARY KEY  (CourseID)
);

-- Table: Customers
CREATE TABLE Customers (
    CustomerID int  NOT NULL,
    Address varchar(40)  NULL,
    City varchar(20)   NULL,
    PostalCode varchar(10)  NULL,
    Country varchar(20)  NULL,
    Phone varchar(20)  NULL,
    Email varchar(20)  NULL,
    CustomerType varchar(1)  NOT NULL,
    CONSTRAINT Customers_pk PRIMARY KEY  (CustomerID),
	CONSTRAINT CustomerTypeCheck check (CustomerType='I' OR CustomerType='B'),
	INDEX customer_type_index (CustomerType)
);

-- Table: CustomersDiscounts
CREATE TABLE CustomersDiscounts (
    CompanyID int  NOT NULL,
    CustomerID int  NOT NULL,
    OrdersWithK1 int  NOT NULL DEFAULT 0,
    ValidTillR2 date   NULL DEFAULT NULL,
    ValidTillR3 date   NULL DEFAULT NULL,
    MonthsWithFK1 int   NOT NULL DEFAULT 0,
    QuarterDiscount money  NOT NULL DEFAULT 0,
    CONSTRAINT CustomersDiscount_pk PRIMARY KEY  (CompanyID,CustomerID),
	CONSTRAINT OrdersWithK1Check check (OrdersWithK1>=0),
	CONSTRAINT MonthsWithFK1Check check (MonthsWithFK1>=0),
	CONSTRAINT QuarterDiscountCheck check (QuarterDiscount>=0),
	INDEX  companyid_index (CompanyID),
	INDEX customerid_index (CustomerID)
);

-- Table: DiscountsData
CREATE TABLE DiscountsData (
    CompanyID int  NOT NULL,
    Z1 int  NOT NULL DEFAULT 10,
    R1 decimal(3,2)  NOT NULL DEFAULT 0.03,
    R2 decimal(3,2)  NOT NULL DEFAULT 0.05,
    R3 decimal(3,2)  NOT NULL DEFAULT 0.05,
    K1 money  NOT NULL DEFAULT 30,
    K2 money  NOT NULL DEFAULT 1000,
    K3 money  NOT NULL DEFAULT 5000,
    D1 int  NOT NULL DEFAULT 7,
    D2 int  NOT NULL DEFAULT 7,
    FZ int  NOT NULL DEFAULT 5,
	FM decimal(3,2)  NOT NULL DEFAULT 0.04,
    FK1 money  NOT NULL DEFAULT 500,
	FK2 money  NOT NULL DEFAULT 10000,
    FR1 decimal(3,3)  NOT NULL DEFAULT 0.001,
    FR2 decimal(3,2)  NOT NULL DEFAULT 0.05,
    CONSTRAINT DiscountsData_pk PRIMARY KEY  (CompanyID),
	CONSTRAINT Z1Check check (Z1>=1),
	CONSTRAINT R1Check check (R1>=0 AND R1<=100),
	CONSTRAINT R2Check check (R2>=0 AND R2<=100),
	CONSTRAINT R3Check check (R3>=0 AND R3<=100),
	CONSTRAINT K1Check check (K1>=0),
	CONSTRAINT K2Check check (K2>=0),
	CONSTRAINT K3Check check (K3>=0),
	CONSTRAINT D1Check check (D1>=0),
	CONSTRAINT D2Check check (D2>=0),
	CONSTRAINT FZCheck check (FZ>=0),
	CONSTRAINT FMCheck check (FM>=0 AND FM<=100),
	CONSTRAINT FK1Check check (FK1>=0),
	CONSTRAINT FK2Check check (FK2>=0),
	CONSTRAINT FR1Check check (FR1>=0 AND FR1<=100),
	CONSTRAINT FR2Check check (FR2>=0 AND FR2<=100)
);

-- Table: Employees
CREATE TABLE Employees (
    EmployeeID int  NOT NULL,
    Firstname varchar(20)  NOT NULL,
    LastName varchar(30)  NOT NULL,
    Title varchar(30) NULL,
    CompanyID int  NOT NULL,
    TitleOfCourtesy varchar(5) NULL,
    BirthDate date  NOT NULL,
    HireDate date  NOT NULL,
    FireDate date  NULL,
    Address varchar(40)  NOT NULL,
    City varchar(20)  NOT NULL,
    Region varchar(20) NULL,
    PostalCode varchar(10)  NOT NULL,
    Country varchar(20)  NOT NULL,
    Phone varchar(20)  NOT NULL,
    Notes text NULL,
    CONSTRAINT EmployeeID PRIMARY KEY  (EmployeeID),
	INDEX companyid_index (CompanyID),
	INDEX fullname_index  (Firstname,Lastname)
);

-- Table: IndividualCustomers
CREATE TABLE IndividualCustomers (
    CustomerID int  NOT NULL,
    Firstname varchar(20)  NOT NULL,
    Lastname varchar(30)  NOT NULL,
    BirthDate date  NULL,
    PESEL varchar(11) NULL,
    CONSTRAINT IndividualCustomers_pk PRIMARY KEY  (CustomerID),
	INDEX fullname_index (Firstname,Lastname)
);

-- Table: Ingredients
CREATE TABLE Ingredients (
    IngredientID int  NOT NULL,
    IngredientName varchar(20)  NOT NULL,
    SeaFood varchar(1)  NOT NULL DEFAULT 'N',
    CONSTRAINT Ingredients_pk PRIMARY KEY  (IngredientID),
	CONSTRAINT SeaFoodCheck check (SeaFood='Y' OR SeaFood='N'),
	INDEX seafood_index (SeaFood)
);

-- Table: IntervalDetails
CREATE TABLE IntervalDetails (
    TableID int  NOT NULL,
    IntervalID int  NOT NULL,
    AvailableChairs int  NOT NULL,
    CONSTRAINT IntervalDetails_pk PRIMARY KEY  (IntervalID,TableID),
	CONSTRAINT AvailableChairsCheck check (AvailableChairs>=0),
	INDEX tableid_index (TableID),
	INDEX intervalid_index (IntervalID)
);

-- Table: Intervals
CREATE TABLE Intervals (
    IntervalID int  NOT NULL,
    CompanyID int  NOT NULL,
    BeginningDate date  NOT NULL,
    EndDate date NULL,
    CONSTRAINT Intervals_pk PRIMARY KEY  (IntervalID),
    	CONSTRAINT DateCheck check (BeginningDate<=ISNULL(EndDate,BeginningDate)),
	INDEX companyid_index (CompanyID)
);

-- Table: Menu
CREATE TABLE Menu (
    MenuID int  NOT NULL,
    CompanyID int  NOT NULL,
    InDate date  NOT NULL,
    OutDate date NULL,
    CONSTRAINT Menu_pk PRIMARY KEY  (MenuID),
    	CONSTRAINT DateCheck_1 check (InDate<=ISNULL(OutDate,InDate)),
	INDEX companyid_index (CompanyID)					 					 
);

-- Table: MenuDetails
CREATE TABLE MenuDetails (
    MenuID int  NOT NULL,
    CourseID int  NOT NULL,
    CategoryID int  NOT NULL,
    UnitPrice money  NOT NULL,
    CONSTRAINT MenuDetails_pk PRIMARY KEY  (MenuID,CourseID),
	CONSTRAINT UnitPriceCheck check (UnitPrice>=0),
	INDEX menuid_index (MenuID),
	INDEX courseid_index (CourseID)
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
    OrderID int  NOT NULL,
    CourseID int  NOT NULL,
    MenuID int  NOT NULL,
    Quantity int  NOT NULL,
    CONSTRAINT OrderDetails_pk PRIMARY KEY  (OrderID,CourseID),
	CONSTRAINT QuantityCheck check (Quantity>=0),
	INDEX orderid_index (OrderID),
	INDEX courseid_index (CourseID)
);

-- Table: OrderedTables
CREATE TABLE OrderedTables (
    OrderID int  NOT NULL,
    IntervalID int  NOT NULL,
    TableID int  NOT NULL,
    OccupiedChairs int  NOT NULL,
    CONSTRAINT OrderedTables_pk PRIMARY KEY  (OrderID,TableID),
	CONSTRAINT OccupiedChairsCheck check (OccupiedChairs>0),
	INDEX orderid_index (OrderID),
	INDEX tableid_index (TableID)
);

-- Table: Orders
CREATE TABLE Orders (
    OrderID int  NOT NULL,
    EmployeeID int NULL,
    CustomerID int NULL,
    CompanyID int  NOT NULL,
    OrderDate datetime  NOT NULL,
    CompletionDate datetime NULL,
    TakeAway varchar(1)  NOT NULL,
    DisposableDiscount money  NOT NULL DEFAULT 0,
    PercentageDiscount decimal(4,3)  NOT NULL DEFAULT 0,
    Valid varchar(1) NOT NULL DEFAULT 'Y',
    CONSTRAINT OrderID PRIMARY KEY  (OrderID),
	CONSTRAINT TakeAwayCheck check (TakeAway='Y' OR TakeAway='N'),
	CONSTRAINT DisposableDiscountCheck check (DisposableDiscount>=0),
	CONSTRAINT PercentageDisscountCheck check (PercentageDiscount>=0 AND PercentageDiscount<=100),
	CONSTRAINT DateCheck_2 check (OrderDate<=(ISNULL(CompletionDate,OrderDate))),
	INDEX employeeid_index (EmployeeID),
	INDEX customerid_index (CustomerID),
	INDEX companyid_index (CompanyID),
	INDEX valid_index (Valid),
	INDEX takeaway_index (TakeAway),
	INDEX orderdate_index (OrderDate)
	
);

-- Table: ReservationDetails
CREATE TABLE ReservationDetails (
    ReservationID int  NOT NULL,
    GuestID int NOT NULL,
    Name varchar(40)  NOT NULL,
    Surname varchar(40)  NOT NULL,
    Presence varchar(1)  NOT NULL DEFAULT 'Y',
    CONSTRAINT ReservationDetails_pk PRIMARY KEY  (ReservationID,GuestID),
	CONSTRAINT U_GuestID UNIQUE(GuestID),
	CONSTRAINT PresenceCheck check (Presence='Y' OR Presence='N'),
	INDEX presence_index (Presence)
);

-- Table: Reservations
CREATE TABLE Reservations (
    ReservationID int  NOT NULL,
    OrderID int  NOT NULL,
    ReservationDate datetime  NOT NULL,
    SubmissionDate datetime NULL,
    CONSTRAINT Reservations_pk PRIMARY KEY  (ReservationID),
	INDEX reservationdate_index (ReservationDate),
	INDEX orderid_index (OrderID)
);

-- Table: Tables
CREATE TABLE Tables (
    TableID int  NOT NULL,
    CompanyID int  NOT NULL,
    NumberOfChairs int  NOT NULL,
    Description varchar(50) NULL,
    CONSTRAINT Tables_pk PRIMARY KEY (TableID),
	CONSTRAINT NumberOfChairsCheck check (NumberOfChairs>=0),
	INDEX companyid_index (CompanyID)
);

-- foreign keys
-- Reference: Contains_Ingredients (table: Contains)
ALTER TABLE "Contains" ADD CONSTRAINT Contains_Ingredients
    FOREIGN KEY (IngredientID)
    REFERENCES Ingredients (IngredientID);



-- Reference: Courses_Contains (table: Contains)
ALTER TABLE "Contains" ADD CONSTRAINT Courses_Contains
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: CustomersDiscount_Customers (table: CustomersDiscounts)
ALTER TABLE CustomersDiscounts ADD CONSTRAINT CustomersDiscount_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: CustomersDiscount_DiscountsData (table: CustomersDiscounts)
ALTER TABLE CustomersDiscounts ADD CONSTRAINT CustomersDiscount_DiscountsData
    FOREIGN KEY (CompanyID)
    REFERENCES DiscountsData (CompanyID);

-- Reference: Customers_BusinessCustomers (table: BusinessCustomers)
ALTER TABLE BusinessCustomers ADD CONSTRAINT Customers_BusinessCustomers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: Customers_IndividualCustomers (table: IndividualCustomers)
ALTER TABLE IndividualCustomers ADD CONSTRAINT Customers_IndividualCustomers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: DiscountsData_Company (table: DiscountsData)
ALTER TABLE DiscountsData ADD CONSTRAINT DiscountsData_Company
    FOREIGN KEY (CompanyID)
    REFERENCES Company (CompanyID);

-- Reference: Employees_Company (table: Employees)
ALTER TABLE Employees ADD CONSTRAINT Employees_Company
    FOREIGN KEY (CompanyID)
    REFERENCES Company (CompanyID);

-- Reference: MenuDetails_Categories (table: MenuDetails)
ALTER TABLE MenuDetails ADD CONSTRAINT MenuDetails_Categories
    FOREIGN KEY (CategoryID)
    REFERENCES Categories (CategoryID);

-- Reference: MenuDetails_Courses (table: MenuDetails)
ALTER TABLE MenuDetails ADD CONSTRAINT MenuDetails_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: MenuDetails_Menu (table: MenuDetails)
ALTER TABLE MenuDetails ADD CONSTRAINT MenuDetails_Menu
    FOREIGN KEY (MenuID)
    REFERENCES Menu (MenuID);

-- Reference: Menu_Company (table: Menu)
ALTER TABLE Menu ADD CONSTRAINT Menu_Company
    FOREIGN KEY (CompanyID)
    REFERENCES Company (CompanyID);

-- Reference: OrderDetails_MenuDetails (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_MenuDetails
    FOREIGN KEY (MenuID,CourseID)
    REFERENCES MenuDetails (MenuID,CourseID);

-- Reference: OrderedTables_Orders (table: OrderedTables)
ALTER TABLE OrderedTables ADD CONSTRAINT OrderedTables_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: OrderedTables_TablesInInterval (table: OrderedTables)
ALTER TABLE OrderedTables ADD CONSTRAINT OrderedTables_TablesInInterval
    FOREIGN KEY (IntervalID,TableID)
    REFERENCES IntervalDetails (IntervalID,TableID);

-- Reference: Orders_Company (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Company
    FOREIGN KEY (CompanyID)
    REFERENCES Company (CompanyID);

-- Reference: Orders_Customers (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);

-- Reference: Orders_Employees (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES Employees (EmployeeID);

-- Reference: Orders_OrderDetails (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT Orders_OrderDetails
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: Reservation_ReservationsDetails (table: ReservationDetails)
ALTER TABLE ReservationDetails ADD CONSTRAINT Reservation_ReservationsDetails
    FOREIGN KEY (ReservationID)
    REFERENCES Reservations (ReservationID);

-- Reference: Reservations_Orders (table: Reservations)
ALTER TABLE Reservations ADD CONSTRAINT Reservations_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: TablesInInterval_Tables (table: IntervalDetails)
ALTER TABLE IntervalDetails ADD CONSTRAINT TablesInInterval_Tables
    FOREIGN KEY (TableID)
    REFERENCES Tables (TableID);

-- Reference: TablesInInterval_TablesInInterval (table: IntervalDetails)
ALTER TABLE IntervalDetails ADD CONSTRAINT TablesInInterval_TablesInInterval
    FOREIGN KEY (IntervalID)
    REFERENCES Intervals (IntervalID);

-- Reference: TablesIntervals_Company (table: Intervals)
ALTER TABLE Intervals ADD CONSTRAINT TablesIntervals_Company
    FOREIGN KEY (CompanyID)
    REFERENCES Company (CompanyID);

-- Reference: Tables_Company (table: Tables)
ALTER TABLE Tables ADD CONSTRAINT Tables_Company
    FOREIGN KEY (CompanyID)
    REFERENCES Company (CompanyID);

-- End of file.

