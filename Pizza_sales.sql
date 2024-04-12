create schema pizzaDB;
use pizzadb;
select * from pizza_sales;
select count(*) Total_count from pizza_sales;
# Changing the datatypes
desc pizza_sales;
alter table pizza_sales modify column pizza_name_id  varchar(100) null;
# Changing the "Order_date" column from text to date
update pizza_sales set order_date=str_to_date(order_date,"%d-%m-%Y");
alter table pizza_sales modify column pizza_ingredients varchar(200) null;
alter table pizza_sales modify column pizza_name  varchar(100) null;
select * from pizza_sales;
# Total Revenue
select Round(sum(total_price)) Total_revenue from pizza_sales;
# Average order value
select sum(total_price)/count(distinct order_id) Average_order_value from pizza_sales;
# Total Pizza sold
select sum(quantity) Total_pizza_sold from pizza_sales;
# Total_orders
select count(distinct order_id) Total_orders from pizza_sales;
# Average pizza per order 
select convert(sum(quantity)/count(distinct order_id),decimal(10,2)) Average_pizza_per_order from pizza_sales;
# Queries for charts Requirements
# Daily Trend for total orders 
select  dayname(order_date) day_name ,count(distinct order_id) daily_count from pizza_sales group by dayname(order_date)  order by daily_count desc;
# Monthly Trend for total orders
select monthname(order_date) Month_name,count(distinct order_id) Monthly_count from pizza_sales group by monthname(order_date) order by
 monthly_count desc;
 # Percentage of sales by pizza category
 select * from pizza_sales;
 select distinct pizza_category from pizza_sales;
 select sum(total_price) from pizza_sales;
 select pizza_category,cast(((sum(total_price)/817860)*100) as decimal(15,2)) Percentage_of_sales from pizza_sales group by pizza_category;
 # Extras
 # Total sales & percentage of sales by pizza category per month
select pizza_category,round(sum(total_price)),cast(((sum(total_price)/(select sum(total_price) from pizza_sales where month(order_date)=2)) *100) 
as decimal(15,2)) Percentage_of_sales from pizza_sales where month(order_date)=2 group by pizza_category;
# Percentage of sales by pizza size
select * from pizza_sales;
select pizza_size,round(((sum(total_price)/(select sum(total_price) from pizza_sales)*100)),2) Percentage_of_sales from pizza_sales 
group by pizza_size order by percentage_of_sales desc;
# Extras
select pizza_size,round(((sum(total_price)/(select sum(total_price) from pizza_sales where order_date between "2015-01-01" and "2015-03-31")*100)),2) 
Percentage_of_sales from pizza_sales where order_date between "2015-01-01" and "2015-03-31" group by pizza_size order by percentage_of_sales desc;
# Top five best sellers by revenue
use pizzadb;
select * from pizza_sales;
select distinct pizza_name from pizza_sales;
# Five best sellers by revenue
select pizza_name,round(sum(total_price)) Total_revenue from pizza_sales group by pizza_name order by total_revenue desc limit 5;
# Five least pizza types/sellers by revenue 
select pizza_name,round(sum(total_price)) Total_revenue from pizza_sales group by pizza_name order by total_revenue limit 5;
# Five best sellers by quantity
select pizza_name,sum(quantity) Total_quantity from pizza_sales group by pizza_name order by total_quantity desc limit 5;
# Five least pizza sellers by quantity
select pizza_name,round(sum(quantity)) Total_quantity from pizza_sales group by pizza_name order by total_quantity limit 5;
# Top five best sellers by orders
select * from pizza_sales;
select pizza_name,count(distinct order_id) Total_orders from pizza_sales group by pizza_name order by total_orders desc limit 5;
# Five least sellers by orders
select pizza_name,count(distinct order_id) Total_orders from pizza_sales group by pizza_name order by total_orders limit 5;