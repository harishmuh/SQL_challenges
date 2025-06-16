# MYSQL
# Relational Database Management System
# - Not case-sensitive
# - Indentation doesn't affect execution
# - Equal comparison uses a single equal sign (=)
# ================================

# Show all databases on the server
SHOW DATABASES;

# Use the "world" database
USE world;

# Show tables in the database
SHOW TABLES;

# Show column descriptions of a table
DESC city;

# ===============================
# Create a new database
# Syntax: create database
CREATE DATABASE seller;

# Trying to create a database with the same name (won't work)
CREATE DATABASE IF NOT EXISTS SELLER; # Will not work if it already exists

USE seller;
SHOW TABLES;

# Delete the "seller" database
DROP DATABASE seller;

# Can't delete a database that doesn't exist
DROP DATABASE IF EXISTS seller; # Will delete only if the database exists

SHOW DATABASES;

# Use SQL DROP (and DELETE) cautiously, because once something is deleted,
# it cannot be restored. There is no UNDO.

#=====================================================================================
# Creating a table and inserting data

CREATE DATABASE IF NOT EXISTS purwadhika;
USE purwadhika;
SHOW TABLES;

# Create a table named "products"
# Syntax: CREATE TABLE table_name (
#           column1 datatype,
#           column2 datatype, ...)
CREATE TABLE IF NOT EXISTS products (
    productID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    productCode CHAR(3),
    name VARCHAR(30) NOT NULL DEFAULT '',
    quantity INT UNSIGNED NOT NULL DEFAULT 0,
    price DECIMAL(7,2) NOT NULL DEFAULT 99999.99,
    PRIMARY KEY (productID));

DESC products;

# Insert data into the table
# INSERT INTO --> used to insert new records into an existing table

# Insert without specifying column names
# Must follow the column order and provide all values
INSERT INTO products VALUES (1001, 'PEN', 'Pen Red', 5000, 1.23);

# Insert multiple records at once
# Inserting NULL into AUTO_INCREMENT column will auto-increment based on max value
INSERT INTO products VALUES 
(NULL, 'PEN', 'Pen Blue', 8000, 1.25),
(NULL, 'PEN', 'PEN Black', 2000, 1.25);

# Insert data by specifying column names and values
INSERT INTO products(productCode, name, quantity, price) VALUES
    ('PEC', 'Pencil 2B', 10000, 0.48),
    ('PEC', 'Pencil 2H', 8000, 0.49);

# Insert data by specifying columns in random order
INSERT INTO products(name, productID) VALUES('Pencil HB', 1006);

# Errors

# Error: value exceeds defined character limit
INSERT INTO products(productCode) VALUES('PENC');

# Error: duplicate value for primary key
INSERT INTO products(productID) VALUES(1001);

# Error: inserting NULL into NOT NULL columns
INSERT INTO products VALUES(NULL, NULL, NULL, NULL, NULL);

# View all table contents
SELECT * FROM products; # * (asterisk) retrieves all columns

#=====================================================================================
# ALTER TABLE
# Modify an existing table

# Add a new column
ALTER TABLE products
ADD descriptions VARCHAR(50);

SELECT * FROM products;

# Rename a column
ALTER TABLE products
RENAME COLUMN descriptions TO keterangan;

DESC products;

# Change data type of a column
ALTER TABLE products
MODIFY COLUMN keterangan VARCHAR(150);

# Delete a column from the table
ALTER TABLE products
DROP COLUMN keterangan;

#=======================================================================================
# SELECT
# Used to access data from a database
# The result is shown in a specific table format

# Access all columns in a table
SELECT * FROM products;

# Access specific columns
SELECT productCode, price FROM products;

# Access columns in random order
SELECT price, name, quantity FROM products;

# Use SELECT without a table
SELECT 1+1;

SELECT NOW();

#================================================================================================
# DISTINCT, COUNT, AVG, SUM, LIMIT

USE world; # use the "world" database
SHOW TABLES; # show all tables
DESC city; # view column descriptions of "city"
DESC country;

# Show all data from "country" table
SELECT * FROM country;

# Show only the "continent" column from "country"
SELECT continent FROM country;

# DISTINCT --> returns only unique values

# Show unique continent names (no duplicates)
SELECT DISTINCT Continent FROM country;

# COUNT --> count number of entries in a column
# Total number of countries (239)
SELECT COUNT(Name) FROM country;

