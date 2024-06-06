-- Data exploration on tables Employess, Person, vendors and Products

-- USE AdventureWorks2019;

-- Number of the employees in the Database
select	
		count(*) as 'Employee Count',
		count(distinct BusinessEntityID) as 'Employee Count2',
		count(distinct NationalIDNumber) as 'Employee Count3'
	from 
		HumanResources.Employee;


-- check for column name in a table with definition
	/*
select 
	t.name as TableName,
	c.name as ColumnName,
	ep.value as Definition
	from sys.extended_properties ep 
	inner join sys.tables t 
		on t.object_id = ep.major_id 
	inner join sys.columns c 
		on c.object_id = ep.major_id 
		and c.column_id = ep.minor_id 
	where class = 1
		and t.name = 'product'
*/


-- active employees of all the table
select	
		CurrentFlag, 
		count(*) as ActiveEmployeeCount
	from 
		HumanResources.Employee
	group by 
		CurrentFlag


-- looking for a specific person Type
	select 
			count(distinct JobTitle) as SP_JobTitleCount
		from 
			HumanResources.Employee e
			INNER JOIN Person.person p on p.BusinessEntityID = e.BusinessEntityID
		where 
			PersonType = 'sp'
		group by CurrentFlag



-- looking for a total sales persons and job titles 
	select 
			distinct JobTitle, 
			count(distinct e.BusinessEntityID) as Sales_person_Count
		from 
			HumanResources.Employee e
			INNER JOIN Person.person p on p.BusinessEntityID = e.BusinessEntityID
		where PersonType = 'sp'
		group by CurrentFlag, JobTitle




-- CEO Details
select CONCAT(p.FirstName,' ', p.LastName) AS CEO, e.HireDate as Started_on
		from Person.Person p
		inner join HumanResources.Employee e on
		p.BusinessEntityID = e.BusinessEntityID
		where e.JobTitle = 'Chief Executive Officer'

-- Who all reports to CEO
select CONCAT(p.FirstName,' ', p.LastName) AS name, e.JobTitle AS JobTitle
		from Person.Person p
			inner join HumanResources.Employee e on
			p.BusinessEntityID = e.BusinessEntityID
		-- OrganizationLevel colum show the hierarchical structure in company
		where OrganizationLevel = 1



-- Find job title by employee Name
select 
			e.JobTitle AS JobTitle 
		from 
			Person.Person p
		inner join HumanResources.Employee e on
		p.BusinessEntityID = e.BusinessEntityID
		where 
			p.FirstName = 'John' AND
			p.LastName='Evans' 

-- find department details by employee name
select 
		p.BusinessEntityID, 
		CONCAT(p.FirstName,' ', p.LastName) as Name, 
		e.JobTitle AS JobTitle, 
		h.DepartmentID, 
		d.Name
	from	
		Person.Person p
		inner join HumanResources.Employee e on
		p.BusinessEntityID = e.BusinessEntityID 
		inner join HumanResources.EmployeeDepartmentHistory h on
		h.BusinessEntityID = e.BusinessEntityID 
		inner join HumanResources.Department d on
		h.DepartmentID = d.DepartmentID
	where
		p.FirstName = 'John' AND
		p.LastName='Evans'


		-- select * from HumanResources.EmployeeDepartmentHistory
		-- select * from HumanResources.Department;


-- Purchasing vendors with  the highest credit rating

select 
			CreditRating, count(*)AS 'Count For each Rating'
		from 
			Purchasing.Vendor
		group by CreditRating
		order by CreditRating;

select * 
	from Purchasing.Vendor
	where 
			CreditRating = 1
	order by 
			CreditRating;


-- Replace 1 and 0 in the  table PreffredVendorStatus to "Preferred" and "Not Prefered"
-- count the vendors on "Preferred" and "Not Prefered" 

