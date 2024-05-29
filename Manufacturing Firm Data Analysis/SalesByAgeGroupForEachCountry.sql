-- Sales of each country by customer age group 

/*	Table				Column			key
	birthdate		 customers		    CustomerKey
	countryname		 georgaphy			CustomerKey
	salesdata		 factINternetSales  GeographyKey
*/

with CTE_AGE AS(
select t3.EnglishCountryRegionName,
		-- finding age by from orderdate to birthdate
		datediff(year, t2.birthdate, OrderDate) AS age,
		t1.salesamount as sales
FROM dbo.FactInternetSales t1
JOIN dbo.DimCustomer t2
on t1.CustomerKey = t2.CustomerKey
JOIN dbo.DimGeography t3
on t2.GeographyKey = t3.GeographyKey
)

select 
	EnglishCountryRegionName,
	CASE WHEN age <  30 THEN 'Under 30'
		WHEN age between 30 and 40 THEN '30 To 40'
		WHEN age between 40 and 50 THEN '40 To 50'
		WHEN age between 50 and 60 THEN '50 To 60'
		WHEN age > 60 THEN 'Over 60'
		else 'Other'
		end as age_group,
		count(sales) as sales
from CTE_AGE
group by EnglishCountryRegionName,
	CASE WHEN age <  30 THEN 'Under 30'
		WHEN age between 30 and 40 THEN  '30 To 40'
		WHEN age between 40 and 50 THEN '40 To 50'
		WHEN age between 50 and 60 THEN '50 To 60'
		WHEN age > 60 THEN 'Over 60'
		else 'Other'
		end 
		order by EnglishCountryRegionName, age_group