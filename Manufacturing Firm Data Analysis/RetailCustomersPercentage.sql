/*

individual (retail) customers in the person table
Show this breakdown by country
What percent of total customers reside in each country.

*/

-- number of retail customers in each country

select cr.name,
		format(count(distinct p.BusinessEntityID),'N0') as Total
	from Person.person p
		inner join Person.BusinessEntityAddress bea on
		p.BusinessEntityID = bea.BusinessEntityID 
		inner join Person.Address a on 
		a.AddressID = bea.AddressID
		inner join Person.StateProvince sp on
		sp.StateProvinceID = a.StateProvinceID
		inner join Person.CountryRegion cr on 
		cr.CountryRegionCode = sp.CountryRegionCode

	where p.PersonType = 'IN'
	group by cr.name
	order by 2 desc;



-- percentage of number of retail customers in each country
/*
select cr.name,
	format(count(distinct p.BusinessEntityID),'N0') as Total,
	format(cast(count(distinct p.BusinessEntityID) as float) /18484, 'p') as HardCodedValue,		
	format(cast(count(distinct p.BusinessEntityID) as float) 
	/(
		select count(BusinessEntityID)
		from Person.person
		where PersonType = 'IN' ),'p'
	) 	as Percentage
		
		from Person.person p
		inner join Person.BusinessEntityAddress bea on
		p.BusinessEntityID = bea.BusinessEntityID 
		inner join Person.Address a on 
		a.AddressID = bea.AddressID
		inner join Person.StateProvince sp on
		sp.StateProvinceID = a.StateProvinceID
		inner join Person.CountryRegion cr on 
		cr.CountryRegionCode = sp.CountryRegionCode

	where p.PersonType = 'IN'
	group by cr.name
	order by 2 desc;
*/

-- with loacl variable
declare @TotalRetailCustomers float =(select count(BusinessEntityID)
									from Person.person
									where PersonType = 'IN' )
select cr.name,
	format(count(distinct p.BusinessEntityID),'N0') as Total,	
	format(cast(count(distinct p.BusinessEntityID) as float) 
	/@TotalRetailCustomers,'P') as '%ofTotal'
		
		from Person.person p
		inner join Person.BusinessEntityAddress bea on
		p.BusinessEntityID = bea.BusinessEntityID 
		inner join Person.Address a on 
		a.AddressID = bea.AddressID
		inner join Person.StateProvince sp on
		sp.StateProvinceID = a.StateProvinceID
		inner join Person.CountryRegion cr on 
		cr.CountryRegionCode = sp.CountryRegionCode

	where p.PersonType = 'IN'
	group by cr.name
	order by 2 desc;




