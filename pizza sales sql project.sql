create database pizza_world;
use pizza_world;

create table orders (
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id));



create table order_details (
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id));

-- Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id)
FROM
    orders AS total_orders;
 
 
 
-- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            0) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

-- Identify the highest-priced pizza.

SELECT 
    pizza_types.name, pizzas.price AS HIGHEST_PRICED_PIZZA
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- Identify the most common pizza size ordered.

SELECT 
    pizzas.size, COUNT(order_details.quantity) AS TOTAL_QUANTITY
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size;


-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS total_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_quantity DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of 
-- each pizza category ordered.

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS TOTAL_ORDERS
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category;

-- Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(ORDER_TIME) AS HOUR, COUNT(ORDER_ID) AS ORDER_COUNT
FROM
    ORDERS
GROUP BY HOUR(ORDER_TIME);


-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name) AS total_distribution
FROM
    pizza_types
GROUP BY category;


-- Group the orders by date and calculate the
--  average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(total_orders), 0) AS avg_order_per_day
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) total_orders
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name,
    ROUND(SUM(order_details.quantity * pizzas.price),
            0) AS TOTAL_REVENUE
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY TOTAL_REVENUE
LIMIT 3;


-- Calculate the percentage contribution of each pizza type to total revenue.


SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * PRICE), 0) / (SELECT 
            ROUND(SUM(order_details.quantity * pizzas.price),
                        2) TOTAL_SALES
        FROM
            order_details
                JOIN
            pizzas ON order_details.pizza_id = pizzas.pizza_id) * 100 AS REVENUE
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY REVENUE DESC;


-- Analyze the cumulative revenue generated over time.

select order_date , sum(revenue) 
over(order by order_date) as cum_revenue
from
(select orders.order_date , 
sum(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas 
on order_details.pizza_id = pizzas.pizza_id
join orders on orders.order_id = order_details.order_id
group by orders.order_date) as sales ;
 
