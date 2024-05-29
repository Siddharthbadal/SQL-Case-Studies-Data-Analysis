use shop_data;
show tables;
-- select count(*) from sales;

-- Fetch sales data where amount is greater than 2500 and boxes < 100.
SELECT *
	FROM sales
    where amount > 2500 and boxes < 100;
    
-- Find the total sales for each salesperson in a perticular month. Eg. Jan 2022.
SELECT s.SPID,  p.Salesperson, sum(s.Amount)
	FROM sales s 
    RIGHT JOIN people p 
    on s.SPID = p.SPID
WHERE month(s.SaleDate)= 01 and 
	  year(s.SaleDate) = 2022 
GROUP BY p.Salesperson, s.SPID
order by s.Amount Desc;  


-- Product with most boxes
SELECT DISTINCT p.Product, sum(s.Boxes) AS Total_Boxes, sum(s.Amount) as Total_Amount
	FROM products p
    JOIN sales s
    on p.PID = s.PID
GROUP BY p.Product
ORDER BY 2 desc;

-- Which producs sold more boxes in the first week of JAN 2022.
SELECT sum(s.Boxes), p.product
	FROM sales s 
    RIGHT JOIN products p 
    ON s.PID = p.PID
WHERE month(s.SaleDate)= 01 and 
	  year(s.SaleDate) = 2022 and
      day(s.SaleDate) BETWEEN 01 and 07
GROUP BY p.Product
order by 1 desc;



-- Find sales under 100 customers and 100 boxes. filter data for wednesday.

SELECT *,
	CASE WHEN Customers > 100 AND Boxes > 100 AND weekday(SaleDate) = 2
    THEN "OKAY"
		ELSE " -"
	END as "Result"
	FROM sales
ORDER BY Result Desc;


-- Count of above values. 
SELECT 
	COUNT(CASE WHEN Customers > 100 AND Boxes > 100 AND weekday(SaleDate) = 2
    THEN 1
		ELSE NULL
	END) as "Okay",
    COUNT(CASE WHEN Customers > 100 AND Boxes > 100 AND weekday(SaleDate) = 2
    THEN NULL
		ELSE 1
	END) as "Okay"
    
	FROM sales
ORDER BY Okay Desc;




