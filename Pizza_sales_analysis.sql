-- Retrieve the total number of orders placed.

SELECT count(order_id) as total_orders
FROM orders;

-- Calculate the total revenue generated from pizza sales. 

SELECT 
 round (sum(order_details. quamtity * pizzas. price),2) as total_sales
FROM order_details join Pizzas
on pizzas. pizza_id = order_details. pizza_id 

--  Identify the highest-price pizza.

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY Pizzas.price DESC
LIMIT 1;

-- Identify the most common pizza size ordered. 

SELECT 
    pizzas.size, COUNT(order_details.order_details_id)
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size;

-- List the top 5 most ordered pizza types along with their quantities. 

SELECT 
    pizza_types.name, SUM(order_details.quamtity) AS quamtity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quamtity DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered

SELECT 
    pizza_types.category,
    SUM(order_details.quamtity) AS quamtity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quamtity DESC;


-- Join relvant tools to find the category the avg number of pizzas ordered per day. 

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category


-- Determine the top 3 most ordered pizzas types based on revenue. 

SELECT 
    pizza_types.name,
    SUM(order_details.quamtity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;


-- Group the orders by date and calculate the average number of pizzas ordered per day.  

SELECT 
    AVG(quamtity)
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quamtity) AS quamtity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quamtity;
    
    SELECT 
    pizza_types.category,
    (SUM(order_details.quamtity * pizzas.price) /  (SELECT 
 round (sum(order_details. quamtity * pizzas. price),2) as total_sales
FROM order_details join Pizzas
on pizzas. pizza_id = order_details. pizza_id ) ) * 100  as revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;


-- Analyze the cumulative revenue generated over time.  
SELECT order_date,
sum(revenue) over(order by order_date) as cum_revenue
FROM
(SELECT orders.order_date,
sum(order_details.quamtity * pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id 
join orders
on orders. order_id = order_details.order_id
group by orders.order_date)  as sales;
