-- I think i can do usin joins and subqueries, but i'm doing only
-- with subqueries because it's a lab about that.

USE sakila;

-- PART 1

SELECT * FROM sakila.inventory;
SELECT COUNT(*) FROM (
	SELECT inventory_id 
	FROM sakila.inventory
	WHERE film_id = (
		SELECT film_id 
		FROM sakila.film
		WHERE title = 'Hunchback Impossible'
	) 
) sub1;

-- PART 2

SELECT * FROM sakila.film;
SELECT * 
FROM sakila.film
WHERE length > (
	SELECT AVG(length) AS average
	FROM sakila.film
);

-- PART 3

SELECT * FROM sakila.film;
SELECT * FROM sakila.film_actor
ORDER BY film_id;
SELECT actor_id, first_name, last_name 
FROM sakila.actor
WHERE actor_id IN (
	SELECT actor_id
    FROM sakila.film_actor
    WHERE film_id = (
		SELECT film_id FROM sakila.film
		WHERE title = 'Alone Trip'
        )
);

-- PART 4

SELECT * FROM sakila.category;
SELECT * FROM sakila.film_category;
SELECT * FROM sakila.film;
SELECT film_id, title 
FROM sakila.film
WHERE film_id IN (
	SELECT film_id
	FROM sakila.film_category
	WHERE category_id IN (
		SELECT category_id
		FROM sakila.category
		WHERE name = 'FAMILY'
	)
);

-- PART 5

SELECT * FROM sakila.customer;
SELECT * FROM sakila.country;
SELECT * FROM sakila.address;
SELECT * FROM sakila.city;
SELECT customer_id, first_name, last_name, email
FROM sakila.customer
WHERE address_id IN (
	SELECT address_id 
	FROM sakila.address
	WHERE city_id IN (	
		SELECT city_id 
		FROM sakila.city
		WHERE country_id IN (
			SELECT country_id 
			FROM sakila.country
			WHERE country = 'CANADA'
		)
	)
)
ORDER BY customer_id ASC;

SELECT c.customer_id, c.first_name, c.last_name, c.email
FROM sakila.customer c
INNER JOIN sakila.address a USING(address_id)
INNER JOIN sakila.city ci USING(city_id)
INNER JOIN sakila.country co USING(country_id)
WHERE country LIKE 'CANADA'
ORDER BY c.customer_id ASC
;

-- PART 6

-- In this part if the question would be about more than one actor 
-- I can use a temporary table instead of WHERE actor_id = ...
-- And the same for part 7

SELECT * FROM sakila.film_actor;
SELECT film_id, title AS films_starred
FROM sakila.film
WHERE film_id IN (
	SELECT film_id
	FROM sakila.film_actor
	WHERE actor_id = (
		SELECT actor_id
		FROM sakila.film_actor
		GROUP BY actor_id
		ORDER BY COUNT(actor_id) DESC
		LIMIT 1
	)
)
ORDER BY film_id ASC;

-- PART 7

SELECT * FROM sakila.payment;
SELECT * FROM sakila.rental;
SELECT * FROM sakila.customer;
SELECT * FROM sakila.inventory;
SELECT film_id, title AS films_rented
FROM sakila.film
WHERE film_id IN (
	SELECT film_id
	FROM sakila.inventory
	WHERE inventory_id IN (	
		SELECT inventory_id
		FROM sakila.rental
		WHERE customer_id = (
			SELECT customer_id
			FROM sakila.payment
			GROUP BY customer_id
			ORDER BY SUM(amount) DESC
			LIMIT 1
		)
	)
)
ORDER BY film_id ASC;

-- PART 8

SELECT * FROM sakila.payment;
SELECT * FROM sakila.customer;
SELECT * FROM sakila.inventory;
SELECT customer_id, first_name, last_name
FROM sakila.customer
WHERE customer_id IN (	
    SELECT customer_id
	FROM sakila.payment
	GROUP BY customer_id
	HAVING SUM(amount) > (
		SELECT SUM(amount)/COUNT(DISTINCT customer_id)
		FROM sakila.payment
	) 
)
ORDER BY customer_id ASC;



