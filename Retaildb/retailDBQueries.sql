-- use retaildb;
-- show tables;
-- describe products;

select *						-- fetch the data 
	from products				-- from where data has to come
where quantityInstock >7500;	-- if there is any condition applied
    
    
select distinct productline 
from products;
   
   
select *
    from products 
    where productname RLIKE 'ship|boat';
	
    
select productline, count(*)
		from products 
        group by productline
        order by 2 desc;
		
        
select * 	
	from payments;
	

select count(*) from payments;
select round(avg(amount),2) as AvgAmount from payments;
select max(amount) as MaxAmount from payments;
select min(amount) as minAmount from payments;


select round(avg(amount),2) as AvgAmount from payments;


-- all the rows where amount is greater than avg amount 
select *
	from payments
    where amount > (select round(avg(amount),2) as AvgAmount from payments);


-- find all columns for max amount
select *
	from payments
    where amount = (select max(amount) as MaxAmount from payments);
    
    
-- second best amount or five best amount after the highest amount   
select *
	from payments
    where amount < (select max(amount) as MaxAmount from payments)
    order by amount desc
    limit 5;
    
select *
	from customers;
    
select country, count(*) as Total
	from customers
    group by country
    order by count(*) desc;

select *
		from customers
        where salesRepEmployeeNumber is null;
        
        
select *
		from customers
        where salesRepEmployeeNumber is not null;        

select count(*)
		from customers
        where salesRepEmployeeNumber is not null;   
                
select 
	count(case when salesRepEmployeeNumber is null then 1 end) as SalesRep_No,
    count(case when salesRepEmployeeNumber is not null then 1 end) as SalesResp_Yes
	from customers;
                
    
-- sales Rep for each customer
select c.customerName, concat(e.firstname,' ', e.lastname) as RepName
		from customers c
        join 
        employees e on c.salesRepEmployeeNumber = e.employeeNumber;
        
        
-- total amount for Mini Wheels Co.
select c.customerName, sum(p.amount) as TotalAmount
			from payments p 
            join 
            customers c on
            p.customerNumber = c.customerNumber
            where c.customerName = 'Mini Wheels Co.'
            group by c.customerName;
            
select * , month(paymentDate) as month, year(paymentDate) as year
	from payments;
    
    

select year(paymentDate) as Year, sum(amount)
		from payments
        group by year(paymentDate);
        
-- customer name with more than 5000 amount payments
select c.customerName, sum(p.amount) as Total_Amount
	from payments p
    join 
    customers c
	on p.customerNumber = c.customerNumber
    where p.amount > 50000
    group by c.customerName
    order by 2 desc;
    
-- cancelled orders for customers
select c.customerName, count(*) as 'Orders_Cancelled'
	from customers c 
    join 
    orders o 
    on c.customerNumber = o.customerNumber
    where o.status ='cancelled'
	group by c.customerName;
        
        
-- orders on a perticular day 
select p.productName, o.orderDate, dayname(o.orderdate) as Day
		from products p 
        join orderdetails od 
        on p.productCode = od.productCode 
        join orders o 
        on od.orderNumber = o.orderNumber
        where dayname(o.orderdate) = 'Sunday';


-- list products from a customer 
select p.productName, p.productLine, o.orderNumber, od.priceEach, c.customerName
	from products p 
    join orderdetails od 
    on p.productCode = od.productCode
    join orders o 
    on od.orderNumber = o.orderNumber
    join customers c
    on c.customerNumber = o.customerNumber
    where c.customerName = 'Herkku Gifts'
    
    
    
    
    




        
        
        
        
        
        

            
            
            
            
            
        
    
    
        
    
    

    
