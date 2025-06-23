-- ========================================================================
-- 1. How many unique regions are there in the world dataset?
SELECT COUNT(DISTINCT(Region)) AS Number_of_Regions
FROM country;

-- 2. How many countries are in Africa? Rename the header as 'Number_of_Countries_in_Africa'.
SELECT COUNT(Name) AS Number_of_Countries_in_Africa
FROM country
WHERE continent='Africa';

-- 3. Display the top 5 most populous countries. Rename headers to 'Country_Name' and 'Population'.
SELECT  Name AS Country_Name,
        Population AS Population
FROM country
ORDER BY Population DESC
LIMIT 5;

-- 4. Show the average life expectancy per continent, sorted from lowest to highest. Rename headers.
SELECT  Continent AS Continent_Name,
        AVG(LifeExpectancy) AS Avg_Life_Expectancy
FROM country
GROUP BY Continent_Name
ORDER BY Avg_Life_Expectancy;

-- 5. Show the number of regions in each continent, only if the number of regions is greater than 3.

SELECT  Continent AS Continent_Name,
        COUNT(DISTINCT Region) AS Number_of_Regions
FROM country
GROUP BY Continent
HAVING Number_of_Regions > 3;

-- 6. Show the average GNP per region in Africa, sorted from highest.

SELECT  Region AS Region_Name,
        AVG(GNP) AS Avg_GNP FROM country
WHERE Continent='Africa'
GROUP BY Region
ORDER BY Avg_GNP DESC;

-- 7. Show countries in Europe whose names start with the letter 'I'.

SELECT  Name,
        Continent
FROM country
WHERE Continent='Europe' AND Name LIKE 'I%';

-- 8. Show the number of languages spoken in each country, sorted by the number of languages.

SELECT  CountryCode,
        COUNT(Language) AS Number_of_Languages
FROM countrylanguage
GROUP BY CountryCode
ORDER BY Number_of_Languages DESC;

-- 9. Show country names that have 6 letters and end with 'o'.

SELECT Name
FROM country
WHERE Name LIKE '_____o'; 

-- 10. Show the 7 most spoken languages in Indonesia (rounded percentages). Rename headers.

SELECT  Language AS Language,
        ROUND(Percentage, 0) AS Percentage
FROM countrylanguage
WHERE CountryCode='IDN'
ORDER BY Percentage
DESC LIMIT 7;

-- 11. Show 10 countries that gained independence earliest (non-NULL values only).

SELECT  Name,
        IndepYear FROM country
WHERE IndepYear IS NOT NULL
ORDER BY IndepYear
LIMIT 10;


-- 12. Show continents with fewer than 10 government forms.

SELECT  Continent AS Continent,
        COUNT(DISTINCT GovernmentForm) AS Number_of_Gov_Forms
FROM country
GROUP BY Continent
HAVING Number_of_Gov_Forms < 10;

-- 13. Which regions have had a GNP increase? Sort by largest difference.

SELECT  Region,
        SUM(GNP) - SUM(GNPOld) AS Difference
FROM country
GROUP BY Region
HAVING Difference > 0
ORDER BY Difference DESC;

-- Accessing the sakila database
USE sakila;

-- 14. Show actor(s) with first name 'Scarlett'.

SELECT *
FROM actor
WHERE first_name='SCARLETT';

-- 15. How many unique last names are there among the actors?

SELECT COUNT(DISTINCT last_name) AS Unique_Last_Names
FROM actor;

-- 16. Show the 5 last names that appear only once in the database.

SELECT  last_name AS Last_Name,
        COUNT(last_name) AS Frequency
FROM actor
GROUP BY last_name
HAVING Frequency = 1
LIMIT 5;

-- 17. Show the 5 last names that appear more than once.

SELECT  last_name AS Last_Name,
        COUNT(last_name) AS Frequency
FROM actor
GROUP BY last_name
HAVING Frequency > 1
LIMIT 5;


-- 18. Show full names (first and last) in uppercase in one column as 'Actor_Name'.

SELECT CONCAT(first_name,' ',last_name) AS Actor_Name
FROM actor;

-- 19. Show the average film duration.

SELECT ROUND(AVG(length), 2) AS Avg_Duration
FROM film;

-- 20. Show all customer records from Indonesia with an odd phone number, sorted by postal code and ID.

SELECT *
FROM customer_list
WHERE country='Indonesia' AND phone%2 != 0
ORDER BY 4, ID;

-- 21. Show average monthly payment amounts, sorted from highest to lowest.

SELECT  MONTHNAME(payment_date) AS Month,
        ROUND(AVG(amount), 3) AS Avg_Payment
FROM payment
GROUP BY MONTHNAME(payment_date)
ORDER BY Avg_Payment DESC;

-- 22. Show the 5 shortest films.

SELECT  title,
        length
FROM film
ORDER BY length
LIMIT 5;

-- 23. Show the number of films per rating, sorted from most to least.

SELECT rating,
COUNT(title) AS Number_of_Films
FROM film
GROUP BY rating
ORDER BY Number_of_Films DESC;

-- 24. Show average replacement cost per rental rate for films starting with 'Z'.

SELECT  rental_rate,
        AVG(replacement_cost) as average_replacement_cost
FROM film
WHERE title LIKE 'Z%'
GROUP BY rental_rate;

-- 25. Show film ratings with average duration above 115 minutes.

SELECT rating,
      FORMAT(AVG(length), 2) AS avg_duration
FROM film
GROUP BY rating
HAVING avg_duration > 115;

-- purwadhika database
USE purwadhika; 

-- 26. From viewership table: count views by laptop vs mobile (tablet + phone). Output headers: 'laptop_views' and 'mobile_views'.

show tables;

SELECT 
    SUM(CASE WHEN device_type='laptop' THEN 1 ELSE 0 END) AS laptop_views,
	  SUM(CASE WHEN device_type='phone' OR device_type='tablet' THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;

-- 27. From employee_expertise: show employee IDs that meet SME conditions.
-- SME =≥ 8 years in 1 domain OR ≥ 12 years in 2 domains.


USE employees;
SHOW TABLES;


SELECT employee_id 
FROM employee_expertise 
GROUP BY employee_id 
HAVING (SUM(years_of_experience) >= 8 AND COUNT(DISTINCT domain) = 1) OR (SUM(years_of_experience) >= 12 AND COUNT(DISTINCT domain) = 2);

-- 28. From applepay_transactions: show total Apple Pay transaction volume per merchant, including merchants with 0.

SELECT  merchant_id,
        SUM(CASE WHEN payment_method='Apple Pay' THEN transaction_amount ELSE 0 END) AS total_transaction
FROM applepay_transactions
GROUP BY merchant_id
ORDER BY total_transaction DESC;

-- 29. From tabel_nilai: add grade column based on final score.

SELECT *,
CASE 
	WHEN nilai_akhir >= 80 THEN 'A'
	WHEN nilai_akhir >= 60 THEN 'B'
	WHEN nilai_akhir >= 40 THEN 'C'
	WHEN nilai_akhir >= 20 THEN 'D'
	ELSE 'E'
END AS grade_index
FROM tabel_nilai;
