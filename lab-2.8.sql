USE sakila;

-- 1. Write a query to display for each store its store ID, city, and country. --
SELECT s.store_id, c.city, ctry.country FROM store AS s
JOIN address AS a
ON s.address_id = a.address_id
LEFT JOIN city AS c
ON a.city_id = c.city_id
LEFT JOIN country AS ctry
ON c.country_id = ctry.country_id;

-- 2. Write a query to display how much business, in dollars, each store brought in. --
SELECT s.store_id, SUM(p.amount) AS total_dollars
FROM staff AS s
JOIN payment AS p
ON s.staff_id = p.staff_id
GROUP BY s.store_id;

-- 3. Which film categories are longest? --
SELECT c.name, AVG(f.length) AS average_film_length
FROM film_category AS fc
JOIN film AS f
ON fc.film_id = f.film_id
RIGHT JOIN category AS c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY average_film_length DESC;

-- 4. Display the most frequently rented movies in descending order. --
SELECT title, rental_rate FROM film
ORDER BY rental_rate DESC;

-- 5. List the top five genres in gross revenue in descending order. --
SELECT c.name, SUM(p.amount) AS gross_revenue
FROM category AS c
JOIN film_category AS fc
ON c.category_id = fc.category_id
LEFT JOIN film AS f
ON fc.film_id = f.film_id
LEFT JOIN inventory AS i
ON f.film_id = i.film_id
LEFT JOIN rental AS r
ON i.inventory_id = r.inventory_id
LEFT JOIN payment AS P
ON r.rental_id = p.rental_id
GROUP by c.name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 6. Is "Academy Dinosaur" available for rent from Store 1? -- 
SELECT f.title, i.store_id 
FROM film AS f
JOIN inventory AS i
ON f.film_id = i.film_id
WHERE f.title = 'Academy Dinosaur';
-- Available in store 1

-- 7. Get all pairs of actors that worked together. --
SELECT a1.actor_id, CONCAT(a1.first_name, ' ', a1.last_name), f.title, a2.actor_id, CONCAT(a2.first_name,' ', a2.last_name)
FROM actor AS a1
INNER JOIN film_actor AS fa
ON a1.actor_id = fa.actor_id
INNER JOIN film AS f
ON f.film_id = fa.film_id
LEFT JOIN film_actor AS fa2
ON fa2.film_id = f.film_id AND fa2.actor_id < fa.actor_id
LEFT JOIN actor AS a2
ON a2.actor_id = fa2.actor_id;

-- 8. Get all pairs of customers that have rented the same film more than 3 times. --
SELECT c1.customer_id, c2.customer_id, COUNT(r.rental_id) AS rentals
FROM rental AS r
INNER JOIN inventory AS i
ON r.inventory_id = i.inventory_id
LEFT JOIN customer AS c1
ON c1.customer_id = r.customer_id 
INNER JOIN customer AS c2
ON r.customer_id AND c1.customer_id > c2.customer_id
GROUP BY c1.customer_id, c2.customer_id
HAVING rentals >3;

--  I think this is the pairs of customers and total number of rentals but I am now stuck on how to get the films that are the same --

-- 9. For each film, list actor that has acted in more films. --

SELECT a.first_name, a.last_name, f.title, COUNT(f.title) AS number_of_films
FROM film_actor AS fa
INNER JOIN actor AS a
ON fa.actor_id = a.actor_id
RIGHT JOIN film AS f
ON fa.film_id = f.film_id
GROUP BY a.first_name, a.last_name, f.title;

-- Stuck on how to just pick the actor that has the most films