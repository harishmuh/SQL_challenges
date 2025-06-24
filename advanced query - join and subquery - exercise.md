
-- -----------------------------------------------------------------------------------------------------

**Accessing the [world](https://dev.mysql.com/doc/world-setup/en/)** database

````sql
USE world;
````

1. Display the top 10 cities with the highest population (as a percentage, rounded to 2 decimal places). Show city name, country name, and population percentage.

````sql
SELECT 
    ci.name AS City_Name,
    co.name AS Country_Name,
    ROUND(ci.population * 100 / (SELECT SUM(population) FROM city), 2) AS Percentage
FROM city ci
JOIN country co ON ci.CountryCode = co.Code
ORDER BY Percentage DESC
LIMIT 10;
````

![image](https://github.com/user-attachments/assets/cc4a82b8-73c3-4164-9891-30e684314c34)


2. Show Asian countries whose life expectancy is higher than the average life expectancy of European countries.
Display the top 10 by highest life expectancy. Show country name, continent, life expectancy, and GNP.

````sql
SELECT Name, Continent, LifeExpectancy, GNP
FROM country
WHERE Continent = 'Asia' AND LifeExpectancy > (
    SELECT AVG(LifeExpectancy)
    FROM country
    WHERE Continent = 'Europe'
)
ORDER BY LifeExpectancy DESC
LIMIT 10;
````
![image](https://github.com/user-attachments/assets/9ebe5022-cfb5-426d-838b-3451dcccbf91)



3. Show the top 10 countries with the highest percentage of English as an official language.
Display country code, country name, language, official (T/F), and percentage.

````sql
SELECT 
    co.Code AS Country_Code,
    co.Name AS Country_Name,
    cl.Language AS Language,
    cl.IsOfficial AS Is_Official,
    cl.Percentage AS Percentage
FROM country co
JOIN countrylanguage cl ON co.Code = cl.CountryCode
WHERE cl.Language = 'English' AND cl.IsOfficial = 'T'
ORDER BY cl.Percentage DESC
LIMIT 10;
````

![image](https://github.com/user-attachments/assets/76ee1b28-5c09-4a1c-9155-c29752fda70d)



4. Display country, country population, GNP, capital city, and capital population for Southeast Asia.
Sorted by country name alphabetically.

````sql
SELECT 
    co.Name AS Country_Name,
    co.Population AS Country_Population,
    co.GNP AS GNP,
    ci.Name AS Capital_Name,
    ci.Population AS Capital_Population
FROM country co, city ci
WHERE co.Code = ci.CountryCode AND co.Capital = ci.ID AND co.Region = 'Southeast Asia'
ORDER BY co.Name ASC;
````

![image](https://github.com/user-attachments/assets/73582061-7324-43c8-819f-269aed09e274)

5. Same as #4, but for G-20 countries. (Argentina - United States)

````sql
SELECT 
    co.Name AS Country_Name,
    co.Population AS Country_Population,
    co.GNP AS GNP,
    ci.Name AS Capital_Name,
    ci.Population AS Capital_Population
FROM country co
JOIN city ci ON co.Capital = ci.ID
WHERE co.Name IN (
    'Argentina', 'Australia', 'Brazil', 'Canada', 'China', 'France',
    'Germany', 'India', 'Indonesia', 'Italy', 'South Korea', 'Japan',
    'Mexico', 'Russian Federation', 'Saudi Arabia', 'South Africa',
    'Turkey', 'United Kingdom', 'United States'
)
ORDER BY co.Name;
````
![image](https://github.com/user-attachments/assets/9c6cf305-b0b4-412b-9d85-9e6ac0fe31ae)


-- --------------------------------------------------------------------------------------------

**Accessing the [sakila](https://dev.mysql.com/doc/sakila/en/sakila-installation.html)** database

````sql
USE sakila;
````

1. Display 10 rows of customer_id, rental_id, amount, and payment_date from the payment table.

````sql
SELECT 
    customer_id,
    rental_id,
    amount,
    payment_date
FROM payment
LIMIT 10;
````

![image](https://github.com/user-attachments/assets/d8374a36-bb06-4005-9408-ee05bebd0685)

2. From the film table, display 10 titles, release year, and rental duration for films starting with the letter 'S'.

````sql
SELECT 
    title,
    release_year,
    rental_duration
FROM film
WHERE title LIKE 'S%'
LIMIT 10;
````

![image](https://github.com/user-attachments/assets/ba1bbb95-2854-4d53-b292-2af7f0fd1e61)

3. From the film table, show rental duration, number of films for each rental duration, and average film length.
Round average to 2 decimal places.

````sql
SELECT 
    rental_duration AS Rental_Duration,
    COUNT(title) AS Number_of_Films,
    ROUND(AVG(length), 2) AS Avg_Film_Length
FROM film
GROUP BY rental_duration
ORDER BY rental_duration;
````

![image](https://github.com/user-attachments/assets/4c6022f2-37f2-407f-9956-bee5b337d711)

4. Show title, length, and rating of films longer than the average film length. Display the top 10 by longest duration.

````sql
SELECT 
    title,
    length,
    rating
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC
LIMIT 10;
````

![image](https://github.com/user-attachments/assets/0d5d7cae-7b12-408d-9133-2039fa81895a)

5. Show rating, highest replacement cost, lowest rental rate, and average length per rating.

````sql
SELECT 
    rating,
    MAX(replacement_cost) AS Max_Replacement_Cost,
    MIN(rental_rate) AS Min_Rental_Rate,
    AVG(length) AS Avg_Length
FROM film
GROUP BY rating;
````

![image](https://github.com/user-attachments/assets/a332f56e-38dd-4cc7-a40e-efa11cbc65be)

6. Show 15 films ending with 'K' in the title, along with duration and language. Join the  film and language tables.

````sql
SELECT 
    f.title AS Film_Title,
    f.length AS Duration,
    l.name AS Language
FROM film f, language l
WHERE f.language_id = l.language_id
AND f.title LIKE '%K'
LIMIT 15;
````

![image](https://github.com/user-attachments/assets/daf4d0b9-336b-4a8b-994c-28904e9aea08)

7. Display film title, first name, and last name of actors with actor_id = 14. Join film, film_actor, and actor tables. Limit to 10 results.

````sql
SELECT f.title, a.first_name, a.last_name
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE a.actor_id = 14
LIMIT 10;
````

![image](https://github.com/user-attachments/assets/f2194a01-1671-439f-bd43-b24c08fafb7d)

8. From the city table, show city and country_id where the city name contains 'd' and ends with 'a'.
Display top 15 results sorted by city name ascending.

````sql
SELECT city, country_id 
FROM city
WHERE city LIKE '%d%a'
ORDER BY city
LIMIT 15;
````

![image](https://github.com/user-attachments/assets/fab72970-d772-4351-a499-a46ec1df10bf)


9. Display genre name and number of films in each genre. Join film, film_category, and category tables.
Sort by number of films ascending.

````sql
SELECT 
    c.name AS Genre_Name,
    COUNT(f.title) AS Number_of_Films
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY Genre_Name
ORDER BY Number_of_Films;
````

![image](https://github.com/user-attachments/assets/0ab57483-6bd5-4e00-8210-7537b319e254)


10. From the film table, show title, description, length, and rating. Display 10 titles that end with 'h' and have above-average length.
Sort by title ascending.

````sql
SELECT 
    title, 
    description, 
    length, 
    rating 
FROM film
WHERE title LIKE '%h' AND length > (SELECT AVG(length) FROM film)
ORDER BY title ASC
LIMIT 10;
````

![image](https://github.com/user-attachments/assets/71743284-93dd-4333-b401-ac7c4a181cfb)
