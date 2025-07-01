---------------------------------------------------
-- 1. Tabela: Klienci (z kwiatkami)
---------------------------------------------------
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    RegistrationDate DATE,
    City NVARCHAR(50)
);

-- Przyk³adowi klienci (50 sztuk)
INSERT INTO Customers (FirstName, LastName, RegistrationDate, City)
SELECT TOP 45
    LEFT(NEWID(), 5),                  
    LEFT(NEWID(), 7),                  
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 1000, GETDATE()),  
    CHOOSE(
        ABS(CHECKSUM(NEWID())) % 10 + 1,
        'Warszawa',        -- poprawnie
        'warszawa',        -- ma³e litery
        'Kraków',          -- poprawnie
        'Krakow',          -- bez ogonka
        'Wroc³aw',         -- poprawnie
        'Gdañsk ',         -- ze spacj¹
        'POZNAÑ',          -- capslock
        NULL,              -- brak miasta
        NULL,              -- brak miasta
        'Lodz'             -- miasto spoza listy
    )
FROM sys.all_objects;

-- Dodatkowi klienci specjalnie do testów czyszczenia
INSERT INTO Customers (FirstName, LastName, RegistrationDate, City)
VALUES
('Anna', 'Nowak', '2026-01-01', 'Kraków'),       -- przysz³a data
('Anna', 'Nowak', '2024-05-01', 'Kraków'),       -- duplikat imienia i nazwiska
('Piotr', 'Zieliñski', NULL, NULL);              -- brak daty i miasta

---------------------------------------------------
-- 2. Produkty (bez zmian)
---------------------------------------------------
DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

INSERT INTO Products (ProductName, Category, UnitPrice)
VALUES
('Laptop Pro 15"', 'Elektronika', 4999.99),
('Smartphone Max', 'Elektronika', 3199.99),
('Kawa ziarnista 1kg', 'Spo¿ywcze', 59.99),
('Buty biegowe X', 'Odzie¿', 299.99),
('Kurtka zimowa', 'Odzie¿', 699.99),
('Zegarek sportowy', 'Elektronika', 899.99),
('Czekolada mleczna', 'Spo¿ywcze', 6.99);

---------------------------------------------------
-- 3. Sprzeda¿ (bez zmian, ale dzia³a z powy¿szymi danymi)
---------------------------------------------------
DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    SaleDate DATE,
    UnitPrice DECIMAL(10,2)
);

-- Generowanie 1000 transakcji
DECLARE @i INT = 0;
DECLARE @RandomCustomerID INT;
DECLARE @RandomProductID INT;
DECLARE @RandomQuantity INT;
DECLARE @RandomDate DATE;
DECLARE @UnitPrice DECIMAL(10,2);

WHILE @i < 1000
BEGIN
    SELECT TOP 1 @RandomCustomerID = CustomerID FROM Customers ORDER BY NEWID();
    SELECT TOP 1 
        @RandomProductID = ProductID,
        @UnitPrice = UnitPrice
    FROM Products
    ORDER BY NEWID();
    SET @RandomQuantity = ABS(CHECKSUM(NEWID())) % 5 + 1;
    SET @RandomDate = DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE());

    INSERT INTO Sales (CustomerID, ProductID, Quantity, SaleDate, UnitPrice)
    VALUES (@RandomCustomerID, @RandomProductID, @RandomQuantity, @RandomDate, @UnitPrice);

    SET @i = @i + 1;
END;
