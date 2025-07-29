create database pizzahut;
use pizzahut;
select * from pizzas;
drop table orders;
create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id)
);
select * from  order_details;
select * from  orders;
select * from  pizza_types;
select * from  pizzas;


-- 1. Retrive the total number of orders placed
select count(order_id) as total_orde from orders;

-- 2. calculate the total revnue generated from pizza sales
SELECT sum(order_details.quantity * pizzas.price) AS total_sales
FROM order_details JOIN pizzas ON 
pizzas.pizza_id = order_details.pizza_id;
 
-- 3. identify the highest price pizza
SELECT pizza_types.name, pizzas.price
FROM pizza_types JOIN pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- 4. identify the most commonly  pizza quantity ordered 
select quantity, count(order_details_id) from order_details group by quantity;

-- 5. identify the most commonly  pizza size ordered 
select pizzas.size, count(order_details.order_details_id) as order_count from pizzas 
join order_details on pizzas.pizza_id=order_details.pizza_id 
group by pizzas.size order by order_count desc;

-- 6. list the top 5 most ordered pizza types along with their qunatities
select pizza_types.name, sum(order_details.quantity) as quantity
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details on order_details.pizza_id = pizzas.pizza_id
group by name order by quantity desc limit 5;
 
-- Intermediate Question 
-- 7. Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category, sum(order_details.quantity) as quantity from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc ;

-- 8. Determine the distribution of orders by hour of the day.
 select hour(time) , count(order_id) as order_count from orders group by hour(time) order by hour(time);
 
-- 9. join relevent tables to find the category-wise distribution of pizzas 
select category, count(name) as numberofpizzas from pizza_types group by category;

-- 10. Group the order by date and calculate the average number of pizzas ordered per day
SELECT round(AVG(quantityperday), 0) FROM
    (SELECT orders.date, sum(order_details.quantity) AS quantityperday
    FROM orders JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY date) AS avgorder;
    
-- 11. Group the order by date and checked the count &  sum of number of pizzas ordered per day
SELECT orders.date, count(order_details.quantity) AS quantityperday, sum(order_details.quantity) as sumused
FROM orders JOIN order_details ON orders.order_id = order_details.order_id
GROUP BY date order by quantityperday desc;

-- 12. Determine the top 3 most ordered pizza types based on revenue 

select pizza_types.name, sum(order_details.quantity* pizzas.price) as revenue from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on order_details.pizza_id= pizzas.pizza_id 
group by pizza_types.name order by revenue desc limit 3;

-- 13. Calculate the percentage contribution of each pizza type to total revenue. 

select pizza_types.category, round(sum(order_details.quantity* pizzas.price)/(
(select sum(order_details.quantity* pizzas.price) as totalsales from order_details join pizzas on  order_details.pizza_id= pizzas.pizza_id))* 100,3)
as revenue from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on order_details.pizza_id= pizzas.pizza_id 
group by pizza_types.category order by revenue desc;

-- 14. analyze a cumulative revenue generated over a time
select date, sum(revenue)over(order by date) as columnn from 
(select orders.date, sum(order_details.quantity* pizzas.price) as revenue 
from order_details join pizzas on  order_details.pizza_id= pizzas.pizza_id
join orders on order_details.order_id= orders.order_id 
group by orders.date) as sales; 

-- 15. determine the top 3 most ordered pizza types based on revenue for each pizza category. 
 select category, name, revenue, rank_ 
 from 
(select category, name, revenue, rank()over(partition by category order by revenue desc) as rank_ 
 from
(select pizza_types.category, pizza_types.name,sum(order_details.quantity* pizzas.price) as revenue
 from pizza_types join pizzas on pizza_types.pizza_type_id= pizzas.pizza_type_id
 join order_details on order_details.pizza_id= pizzas.pizza_id 
 group by pizza_types.category,pizza_types.name)as r) as b where rank_<4;
    
select * from  order_details;
select * from  orders;
select * from  pizza_types;
select * from  pizzas;

-- QuestionBANK
-- Basic:
-- Retrieve the total number of orders placed.
-- Calculate the total revenue generated from pizza sales.
-- Identify the highest-priced pizza.
-- Identify the most common pizza size ordered.
-- List the top 5 most ordered pizza types along with their quantities.


-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.
-- Determine the distribution of orders by hour of the day.
-- Join relevant tables to find the category-wise distribution of pizzas.
-- Group the orders by date and calculate the average number of pizzas ordered per day.
-- Determine the top 3 most ordered pizza types based on revenue.

-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.
-- Analyze the cumulative revenue generated over time.
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.



