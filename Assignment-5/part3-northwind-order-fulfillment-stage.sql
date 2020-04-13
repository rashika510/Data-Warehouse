use [ist722_rsingh37_stage]
drop table dbo.stgNorthwindCustomers
drop table dbo.stgNorthwindDates
drop table dbo.stgNorthwindEmployees
drop table dbo.stgNorthwindProducts
drop table dbo.stgNorthwindSales

---stage Customers
select [CustomerID]
	,[CompanyName]
	,[ContactName]
	,[ContactTitle]
	,[Address]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country]
INTO [dbo].[stgNorthwindCustomers]
From [Northwind].[dbo].[Customers]
      
--stage employee
select [EmployeeID]
	,[FirstName]
	,[LastName]
	,[Title]
into [dbo].[stgNorthwindEmployees]
from [Northwind].[dbo].[Employees]

--stage products
select [ProductID]
	,[ProductName]
	,[Discontinued]
	,[CompanyName]
	,[CategoryName]
into [dbo].[stgNorthwindProducts]
from [Northwind].[dbo].[Products] p
	join [Northwind].[dbo].Suppliers s
		on p.[SupplierID]=s.[SupplierID]
	join [Northwind].[dbo].Categories c
		on c.[CategoryID]=p.CategoryID

--stage date
select *
into [dbo].[stgNorthwindDates]
from [ExternalSources2].[dbo].date_dimension
where Year between 1996 and 1998

--stage fact
select [ProductID]
	,d.[OrderID]
	,[CustomerID]
	,[EmployeeID]
	,[OrderDate]
	,[ShippedDate]
	,[UnitPrice]
	,[Quantity]
	,[Discount]
into [dbo].[stgNorthwindSales]
from [Northwind].[dbo].[Order Details] d
	join [Northwind].[dbo].[Orders] o
		on o.[OrderID]=d.[OrderID]

--stage FactOrderFullfillment
select [OrderID],[OrderDate],[ShippedDate]

into [dbo].[stgNorthwindOrderFullfillment]
from [Northwind].[dbo].[Orders]
