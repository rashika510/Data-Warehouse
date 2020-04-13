use ist722_rsingh37_dw

select EmployeeID, FirstName + ' ' + LastName as EmployeeName, [Title]
	from [ist722_rsingh37_stage].[dbo].[stgNorthwindEmployees]

--load DimEmployees
insert into [northwind].[DimEmployee]
			([EmployeeID],[EmployeeName],[EmployeeTitle])
select EmployeeID, FirstName + ' ' + LastName as EmployeeName, [Title]
	from [ist722_rsingh37_stage].[dbo].[stgNorthwindEmployees]

select * from [northwind].[DimEmployee]


--load DimCustomer
insert into [northwind].[DimCustomer]
		([CustomerID],[CompanyName],[ContactName],[ContactTitle],
		[CustomerCountry],[CustomerRegion],[CustomerCity],[CustomerPostalCode])
select 
		[CustomerID],[CompanyName],[ContactName],[ContactTitle],[Country],
		case when [Region] is null then 'N/A' else [Region] end,
		[City],
		case when [PostalCode] is null then 'N/A' else [PostalCode] end
		from [ist722_rsingh37_stage].[dbo].[stgNorthwindCustomers];

select * from [northwind].[DimCustomer];

---load DimProduct
insert into [northwind].[DimProduct]
		([ProductID],[ProductName],[Discontinued],[SupplierName],[CategoryName])
select 
		[ProductID],[ProductName],[Discontinued],[CompanyName],[CategoryName]
		from [ist722_rsingh37_stage].[dbo].[stgNorthwindProducts];

Select * from [northwind].[DimProduct];

--load DimDate
insert into northwind.DimDate
		([DateKey],[Date],[FullDateUSA],[DayOfWeek],[DayName],[DayOfMonth],[DayOfYear]
		,[WeekOfYear],[MonthName],[MonthOfYear],[Quarter],[QuarterName]
		,[Year],[IsWeekday])
select 
		[ExternalSources2].[dbo].[getDateKey]([Date]),
		[Date],[FullDateUSA],[DayOfWeekUSA],[DayName],[Month],[DayOfYear]
		,[WeekOfYear],[MonthName],[MonthYear],[Quarter],[QuarterName]
		,[Year],[IsWeekday]
		from [ist722_rsingh37_stage].[dbo].[stgNorthwindDates];

select * from northwind.DimDate;

select s.*,c.CustomerKey,e.EmployeeKey,p.ProductKey,
	[ExternalSources2].[dbo].[getDateKey](s.OrderDate) as OrderDateKey,
	[ExternalSources2].[dbo].[getDateKey](s.ShippedDate) as ShippedDateKey,
from [ist722_rsingh37_stage].[dbo].[stgNorthwindSales] s
		join [ist722_rsingh37_dw].[northwind].DimCustomer c
			on s.CustomerID=c.CustomerID--match on business keys, not pk/fk
		join [ist722_rsingh37_dw].[northwind].DimEmployee e
			on s.EmployeeID=e.EmployeeID--match on business keys, not pk/fk
		join [ist722_rsingh37_dw].[northwind].DimProduct p
			on s.ProductID=p.ProductID--match on business keys, not pk/fk
		
--load FactSales

insert into [northwind].[FactSales]
		([ProductKey],[CustomerKey],[EmployeeKey]
		,[OrderDateKey]
		,[ShippedDateKey]
		,[OrderID]
		,[Quantity]
		,[ExtendedPriceAmount]
		,[DiscountAmount]
		,[SoldAmount])
select p.ProductKey, c.CustomerKey, e.EmployeeKey,
	[ExternalSources2].[dbo].[getDateKey](s.OrderDate) as OrderDateKey,
	case when [ExternalSources2].[dbo].[getDateKey](s.ShippedDate) is null then -1
	else [ExternalSources2].[dbo].[getDateKey](s.ShippedDate) end as ShippedDateKey,
	s.OrderID,
	Quantity,
	Quantity * UnitPrice as ExtendedPriceAmount,
	Quantity * UnitPrice * Discount as DiscountAmount,
	Quantity * UnitPrice * (1-Discount) as SoldAmount
from [ist722_rsingh37_stage].dbo.[stgNorthwindSales] s
	join [ist722_rsingh37_dw].[northwind].DimCustomer c
			on s.CustomerID=c.CustomerID
		join [ist722_rsingh37_dw].[northwind].DimEmployee e
			on s.EmployeeID=e.EmployeeID
		join [ist722_rsingh37_dw].[northwind].DimProduct p
			on s.ProductID=p.ProductID;

select * from  [northwind].[FactSales];

---load FactOrderFullfillment
insert into [northwind].[FactOrderFullfillment] 
( [OrderID],[OrderDateKey]
 ,[ShipDateKey],[CountOrderDate],[CountShipDate],[Delay]
  )

SELECT b.OrderID , 

 [ExternalSources2].[dbo].[getDateKey](b.OrderDate) as OrderDateKey,

 case when [ExternalSources2].[dbo].[getDateKey](b.ShippedDate) is null then -1
 else [ExternalSources2].[dbo].[getDateKey](b.ShippedDate) end as ShipDateKey,

case when [ExternalSources2].[dbo].[getDateKey](b.OrderDate) is null then 0
 else 1 end as CountOrderDate, 

case when [ExternalSources2].[dbo].[getDateKey](b.ShippedDate) is null then 0
 else 1 end as CountShipDate, 

 case when (b.OrderDate) is null or (b.ShippedDate) is NULL then -1
 else DATEDIFF(day, b.OrderDate, b.ShippedDate ) end as [Delay]

 from  [ist722_rsingh37_stage].[dbo].[stgNorthwindOrderFullfillment]  b

CREATE VIEW [northwind].[OrderMart]
AS
Select f.OrderID, OrderDateKey, ShipDateKey, CountOrderDate,CountShipDate,[Delay]
from [northwind].[FactOrderFullfillment] f

















