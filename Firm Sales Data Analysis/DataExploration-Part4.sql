-- working with SalesOrderHeader and SalesOrderDetails


-- Difference between "SubTotal" and "TotalDue"

select format(sum(SubTotal), 'N0') as SubTotal,
	   format(sum(TotalDue), 'N0') as TotalDue,
	   format(sum(TotalDue) - sum(SubTotal), 'C0') as difference 
from Sales.SalesOrderHeader
where SalesOrderID = '69412'


select format(sum(linetotal), 'C0')
from Sales.SalesOrderDetail
where SalesOrderID = '69412'



-- TotalDue calculations in SalesOrderHeader
select 
		subTotal, taxAmt, Freight, 
		format((subtotal + taxAmt + Freight), 'C0') as Total, 
		format(TotalDue, 'C0') as TotalDue
from Sales.SalesOrderHeader
where SalesOrderID = '69412'


-- calculate line total 
select format(sum(UnitPrice*(1-unitpricediscount)*orderQty),'C0') as Computed,
		format(sum(LineTotal),'C0') as LineTotal
from Sales.SalesOrderDetail
where SalesOrderID = '69412'



/*
Summary :
There is a difference between subtotal and totaldue. (first query above)
Total due from customer is calculated as : Subtotal + TaxAmt + Freight (Second Query Above)
linetotal is Per product subtotal.

LineTotal calculations:  UnitPrice * (1 - UnitPriceDiscount) * OrderQty. (Third Query Above)
*/

