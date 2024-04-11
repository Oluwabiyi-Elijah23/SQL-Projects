create schema if not exists salesdatawalmart;
use salesdatawalmart;
create table if not exists sales(
invoice_id varchar(30) not null,
branch varchar(30) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(30) not null,
product_line varchar(100),
unit_price decimal(10,2) not null,
quantity integer not null,
VAT float not null,
total decimal(12,4) not null,
`date` datetime not null,
`time` time not null,
payment_method varchar(15) not null,
cogs decimal (10,2) not null,
gross_margin_percentage float not null,
gross_income decimal(12,4) not null,
rating float not null);
truncate table sales;
select * from sales;
# Feature Engineering 
select time, case when `time` between '00:00:00' and "12:00:00" then "Morning" when `time` between '12:01:00' and  "16:00:00" then "Afternoon" Else 
"Evening" end as time_of_date  from sales;
alter table sales add column time_of_day varchar(20);
-- update sales set time_of_day='Morning' where `time` between '00:00:00' and "12:00:00";
-- update sales set time_of_day='Afternoon' where `time` between "12:01:00"  and "16:00:00";
-- update sales set time_of_day='Evening' where time_of_day is null;
-- alter table sales drop column time_of_day;
update sales set time_of_day=(case when `time` between '00:00:00' and "12:00:00" then "Morning" when `time` between '12:01:00' and  "16:00:00" then "Afternoon" Else 
"Evening" end);
# Day_name
select date,dayname(date) from sales;
alter table sales add column day_name varchar(10); 
update sales set day_name=dayname(date);
# Month_name
alter table sales add column `Month` varchar(10);
alter table sales modify column `Month` varchar(15);
select date,monthname(date) from sales;
alter table sales rename column `month` to month_name;
update sales set month_name=monthname(date);
commit;
use salesdatawalmart;
select * from sales;

# Exploratory Data Analysis(EDA)
# Business questions to answer (Generic Questions)
# How many unique cities does the data have?
select  count(distinct city)from sales;
# In which city is each branch?
select distinct branch,city from sales order by branch asc;

# Product
# How many unique product lines does the data have?
select count(distinct product_line) from sales;
# What is the most common payment method?
select payment_method,count(payment_method) as total_count from sales group by payment_method order by total_count asc limit 2,1;
# What is the most selling product line?
select product_line,count(product_line) as count_of_productline from sales group by product_line order by count_of_productline desc;
# What is the total revenue by month?
select  month_name,(round(sum(total),2)) as total_revenue from sales group by month_name order by total_revenue desc;
select * from sales;
# What month had the largest cogs?
# Cogs:Cost of goods sold
select `month_name`,sum(cogs) from sales group by `month_name` order by sum(cogs) desc;
# What product line has the largest revenue? 
select product_line,(round(sum(total),2)) as sum_of_revenue from sales group by product_line order by sum_of_revenue desc;
# What is the city with the largest revenue?
select city,round(sum(total),2) as sum_of_revenue from sales group by city order by sum_of_revenue desc;
# Which product line had the highest VAT?
select product_line,round(sum(vat),2) from sales group by product_line order by sum(vat) desc;
# Fetch each product line and add a column to those product line showing "Good","Bad". Good if its greater than average sales
select distinct product_line from sales;
select product_line,sum(total), case when sum(total) >avg(total) then "Good" else "Bad" end as status_of_product_line from sales 
group by product_line;
# Which branch sold more product than average product sold?
select branch,sum(quantity) from sales group by branch having sum(quantity)>avg(quantity) order by sum(quantity) desc;
# What is the most common product line by gender?
select * from sales;
select gender, product_line,count(gender) from sales group by product_line,gender order by count(gender) desc;
# What is the average rating of each product line?
select product_line,(round(avg(rating),2))from sales group by product_line order by avg(rating) desc;

# Sales
# Number of sales made in each time of day per weekday
select * from sales;
select distinct day_name from sales;
select day_name, time_of_day,count(total) from sales group by day_name,time_of_day order by day_name asc;
# Which of the customer types brings the most revenue?
select distinct customer_type from sales;
select customer_type,round(sum(total),2) as Total_revenue from sales group by customer_type;
# Which city has the largest value added tax?
select city,round(sum(vat),2) value_added_tax from sales group by city order by value_added_tax desc;
# Which customer type pays the most in VAT?
select customer_type,round(sum(vat),2) Total_VAT from sales group by customer_type order by Total_vat desc;

# Customer
# How many unique customer_types does the data have? 
select count(distinct customer_type) customer_type_count from sales;
# How many unique payment methods does the data have?
select count(distinct payment_method) payment_method_count from sales;
# What is the most common customer type?
select customer_type,count(customer_type) from sales group by customer_type;
# Which customer type buys the most?
select customer_type,sum(quantity) from sales group by customer_type;
# What is the gender of most of the customers?
select * from sales;
select gender,count(gender) gender_count from sales group by gender order by gender_count desc;
# What is the gender distribution per branch?
select branch,gender,count(gender) Gender_distribution  from sales group by branch,gender order by branch;
select branch,count(gender) Gender_distribution from sales where gender in (select gender where gender='male')  group by branch order by branch;
# What time of day do customers give most ratings
select time_of_day,count(rating) count_of_ratings from sales group by time_of_day order by count(rating) desc;
# What time of day do customers give most ratings per branch?
select distinct branch from sales;
select branch,time_of_day,count(rating) count_of_ratings from sales group by time_of_day,branch order by branch asc;
# Which day of the week has the best average ratings?
select * from sales;
select day_name,avg(rating) Average_rating from sales  group by day_name order by average_rating desc;
# Which day of the week has the best average rating per branch?
select day_name,avg(rating) Average_rating from sales where branch in (select branch where branch='b') group by day_name order by average_rating desc;








