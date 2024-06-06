-- working with sales and transactions tables withs states and exploring tax rates
-- salesOrderDetail table

-- total line total by salesOrderID in currency

select 
			salesorderid,
			format(SUM(linetotal), 'C') AS lineTotal
		from 
			sales.SalesOrderDetail
		group by 
			SalesOrderID
		order by 
			lineTotal desc;


-- line total as currency by products makeflag)and total sales orders
select 
			CASE WHEN p.MakeFlag=1 THEN 'Manufactured'
			else 'Purchased' end as inHouseProducts,
			format(SUM(linetotal), 'C1') AS lineTotal,
			format(count(distinct s.salesorderid),'N0') as TotalOrderIds
			-- 'N0' means number with zero decimal, so put a comma 
		from 
			sales.SalesOrderDetail s
			inner join Production.Product p on 
			s.ProductID = p.ProductID
		GROUP BY 
			CASE WHEN p.MakeFlag=1 THEN 'Manufactured'
			else 'Purchased' end


--- Average LineTotal per SalesOrderID
select 
			CASE WHEN p.MakeFlag=1 THEN 'Manufactured'
			else 'Purchased' end as inHouseProducts,
			format(SUM(linetotal), 'C1') AS lineTotal,
			format(count(distinct s.salesorderid),'N0') as TotalOrderIds,
			-- 'N0' means number with zero decimal, so put a comma 
			format(SUM(linetotal) / count(distinct s.salesorderid),'C0') as AvgLineTotal
		from 
			sales.SalesOrderDetail s
			inner join Production.Product p on 
			s.ProductID = p.ProductID
		GROUP BY 
			CASE WHEN p.MakeFlag=1 THEN 'Manufactured'
			else 'Purchased' end





-- group data by CountryRegionCode and name

select 
		name, 
		CountryRegionCode, [Group], 
		sum(salesYTD)
	from 
		Sales.SalesTerritory
	GROUP by 
		--grouping sets
		cube
(
	--(name),
	--(name, CountryRegionCode),
	(name, CountryRegionCode, [group])
	
)



-- working on Transcations dates 

-- check for column name and definition of any table in database 
select 
		t.name as TableName,
		c.name as ColumnName,
		ep.value as Definition
	from 
		sys.extended_properties ep 
		inner join sys.tables t 
			on t.object_id = ep.major_id 
		inner join sys.columns c 
			on c.object_id = ep.major_id 
			and c.column_id = ep.minor_id 
	where class = 1
		and t.name = 'TransactionHistory'

/*	
			Transaction Types:
			W = WorkOrder, S = SalesOrder, P = PurchaseOrder
*/

/*
find the first and last transaction date for all the Transaction Types 
and re confirm the dates with other respected tables
*/

select 
		Case 
			when TransactionType = 'W' then 'workorder'
			when TransactionType = 'S' then 'salesorder'
			when TransactionType = 'P' then 'purchaseorder'
			else null end as TransactionType,
			cast(min(TransactionDate) as Date) as firstDate,
			convert(date, max(TransactionDate)) as lastDate
from (
select * 
	from Production.TransactionHistory
UNION
select * 
	from 
			Production.TransactionHistoryArchive) a
	group by 
			TransactionType;


-- confirm the above dates of sales orders with salesorderheader table
select 
		cast(min(orderdate) as date) as firstOderdate,
		convert(Date, max(orderdate)) as lastOrderdate

		from Sales.salesorderheader;



-- confirming above dates purchaseorder with Purchases schemas tables

select 
		cast(min(orderdate) as date) as firstOderdate,
		convert(Date, max(orderdate)) as lastOrderdate
	from  
		Purchasing.PurchaseOrderHeader;

-- confirme the above dates for workorder with workorder table under productions
select 
		cast(min(StartDate) as date) as firstOderdate,
		convert(Date, max(StartDate)) as lastOrderdate
	from  
		Production.Workorder;


/*
			workorder		2011-06-03	2014-06-02
			salesorder		2011-05-31	2014-06-30
			purchaseorder	2011-04-16	2014-08-03

*/





-- list of every country and state in the database.
select 
	countryregioncode, 
	--stateprovincecode, 
	count(stateprovincecode) as TotalstateProvince

	from Person.stateprovince
	group by countryregioncode


-- state province names with countries
select 
	cr.name as 'country',
	sp.name as 'State'

from Person.stateprovince sp
	inner join Person.countryregion cr on 
	sp.countryregioncode = cr.countryregioncode 

/*
Total 181 state province
*/



-- Tax rates with state province and countries

select 
	cr.name as 'country',
	sp.name as 'State',
	tr.TaxRate as 'TaxRate'

from Person.stateprovince sp
	inner join Person.countryregion cr on 
	sp.countryregioncode = cr.countryregioncode 
	left join Sales.SalesTaxRate tr on 
	tr.StateProvinceID = sp.StateProvinceID
/*
There are 181 rows when working with countries and states, 
but with tax rates the number of rows increases to 184. (query above)
because we have three duplicate entries. Query below.
*/

select 
	sp.StateProvinceCode,
	sp.StateProvinceID

	from Person.stateprovince sp
		inner join Person.countryregion cr on 
		sp.countryregioncode = cr.countryregioncode 
		left join Sales.SalesTaxRate tr on 
		tr.StateProvinceID = sp.StateProvinceID

	group by sp.StateProvinceID, sp.StateProvinceCode
	having count(StateProvinceCode) > 1;



--locations with the  highest tax rates
Select 
	cr.Name as 'Country',
	sp.Name as 'State',
	tr.TaxRate
From Person.StateProvince sp
	Inner Join Person.CountryRegion cr 
	on cr.CountryRegionCode = sp.CountryRegionCode
	Left Join Sales.SalesTaxRate tr on 
	tr.StateProvinceID = sp.StateProvinceID
Order by 3 desc
