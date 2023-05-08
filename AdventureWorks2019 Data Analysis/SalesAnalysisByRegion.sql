-- Analysis of totaldue -sales figure by region and customers 

-- List the sales region 
select st.Name as RegionName
	from Sales.SalesTerritory st

-- get the sales figure - total due by region
select st.Name as RegionName,
	format(sum(totaldue), 'C0') as TotalDue
	from Sales.SalesTerritory st 
	JOIN Sales.SalesOrderHeader soh 
	ON st.TerritoryID = soh.TerritoryID
	group by st.name
	order by st.name


-- get customers name for each region with spending
select  st.Name as RegionName,
		concat(firstName, ' ', lastName) as customer,
		format(sum(totaldue), 'C0') as TotalDue
		
	from Sales.SalesTerritory st 
	JOIN Sales.SalesOrderHeader soh 
	ON st.TerritoryID = soh.TerritoryID
	JOIN Sales.Customer c on 
	soh.CustomerID = c.CustomerID
	join Person.Person p on
	p.BusinessEntityID = c.PersonID
	group by st.name, concat(firstName, ' ', lastName)
	order by st.name;

-- ranking by customer spending and by region 
-- finding the most spending customers
select  st.Name as RegionName,
		concat(firstName, ' ', lastName) as customer,
		format(sum(totaldue), 'C0') as TotalDue,
		ROW_NUMBER() over(partition by st.name order by sum(totaldue) desc) as RowNumber
		
	from Sales.SalesTerritory st 
	JOIN Sales.SalesOrderHeader soh 
	ON st.TerritoryID = soh.TerritoryID
	JOIN Sales.Customer c on 
	soh.CustomerID = c.CustomerID
	join Person.Person p on
	p.BusinessEntityID = c.PersonID
	group by st.name, concat(firstName, ' ', lastName)
	order by 4;


-- temp table to get top 20 customers from each region 

select *
	from(
			select  st.Name as RegionName,
					concat(firstName, ' ', lastName) as customer,
					sum(totaldue) as TotalDue,
					ROW_NUMBER() over(partition by st.name order by sum(totaldue) desc) as RowNumber
				from Sales.SalesTerritory st 
				JOIN Sales.SalesOrderHeader soh 
				ON st.TerritoryID = soh.TerritoryID
				JOIN Sales.Customer c on 
				soh.CustomerID = c.CustomerID
				join Person.Person p on
				p.BusinessEntityID = c.PersonID
				group by st.name, concat(firstName, ' ', lastName)
				
			) as salesByRegion_Cust
			
-- top 25 customers for each region
select *
	from(
			select  st.Name as RegionName,
					concat(firstName, ' ', lastName) as customer,
					format(sum(totaldue), 'C0') as TotalDue, --text datatype
					--sum(totaldue) as TotalDue,
					ROW_NUMBER() over(partition by st.name order by sum(totaldue) desc) as RowNumber
				from Sales.SalesTerritory st 
				JOIN Sales.SalesOrderHeader soh 
				ON st.TerritoryID = soh.TerritoryID
				JOIN Sales.Customer c on 
				soh.CustomerID = c.CustomerID
				join Person.Person p on
				p.BusinessEntityID = c.PersonID
				group by st.name, concat(firstName, ' ', lastName)
				
			) as salesByRegion_Cust
		where RowNumber <= 25
		


-- average of other customers by region [not top 25]
select RegionName, format(avg(totaldue), 'C0') as AvgTotalDue
	from(
			select  st.Name as RegionName,
					concat(firstName, ' ', lastName) as customer,
					--format(sum(totaldue), 'C0') as TotalDue, --text datatype
					sum(totaldue) as TotalDue,
					ROW_NUMBER() over(partition by st.name order by sum(totaldue) desc) as RowNumber
				from Sales.SalesTerritory st 
				JOIN Sales.SalesOrderHeader soh 
				ON st.TerritoryID = soh.TerritoryID
				JOIN Sales.Customer c on 
				soh.CustomerID = c.CustomerID
				join Person.Person p on
				p.BusinessEntityID = c.PersonID
				group by st.name, concat(firstName, ' ', lastName)
				
			) as salesByRegion_Cust
		where RowNumber >= 25
		group by regionName
		order by RegionName

-- average of top 25 customers
select RegionName, format(avg(totaldue), 'C0') as AvgTotalDue
	from(
			select  st.Name as RegionName,
					concat(firstName, ' ', lastName) as customer,
					--format(sum(totaldue), 'C0') as TotalDue, --text datatype
					sum(totaldue) as TotalDue,
					ROW_NUMBER() over(partition by st.name order by sum(totaldue) desc) as RowNumber
				from Sales.SalesTerritory st 
				JOIN Sales.SalesOrderHeader soh 
				ON st.TerritoryID = soh.TerritoryID
				JOIN Sales.Customer c on 
				soh.CustomerID = c.CustomerID
				join Person.Person p on
				p.BusinessEntityID = c.PersonID
				group by st.name, concat(firstName, ' ', lastName)
				
			) as salesByRegion_Cust
		where RowNumber <= 25
		group by regionName
		order by RegionName