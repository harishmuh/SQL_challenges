
Accessing the database Sakila

````sql
USE sakila;
````

**Query question 1**

Show the top five total rental_duration values for each film category.
Calculate the cumulative sum and moving average of those total rental_duration values.
To limit the data, only select films where the rental_duration is less than or equal to the average rental duration.

````sql
WITH cte AS (
	SELECT 
		c.name AS genre, 
		SUM(rental_duration) AS total_rental_duration
	FROM film f, film_category fc, category c
	WHERE f.film_id = fc.film_id 
		AND c.category_id = fc.category_id 
		AND rental_duration <= (SELECT AVG(rental_duration) FROM film)
	GROUP BY c.name
	ORDER BY total_rental_duration DESC
	LIMIT 5
)
SELECT 
	genre, 
    total_rental_duration,
    SUM(total_rental_duration) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sum,
	AVG(total_rental_duration) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_avg 
FROM cte;
````

Output:

![image](https://github.com/user-attachments/assets/72c5e161-7144-44f0-af12-f75bce3f75ab)




**Query question 2**

Show the film ratings and their average rental durations.
Use only films from the top 3 categories that have the highest number of films.

````sql
WITH joined_table AS (
	SELECT 
		c.name AS genre, 
		rental_duration, 
		rating
	FROM film f, film_category fc, category c
	WHERE f.film_id = fc.film_id AND c.category_id = fc.category_id
),
list_top3 AS (
	SELECT genre 
	FROM joined_table
	GROUP BY genre
	ORDER BY COUNT(*) DESC
	LIMIT 3
)
SELECT 
	rating, 
	AVG(rental_duration) AS avg_rental_duration 
FROM joined_table
WHERE genre IN (SELECT * FROM list_top3)
GROUP BY rating
ORDER BY 2 DESC;
````

Output:

![image](https://github.com/user-attachments/assets/3d3c196b-f8c7-4e2f-b50c-2cd6f99cfaf6)



**Query question 3**

Show the film titles and the total number of customers who rented each film.
Apply the following filters:
* The film title must start with the letter ‘C’ or ‘G’
* The total number of customers must be higher than the average
* The number of customers must be between 15 and 25

````sql
WITH joined_table AS (
	SELECT 
		title, 
		COUNT(customer_id) AS total_customer 
	FROM rental r
	JOIN inventory i ON r.inventory_id = i.inventory_id
	JOIN film f ON f.film_id = i.film_id
    GROUP BY title
)
SELECT * 
FROM joined_table
WHERE (title LIKE 'C%' OR title LIKE 'G%')
	AND total_customer > (SELECT AVG(total_customer) FROM joined_table)
	AND total_customer BETWEEN 15 AND 25;
````

Output:

![image](https://github.com/user-attachments/assets/627b587a-7b6e-4025-a5fa-41148a794c51)

![image](https://github.com/user-attachments/assets/ed1e46b5-4c28-4269-81ef-f9cc259451d2)

![image](https://github.com/user-attachments/assets/f4a19e2a-adb9-4a1c-8d30-e0535539cf4f)

