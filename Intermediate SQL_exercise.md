**Accessing the [world](https://dev.mysql.com/doc/world-setup/en/) database**


````sql
USE world;
````

1. How many unique regions are there in the world dataset?

````sql
SELECT COUNT(DISTINCT(Region)) AS Number_of_Regions
FROM country;
````

![image](https://github.com/user-attachments/assets/4e08f701-c877-4fbd-93f2-d33316b6c381)


2. How many countries are in Africa? Rename the header as 'Number_of_Countries_in_Africa'.


````sql
SELECT COUNT(Name) AS Number_of_Countries_in_Africa
FROM country
WHERE continent='Africa';
````

![image](https://github.com/user-attachments/assets/5d45eab8-c3cc-40ce-8173-412b338b5abe)



3. Display the top 5 most populous countries. Rename headers to 'Country_Name' and 'Population'.

````sql
SELECT  Name AS Country_Name,
        Population AS Population
FROM country
ORDER BY Population DESC
LIMIT 5;
````
![image](https://github.com/user-attachments/assets/874aad68-a84e-4829-843b-4dc8f8d00124)



4. Show the average life expectancy per continent, sorted from lowest to highest. Rename headers.

````sql
SELECT  Continent AS Continent_Name,
        AVG(LifeExpectancy) AS Avg_Life_Expectancy
FROM country
GROUP BY Continent_Name
ORDER BY Avg_Life_Expectancy;
````

![image](https://github.com/user-attachments/assets/febb0b9c-0929-4af1-9ae6-be958e1a98cb)


5. Show the number of regions in each continent, only if the number of regions is greater than 3.


````sql
SELECT  Continent AS Continent_Name,
        COUNT(DISTINCT Region) AS Number_of_Regions
FROM country
GROUP BY Continent
HAVING Number_of_Regions > 3;
````

![image](https://github.com/user-attachments/assets/00afa374-1b3d-41a0-b176-4386a91e9ab0)


6. Show the average GNP per region in Africa, sorted from highest.


````sql
SELECT  Region AS Region_Name,
        AVG(GNP) AS Avg_GNP FROM country
WHERE Continent='Africa'
GROUP BY Region
ORDER BY Avg_GNP DESC;

````

![image](https://github.com/user-attachments/assets/263b59d4-28e8-4d40-ad58-4df04487b716)


7. Show countries in Europe whose names start with the letter 'I'.

````sql
SELECT  Name,
        Continent
FROM country
WHERE Continent='Europe' AND Name LIKE 'I%';
````

![image](https://github.com/user-attachments/assets/e087a25f-3d57-49a3-a3ec-c60bfc0180eb)


8. Show the number of languages spoken in each country, sorted by the number of languages.

````sql
SELECT  CountryCode,
        COUNT(Language) AS Number_of_Languages
FROM countrylanguage
GROUP BY CountryCode
ORDER BY Number_of_Languages DESC;
````

![image](https://github.com/user-attachments/assets/66cc598f-df97-4afc-a1de-7d9e38172503)



9. Show country names with 6 letters and end with 'o'.

````sql
SELECT Name
FROM country
WHERE Name LIKE '_____o'; 
````

![image](https://github.com/user-attachments/assets/79b7a85a-d30f-4197-8f59-721f2432f158)


10. Show the 7 most spoken languages in Indonesia (rounded percentages). Rename headers.

````sql
SELECT  Language AS Language,
        ROUND(Percentage, 0) AS Percentage
FROM countrylanguage
WHERE CountryCode='IDN'
ORDER BY Percentage
DESC LIMIT 7;
````

![image](https://github.com/user-attachments/assets/6b2f351d-65f1-4e60-8da4-e009bf706b4a)

11. Show 10 countries that gained independence earliest (non-NULL values only).

````sql
SELECT  Name,
        IndepYear
FROM country
WHERE IndepYear IS NOT NULL
ORDER BY IndepYear
LIMIT 10;
````

![image](https://github.com/user-attachments/assets/40a6f99f-537f-46b5-a317-684c2cf61f3c)


12. Show continents with fewer than 10 government forms.


````sql
SELECT  Continent AS Continent,
        COUNT(DISTINCT GovernmentForm) AS Number_of_Gov_Forms
FROM country
GROUP BY Continent
HAVING Number_of_Gov_Forms < 10;
````

![image](https://github.com/user-attachments/assets/448dfc8f-4fdc-4dea-a817-69097abef181)


13. Which regions have had a GNP increase? Sort by largest difference.

````sql
SELECT  Region,
        SUM(GNP) - SUM(GNPOld) AS Difference
FROM country
GROUP BY Region
HAVING Difference > 0
ORDER BY Difference DESC;
````

![image](https://github.com/user-attachments/assets/d3388ab0-ea34-4b73-a69e-669667d341c2)


**Accessing the [sakila](https://dev.mysql.com/doc/sakila/en/sakila-installation.html)** database

````sql
USE sakila;
````

14. Show actor(s) with first name 'Scarlett'.


````sql
SELECT *
FROM actor
WHERE first_name='SCARLETT';
````
![image](https://github.com/user-attachments/assets/d1559ab9-b04c-4eb6-bb23-7923c9732bd6)



15. How many unique last names are there among the actors?

````sql
SELECT COUNT(DISTINCT last_name) AS Unique_Last_Names
FROM actor;
````

![image](https://github.com/user-attachments/assets/078547eb-3961-491d-abeb-c4da0716d872)


16. Show the 5 last names that appear only once in the database.


````sql
SELECT  last_name AS Last_Name,
        COUNT(last_name) AS Frequency
FROM actor
GROUP BY last_name
HAVING Frequency = 1
LIMIT 5;
````

![image](https://github.com/user-attachments/assets/9cf45409-2836-49dc-9d8a-94fe2b7c2ae6)


17. Show the 5 last names that appear more than once.

````sql
SELECT  last_name AS Last_Name,
        COUNT(last_name) AS Frequency
FROM actor
GROUP BY last_name
HAVING Frequency > 1
LIMIT 5;
````

![image](https://github.com/user-attachments/assets/463bb419-e087-46cc-8901-98d7ae1411db)




18. Show full names (first and last) in uppercase in one column as 'Actor_Name'.


````sql
SELECT CONCAT(first_name,' ',last_name) AS Actor_Name
FROM actor;
````

![image](https://github.com/user-attachments/assets/2d8ebb99-eac3-410f-95dc-367944c0f947)


19. Show the average film duration.


````sql
SELECT ROUND(AVG(length), 2) AS Avg_Duration
FROM film;
````
![image](https://github.com/user-attachments/assets/2ece6a85-e555-4858-a2b9-7e1b69dab1b9)

20. Show all customer records from Indonesia with an odd phone number, sorted by postal code and ID.


````sql
SELECT *
FROM customer_list
WHERE country='Indonesia' AND phone%2 != 0
ORDER BY 4, ID;
````

![image](https://github.com/user-attachments/assets/5c03d536-552e-4d79-a6d6-b644c95adfd0)


21. Show average monthly payment amounts, sorted from highest to lowest.


````sql
SELECT  MONTHNAME(payment_date) AS Month,
        ROUND(AVG(amount), 3) AS Avg_Payment
FROM payment
GROUP BY MONTHNAME(payment_date)
ORDER BY Avg_Payment DESC;
````

![image](https://github.com/user-attachments/assets/b7fd7820-561a-4092-aad3-0640ed2a0e88)


22. Show the 5 shortest films.


````sql
SELECT  title,
        length
FROM film
ORDER BY length
LIMIT 5;
````

![image](https://github.com/user-attachments/assets/4726fd07-6f8e-4501-ae88-60e97757ebd1)


23. Show the number of films per rating, sorted from most to least.


````sql
SELECT rating,
COUNT(title) AS Number_of_Films
FROM film
GROUP BY rating
ORDER BY Number_of_Films DESC;
````

![image](https://github.com/user-attachments/assets/35182fd1-f081-4a2c-983b-3291382b9c42)


24. Show average replacement cost per rental rate for films starting with 'Z'.

````sql
SELECT  rental_rate,
        AVG(replacement_cost)
FROM film
WHERE title LIKE 'Z%'
GROUP BY rental_rate;
````

![image](https://github.com/user-attachments/assets/35423484-2897-42a6-b7ad-a7b4d29ee90d)

25. Show film ratings with average duration above 115 minutes.

````sql
SELECT rating,
      FORMAT(AVG(length), 2) AS avg_duration
FROM film
GROUP BY rating
HAVING avg_duration > 115;
````

![image](https://github.com/user-attachments/assets/428a37cb-4eb3-48ab-891e-ce8a7cde10d9)




