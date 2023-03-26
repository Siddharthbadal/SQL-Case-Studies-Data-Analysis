-- working with sales data and transactions tables


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
