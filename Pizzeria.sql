create schema Benspizzeria;
use benspizzeria;
create table orders(row_id int unique not null,
order_id varchar(15),
created_at datetime,
item_name varchar(100),
item_category varchar(100),
item_size varchar(40),
item_price decimal(5,2),
quantity int,
customer_id int,
delivery boolean,
delivery_address1 varchar(200),
delivery_address2 varchar(200),
delivery_city varchar(100),
delivery_zipcode varchar(50));
select * from orders;
desc orders;
create table customers (customer_id int primary key,First_name varchar(100),Last_name varchar(100));
select * from customers;
desc customers;
alter table orders add constraint foreign key(customer_id) references customers(customer_id);
create table address (address_id int )select delivery_address1,delivery_address2,delivery_city,delivery_zipcode from orders;
select * from address;
desc address;
alter table address modify address_id int primary key;
alter table orders add column address_id int, add constraint foreign key(address_id) references address(address_id);
create table item(item_id int,sku varchar(20))select item_name,item_category item_size,item_price from orders;
select * from item;
desc item;
alter table item modify column item_id int primary key;
alter table orders add column item_id int, add constraint foreign key(item_id) references item(item_id);
create table recipe(row_id int primary key,recipe_id varchar(20),ing_id varchar(10),quantity int);
select * from recipe;
desc recipe;
alter table recipe modify recipe_id varchar(20) unique;
alter table item add constraint foreign key(sku) references recipe(recipe_id);
desc item;
create table ingredient (ing_id varchar(10) not null unique,ing_name varchar(200),ing_weight int,ing_meas varcharacter(20),ing_price decimal(5,2));
describe ingredient;
alter table recipe add constraint foreign key(ing_id) references ingredient(ing_id);
desc recipe;
create table inventory(inv_id int primary key,item_id varchar(10), quantity int);
select * from inventory;
desc inventory;
alter table inventory modify column item_id varchar(10) unique;
alter table recipe add constraint foreign key(ing_id) references inventory(item_id);
create table rota(row_id int primary key,rota_id varchar(20),`date` datetime, shift_id varchar(20),staff_id varchar(20));
select * from rota;
alter table rota modify column date datetime unique;
alter table orders add constraint foreign key(created_at) references rota(date);
create table shift(shift_id varchar(20)primary key,day_of_week varchar(10),start_time time,end_time time);
select * from shift;
alter table rota add constraint foreign key(shift_id) references shift(shift_id);
create table staff(staff_id varchar(20) primary key,first_name varchar(20),last_name varchar(50),position varchar(100),hourly_rate decimal(5,2));
select * from staff;
alter table rota modify column staff_id varchar(20) unique;
alter table staff add constraint foreign key(staff_id) references rota (staff_id);
desc rota;
show tables;






