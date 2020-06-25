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
Now we need to know how the length of rental duration of these family-friendly 
movies compares to the duration that all movies are rented for. 
Can you provide a table with the movie titles and divide them into 4 levels 
(first_quarter, second_quarter, third_quarter, and final_quarter) based on the 
quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? 
Make sure to also indicate the category that these family-friendly movies fall into.
*/

WITH intermediate_table AS (
     SELECT film.title AS movie,
            film.rental_duration AS duration,
            cat.name AS category,
            NTILE(4) OVER (ORDER BY film.rental_duration) AS quartile
       FROM category AS cat
       JOIN film_category AS fcat
         ON cat.category_id = fcat.category_id
       JOIN film
         ON fcat.film_id = film.film_id
   ORDER BY film.rental_duration
)

SELECT t1.movie,
       t1.duration,
       t1.category,
       CASE 
           WHEN quartile = 1 THEN 'first_quarter' 
           WHEN quartile = 2 THEN 'second_quarter'
           WHEN quartile = 3 THEN 'third_quarter'
           WHEN quartile = 4 THEN 'final_quarter'
       END         
  FROM intermediate_table AS t1
 WHERE t1.category IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music');


/*
QUESTION 3
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
QUESTION 4
We want to find out how the two stores compare in their count of rental orders 
during every month for all the years we have data for. Write a query that returns 
the store ID for the store, the year and month and the number of rental orders 
each store has fulfilled for that month. Your table should include a column for 
each of the following: year, month, store ID and count of rental orders fulfilled 
during that month.
*/





/*
QUESTION 5
We would like to know who were our top 10 paying customers, how many payments 
they made on a monthly basis during 2007, and what was the amount of the monthly 
payments. Can you write a query to capture the customer name, month and year of 
payment, and total payment amount for each month by these top 10 paying customers?
*/




/*
QUESTION 6
Finally, for each of these top 10 paying customers, I would like to find out 
the difference across their monthly payments during 2007. Please go ahead and 
write a query to compare the payment amounts in each successive month. Repeat 
this for each of these 10 paying customers. Also, it will be tremendously 
helpful if you can identify the customer name who paid the most difference in 
terms of payments.
*/



/* 
PROJECT SUBMISSION
You are now on the portion of the project you will need to submit to a reviewer. 
To pass this project follow the instructions below to create a presentation. 
You will submit a zip file with two items:
- Slide Deck (4 slides)
- Text File with SQL queries
Your presentation should include:
- Four slides
- One question on each slide
- One visualization (graph / chart / table) per slide
- A 1-2 sentence answer to the question, based on the data and visualization, on each slide

RUBRIC!!!
https://review.udacity.com/#!/rubrics/2095/view
*/