select 
	CASE WHEN PreferredVendorStatus = '1' THEN 'Preferred'
		ELSE 'Not Preferred' END as 'PreferredStatus',
	count(*) as Total

	from 
			Purchasing.Vendor
	group by 
			CASE WHEN PreferredVendorStatus = '1' THEN 'Preferred'
		ELSE 'Not Preferred' END 
		
		

-- For active "Preferred" and "Not Prefered", which one has better average credit rating 
select 
	CASE WHEN PreferredVendorStatus = '1' THEN 'Preferred'
		ELSE 'Not Preferred' END as 'PreferredStatus',
		-- credit rating is tinyint, so need to cast as decimal to get the correct values
	avg(cast(CreditRating as decimal)) as Total

	from 
			Purchasing.Vendor
	where 
			ActiveFlag=1
	group by 
			CASE WHEN PreferredVendorStatus = '1' THEN 'Preferred'
			ELSE 'Not Preferred' END 
/*
so not prefered vendors has a higher or better rating 
although number of not preferred are is just seven		
*/

-- Active but Not Preferred (0 Value) Venords
select *
		from 
				Purchasing.Vendor
		where 
				ActiveFlag = 1 and PreferredVendorStatus = 0



--- Find on Employess Age

select 
		BusinessEntityID, 
		JobTitle,  
		BirthDate, 
		DATEDIFF(year, BirthDate, '2023-01-01'  ) AS EmpAgeYears,
		DATEDIFF(MONTH, BirthDate, '2023-01-01' ) AS EmpAgeMonth
		
		from 
				HumanResources.Employee
		order by 
				EmpAgeYears desc;
				
								

-- Average Age by OrganizationLevel in decimal to single digit 
-- Use ceiling, floor, and format
select 
		OrganizationLevel, 
		format(AVG(cast(DATEDIFF(year, BirthDate, '2023-01-01') as decimal)),'N1') AS EmpAge_format,
		CEILING(AVG(cast(DATEDIFF(year, BirthDate, '2023-01-01') as decimal))) AS EmpAge_Ceiling,
		FLOOR(AVG(cast(DATEDIFF(year, BirthDate, '2023-01-01') as decimal))) AS EmpAge_Floor
		
		from 
				HumanResources.Employee
		group by 
				OrganizationLevel






--- Purchased or manufactured AND salable or not salable products 

select 
		FinishedGoodsFlag, 
		count(productnumber) AS TotalNumberOfProducts
		from 
				Production.Product
		group by 
				FinishedGoodsFlag;


-- number of products salable or not salable
select 
		CASE WHEN FinishedGoodsFlag = 0 THEN 'Not Salable'
			else 'Saleable' end as 'salable Product',
			count(productnumber) AS TotalNumberOfProducts
		from 
				Production.Product
		group by 
				CASE WHEN FinishedGoodsFlag = 0 THEN 'Not Salable'
				else 'Saleable' end
-- 0 not saleable & 1 Salabale


-- Salable products those are active 
select 
		count(*)as ProductCount
		from Production.Product
		where 
				FinishedGoodsFlag = 1 and 
				SellEndDate is null;


-- number of products purchased or manufacutred 
select 
			count(*) as TotalProducts,
			count(CASE WHEN MakeFlag = 0 THEN ProductID
			else null end) as PurchasedProducts,
			count(CASE WHEN MakeFlag = 1 THEN ProductID
			else null end) as ManufacturedProducts
			from 
					Production.Product
			where 
					FinishedGoodsFlag = 1 and 
					SellEndDate is null


-- manufactured products those are active or still being sold 
select 
	count(*) as ProductCount
	from 
			Production.Product
	where 
			MakeFlag = 1 and 
			SellEndDate is null;


/*
Analysis:
	So total Salable products are 295 and 197 of these are still being sold
	as these do not have a sellenddate

	197 TotalProducts | 61 Purchased & 136 Manufactured 

	239 products are manufactured by adventure works and
	163 of these are still being sold.
*/