# Count values in the "continent" column (including duplicates)
SELECT COUNT(Continent) FROM country;

# COUNT(DISTINCT) --> count unique values
SELECT COUNT(DISTINCT continent) FROM country;

# AVG --> average of numeric column
SELECT AVG(LifeExpectancy) FROM country;

# SUM --> sum of numeric column
SELECT SUM(Population) FROM country;

# ROUND --> round a number
SELECT ROUND(AVG(LifeExpectancy), 2) FROM country;

# ALIAS --> rename a column
SELECT ROUND(AVG(LifeExpectancy), 2) AS Avg_Life_Expectancy
FROM country;

SELECT ROUND(AVG(LifeExpectancy), 2) Avg_Life_Expectancy
FROM country;

# LIMIT --> limit number of returned rows
SELECT * FROM country
LIMIT 3; # first 3 rows

SELECT * FROM country
LIMIT 5 OFFSET 3; # 5 rows after skipping first 3

#=================================================================================================
# WHERE
# Used to filter records based on conditions

SELECT * FROM city;

# Get all rows where name is 'Jakarta'
SELECT * FROM city 
WHERE Name = 'Jakarta';

# Get all rows where population is >= 10,000,000
SELECT * FROM city
WHERE Population >= 10000000;

# Get top 5 rows where country code is 'IDN'
SELECT * FROM city
WHERE CountryCode = 'IDN'
LIMIT 5;

# Country names starting with V
SELECT Name FROM country
WHERE Name LIKE 'v%';

# Country names ending in G
SELECT Name FROM country
WHERE Name LIKE '%g';

# Country names that contain the letter X
SELECT Name FROM country
WHERE Name LIKE '%X%';

# Second letter is G
SELECT Name FROM country
WHERE NAME LIKE '_G%';

# Indonesian cities where second letter is U
SELECT Name FROM city
WHERE CountryCode = 'IDN' AND Name LIKE '_U%';

# Cities with population ≥ 5 million OR located in Japan
SELECT Name, Population FROM city
WHERE Population >= 5000000 OR CountryCode='JPN';

#==================================================================================================
# UPDATE
# Modify existing records in a table

USE purwadhika;
SELECT * FROM products;

SET SQL_SAFE_UPDATES = 0;

# Update quantity of 'Pencil 2B' from 10000 to 3000
UPDATE products
SET quantity = 3000
WHERE name = 'Pencil 2B';

# Reduce stock of products with code 'PEN' by 1000
UPDATE products
SET quantity = quantity - 1000
WHERE productCode = 'PEN';

# Replace NULL productCode with 'PEC', set quantity to 2000, price to 0.5
UPDATE products
SET productCode='PEC', quantity=2000, price=0.5
WHERE productCode IS NULL;

# Set productCode to NULL where productID is 1001
UPDATE products
SET productCode=NULL
WHERE productID = 1001;

# Set NULL productCode to 'PEN'
UPDATE products
SET productCode='PEN'
WHERE productCode IS NULL;

SELECT * FROM products;

#==================================================================================================
# DELETE
# Delete rows from a table

# Delete rows with quantity ≤ 3000
DELETE FROM products
WHERE quantity <= 3000;

# Delete rows where productCode is 'PEC'
DELETE FROM products
WHERE productCode='pec';

# Delete all rows from the table
DELETE FROM products;

SELECT * FROM products;

#=================================================================================================
# TRANSACTION
# A transaction is a group of SQL operations that are either all committed or all rolled back
# It ensures no partial updates occur
# Transactions use COMMIT and ROLLBACK

# Example

# Create "accounts" table
CREATE TABLE accounts(
    name VARCHAR(10),
    balance DECIMAL(10,2)
);

# Insert data
INSERT INTO accounts VALUES
    ('Paul', 1000),
    ('Peter', 2000);

SELECT * FROM accounts;

# Transfer money from Paul to Peter
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE name = 'Paul';
UPDATE accounts SET balance = balance + 100 WHERE name = 'Peter';
SELECT * FROM accounts;
COMMIT; # commit and end transaction

SELECT * FROM accounts;

# Another transfer but rollback instead of commit
START TRANSACTION;
UPDATE accounts SET balance = balance - 200 WHERE name = 'Paul';
UPDATE accounts SET balance = balance + 200 WHERE name = 'Peter';
SELECT * FROM accounts;
ROLLBACK; # cancel transaction and undo changes

SELECT * FROM accounts;
