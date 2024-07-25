-- Table details
show tables;
show columns from car_prices;

-- check the data
select * from car_prices;

-- total rows
select count(*) from car_prices;

-- Total SUV cars
select count(*) from car_prices where body ='SUV';

-- count of cars in a year
select count(*) from car_prices where year='2015';

-- data by transmission
select transmission, count(*) as Total
	from car_prices
    where transmission <> ''
    group by transmission;
    
-- selling price more than average selling price 
select *
		from car_prices
        where sellingprice > (select avg(sellingprice) from car_prices)
        order by sellingprice desc;

-- which car maker is sold most
select make, count(*) as Total
	from car_prices
    group by make 
    order by 2 desc
    limit 10;
    
    
-- revenue by makers
select make, sum(sellingprice) as Revenue
	from car_prices
    group by make 
    order by 2 desc
    limit 10;


-- Average sellingprice over the years
select year, round(avg(sellingprice),2) as avg_sellingprice 
		from car_prices
        group by year 
        order by 2;

-- Top 5 Selling Model
select model, count(*) as Total
	from car_prices
    group by model 
    order by 2 desc
    limit 10;


-- Min, Max, Avg Price for each maker
select make, 
		min(sellingprice) as Minimum_Price,
		round(avg(sellingprice), 2) as Average_Price,
        max(sellingprice) as Maximum_Price
	from car_prices
    group by make 
    order by 3 desc;
    
-- Market Share of Makers
select make, 
		round((count(*)/(select count(*) from car_prices))*100,2) as PercentageShare
	from car_prices
    group by make 
    order by 2 desc
    limit 10;
    
    
-- state by analysis
select state, count(*) as Total
	from car_prices
    group by state 
    order by 2 desc;
        
-- sales share by state
select state, 
		round((count(*)/(select count(*) from car_prices))*100,2) as PercentageShare
	from car_prices
    group by state 
    order by 2 desc
    limit 10;


-- how does conditions impact sales 
select 
	count(case when car_prices.condition between 0 and 10 then 1 end) as '0-10',
    count(case when car_prices.condition between 10 and 25 then 1 end) as '10-25',
    count(case when car_prices.condition between 25 and 50 then 1 end) as '25-50',
    count(case when car_prices.condition between 50 and 100 then 1 end) as '50-100'
	from car_prices;

-- Most common sold cars
select	make, 
		model, 
        count(*)
		from car_prices 
        group by make, model
        order by 3 desc
        limit 10;
        
-- create a temporary table with sale year , month and day
drop temporary table car_prices_temp;
create temporary table car_prices_temp as
select `year` as manufacutring_year, make, model, trim, body, transmission, vin, state, 
		`condition` as car_condition, odometer, 
		color, interior, seller, mmr, sellingprice,
	mid(saledate, 12, 4) as sale_year,
    mid(saledate, 5, 3) as sale_monthname,
    mid(saledate, 9, 2) as sale_day,
    case mid(saledate, 5, 3)
		when 'Jan' then 1
        when 'Feb' then 2
        when 'Mar' then 3
        when 'Apr' then 4
        when 'May' then 5
        when 'Jun' then 6
        when 'Jul' then 7
        when 'Aug' then 8
        when 'Sep' then 9
        when 'Oct' then 10
        when 'Nov' then 11
        when 'Dec' then 12
        else 'None'
        end sale_month
	from car_prices
    where make !='' and model !='';
    
select * from car_prices_temp;   
 
-- find average selling price by month for each year
select sale_year,
		sale_month,
        avg(sellingprice) as avg_price
	from car_prices_temp
    group by sale_year, sale_month
    order by sale_year desc , sale_month;
    
-- Sales by months
select sale_month,
		count(*) as Total
	from car_prices_temp
    group by sale_month
    order by 2 desc;
    
-- Top Cars by body type
select *
from (
	select make,
		model,
		body,
		count(*) as total_sales,
		rank() over(partition by body order by count(*) desc) as body_rank
		from car_prices
        where body != ''
		group by make, model, body
		order by body asc, count(*) desc
		) as t
        where body_rank <= 5
        order by body asc, total_sales desc;
        
        
-- sales prices in comparision to avg prices by models and make
select *
	from 
		( select make, model, vin, sale_year, sale_month, sale_day, sellingprice,
	avg(sellingprice) over(partition by make, model) as avg_model_price
	from car_prices_temp) as t 
    where sellingprice > avg_model_price
    order by sellingprice desc;

-- get the price ratio for above query
select *, sellingprice / avg_model_price as price_ratio
	from 
		( select make, model, vin, sale_year, sale_month, sale_day, sellingprice,
	avg(sellingprice) over(partition by make, model) as avg_model_price
	from car_prices_temp) as t 
    where sellingprice > avg_model_price
    order by sellingprice / avg_model_price desc;

-- ordering models on average selling price 
select	
	make,
    count(distinct model) as num_models,
    count(*) as num_sales,
    min(sellingprice) as Min_sellingPrice,
    max(sellingprice) as Max_sellingPrice,
    avg(sellingprice) as Avg_sellingPrice
	from car_prices
    where make != ''
    group by make
    order by Avg_sellingPrice desc;
        
        




        