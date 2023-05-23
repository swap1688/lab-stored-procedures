# Lab | Stored procedures

### Instructions

## Write queries, stored procedures to answer the following questions:
# 1.
-- In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented `Action` movies. 
-- Convert the query into a simple stored procedure. Use the following query:
USE sakila;
delimiter //
create procedure customer_rented_action()
begin
    select first_name, last_name, email
    from customer
    join rental on customer.customer_id = rental.customer_id
    join inventory on rental.inventory_id = inventory.inventory_id
    join film on film.film_id = inventory.film_id
    join film_category on film_category.film_id = film.film_id
    join category on category.category_id = film_category.category_id
    where category.name = "Action"
    group by first_name, last_name, email;
  end;
//
delimiter ;

call customer_rented_action();

-- Now keep working on the previous stored procedure to make it more dynamic. 
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be `action`, `animation`, `children`, `classics`, etc.

delimiter //
create procedure customer_rented_category(in cat char(20))
begin
    select first_name, last_name, email
    from customer
    join rental on customer.customer_id = rental.customer_id
    join inventory on rental.inventory_id = inventory.inventory_id
    join film on film.film_id = inventory.film_id
    join film_category on film_category.film_id = film.film_id
    join category on category.category_id = film_category.category_id
    where category.name = cat COLLATE utf8mb4_general_ci
    group by first_name, last_name, email;
  end;
//
delimiter ;

call customer_rented_category('animation');

# 2.
-- Write a query to check the number of movies released in each movie category. 
SELECT name, COUNT(film_id) as Number_of_films
FROM film_category 
JOIN category 
USING (category_id)
GROUP BY category_id 
ORDER BY Number_of_films;

-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.

delimiter //
create procedure category_movies(in numb int)
begin
SELECT name, COUNT(film_id) as Number_of_films
FROM film_category 
INNER JOIN category 
USING (category_id)
GROUP BY category_id 
HAVING Number_of_films > numb
ORDER BY Number_of_films;
 end;
//
delimiter ;


call category_movies(70);

