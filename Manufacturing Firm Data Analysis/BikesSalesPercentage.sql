-- Monthly Sales % of mountain and road bikes in year 2012

	select month(orderdate) as month,
		sum(case when t1.name = 'mountain bikes' then t4.SubTotal else 0 end) as mountain_bike_sales,
		sum(case when t1.name = 'road bikes' then t4.SubTotal else 0 end) as road_bike_sales,
		sum(t4.SubTotal) as TotalSales
	from 
		Production.ProductSubcategory t1 join 
		Production.Product t2 on
		t1.ProductSubcategoryID = t2.ProductSubcategoryID join
		Sales.SalesOrderDetail t3 on
		t2.ProductID = t3.ProductID join 
		Sales.SalesOrderHeader t4 on
		t3.SalesOrderID = t4.SalesOrderID
	where 
		year(t4.orderdate) = '2012'
	group by 
		month(orderdate)
	order by 1;


 /*
	Summary:
		Road bike Sales are higher accross the year. and in april and december the difference is more than 30%
		Road bike sales were as higher as 45% of total sales
		Moutain bikes sales are as lower as 11% of toal bikes sales
		Chart attached. 
 */
