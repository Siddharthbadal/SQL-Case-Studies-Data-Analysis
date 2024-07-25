-- Know your data table
USE walmart;
SHOW tables;
SHOW columns from sales;

-- Exploratory Data Analysis - Basic Data Exploration;
SELECT count(*) FROM sales;
-- Unique Customer Type

select distinct Customertype from sales;
-- unique payments methord

select distinct payment from sales;
-- all unique cities
select distinct city from sales;

-- unique product lines
select distinct Productline from sales;

-- branches in each city
select distinct city, count(branch) as num_of_branch
	from sales
    group by city;

-- productline in each branch by gender
select distinct branch, gender, count(distinct productline) as num_of_productline
	from sales
    group by branch, gender
    order by 1;
        
-- Common payment methords
select payment, count(payment)
	from sales
    group by payment;
    
-- common product line
select  productline, count(productline)
	from sales
    group by productline
    order by 2 desc;

-- revenue by months
select MonthName, sum(total) as Revenue
	from sales
    group by MonthName;
    
-- most revenue by city
select city, sum(total) as Revenue
		from sales
        group by city;
    
    



