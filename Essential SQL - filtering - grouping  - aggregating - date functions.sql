#=================================================================================================
# STRING PATTERN
# - LIKE is used to filter rows where the column has a text data type.
# - LIKE is used after WHERE.

# % → represents any number of characters (including zero)
# e.g., 'bl%' will match 'blue', 'black', 'blob', etc.
# _ → represents exactly one character
# e.g., 'h_t' will match 'hat', 'hit', 'hut', 'hot', etc.

USE world;
-- Show cities where the district is 'England'
SELECT * FROM city
WHERE District = 'England';

-- Filter using text pattern
SELECT * FROM city
WHERE District LIKE 'England';

-- Filter numeric value (not common, but possible)
SELECT * FROM city
WHERE Population LIKE 461000;

-- Filter number pattern
SELECT * FROM city
WHERE Population LIKE '4%6';

-- Find cities starting with 'Z'
SELECT * FROM city
WHERE Name LIKE 'Z%';

-- Find cities ending with 'X'
SELECT * FROM city
WHERE Name LIKE '%X';

-- Find 4-letter city names starting with 'Z'
SELECT * FROM city
WHERE Name LIKE 'Z___';

-- Find city names with exactly 3 letters
SELECT * FROM city
WHERE Name LIKE '___';

-- Find city names with 6 letters ending with 'o'
SELECT * FROM city
WHERE Name LIKE '_____o';

-- Find city names containing letter 'x'
SELECT * FROM city
WHERE Name LIKE '%x%';

-- Find city names with 'x' in the middle (not at start or end)
SELECT * FROM city
WHERE Name LIKE '%x%'
AND Name NOT LIKE 'x%'
AND Name NOT LIKE '%x';

# NOT is used for negation
  
#=================================================================================================
# RANGE (BETWEEN)
# Used to filter data between a certain range.

-- Show 5 countries with population between 400,000 and 1,000,000
SELECT Name, Population FROM country
WHERE Population >= 400000 AND Population <= 1e6
LIMIT 5;

-- Same with BETWEEN
SELECT Name, Population FROM country
WHERE Population BETWEEN 400000 AND 1000000
LIMIT 5;

-- Show 5 countries with population < 100,000 or > 100,000,000
SELECT Name, Population FROM country
WHERE Population NOT BETWEEN 1e5 AND 1e8
LIMIT 5;
#=================================================================================================
# SORTING
# ORDER BY is used to sort data in ascending or descending order.

-- Sort by population (ascending)
SELECT Name, Population FROM country
ORDER BY Population;

-- Sort by population (descending)
SELECT Name, FORMAT(Population,0) 
FROM country
ORDER BY Population DESC;

-- Show 10 cities with population between 3M and 4M, sorted descending
SELECT Name, FORMAT(Population,0) FROM city
WHERE Population BETWEEN 3e6 AND 4e6
ORDER BY Population DESC
LIMIT 10;

-- Show countries in Southeast and East Asia, sorted by region and population descending
SELECT Name, Region, FORMAT(Population,0) 
FROM country
WHERE Region = 'SouthEast Asia' OR Region = 'Eastern Asia'
ORDER BY Region ASC, Population DESC;

#=================================================================================================
# GROUP BY
# Used to group data by a column and apply aggregate functions.
-- Total population in Asia
SELECT FORMAT(SUM(Population),0) FROM country
WHERE Continent='Asia';

-- Total population in Europe
SELECT FORMAT(SUM(Population),0) FROM country
WHERE Continent='Europe';

-- Count the number of countries
SELECT COUNT(Name) FROM country;

-- Count countries by continent
SELECT Continent, COUNT(Name) FROM country
GROUP BY Continent;

-- Same as above, but ordered by count descending
SELECT Continent, COUNT(Name) FROM country
GROUP BY Continent
ORDER BY COUNT(Name) DESC;

-- Exclude Antarctica and Oceania, order by count
SELECT Continent, COUNT(Name) FROM country
GROUP BY Continent
HAVING Continent NOT LIKE 'Antarctica' AND Continent NOT LIKE 'Oceania'
ORDER BY COUNT(Name) DESC;

-- Alternative using NOT IN
SELECT Continent, COUNT(Name) FROM country
GROUP BY Continent
HAVING Continent NOT IN ('Antarctica', 'Oceania', 'Europe')
ORDER BY COUNT(Name) DESC;

-- Continents with more than 50 countries, excluding Antarctica and Oceania
SELECT Continent, Count(Name) FROM country
WHERE Continent NOT IN ('Antarctica', 'Oceania')
GROUP BY Continent
HAVING COUNT(Name) > 50
ORDER BY COUNT(Name) DESC;

