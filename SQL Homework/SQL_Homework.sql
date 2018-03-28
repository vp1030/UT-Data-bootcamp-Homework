-- Question 1a
USE sakila

SELECT *
FROM Actor

SELECT actor_id, first_name, last_name
FROM Actor
WHERE actor_id IN (1, 201);

-- Question 1b
SELECT *,
CONCAT_WS(' ', first_name, last_name) AS Actor_Name
FROM Actor

-- Question 2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name LIKE 'Joe%';

-- Question 2b
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%Gen%';

-- Question 2c
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%Li%'
ORDER BY last_name, first_name;

-- Question 2d
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- Question 3a
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(35) AFTER first_name;

SELECT *
FROM actor
LIMIT 5;

-- Question 3b
ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;

SHOW FIELDS FROM actor

-- Question 3c
ALTER TABLE actor
DROP COLUMN middle_name;

SELECT *
FROM actor
LIMIT 5;

-- Question 4a
SELECT last_name, COUNT(last_name) c 
FROM actor
GROUP BY last_name
ORDER BY c DESC

-- Question 4b
SELECT *
FROM (
	SELECT last_name, COUNT(last_name) c
    FROM actor
    GROUP BY last_name) AS actor
WHERE c >1
ORDER BY c DESC;

-- Question 4c
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name = 'Williams'

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id = 172;

UPDATE actor
SET first_name = 'HARPO', last_name = 'WILLIAMS'
WHERE actor_id = 172;

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id = 172;

-- Question 4d
UPDATE actor
SET first_name = CASE 
WHEN first_name = 'HARPO' THEN first_name = 'GROUCHO' 
ELSE first_name = 'MUCHO GROUCHO' END
WHERE actor_id = 172

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id = 172;

-- Question 5a
SHOW CREATE TABLE sakila.address;

-- Question 6a
SELECT first_name, last_name, address
FROM staff JOIN address
USING (address_id)

SELECT first_name, last_name, address
FROM staff, address

-- Question 6b
SELECT first_name, last_name, SUM(amount)
FROM staff s
LEFT JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY s.first_name, s.last_name;

-- Question 6c
SELECT title, COUNT(actor_id)
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY title;

-- Question 6d
SELECT title, COUNT(inventory_id)
FROM film f
INNER JOIN inventory i
ON f.film_id=i.film_id
WHERE title = 'Hunchback Impossible';

-- Question 6e
SELECT last_name, first_name, SUM(amount)
FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id
ORDER BY last_name ASC;

-- Question 7a
SELECT title
FROM film
WHERE language_id IN
	(SELECT language_id
    FROM language
    WHERE name = "English")
AND (title LIKE 'K%') OR (title LIKE 'Q%');

-- Question 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN 
	(SELECT actor_id
    FROM film_actor
    WHERE film_id IN
		(SELECT film_id 
        FROM film
        WHERE title = "Alone Trip"));

-- Question 7c
SELECT country, first_name, last_name, email
FROM country c
LEFT JOIN customer cus
ON c.country_id = cus.customer_id
WHERE country = "Canada";

-- Question 7d
SELECT title, category
FROM film_list
WHERE category = "Family";

-- Questino 7e
SELECT i.film_id, f.title, COUNT(r.inventory_id)
FROM inventory i
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN film_text f
ON i.film_id = f.film_id
GROUP BY r.inventory_id
ORDER BY COUNT(r.inventory_id) DESC;

-- Question 7f
SELECT store.store_id, SUM(amount)
FROM store 
INNER JOIN staff st
ON store.store_id = st.store_id
INNER JOIN payment p
ON p.staff_id = st.staff_id
GROUP BY store.store_id
ORDER BY SUM(amount);

-- Question 7g
SELECT s.store_id, city, country
FROM store s
INNER JOIN customer cus
ON s.store_id = cus.store_id
INNER JOIN staff st
ON s.store_id = st.store_id
INNER JOIN address a
ON cus.address_id = a.address_id
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country cou
ON ci.country_id = cou.country_id;

-- Question 7h
USE sakila

SELECT c.name, SUM(p.amount) AS "Gross"
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON i.film_id = fc.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY Gross
LIMIT 5;

-- Question 8a
CREATE VIEW top_five_grossing_genres AS
SELECT c.name, SUM(p.amount) AS "Gross"
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON i.film_id = fc.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY Gross
LIMIT 5;

-- Question 8b
SELECT *
FROM top_five_grossing_genres

-- Question 8c
DROP VIEW top_five_grossing_genres;