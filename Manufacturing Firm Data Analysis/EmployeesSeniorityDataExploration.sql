-- Looking into the seniority of the employess in the database and grouping these

-- ranking the employess
select rank() over(order by hiredate) as 'workingPeriod', *
		from HumanResources.Employee;

-- declaring current employee		
declare @currentDate date = '2015-01-01'
--  finidng the employess tenure by years, months and days
select	
		t2.FirstName,
		t2.LastName,
		 t1.JobTitle
		, t1.HireDate
		, t1.BusinessEntityID,
		t2.personType,
		rank() over(order by hiredate asc) as 'Rank',
		DATEDIFF(year, HireDate, @currentDate) as 'YearEmployed',
		DATEDIFF(month, HireDate, @currentDate) as 'MonthsEmployed',
		DATEDIFF(day, HireDate, @currentDate) as 'DaysEmployed'
		INTO #tempTable1
		from HumanResources.Employee t1 
		join Person.person t2 on 
		t1.BusinessEntityID = t2.BusinessEntityID
		


		
-- grouping the employes by working tenure
select 
	case when YearEmployed between 0 and 2 then 'EmployedLessThanTwoYear'
		when YearEmployed between 2 and 4 then 'EmployedLessThanFourYears'
		when YearEmployed between 4 and 6 then 'EmployedLessThanSixYears'
		when YearEmployed between 6 and 8 then 'EmployedLessThanEightYear'
		else 'OverEightYears'
		End as 'yearslEmployedGroup',
		count(*) as employeeCount
		
from #tempTable1
group by case when YearEmployed between 0 and 2 then 'EmployedLessThanTwoYear'
		when YearEmployed between 2 and 4 then 'EmployedLessThanFourYears'
		when YearEmployed between 4 and 6 then 'EmployedLessThanSixYears'
		when YearEmployed between 6 and 8 then 'EmployedLessThanEightYear'
		else 'OverEightYears'
		End 
