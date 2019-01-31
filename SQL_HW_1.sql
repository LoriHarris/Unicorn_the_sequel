
USE sakila;
#1a - display first and last names of actors from actor table
SELECT first_name, last_name FROM actor;

#1b
ALTER TABLE actor
ADD COLUMN `Actor Name` VARCHAR(50);
SELECT CONCAT(UPPER(first_name)," ", UPPER(last_name)) as `Actor Name` FROM actor;

#2a
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

#2b
SELECT last_name from actor WHERE last_name LIKE '%GEN%'; 

#2c
SELECT last_name, first_name from actor WHERE last_name LIKE '%LI%'
ORDER BY last_name;

#2d
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a
ALTER TABLE actor
ADD COLUMN description BLOB;
ALTER TABLE actor

#3b
DROP description;

#4a
SELECT COUNT(last_name) as "Count of Last Name", last_name FROM actor GROUP BY last_name;

#4b
SELECT COUNT(last_name) as "Count of Last Name", last_name FROM actor GROUP BY last_name HAVING COUNT(last_name) >= 2;

#4c
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";
SET SQL_SAFE_UPDATES = 1;

#4d
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO" AND last_name = "WILLIAMS";
SET SQL_SAFE_UPDATES = 1;

#5a
SHOW CREATE TABLE address

#6a
SELECT staff.first_name, staff.last_name, address.address
FROM address
INNER JOIN staff ON
staff.address_id=address.address_id;

#6b
SELECT staff.first_name, staff.last_name, SUM(payment.amount)
FROM payment
INNER JOIN staff ON
staff.staff_id=payment.staff_id
GROUP BY staff.staff_id;

#6c
SELECT film.title, COUNT(film_actor.actor_id)
FROM film
INNER JOIN film_actor ON
film.film_id=film_actor.film_id
GROUP BY film.title;

#6d
SELECT COUNT(inventory_id)
FROM inventory
WHERE film_id IN 
(
SELECT film_id
FROM film
WHERE title = "Hunchback Impossible"
);

#6e
SELECT customer.last_name, customer.first_name, SUM(payment.amount) as "Total Paid by Customer"
FROM customer
INNER JOIN payment ON
customer.customer_id=payment.customer_id
GROUP BY customer.last_name;

#7a
SELECT title  
FROM film 
WHERE title LIKE 'Q%'OR title LIKE 'K%' AND language_id IN
(
SELECT language_id 
FROM `language` 
WHERE `name` = "English"
);

#7b
SELECT first_name, last_name
FROM actor
WHERE actor_id in
(
SELECT actor_id
FROM film_actor
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
)
);

#7c
SELECT customer.email, customer.first_name, 
customer.last_name, country.country
FROM customer
INNER JOIN
(address INNER JOIN 
(city INNER JOIN country
ON
city.country_id=country.country_id)
ON
address.city_id=city.city_id)
ON
address.address_id = customer.address_id
WHERE country = 'Canada';

#7d
SELECT title 
FROM film
WHERE film_id IN
(
SELECT film_id
FROM film_category
WHERE category_id IN
(
SELECT category_id
FROM category
WHERE `name` = "family" 
)
);

#7e
SELECT COUNT(film.title) as 'times rented', film.title
FROM rental
INNER JOIN
(film INNER JOIN inventory 
ON
inventory.film_id=film.film_id)
ON
inventory.inventory_id=rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(film.title) DESC;

#7f
SELECT FORMAT(SUM(payment.amount), 'C', 'en-us') as "Amount", store.store_id
FROM payment
INNER JOIN
(staff INNER JOIN store
ON
store.store_id=staff.store_id)
ON
staff.staff_id=payment.staff_id
GROUP BY store.store_id;

#7g
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN 
(address INNER JOIN
(city INNER JOIN country
ON
country.country_id=city.country_id)
ON
city.city_id = address.city_id)
ON
store.address_id=address.address_id;

#7h
SELECT category.name, sum(payment.amount)
FROM category
INNER JOIN 
(film_category INNER JOIN
(inventory INNER JOIN
(rental INNER JOIN payment
ON
rental.rental_id = payment.rental_id)
ON
inventory.inventory_id=rental.inventory_id)
ON
inventory.film_id=film_category.film_id)
ON
category.category_id=film_category.category_id
GROUP BY name
ORDER BY SUM(amount) DESC
LIMIT 5;

#8a - created view 'top 5 grossing genres'
CREATE VIEW top_5_genres AS
SELECT category.name, sum(payment.amount)
FROM category
INNER JOIN 
(film_category INNER JOIN
(inventory INNER JOIN
(rental INNER JOIN payment
ON
rental.rental_id = payment.rental_id)
ON
inventory.inventory_id=rental.inventory_id)
ON
inventory.film_id=film_category.film_id)
ON
category.category_id=film_category.category_id
GROUP BY name
ORDER BY SUM(amount) DESC
LIMIT 5;

#8b-display vew
SELECT * FROM top_5_genres

#8c-drop view
DROP VIEW top_5_genres