# GROUP BY + LIMIT + OFFSET
-- Show countries with more than 75 cities, sorted by average population (4th-6th rows only)
SELECT CountryCode, FORMAT(AVG(Population),0), COUNT(Name) FROM city
GROUP BY CountryCode
HAVING COUNT(Name) > 75
ORDER BY AVG(Population) DESC
LIMIT 3 OFFSET 3;

-- Alternative using aliases
SELECT 
	CountryCode, 
    	FORMAT(AVG(Population),0) AS Avg_Population, 
    	COUNT(Name) AS Total_Cities
FROM city
GROUP BY CountryCode
HAVING Total_Cities > 75
ORDER BY Avg_Population DESC;

-- Another way using column number in ORDER BY
ORDER BY 2 DESC;  -- sort by second column (Avg_Population)

#=================================================================================================
# BUILT-IN FUNCTIONS
# Aggregate functions: apply to entire column or groups
Examples: SUM, AVG, COUNT, MIN, MAX

# Scalar functions: apply to each row
Examples: LENGTH, UCASE, LCASE

-- Character length
SELECT Name, LENGTH(Name) AS Char_Length FROM country;

-- Uppercase
SELECT Name, UCASE(Name) AS Uppercase FROM country;

-- Lowercase
SELECT Name, LCASE(Name) AS Lowercase FROM country;

#=================================================================================================
# DATE & TIME FUNCTIONS
# Formats:
# -DATE: YYYYMMDD
# -TIME: hhmmss

-- Current datetime
SELECT NOW();

-- Current date
SELECT CURDATE();

-- Current time
SELECT CURTIME();

-- Extracting parts of date/time
SELECT payment_date, YEAR(payment_date), MONTH(payment_date), MONTHNAME(payment_date),
       DAY(payment_date), DAYNAME(payment_date), HOUR(payment_date),
       MINUTE(payment_date), SECOND(payment_date), WEEK(payment_date),
       DAYOFYEAR(payment_date), DAYOFWEEK(payment_date)
FROM payment;

-- Using EXTRACT
SELECT payment_date, EXTRACT(YEAR FROM payment_date),
                    EXTRACT(MONTH FROM payment_date),
                    EXTRACT(DAY FROM payment_date),
                    EXTRACT(HOUR FROM payment_date)
FROM payment;

-- Add/Subtract date intervals
SELECT DATE_ADD('2024-02-21', INTERVAL 5 DAY);
SELECT DATE_SUB('2024-02-21', INTERVAL 5 DAY);

-- Difference between dates
SELECT DATEDIFF('2024-02-28', '2024-02-21');

-- TIMESTAMPDIFF
SELECT TIMESTAMPDIFF(DAY, '1997-05-28', CURDATE());
SELECT TIMESTAMPDIFF(MONTH, '1997-05-28', CURDATE());
SELECT TIMESTAMPDIFF(YEAR, '1997-05-28', CURDATE());

-- Custom formatted date
SELECT DATE_FORMAT('2024-02-21', '%W, %D %M %Y');

#=================================================================================================
# CASE STATEMENT
# Allows for conditional logic in queries.
# Syntax:
CASE [Expression]
    WHEN condition_1 THEN result_1
    WHEN condition_2 THEN result_2
    ...
    ELSE result_n
END

-- With expression
SELECT
	title,
    	rating,
    CASE rating
	WHEN 'PG' THEN 'Parental Guidance Suggested'
        WHEN 'PG-13' THEN 'Parental Guidance Cautioned'
        WHEN 'G' THEN 'General Audience'
        WHEN 'R' THEN 'Restricted'
        WHEN 'NC-17' THEN 'Adults Only'
	END AS rating_description
FROM film;

-- Without expression
SELECT 
	title, 
	length,
    CASE
		WHEN length > 0 AND length <= 60 THEN 'Short'
        WHEN length > 60 AND length <= 120 THEN 'Medium'
        ELSE 'Long'
	END AS duration_category
FROM film;

-- Rental rate description
SELECT
	title,
    	rental_rate,
    CASE rental_rate
	WHEN 0.99 THEN 'Economy'
        WHEN 2.99 THEN 'Mass'
        ELSE 'Premium'
	END AS rental_rate_description
FROM film
ORDER BY rental_rate_description;

-- Count of films per rental category
SELECT
    SUM(CASE rental_rate WHEN 0.99 THEN 1 ELSE 0 END) AS Total_Economy,
    SUM(CASE rental_rate WHEN 2.99 THEN 1 ELSE 0 END) AS Total_Mass,
    SUM(CASE rental_rate WHEN 4.99 THEN 1 ELSE 0 END) AS Total_Premium
FROM film;
