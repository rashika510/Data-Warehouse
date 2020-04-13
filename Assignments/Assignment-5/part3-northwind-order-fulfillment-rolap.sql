
USE ist722_rsingh37_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;
/* Drop table northwind.FactSales */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.FactSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.FactSales 
;


/* Drop table northwind.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.DimCustomer 
;

/* Create table northwind.DimCustomer */
CREATE TABLE northwind.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  nvarchar(5)   NOT NULL
,  [CompanyName]  nvarchar(40)   NOT NULL
,  [ContactName]  nvarchar(30)   NOT NULL
,  [ContactTitle]  nvarchar(30)   NOT NULL
,  [CustomerCountry]  nvarchar(15)   NOT NULL
,  [CustomerRegion]  nvarchar(15)  DEFAULT 'N/A' NOT NULL
,  [CustomerCity]  nvarchar(15)   NOT NULL
,  [CustomerPostalCode]  nvarchar(10)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_northwind.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT northwind.DimCustomer ON
;
INSERT INTO northwind.DimCustomer (CustomerKey, CustomerID, CompanyName, ContactName, ContactTitle, CustomerCountry, CustomerRegion, CustomerCity, CustomerPostalCode, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, 'NONE', 'No Customer', 'None', 'None', 'None', 'None', 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT northwind.DimCustomer OFF
;


/* Drop table northwind.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.DimDate 
;
alter table northwind.DimDate
alter column [DayOfYear]  int   NULL;

alter table northwind.DimDate
alter column [Year]  int  NULL

alter table northwind.DimDate
alter column [MonthOfYear]  nchar(10) NULL

alter table northwind.DimDate
alter column [DateKey] int NULL;

/* Create table northwind.DimDate */
CREATE TABLE northwind.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  date   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  int   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  nchar(10)   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  int   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_northwind.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;

/* Drop table northwind.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.DimProduct 
;

/* Create table northwind.DimProduct */
CREATE TABLE northwind.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int   NOT NULL
,  [ProductName]  nvarchar(40)   NOT NULL
,  [Discontinued]  nchar(1)  DEFAULT 'N' NOT NULL
,  [SupplierName]  nvarchar(40)   NOT NULL
,  [CategoryName]  nvarchar(15)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_northwind.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT northwind.DimProduct ON
;
INSERT INTO northwind.DimProduct (ProductKey, ProductID, ProductName, Discontinued, SupplierName, CategoryName, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', '?', 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT northwind.DimProduct OFF

/* Drop table northwind.DimEmployee */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimEmployee') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.DimEmployee 
;

/* Create table northwind.DimEmployee */
CREATE TABLE northwind.DimEmployee (
   [EmployeeKey]  int IDENTITY  NOT NULL
,  [EmployeeID]  int   NOT NULL
,  [EmployeeName]  nvarchar(40)   NOT NULL
,  [EmployeeTitle]  nvarchar(30)   NOT NULL
,  [RowIsCurrent]  bit   DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_northwind.DimEmployee] PRIMARY KEY CLUSTERED 
( [EmployeeKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT northwind.DimEmployee ON
;
INSERT INTO northwind.DimEmployee (EmployeeKey, EmployeeID, EmployeeName, EmployeeTitle, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT northwind.DimEmployee OFF
;

/* Create table northwind.FactSales */
CREATE TABLE northwind.FactSales (
   [ProductKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [EmployeeKey]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ShippedDateKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [Quantity]  smallint   NOT NULL
,  [ExtendedPriceAmount]  money   NOT NULL
,  [DiscountAmount]  money  DEFAULT 0 NOT NULL
,  [SoldAmount]  money   NOT NULL
, CONSTRAINT [PK_northwind.FactSales] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID] )
) ON [PRIMARY]
;

ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES northwind.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES northwind.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_EmployeeKey FOREIGN KEY
   (
   EmployeeKey
   ) REFERENCES northwind.DimEmployee
   ( EmployeeKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES northwind.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_ShippedDateKey FOREIGN KEY
   (
   ShippedDateKey
   ) REFERENCES northwind.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

/* Drop table dbo.FactOrderFullfillment */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactOrderFullfillment') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactOrderFullfillment 
;

---Create table dbo.FactOrderFullfillment 
CREATE TABLE dbo.FactOrderFullfillment (
   [OrderID]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ShipDatekey]  int   NOT NULL
,  [CountOrderDate]  int  DEFAULT 0 NOT NULL
,  [CountshipDate]  int  DEFAULT 0 NOT NULL
,  [Delay]  int  DEFAULT -1 NOT NULL
, CONSTRAINT [PK_dbo.FactOrderFullfillment] PRIMARY KEY NONCLUSTERED 
( [OrderID] )
) ON [PRIMARY]
;
ALTER TABLE dbo.FactOrderFullfillment ADD CONSTRAINT
   FK_dbo_FactOrderFullfillment_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES northwind.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION/* Drop table northwind.FactOrderFullfillment */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.FactOrderFullfillment') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.FactOrderFullfillment 
;

---Create table northwind.FactOrderFullfillment
CREATE TABLE northwind.FactOrderFullfillment (
   [OrderID]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ShipDatekey]  int   NOT NULL
,  [CountOrderDate]  int  DEFAULT 0 NOT NULL
,  [CountshipDate]  int  DEFAULT 0 NOT NULL
,  [Delay]  int  DEFAULT -1 NOT NULL
, CONSTRAINT [PK_northwind.FactOrderFullfillment] PRIMARY KEY NONCLUSTERED 
( [OrderID] )
) ON [PRIMARY]
;

ALTER TABLE northwind.FactOrderFullfillment ADD CONSTRAINT
   FK_northwind_FactOrderFullfillment_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES northwind.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE northwind.FactOrderFullfillment ADD CONSTRAINT
   FK_northwind_FactOrderFullfillment_ShipDatekey FOREIGN KEY
   (
   ShipDatekey
   ) REFERENCES northwind.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 

ALTER TABLE dbo.FactOrderFullfillment ADD CONSTRAINT
   FK_dbo_FactOrderFullfillment_ShipDatekey FOREIGN KEY
   (
   ShipDatekey
   ) REFERENCES northwind.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
