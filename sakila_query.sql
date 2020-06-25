-- SAKILA DVD RENTAL
-- Udacity Programming for Data Science Nanodegree
-- Made by Julian Quintana, from Medellin, Colombia, in 2020, amid the lockdown.


/*
QUESTION 1
We want to understand more about the movies that families are watching. 
The following categories are considered family movies: Animation, Children, 
Classics, Comedy, Family and Music.

Create a query that lists each movie, the film category it is classified in, 
and the number of times it has been rented out.
*/

SELECT film.title AS movie,
       cat.name AS classification,
       COUNT(rent.rental_id) AS times_rented
  FROM category AS cat
  JOIN film_category AS fcat
    ON cat.category_id = fcat.category_id
  JOIN film
    ON fcat.film_id = film.film_id
  JOIN inventory AS inv
    ON film.film_id = inv.film_id
  JOIN rental AS rent
    ON inv.inventory_id = rent.inventory_id
 WHERE cat.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
 GROUP BY movie, classification
 ORDER BY classification, movie;


/*  
QUESTION 2
Finally, provide a table with the family-friendly film category, 
each of the quartiles, and the corresponding count of movies within each 
combination of film category for each corresponding rental duration category. 
The resulting table should have three columns:
- Category
- Rental length category
- Count
*/

WITH dq AS (
    SELECT film.title AS movie, 
           cat.name AS category,
           film.rental_duration AS duration,
           NTILE(4) OVER (ORDER BY film.rental_duration) AS quartile
      FROM category AS cat
      JOIN film_category AS fcat
        ON cat.category_id = fcat.category_id
      JOIN film 
        ON fcat.film_id = film.film_id
)

SELECT category,
       quartile,
       COUNT(*)
  FROM dq
 WHERE category IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
 GROUP BY category, quartile;


/*
QUESTION 3
We want to find out how the two stores compare in their count of rental orders 
during every month for all the years we have data for. Write a query that returns 
the store ID for the store, the year and month and the number of rental orders 
each store has fulfilled for that month. Your table should include a column for 
each of the following: year, month, store ID and count of rental orders fulfilled 
during that month.
*/

SELECT DATE_PART('year', ren.rental_date) AS year,
       DATE_PART('month', ren.rental_date) AS month,
       str.store_id AS office,
       COUNT(*)
  FROM rental AS ren
  JOIN staff AS stf
    ON ren.staff_id = stf.staff_id
  JOIN store AS str
    ON stf.store_id = str.store_id
 GROUP BY year, month, office
 ORDER BY year, month;


/*
QUESTION 4
We would like to know who were our top 10 paying customers, how many payments 
they made on a monthly basis during 2007, and what was the amount of the monthly 
payments. Can you write a query to capture the customer name, month and year of 
payment, and total payment amount for each month by these top 10 paying customers?
*/

WITH top_payers AS (
    SELECT ctmr.customer_id AS id,
           CONCAT(ctmr.first_name, ' ', ctmr.last_name) AS name, 
           SUM(pmt.amount) AS paid
      FROM payment AS pmt 
      JOIN customer AS ctmr
        ON pmt.customer_id = ctmr.customer_id
     GROUP BY ctmr.customer_id
     ORDER BY paid DESC
     LIMIT 10
)

SELECT tp.name,
       DATE_PART('year', pmt.payment_date) AS year,
       DATE_PART('month', pmt.payment_date) AS month,
       SUM(pmt.amount) AS paid
  FROM top_payers AS tp
  JOIN payment AS pmt
    ON tp.id = pmt.customer_id
 WHERE DATE_PART('year', pmt.payment_date) = 2007
 GROUP BY name, year, month
 ORDER BY name, year, month;


