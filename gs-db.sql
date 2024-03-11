CREATE TABLE Store (
    StoreID INT,
    StoreName VARCHAR(30),
    Address VARCHAR(30),
    City VARCHAR(30),
    State VARCHAR(30),
    ZIPCode CHAR(5),
    Phone CHAR(10),
    StoreSize VARCHAR(10) CHECK (StoreSize IN ('Small', 'Medium', 'Large', 'Super')), 
    OpenDate DATE,
    CONSTRAINT Store_PK PRIMARY KEY (StoreID)
);

CREATE TABLE Department (
    DepartmentID INT,
    DepartmentName VARCHAR(30),
    StoreID INT,
    CONSTRAINT Department_PK PRIMARY KEY (DepartmentID),
    CONSTRAINT FK_Department_Store FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);

CREATE TABLE Aisle (
    AisleID INT,
    AisleNumber INT,
    StoreID INT,
    DepartmentID INT,
    CONSTRAINT Aisle_PK PRIMARY KEY (AisleID),
    CONSTRAINT FK_Aisle_Store FOREIGN KEY (StoreID) REFERENCES Store(StoreID),
    CONSTRAINT FK_Aisle_Department FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Employee (
    EmployeeID INT,
    FirstName VARCHAR(30),
    LastName VARCHAR(30),
    DateOfBirth DATE,
    HireDate DATE,
    Position VARCHAR(30),
    Salary DECIMAL(7,2),
    StoreID INT,
    CONSTRAINT Employee_PK PRIMARY KEY (EmployeeID),
    CONSTRAINT FK_Employee_Store FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);

CREATE TABLE Customer (
    CustomerID INT,
    FirstName VARCHAR(30),
    LastName VARCHAR(30),
    Email VARCHAR(30),
    Phone VARCHAR(30),
    LoyaltyCardNumber VARCHAR(30),
    CONSTRAINT Customer_PK PRIMARY KEY (CustomerID)
);

CREATE TABLE SalesTransaction (
    TransactionID INT,
    Date DATE,
    Time TIME,
    TotalAmount DECIMAL(9,2),
    EmployeeID INT,
    CustomerID INT, -- Added CustomerID column
    CONSTRAINT SalesTransaction_PK PRIMARY KEY (TransactionID),
    CONSTRAINT FK_SalesTransaction_Employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    CONSTRAINT FK_SalesTransaction_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE ReturnTransaction (
    ReturnID INT,
    TransactionID INT,
    Date DATE,
    Reason VARCHAR(30),
    EmployeeID INT,
    CONSTRAINT ReturnTransaction_PK PRIMARY KEY (ReturnID),
    CONSTRAINT FK_ReturnTransaction_SalesTransaction FOREIGN KEY (TransactionID) REFERENCES SalesTransaction(TransactionID),
    CONSTRAINT FK_ReturnTransaction_Employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE Categories (
    CategoryID INT,
    CategoryName VARCHAR(30),
    CategoryType VARCHAR(30),
    CONSTRAINT Categories_PK PRIMARY KEY (CategoryID)
);

CREATE TABLE Supplier (
    SupplierID INT,
    SupplierName VARCHAR(30),
    ContactName VARCHAR(30),
    Address VARCHAR(30),
    ContactEmail VARCHAR(30),
    Phone VARCHAR(30),
    CONSTRAINT Supplier_PK PRIMARY KEY (SupplierID)
);

CREATE TABLE Product (
    ProductID INT,
    ProductName VARCHAR(30),
    Description VARCHAR(30),
    CategoryID INT,
    SupplierID INT,
    Price DECIMAL(7,2),
    StockQuantity INT,
    CONSTRAINT Product_PK PRIMARY KEY (ProductID),
    CONSTRAINT FK_Product_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT FK_Product_Supplier FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

CREATE TABLE ProductTransaction (
    PTransactionID INT,
    ProductID INT,
    Quantity INT,
    Discount DECIMAL(5,2),
    SubTotal DECIMAL(9,2),
    CONSTRAINT PK_ProductTransaction PRIMARY KEY (PTransactionID),
    CONSTRAINT FK_ProductTransaction_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);


CREATE TABLE Payment (
    PaymentID INT,
    PTransactionID INT,
    PaymentType VARCHAR(30),
    PaymentAmount DECIMAL(9,2),
    Date DATE,
    CONSTRAINT Payment_PK PRIMARY KEY (PaymentID),
    CONSTRAINT FK_Payment_Transaction FOREIGN KEY (PTransactionID) REFERENCES ProductTransaction(PTransactionID)
);

CREATE TABLE Promotion (
    PromotionID INT,
    ProductID INT,
    StartDate DATE,
    EndDate DATE,
    DiscountPercentage DECIMAL(4,2),
    Description VARCHAR(30),
    CONSTRAINT Promotion_PK PRIMARY KEY (PromotionID),
    CONSTRAINT FK_Promotion_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);


CREATE TABLE Contracts (
    ContractID INT,
    StartDate DATE,
    EndDate DATE,
    SupplierID INT,
    CONSTRAINT Contracts_PK PRIMARY KEY (ContractID),
    CONSTRAINT FK_Contracts_Supplier FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

CREATE TABLE ShippingProvider (
    ProviderID INT,
    ProviderName VARCHAR(30),
    ContactInfo VARCHAR(30),
    ShippingRates VARCHAR(30),
    CONSTRAINT ShippingProvider_PK PRIMARY KEY (ProviderID)
);

CREATE TABLE Inventory (
    InventoryID INT,
    ProductID INT,
    StoreID INT,
    Quantity INT,
    CONSTRAINT Inventory_PK PRIMARY KEY (InventoryID),
    CONSTRAINT FK_Inventory_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    CONSTRAINT FK_Inventory_Store FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);

CREATE TABLE Orders (
    OrdersID INT,
    CustomerID INT,
    Date DATE,
    TotalAmount DECIMAL(9,2),
    DeliveryID INT, -- Keep this if you still need to store DeliveryID in Orders
    CONSTRAINT Orders_PK PRIMARY KEY (OrdersID),
    CONSTRAINT FK_Orders_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Delivery (
    DeliveryID INT,
    OrdersID INT,
    ProviderID INT,
    ShipDate DATE,
    ExpectedArrival DATE,
    Type VARCHAR(30),
    CONSTRAINT Delivery_PK PRIMARY KEY (DeliveryID),
    CONSTRAINT FK_Delivery_Orders FOREIGN KEY (OrdersID) REFERENCES Orders(OrdersID),
    CONSTRAINT FK_Delivery_Provider FOREIGN KEY (ProviderID) REFERENCES ShippingProvider(ProviderID)
);


CREATE TABLE LoyaltyProgram (
    ProgramID INT,
    ProgramName VARCHAR(30),
    PointsPerDollar DECIMAL(4,2),
    Description VARCHAR(30),
    CONSTRAINT LoyaltyProgram_PK PRIMARY KEY (ProgramID)
);

CREATE TABLE Feedback (
    FeedbackID INT,
    CustomerID INT,
    Date DATE,
    FeedbackText VARCHAR(30),
    Rating CHAR(1),
    CONSTRAINT Feedback_PK PRIMARY KEY (FeedbackID),
    CONSTRAINT FK_Feedback_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    CONSTRAINT CHK_Rating CHECK (Rating IN ('1', '2', '3', '4', '5'))
);




—-------INSERT DATA

-- Additional data for Store table
INSERT INTO Store (StoreID, StoreName, Address, City, State, ZIPCode, Phone, StoreSize, OpenDate)
VALUES 
  (2, 'Downtown Store', '456 Oak St', 'Downtownville', 'CA', '54321', '555-9876', 'Large', '2023-02-01'),
  (3, 'Suburb Store', '789 Maple Ave', 'Suburbia', 'CA', '67890', '555-5555', 'Small', '2023-03-01');

-- Additional data for Department table
INSERT INTO Department (DepartmentID, DepartmentName, StoreID)
VALUES 
  (2, 'Clothing', 2),
  (3, 'Home Goods', 3);

-- Additional data for Aisle table
INSERT INTO Aisle (AisleID, AisleNumber, StoreID, DepartmentID)
VALUES 
  (2, 20, 2, 2),
  (3, 30, 3, 3);

-- Additional data for Employee table
INSERT INTO Employee (EmployeeID, FirstName, LastName, DateOfBirth, HireDate, Position, Salary, StoreID)
VALUES 
  (2, 'Jane', 'Smith', '1992-05-20', '2023-02-01', 'Manager', 60000.00, 2),
  (3, 'Bob', 'Johnson', '1988-11-10', '2023-03-01', 'Cashier', 45000.00, 3);

-- Additional data for Customer table
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Phone, LoyaltyCardNumber)
VALUES 
  (2, 'Bob', 'Williams', 'bob@example.com', '555-4444', 'L54321'),
  (3, 'Charlie', 'Davis', 'charlie@example.com', '555-3333', 'L98765');

-- Additional data for SalesTransaction table
INSERT INTO SalesTransaction (TransactionID, Date, Time, TotalAmount, EmployeeID, CustomerID)
VALUES 
  (2, '2023-02-10', '14:45:00', 75.50, 2, 2),
  (3, '2023-03-05', '10:30:00', 30.75, 3, 3);

-- Additional data for ReturnTransaction table
INSERT INTO ReturnTransaction (ReturnID, TransactionID, Date, Reason, EmployeeID)
VALUES 
  (2, 2, '2023-02-15', 'Wrong size', 2),
  (3, 3, '2023-03-10', 'Defective item', 3);

-- Additional data for Categories table
INSERT INTO Categories (CategoryID, CategoryName, CategoryType)
VALUES 
  (2, 'Apparel', 'Clothing'),
  (3, 'Furniture', 'Home Furnishings');

-- Additional data for Supplier table
INSERT INTO Supplier (SupplierID, SupplierName, ContactName, Address, ContactEmail, Phone)
VALUES 
  (2, 'FashionSupplier', 'Sarah Fashion', '789 Style St', 'sarah@fashionsupplier.com', '555-2222'),
  (3, 'HomeGoodsCo', 'Michael Home', '101 Furnish Ave', 'michael@homegoodsco.com', '555-1111');

-- Additional data for Product table
INSERT INTO Product (ProductID, ProductName, Description, CategoryID, SupplierID, Price, StockQuantity)
VALUES 
  (2, 'T-shirt', 'Cotton T-shirt', 2, 2, 19.99, 100),
  (3, 'Coffee Table', 'Wooden Coffee Table', 3, 3, 129.99, 20);

-- Additional data for ProductTransaction table
INSERT INTO ProductTransaction (PTransactionID, ProductID, Quantity, Discount, SubTotal)
VALUES 
  (2, 2, 3, 5.00, 56.97),
  (3, 3, 1, 0.00, 129.99);

-- Additional data for Payment table
INSERT INTO Payment (PaymentID, PTransactionID, PaymentType, PaymentAmount, Date)
VALUES 
  (2, 2, 'Debit Card', 56.97, '2023-02-10'),
  (3, 3, 'Credit Card', 129.99, '2023-03-05');

-- Additional data for Promotion table
INSERT INTO Promotion (PromotionID, ProductID, StartDate, EndDate, DiscountPercentage, Description)
VALUES 
  (2, 2, '2023-02-01', '2023-02-28', 10.00, 'Valentine\'s Day Sale'),
  (3, 3, '2023-03-01', '2023-03-31', 0.00, 'No discount');

-- Additional data for Contracts table
INSERT INTO Contracts (ContractID, StartDate, EndDate, SupplierID)
VALUES 
  (2, '2023-02-01', '2023-12-31', 2),
  (3, '2023-03-01', '2023-12-31', 3);

-- Additional data for ShippingProvider table
INSERT INTO ShippingProvider (ProviderID, ProviderName, ContactInfo, ShippingRates)
VALUES 
  (2, 'StandardShip', 'info@standardship.com', 'Flat rate: $5'),
  (3, 'FurnitureExpress', 'support@furnitureexpress.com', 'Free shipping on furniture');

-- Additional data for Inventory table
INSERT INTO Inventory (InventoryID, ProductID, StoreID, Quantity)
VALUES 
  (2, 2, 2, 100),
  (3, 3, 3, 20);

-- Additional data for Orders table
INSERT INTO Orders (OrdersID, CustomerID, Date, TotalAmount, DeliveryID)
VALUES 
  (2, 2, '2023-02-10', 56.97, 2),
  (3, 3, '2023-03-05', 129.99, 3);

-- Additional data for Delivery table
INSERT INTO Delivery (DeliveryID, OrdersID, ProviderID, ShipDate, ExpectedArrival, Type)
VALUES 
  (2, 2, 2, '2023-02-10', '2023-02-15', 'Standard'),
  (3, 3, 3, '2023-03-05', '2023-03-10', 'Express');

-- Additional data for LoyaltyProgram table
INSERT INTO LoyaltyProgram (ProgramID, ProgramName, PointsPerDollar, Description)
VALUES 
  (2, 'Silver Rewards', 0.03, 'Earn points on every purchase'),
  (3, 'Bronze Rewards', 0.02, 'Limited rewards program');

—----------------------------------
-- Additional data for Store table
INSERT INTO Store (StoreID, StoreName, Address, City, State, ZIPCode, Phone, StoreSize, OpenDate)
VALUES 
  (4, 'Northside Store', '123 Pine St', 'Northville', 'CA', '54321', '555-9876', 'Medium', '2023-04-01'),
  (5, 'Riverside Store', '789 Willow Ave', 'Rivertown', 'CA', '67890', '555-5555', 'Small', '2023-05-01'),
  (6, 'Lakeside Store', '456 Birch St', 'Laketown', 'CA', '54321', '555-9876', 'Large', '2023-06-01'),
  (7, 'Eastend Store', '321 Cedar Blvd', 'Eastville', 'CA', '67890', '555-5555', 'Small', '2023-07-01'),
  (8, 'Westend Store', '654 Spruce Rd', 'Westville', 'CA', '54321', '555-9876', 'Extra Large', '2023-08-01');

-- Additional data for Department table
INSERT INTO Department (DepartmentID, DepartmentName, StoreID)
VALUES 
  (4, 'Electronics', 4),
  (5, 'Toys', 5),
  (6, 'Jewelry', 6),
  (7, 'Sporting Goods', 7),
  (8, 'Footwear', 8);

-- Additional data for Aisle table
INSERT INTO Aisle (AisleID, AisleNumber, StoreID, DepartmentID)
VALUES 
  (4, 40, 4, 4),
  (5, 50, 5, 5),
  (6, 60, 6, 6),
  (7, 70, 7, 7),
  (8, 80, 8, 8);

-- Additional data for Employee table
INSERT INTO Employee (EmployeeID, FirstName, LastName, DateOfBirth, HireDate, Position, Salary, StoreID)
VALUES 
  (4, 'Emily', 'Johnson', '1994-04-25', '2023-04-15', 'Assistant Manager', 55000.00, 4),
  (5, 'Mike', 'Lee', '1989-07-30', '2023-05-20', 'Sales Associate', 40000.00, 5),
  (6, 'Laura', 'Garcia', '1991-06-10', '2023-06-05', 'Stock Clerk', 38000.00, 6),
  (7, 'Chris', 'Martinez', '1987-08-19', '2023-07-12', 'Cashier', 35000.00, 7),
  (8, 'Jessica', 'Taylor', '1995-09-05', '2023-08-01', 'Supervisor', 45000.00, 8);

-- Additional data for Customer table
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Phone, LoyaltyCardNumber)
VALUES 
  (4, 'Samantha', 'Brown', 'samantha@example.com', '555-1111', 'L65432'),
  (5, 'David', 'Wilson', 'david@example.com', '555-2222', 'L87654'),
  (6, 'Nancy', 'Miller', 'nancy@example.com', '555-3333', 'L23456'),
  (7, 'Joshua', 'Davis', 'joshua@example.com', '555-4444', 'L98765'),
  (8, 'Angela', 'Rodriguez', 'angela@example.com', '555-5555', 'L54321');

-- Additional data for SalesTransaction table
INSERT INTO SalesTransaction (TransactionID, Date, Time, TotalAmount, EmployeeID, CustomerID)
VALUES 
  (4, '2023-04-15', '15:30:00', 120.75, 4, 4),
  (5, '2023-05-22', '11:00:00', 45.00, 5, 5),
  (6, '2023-06-10', '16:20:00', 200.50, 6, 6),
  (7, '2023-07-18', '13:45:00', 65.25, 7, 7),
  (8, '2023-08-03', '09:30:00', 150.00, 8, 8);

-- Additional data for ReturnTransaction table
INSERT INTO ReturnTransaction (ReturnID, TransactionID, Date, Reason, EmployeeID)
VALUES 
  (4, 4, '2023-04-20', 'Changed mind', 4),
  (5, 5, '2023-05-25', 'Wrong color', 5),
  (6, 6, '2023-06-15', 'Does not fit', 6),
  (7, 7, '2023-07-20', 'Missing parts', 7),
  (8, 8, '2023-08-05', 'Damaged item', 8);

-- Additional data for Categories table
INSERT INTO Categories (CategoryID, CategoryName, CategoryType)
VALUES 
  (4, 'Books', 'Reading Material'),
  (5, 'Gadgets', 'Electronics'),
  (6, 'Beauty', 'Personal Care'),
  (7, 'Toys & Games', 'Entertainment'),
  (8, 'Sporting Equipment', 'Sports');

-- Additional data for Supplier table
INSERT INTO Supplier (SupplierID, SupplierName, ContactName, Address, ContactEmail, Phone)
VALUES 
  (4, 'BookWorld', 'Linda Page', '123 Reading Ln', 'linda@bookworld.com', '555-6666'),
  (5, 'GadgetGuru', 'Kevin Tech', '456 Innovation Blvd', 'kevin@gadgetguru.com', '555-7777'),
  (6, 'BeautyBasics', 'Sandra Skin', '789 Makeup St', 'sandra@beautybasics.com', '555-8888'),
  (7, 'ToyTown', 'Rachel Fun', '321 Play Rd', 'rachel@toytown.com', '555-9999'),
  (8, 'SportsSupplies', 'Tom Active', '654 Athletic Ave', 'tom@sportssupplies.com', '555-0000');

-- Additional data for Product table
INSERT INTO Product (ProductID, ProductName, Description, CategoryID, SupplierID, Price, StockQuantity)
VALUES 
  (4, 'Novel', 'Fictional novel', 4, 4, 14.99, 50),
  (5, 'Smartphone', 'Latest model smartphone', 5, 5, 999.99, 15),
  (6, 'Lipstick', 'Matte lipstick', 6, 6, 9.99, 75),
  (7, 'Board Game', 'Family board game', 7, 7, 29.99, 40),
  (8, 'Tennis Racket', 'Professional tennis racket', 8, 8, 89.99, 30);

-- Additional data for ProductTransaction table
INSERT INTO ProductTransaction (PTransactionID, ProductID, Quantity, Discount, SubTotal)
VALUES 
  (4, 4, 2, 2.00, 27.98),
  (5, 5, 1, 50.00, 949.99),
  (6, 6, 4, 1.00, 37.96),
  (7, 7, 3, 0.00, 89.97),
  (8, 8, 1, 10.00, 79.99);

-- Additional data for Payment table
INSERT INTO Payment (PaymentID, PTransactionID, PaymentType, PaymentAmount, Date)
VALUES 
  (4, 4, 'Cash', 27.98, '2023-04-20'),
  (5, 5, 'Credit Card', 949.99, '2023-05-25'),
  (6, 6, 'Debit Card', 37.96, '2023-06-15'),
  (7, 7, 'Credit Card', 89.97, '2023-07-20'),
  (8, 8, 'Cash', 79.99, '2023-08-05');

-- Additional data for Promotion table
INSERT INTO Promotion (PromotionID, ProductID, StartDate, EndDate, DiscountPercentage, Description)
VALUES 
  (4, 4, '2023-04-01', '2023-04-30', 10.00, 'Spring Sale'),
  (5, 5, '2023-05-01', '2023-05-31', 5.00, 'New Arrival Discount'),
  (6, 6, '2023-06-01', '2023-06-30', 15.00, 'Summer Beauty Sale'),
  (7, 7, '2023-07-01', '2023-07-31', 0.00, 'Regular Price'),
  (8, 8, '2023-08-01', '2023-08-31', 20.00, 'Sports Season Sale');

-- Additional data for Contracts table
INSERT INTO Contracts (ContractID, StartDate, EndDate, SupplierID)
VALUES 
  (4, '2023-04-01', '2024-03-31', 4),
  (5, '2023-05-01', '2024-04-30', 5),
  (6, '2023-06-01', '2024-05-31', 6),
  (7, '2023-07-01', '2024-06-30', 7),
  (8, '2023-08-01', '2024-07-31', 8);

-- Additional data for ShippingProvider table
INSERT INTO ShippingProvider (ProviderID, ProviderName, ContactInfo, ShippingRates)
VALUES 
  (4, 'BookDelivery', 'info@bookdelivery.com', 'Flat rate: $3'),
  (5, 'TechShip', 'support@techship.com', 'Weight-based rates'),
  (6, 'BeautyMail', 'contact@beautymail.com', 'Free shipping over $50'),
  (7, 'GameCourier', 'help@gamecourier.com', 'Flat rate: $4'),
  (8, 'ActiveFreight', 'services@activefreight.com', 'Free for orders over $100’);

-- Additional data for Inventory table
INSERT INTO Inventory (InventoryID, ProductID, StoreID, Quantity)
VALUES 
  (4, 3, 5, 10),
  (5, 6, 7, 90),
  (6, 8, 2, 100),
  (7, 5, 9, 40),
  (8, 4, 2, 30);

-- Additional data for Orders table
INSERT INTO Orders (OrdersID, CustomerID, Date, TotalAmount, DeliveryID)
VALUES 
  (4, 2, '2023-02-10', 56.97, 4),
  (5, 3, '2023-04-10', 56.97, 5),
  (6, 4, '2023-06-10', 56.97, 6),
  (7, 2, '2023-08-10', 56.97, 27),
  (8, 6, '2023-09-05', 129.99, 8);

-- Additional data for Delivery table
INSERT INTO Delivery (DeliveryID, OrdersID, ProviderID, ShipDate, ExpectedArrival, Type)
VALUES 
  (4, 2, 2, '2023-01-10', '2023-02-15', 'Standard'),
  (5,4 2, '2023-04-10', '2023-02-15', 'Standard'),
  (6, 5, 2, '2023-03-10', '2023-02-15', 'Standard'),
  (7, 6, 3, '2023-04-05', '2023-03-10', 'Express'),
  (8, 7, 2, '2023-05-10', '2023-02-15', 'Standard');

-- Additional data for LoyaltyProgram table
INSERT INTO LoyaltyProgram (ProgramID, ProgramName, PointsPerDollar, Description)
VALUES 
  (4, 'Silver Rewards', 0.03, 'Earn points on every purchase'),
  (5, 'Gold Rewards', 0.04, 'Earn points on every purchase'),
  (6, 'Platinum Rewards', 0.08, 'Earn points on every purchase'),
  (7, 'Silver Rewards', 0.06, 'Earn points on every purchase'),
  (8, 'Bronze Rewards', 0.02, 'Limited rewards program');





—---------------------------------

Pivot table ideas: 
Store Performance:

Rows: StoreName.
Values: Total Sales (Sum), Average Transaction Amount (Average).

Product Sales by Category:

Rows: CategoryName, ProductName.
Values: Total Sales (Sum).
Employee Sales Performance:

Rows: EmployeeName.
Values: Total Sales (Sum), Number of Transactions (Count).
Customer Loyalty Analysis:

Rows: CustomerName.
Values: Total Purchases (Count), Total Spending (Sum).
Product Inventory Status:

Rows: ProductName.
Values: Current Stock Quantity (Sum), Products Needing Restock (Filter for low stock).
Feedback and Ratings Analysis:

Rows: Rating.
Values: Number of Feedbacks (Count).

Supplier Performance:
Rows: SupplierName.
Values: Total Products Supplied (Count), Total Contract Value (Sum).
Promotion Impact:

Rows: PromotionDescription.
Values: Number of Transactions with Promotion (Count), Total Sales with Promotion (Sum).
Employee Position Distribution:

Rows: Position.
Values: Number of Employees (Count).
Sales by Day and Time:

Rows: Date, Time (grouped by hour or half-hour).
Values: Total Sales (Sum).




—------
-- Store table
INSERT INTO Store VALUES
(1, 'SuperMart', '123 Main St', 'Anytown', 'CA', '12345', '555-1234', 'Large', '2022-01-01');

-- Department table
INSERT INTO Department VALUES
(1, 'Grocery', 1);

-- Aisle table
INSERT INTO Aisle VALUES
(1, 1, 1, 1);

-- Employee table
INSERT INTO Employee VALUES
(1, 'John', 'Doe', '1990-01-01', '2022-01-01', 'Cashier', 50000.00, 1);

-- Customer table
INSERT INTO Customer VALUES
(1, 'Alice', 'Smith', 'alice@email.com', '555-5678', '123-456-789');

-- SalesTransaction table
INSERT INTO SalesTransaction VALUES
(1, '2022-01-01', '12:00:00', 100.00, 1, 1);

-- ReturnTransaction table
INSERT INTO ReturnTransaction VALUES
(1, 1, '2022-01-02', 'Defective product', 1);

-- Categories table
INSERT INTO Categories VALUES
(1, 'Groceries', 'Food');

-- Supplier table
INSERT INTO Supplier VALUES
(1, 'Farm Fresh', 'John Supplier', '456 Farm Rd', 'john@farmfresh.com', '555-9876');

-- Product table
INSERT INTO Product VALUES
(1, 'Bread', 'Whole Wheat Bread', 1, 1, 2.99, 100);

-- ProductTransaction table
INSERT INTO ProductTransaction VALUES
(1, 1, 2, 0.50, 5.98);

-- Payment table
INSERT INTO Payment VALUES
(1, 1, 'Credit Card', 5.98, '2022-01-01');

-- Promotion table
INSERT INTO Promotion VALUES
(1, 1, '2022-01-01', '2022-02-01', 0.10, 'January Sale');

-- Contracts table
INSERT INTO Contracts VALUES
(1, '2022-01-01', '2022-12-31', 1);

-- ShippingProvider table
INSERT INTO ShippingProvider VALUES
(1, 'FastShip', 'info@fastship.com', '5.99 per pound');

-- Inventory table
INSERT INTO Inventory VALUES
(1, 1, 1, 50);

-- Orders table
INSERT INTO Orders VALUES
(1, 1, '2022-01-01', 50.00, 1);

-- Delivery table
INSERT INTO Delivery VALUES
(1, 1, 1, '2022-01-02', '2022-01-10', 'Express');

-- LoyaltyProgram table
INSERT INTO LoyaltyProgram VALUES
(1, 'VIP Club', 0.05, 'Exclusive discounts for VIP members');

-- Feedback table
INSERT INTO Feedback VALUES
(1, 1, '2022-01-03', 'Great service!', '5');


