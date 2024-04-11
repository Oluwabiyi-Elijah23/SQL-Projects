select * from customer_orders;
select * from driver_order;
# Roll Metrics
# How many rolls were ordered?
select * from customer_orders;
select count(order_id) from customer_orders;
# How many unique customer orders were made?
select * from customer_orders;
select count(distinct customer_id) Unique_customer_orders from customer_orders;
# How many successful orders were delivered by each driver?
select  driver_id,count(pickup_time) Successful_orders from driver_order where pickup_time is not null group by driver_id;
# How many of each type of roll was delivered?
select * from customer_orders;
select * from rolls;
select roll_id,roll_name,sum(count_of_rolls) Amount_of_rolls_delivered from
(select driver_id,pickup_time,roll_name, roll_id, count(roll_name) count_of_rolls from
(select driver_id,pickup_time,b.roll_id,c.roll_name from
(select driver_id,pickup_time,b.roll_id from
(select * from driver_order where pickup_time is not null)a inner join customer_orders b on a.order_id=b.order_id)b join rolls c 
on b.roll_id=c.roll_id)d group by driver_id,pickup_time,roll_name,roll_id order by driver_id)e group by roll_id, roll_name;
# How man veg and non veg roles were ordered by each customer?
select * from customer_orders;
select customer_id,roll_name,count(roll_name) count_of_rolls from 
(select c.customer_id,c.roll_id,r.roll_name from customer_orders c inner join rolls r on c.roll_id=r.roll_id)a group by customer_id,roll_name 
order by customer_id;
# What is the maximum number of rolls in a single order?
select * from customer_orders;
select order_id,customer_id,count(roll_id) count_of_rolls from  customer_orders group by order_id,customer_id order by count_of_rolls desc limit 1;
# Basic data cleaning
# Customer_orders table
create temporary table newcustomer_orders select * from customer_orders;
select * from newcustomer_orders;
update newcustomer_orders set not_include_items=0 where not_include_items="";
update newcustomer_orders set not_include_items=0 where not_include_items is null;
update newcustomer_orders set extra_items_included=0 where extra_items_included in ("","NaN");
update newcustomer_orders set extra_items_included=0 where extra_items_included is null;
# Driver_order table
create temporary table newdriver_order select * from driver_order;
select * from newdriver_order;
update newdriver_order set  cancellation="Not Cancelled" where cancellation is null;
update newdriver_order set  cancellation="Not Cancelled" where cancellation in ("","nan");
update newdriver_order set  cancellation="Order Cancelled" where cancellation in ("cancellation","customer cancellation");
# For each customer, how many delivered rolls had at least one change and how many had no changes?
select * from newdriver_order;
select * from newcustomer_orders;
select customer_id,Ingredient_status, count(ingredient_status) Ingredient_status_count from
(select customer_id,not_include_items,extra_items_included, case when not_include_items=0 and extra_items_included=0 then "No Change" else 
"Changed" end as Ingredient_status from
(select a.order_id,driver_id,pickup_time,b.customer_id,b.not_include_items,b.extra_items_included from
(select * from newdriver_order where cancellation <>"order cancelled")a inner join newcustomer_orders b on a.order_id=b.order_id)b)c 
group by customer_id,ingredient_status order by customer_id;
# How many rolls were delivered that had both exclusions and extras?
select * from newcustomer_orders;
select * from rolls;
Select Inclusions_and_Exclusions,count(Inclusions_and_Exclusions) Delivery_Ingredients from
(select customer_id,driver_id,d.roll_id,not_include_items,extra_items_included,c.roll_name,
case when not_include_items<>0 and extra_items_included<>0 then "Yes" else "No" end as Inclusions_and_Exclusions from 
(select a.order_id,driver_id,pickup_time,b.customer_id,b.not_include_items,b.extra_items_included,b.roll_id from
(select * from newdriver_order where cancellation <>"order cancelled")a inner join newcustomer_orders b on a.order_id=b.order_id)d 
join rolls c on d.roll_id=c.roll_id)e group by Inclusions_and_Exclusions order by count(Inclusions_and_Exclusions);
# What was the total number of rolls ordered for each hour of the day?
select * from newcustomer_orders;
select order_time_in_hours,count(distinct order_id) count_of_orders from
(select order_id,time(order_date) order_time,hour(time(order_date)) order_time_in_hours from newcustomer_orders)a group by order_time_in_hours
order by count_of_orders desc;
# What is the number of orders for each day of the week?
select * from newcustomer_orders;
select day_of_week,count(distinct order_id) Number_of_orders from
(select order_id,date(order_date) order_date,dayname(date(order_date)) day_of_week from newcustomer_orders)a group by day_of_week 
order by number_of_orders desc;
select * from newdriver_order;
# Driver and customer Experience
# What is the average time in minutes it took for each driver to arrive at the headquaters to pick up the order
create temporary table average_time select * from
(select  (a. order_id),b.driver_id,b.pickup_time,order_date,minute(pickup_time)-minute(order_date) commute_time from
(select * from newcustomer_orders)a join newdriver_order b on a.order_id=b.order_id where pickup_time is not null)c ;
select * from average_time;
update average_time set commute_time=21 where commute_time=-39;
select driver_id,round(avg(commute_time)) Average_commute_time from
(select distinct order_id,driver_id,(commute_time) from average_time)a group by driver_id;
# Is there any relationship between number of rolls and how long the order takes to prepare?
select * from customer_orders;
select * from driver_order;
create temporary table relationship select * from
(select a.order_id,b.roll_id, minute(pickup_time),minute(order_date),minute(pickup_time)-minute(order_date) from
(select * from driver_order where pickup_time is not null)a inner join customer_orders b on a.order_id=b.order_id)c;
select * from relationship;
update relationship set time_difference=21 where time_difference=-39;
select distinct order_id,count(roll_id) count_of_orders,time_difference from relationship group by order_id,time_difference;
# Created a chart in excel for the code above
# What was the average distance travelled for each customer?
select * from customer_orders;
select * from driver_order;
select customer_id,round(avg(distance)) `Average_distance_travelled(km)`from
(select a.driver_id,b.customer_id, a.distance from
(select order_id,driver_id,distance,duration_in_minutes from driver_order where pickup_time is not null)a inner join customer_orders b 
on a.order_id=b.order_id order by customer_id)y group by customer_id;
# What was the difference between the longest and shortest delivery times for all orders?
select * from customer_orders;
select * from driver_order;
select max(duration_in_minutes) maximum_duration,min(duration_in_minutes) minimum_duration,max(duration_in_minutes)-min(duration_in_minutes) 
Duration_difference_in_minutes from driver_order;
# What was the average speed for each driver for each delivery and do you notice any trend for these values?
select * from driver_order;
create temporary table average_speed select * from driver_order;
select * from average_speed;
delete from average_speed where pickup_time is  null;
alter table average_speed modify column distance int null;
select mid(distance,1,2) from average_speed where distance is not null;
update average_speed set distance=mid(distance,1,2);
select driver_id,avg(speed) Average_speed from
(select driver_id,distance,duration_in_minutes,distance/duration_in_minutes speed from average_speed)a group by driver_id order by avg(speed) desc;
select count(*) from average_speed;
# More detailed answer
select driver_id,avg(speed) Average_speed,count(roll_count) roll_count from
(select a.order_id, driver_id,speed,count(b.roll_id) roll_count from
(select driver_id,order_id, distance,duration_in_minutes,distance/duration_in_minutes speed from average_speed)a inner join 
customer_orders b on a.order_id=b.order_id group by order_id,driver_id,speed order by driver_id)c group by driver_id;
# What is successful delivery percentage for each driver?
select * from driver_order;
select  driver_id, round((sum(delivery_status)/count(driver_id))*100) Percentage_of_successful_deliveries from
(select driver_id,case when cancellation like "c%" then 0 else 1 end as delivery_status from driver_order)a group by driver_id;


