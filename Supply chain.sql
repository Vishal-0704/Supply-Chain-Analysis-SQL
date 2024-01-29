-- Basic Queries

-- 1.	Find the country-wise count of customers.

select Country,count(FirstName) No_of_customers from customer group by Country;

-- 2.	Display customer information who stays in 'Mexico'

select * from customer where country='mexico';

-- 3.	Display the number of orders delivered every year.

select year(OrderDate), count(id) from orders group by year(OrderDate);

-- 4.	Display month-wise and year-wise counts of the orders placed.

select year(orderdate), month(orderdate), count(OrderNumber) from orders group by year(orderdate), month(orderdate);

-- Queries using join

-- 5.	Display the list of companies along with the product name that they are supplying.

select CompanyName, ProductName  from supplier s join product p on s.id=p.supplierid;

-- 6.	Display the companies which supplies products whose cost is above 100.

select ProductName,CompanyName, UnitPrice
from product p join supplier s on p.SupplierId = s.id 
where UnitPrice> 100;

-- Queries using join and subquery

-- 7.	Display the costliest item that is ordered by the customer.

select ProductName,CustomerId,TotalAmount 
from orders o join orderitem oi on o.id = oi.OrderId join product p on oi.ProductId = p.Id 
where TotalAmount= (select max(TotalAmount) from orders);

-- Using CTE's and window functions

-- 8.	Display supplier id who owns the highest number of products.

select * from
(select s.id, CompanyName,count(ProductName) no_of_product, dense_rank()over(order by count(ProductName) desc) rnk 
from supplier s join product p on s.id = p.SupplierId group by s.id,CompanyName)t 
where rnk=1;

-- 9.	Fetch the records to display the customer details who ordered more than 10 products in the single order

select * from
(select c.*, OrderNumber, ProductName, count(OrderNumber)over(partition by OrderNumber) no_of_product
from customer c join orders o on c.id=o.customerid join orderitem oi on o.id = oi.OrderId join product p on oi.ProductId = p.Id)t
where no_of_product > 10;

-- Queries using Correlated subquery

-- 10.	Find number of Orders placed by each customers?

select FirstName, 
(SELECT COUNT(*) FROM Orders o WHERE o.CustomerId = c.Id) no_of_orders 
from customer c order by no_of_orders desc;