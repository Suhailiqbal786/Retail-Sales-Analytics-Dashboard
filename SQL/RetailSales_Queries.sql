CREATE DATABASE RetailSales

USE RetailSales

select top 7 * from Customers_Ref

SELECT COUNT(*) AS TotalOrders
FROM Orders_Cleaned

SELECT COUNT(*) AS TotalCustomers
FROM Customers_Ref;


--1 Count rows and distinct OrderIDs.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT OrderID) AS DistinctOrderIDs
FROM Orders_Cleaned

--2 Count NULL values
SELECT
    SUM(CASE WHEN CustomerName IS NULL THEN 1 ELSE 0 END) AS CustomerName_Nulls,
    SUM(CASE WHEN Email IS NULL THEN 1 ELSE 0 END) AS Email_Nulls,
    SUM(CASE WHEN Phone IS NULL THEN 1 ELSE 0 END) AS Phone_Nulls,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS City_Nulls,
    SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS Rating_Nulls
FROM Orders_Cleaned

--3 Find Duplicate OrderIDs
SELECT
    OrderID,
    COUNT(*) AS DuplicateCount
FROM Orders_Cleaned
GROUP BY OrderID
HAVING COUNT(*) > 1

--4 Identify invalid data

SELECT *
FROM Orders_Cleaned
WHERE Quantity <= 0
   OR UnitPrice <= 0
   OR Rating NOT BETWEEN 1 AND 5
   OR Discount_Pct > 100
   OR OrderDate IS NULL;

--5 Clean data using UPDATE / DELETE
SELECT *
INTO Orders_Cleaned_Backup
FROM Orders_Cleaned

UPDATE Orders_Cleaned_Backup
SET Rating = 1
WHERE Rating < 1 OR Rating > 5

DELETE FROM Orders_Cleaned_Backup
WHERE Quantity <= 0
   OR UnitPrice <= 0

SELECT * FROM Orders_Cleaned_Backup

--6 Revenue Analysis by Category
SELECT
    Category,
    SUM(FinalAmount) AS TotalRevenue
FROM Orders_Cleaned
GROUP BY Category
ORDER BY TotalRevenue DESC

--7a Top 5 Cities by Revenue
SELECT TOP 5
    City,
    SUM(FinalAmount) AS TotalRevenue
FROM Orders_Cleaned
GROUP BY City
ORDER BY TotalRevenue DESC

--7b Top 5 Customers
SELECT TOP 5
    CustomerName,
    SUM(FinalAmount) AS TotalRevenue
FROM Orders_Cleaned
GROUP BY CustomerName
ORDER BY TotalRevenue DESC;

--8a Monthly Sales Trend
SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(FinalAmount) AS MonthlyRevenue
FROM Orders_Cleaned
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY SalesYear, SalesMonth

--8b Average Rating by Category
SELECT
    Category,
    AVG(Rating) AS AverageRating
FROM Orders_Cleaned
GROUP BY Category
ORDER BY AverageRating DESC