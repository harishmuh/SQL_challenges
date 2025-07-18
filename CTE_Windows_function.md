# **Common Table Expression (CTE) and Window Function concept**

## **Common Table Expression**
* A CTE (Common Table Expression) is a temporary named result set that can be referred to within a SELECT, INSERT, UPDATE, or DELETE statement. It's declared before the main query and can be reused.

**Database: employees**

Please display a list of employees who were born in 1960. Please show columns: emp_no, first_name, birth_date. 

Accessing database
````sql
USE employees;
````

With subquery:
````sql
SELECT emp_no, first_name, birth_date
FROM (
    SELECT emp_no, first_name, birth_date
    FROM employees
    WHERE YEAR(birth_date) = 1960
) AS sub;
````

![image](https://github.com/user-attachments/assets/d163fff4-3ede-4028-b625-d7655c8bf1d2)



With CTE:
````sql
WITH born_1960 AS (
    SELECT emp_no, first_name, birth_date
    FROM employees
    WHERE YEAR(birth_date) = 1960
)
SELECT *
FROM born_1960;
````

![image](https://github.com/user-attachments/assets/fe9f5943-e9e6-4e64-b4f0-622183cff137)


**Database: sakila**

Accessing the Sakila database

````sql
USE sakila;
````
Query: Show films with a Duration longer than the average!

````sql
SELECT title, length FROM film
WHERE length > (SELECT AVG(length) FROM film);
````

![image](https://github.com/user-attachments/assets/f9c98164-2e0e-482f-8f9a-bd4dd4d0b1ef)


CTE Exercise: Create a temporary table, avg_length, to store the average film duration, then select all films longer than that average.

````sql
WITH avg_length AS 
	(SELECT AVG(length) FROM film)
SELECT title, length FROM film
WHERE length > (SELECT * FROM avg_length);
````

The query below provides the same logic (using an implicit JOIN) and displays the average duration as a column in the results.

![image](https://github.com/user-attachments/assets/af91636e-9220-49db-bfb3-5c5606483146)

````sql
WITH avg_length AS 
	(SELECT AVG(length) AS avg_duration FROM film)
SELECT title, length, avg_duration 
FROM film f, avg_length al
WHERE f.length > al.avg_duration;
````

![image](https://github.com/user-attachments/assets/a611fe1b-d3f9-4dd0-b476-44633a475c63)


The query below provides the same logic, but uses explicit JOIN.

````sql
WITH avg_length AS (
    SELECT AVG(length) AS rerata_durasi
    FROM film
)
SELECT f.title, f.length, al.rerata_durasi
FROM film f
JOIN avg_length al ON f.length > al.rerata_durasi;
````

![image](https://github.com/user-attachments/assets/48a05b84-9761-4811-897b-dc49dc46ab6e)





**CTE Use Case Example** 
* Count of Countries per Continent and show continents with more countries than North America

Step:

**Database: world**
* Accessing the world database

````sql
Use world;
````

* Calculate and display the number of countries in every continent

````sql
SELECT continent, COUNT(Name) AS Jumlah
FROM country
GROUP BY continent;
````

* Calculate the number of countries in the North American continent

````sql
SELECT COUNT(Name) AS Jumlah
FROM country
WHERE continent = 'North America';
````

* Combining both calculations into CTE 

````sql
WITH na_country_count AS 
	(SELECT COUNT(Name) AS country_count
	FROM country
	WHERE continent = 'North America')
SELECT continent, COUNT(Name) AS country_count
FROM country
GROUP BY continent
HAVING country_count > (SELECT * FROM na_country_count);
````

![image](https://github.com/user-attachments/assets/6a2f739d-dfa7-4bf8-95f6-40876d3c4728)

The query below displays CTE + an implicit join + direct comparison with the country count of North America (NA)

````sql
WITH jumlah_negara_NA AS 
	(SELECT COUNT(Name) AS country_count_NA
	FROM country
	WHERE continent = 'North America')
SELECT continent, COUNT(name) as country_count, country_count_NA FROM country, jumlah_negara_NA
GROUP BY 1, 3;
````

![image](https://github.com/user-attachments/assets/1be3cb83-5b40-4d87-8d50-2f138f8eefae)



---
## **window functions**

What Are Window Functions?
* These functions allow aggregation without reducing the number of rows, unlike GROUP BY. Every row stays intact but gains new aggregated data.

Example: Please display the average film duration for each rating

````sql
SELECT 
	rating, 
	length,
	AVG(length) OVER(PARTITION BY rating) AS avg_by_rating
FROM film;
````

![image](https://github.com/user-attachments/assets/9411ae1c-564a-46bf-a2ae-6a1f6f843c27)

...

![image](https://github.com/user-attachments/assets/0e27acc0-8dcd-482b-82e4-46acbb979570)

For each film, show its rating and duration along with the average duration for that rating.

### **ROW NUMBER**

````sql
SELECT 
	title,
	rating,
	rental_duration,
	ROW_NUMBER() OVER(PARTITION BY rating) AS row_number_
FROM film;
````

![image](https://github.com/user-attachments/assets/257715f3-2fb0-471f-b362-155b9a791473)

*Number the films within each rating group starting from 1.

 Limit to Top 5 Films per Rating. Show only the top 5 films for each rating group.

````sql
WITH cte AS 
	(SELECT 
		title,
		rating,
		rental_duration,
		ROW_NUMBER() OVER(PARTITION BY rating) AS row_number_
	FROM film)
SELECT * FROM cte
WHERE row_number_ < 6;
````

![image](https://github.com/user-attachments/assets/438bbaa5-4fb2-44af-8d5a-63c7bceeec0d)

### **RANK VS DENSE RANK**

* RANK(): gives the same rank for equal values, but skips numbers.

* DENSE_RANK(): same rank for equal values, but does not skip.

Show only the top 5 films for each rating group.

````sql
SELECT 
	title, 
	length,
	RANK() OVER(ORDER BY length ASC) AS rank_r,
	DENSE_RANK() OVER(ORDER BY length ASC) AS dense_rank_r
FROM film;
````

![image](https://github.com/user-attachments/assets/0a9f42a5-2415-45f2-a2d0-3b8580f4030a)

Problem: Show the longest film per rating

````sql
WITH cte AS 
	(SELECT 
		title, 
		rating, 
		length,
		DENSE_RANK() OVER(PARTITION BY rating ORDER BY length DESC) AS ranking
	FROM film)
SELECT * FROM cte
WHERE ranking = 1;
````

![image](https://github.com/user-attachments/assets/e531d131-43c2-412b-a262-621b201fce53)

For each rating, display the film(s) with the longest duration.

**NTILE for Grouping into Percentiles or Quartiles**

````sql
SELECT 
	title, 
	rating, 
	length,
	NTILE(4) OVER() AS quartile,
	NTILE(100) OVER(ORDER BY length DESC) AS percentile
FROM film;
````

![image](https://github.com/user-attachments/assets/becb9a2f-06d3-4ddd-a2bc-38e97c21e011)

...

![image](https://github.com/user-attachments/assets/f7d4f66e-4e46-4c44-bce1-1a3b3f85bdc7)

Divide the films into 4 equal quartiles or 100 equal percentiles by duration.

### **Sliding Window / Cumulative Sum / Moving Average**

**Cumulative sum of amount**

````sql
SELECT 
	amount,
	SUM(amount) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sum
FROM payment;
````

![image](https://github.com/user-attachments/assets/2ca93799-f282-407f-bc70-97d5ee49d4a7)

...

![image](https://github.com/user-attachments/assets/59aa2b6a-b169-43cf-a6a2-53e39abd5c90)

**Moving average over 2 rows**

````sql
SELECT
	amount,
	AVG(amount) OVER(ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS moving_avg
FROM payment;
````

![image](https://github.com/user-attachments/assets/33d9d0df-31ea-4764-b16b-9b6af5dcedd5)

...

![image](https://github.com/user-attachments/assets/1dfa5fef-8e07-48d2-9799-5da3c83c5da8)

*2-row moving average of the amount.

**Cumulative sum of film counts by rating**

````sql

WITH cte AS
	(SELECT 
		rating, 
		COUNT(title) AS film_count
	FROM film
	GROUP BY rating)
SELECT *,
	SUM(film_count) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sum
FROM cte;
````

![image](https://github.com/user-attachments/assets/05384bfd-def0-4534-81ef-281e4ad31291)

*Count how many films exist per rating, then compute the cumulative total of those counts across all rating groups.



