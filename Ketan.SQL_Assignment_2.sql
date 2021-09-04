create database superstore ;

show databases;

/* Task 1 - Understanding the Data */

## 1. Describe the data in hand in your own words.

/* Dataset “Superstores” Contain five tables each table having information about Sales, Product, and buyer name etc.
These tables contain relational data to one another, one table follows another table information.
Cust_dimen table contain Customer_name, Customer_segment, cust_id.
Market_fact table contain information which is related to first table, 
having info about ord_id, cust_id, prod_id, ship_id, sales, discount, order_quantity, profit, shipping_cost, product_base_margin.
Order_dimen table contain order_id, order_date, order_priority, ord_id.
Prod_dimen table contain product_category, product_sub_category, prod_id.
Shipping_dimen table contain order_ID, ship_date, ship_id, ship_mode.
This all five table contain information from product order date to product delivery, 
product price, quantity, profit, and each and every information contain in sales cycle. /*
 
 ## 2. Identify and list the Primary Keys and Foreign Keys for this dataset provided to you.
 
 /*-----PRIMARY KEYS- 
 1. cust-id - cust_dimen table
 2. ord_id - orders_dimen table
 3. prod_id - prod_dimen table
 4. ship_id - shipping_dimen table 
 -------------------------------------*/
 
 /*----FOREIGN KEYS-
 1. ord_id- market_fact table
 2.prod-id-  market-fact table
 3.ship_id - market_fact table
 4.cust_id - market_fact table
  --------------------------------------------*/ 
  
  /*------Task 2 ---*/
  
/* 1. Write a query to display the Customer_Name and Customer Segment using alias 
name “Customer Name", "Customer Segment" from table Cust_dimen.*/ 

use superstore ;

select customer_name as 'Customer Name', customer_segment as 'Customer Segment'
from cust_dimen ;

/* 2. Write a query to find all the details of the customer from the table cust_dimen 
order by desc. */

select * from cust_dimen 
order by cust_id desc ;

/* 3. Write a query to get the Order ID, Order date from table orders_dimen where 
‘Order Priority’ is high. */

select order_id, order_date
from orders_dimen
where order_priority like 'high' ;

/* 4. Find the total and the average sales (display total_sales and avg_sales)  */

select sum(sales) as 'total_sales', avg(sales) as 'avg_sales' 
from market_fact ;

/* 5. Write a query to get the maximum and minimum sales from maket_fact table. */

select max(sales), min(sales) 
from market_fact ;

/* 6. Display the number of customers in each region in decreasing order of 
no_of_customers. The result should contain columns Region, no_of_customers. */

select count(*) as 'no_of_customers' , region 
from cust_dimen 
group by region
order by no_of_customers desc;

/* 7. Find the region having maximum customers (display the region name and 
max(no_of_customers) */

select region, count(*) as 'no_of_customers'
from cust_dimen
group by region 
order by no_of_customers desc limit 1 ;

/* 8. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ 
and the number of tables purchased (display the customer name, no_of_tables 
purchased)  */

SELECT c.customer_name, COUNT(*) as 'no_of_tables_purchased'
FROM market_fact m
INNER JOIN cust_dimen c ON m.cust_id = c.cust_id
WHERE c.region = 'atlantic'
AND m.prod_id = ( SELECT prod_id
FROM prod_dimen
WHERE product_sub_category = 'tables')
GROUP BY m.cust_id, c.customer_name;

/* 9. Find all the customers from Ontario province who own Small Business. (display 
the customer name, no of small business owners) */

select customer_name as 'customer name' , customer_segment as 'no of small business owners'
from cust_dimen 
where region = "ontario" and customer_segment = "small business" ;

/* 10. Find the number and id of products sold in decreasing order of products sold 
(display product id, no_of_products sold) */

select prod_id as 'product id', sum(order_quantity) as 'no_of_products sold'
from market_fact
group by prod_id
order by 'no_of_products sold' desc ;

/* 11. Display product Id and product sub category whose product category belongs to 
Furniture and Technlogy. The result should contain columns product id, product 
sub category. */

select prod_id as 'product id' , product_sub_category as 'product sub category'
from prod_dimen
where product_category in ("furniture" and "technology");

/* 12. Display the product categories in descending order of profits (display the product 
category wise profits i.e. product_category, profits)? */

select p.product_category,sum(profit)
from market_fact m
join prod_dimen p on m.prod_id = p.prod_id
group by p.product_category
order by sum(profit) desc;

/* 13. Display the product category, product sub-category and the profit within each 
subcategory in three columns. */

select p.product_category, p.product_sub_category, sum(profit)
from market_fact m
inner join prod_dimen p on m.prod_id = p.prod_id
group by p.product_category, p.product_sub_category;

/* 14. Display the order date, order quantity and the sales for the order. */

select o.order_date, sum(m.order_quantity) as "order quantity"
, sum(M.sales) as "sales of order"
from  orders_dimen o
inner join market_fact m on o.ord_id = m.ord_id 
group by o.order_date  ;

/* 15. Display the names of the customers whose name contains the 
 i) Second letter as ‘R’
 ii) Fourth letter as ‘D’ */
 
 select customer_name
 from cust_dimen
 where customer_name like '_r%';

 select customer_name
 from cust_dimen
 where customer_name like '___d%' ;
 
 /* 16. Write a SQL query to make a list with Cust_Id, Sales, Customer Name and 
their region where sales are between 1000 and 5000. */

select c.cust_id, m.sales, c.customer_name, c.region, m.cust_id
from market_fact m
inner join cust_dimen c
on c.cust_id = m.cust_id
where sales between 1000 and 5000 ;
 
 /* 17. Write a SQL query to find the 3rd highest sales. */
 
 select sales
 from 
 (select sales
 from market_fact
 order by sales desc limit 3) as a
 order by sales limit 1;
 
 /* 18. Where is the least profitable product subcategory shipped the most? For the least 
profitable product sub-category, display the region-wise no_of_shipments and the
profit made in each region in decreasing order of profits (i.e. region, 
no_of_shipments, profit_in_each_region)
 → Note: You can hardcode the name of the least profitable product subcategory */
 
 select c.region, count(distinct s.ship_id) as no_of_shipments, sum(m.profit) as profit_in_each_region
from market_fact m
inner join cust_dimen c on m.cust_id = c.cust_id
inner join shipping_dimen s on m.ship_id = s.ship_id
inner join prod_dimen p on m.prod_id = p.prod_id
where p.product_sub_category in 
(select p.product_sub_category
from market_fact m
inner join
prod_dimen p on m.prod_id = p.prod_id
group by p.product_sub_category
having sum(m.profit) <= all
(select sum(m.profit) as profits
from market_fact m
inner join prod_dimen p on m.prod_id = p.prod_id
group by p.product_sub_category))
group by c.region
order by profit_in_each_region desc;