**Accessing the database [world](https://dev.mysql.com/doc/world-setup/en/)**

````sql
USE world;
````

**1. Ada berapa negara di database world?**
→ How many countries are there in the world database?

````sql
SELECT COUNT(Name) AS Jumlah_Negara
FROM country;
````
![image](https://github.com/user-attachments/assets/3e22ed52-f8c1-4bcf-a537-08cb7da7e20c)

**2. Tampilkan rata-rata harapan hidup di benua Asia!**
→ Display the average life expectancy in the continent of Asia!

````sql
SELECT ROUND(AVG(LifeExpectancy), 2) AS Rata_Rata_Harapan_Hidup_di_Asia
 FROM country
 WHERE continent='Asia';
````
![image](https://github.com/user-attachments/assets/5993aa32-b9ef-436f-b292-14de202d190a)


**3. Tampilkan total populasi di Asia Tenggara!**
→ Display the total population in Southeast Asia!

````sql
 SELECT SUM(Population) AS Total_Populasi_di_Asia_Tenggara
 FROM country
 WHERE region='Southeast Asia';
````
![image](https://github.com/user-attachments/assets/8cad732e-07e0-4f9e-b867-f23090ae6a45)


**4. Tampilkan rata-rata GNP di benua Afrika region Eastern Africa. Gunakan alias 'Average_GNP' untuk rata-rata GNP!**
→ Display the average GNP in the continent of Africa, specifically the Eastern Africa region. Use the alias 'Average_GNP' for the average GNP!

````sql
 SELECT AVG(GNP) AS Average_GNP
 FROM country
 WHERE region='Eastern Africa';
````
![image](https://github.com/user-attachments/assets/551fd217-d6a4-4f03-8aa2-ada87f6c8f83)



**5. Tampilkan rata-rata Populasi pada negara yang luas areanya lebih dari 5 juta km2!**
→ Display the average population in countries with an area greater than 5 million km²!

````sql
 SELECT AVG(Population) AS Average_Population
 FROM country
 WHERE SurfaceArea > 5000000
````
![image](https://github.com/user-attachments/assets/b20d727c-d0e2-4c45-8fcf-9a54936cc127)


**6. Tampilkan nama provinsi di Indonesia beserta populasinya yang memiliki populasi di atas 5 juta!**
→ Display the names of cities in Indonesia and their populations for those with a population above 5 million!

````sql
SELECT Name, Population
FROM city
WHERE CountryCode = 'IDN' AND Population > 5000000;
````
![image](https://github.com/user-attachments/assets/21361e7c-e904-4314-8714-8264318e1a71)


**7. Ada berapa bahasa (unique) di dunia?**
→ How many unique languages are there in the world?

````sql
SELECT COUNT(DISTINCT Language) AS Jumlah_Bahasa_di_Dunia
FROM countrylanguage;
````
![image](https://github.com/user-attachments/assets/df0dcc41-ed27-4826-9645-8016bee5f5d4)


**8. Tampilkan bahasa-bahasa apa saja yang dipergunakan di Indonesia!**
→ Display the languages that are used in Indonesia!

````sql
SELECT DISTINCT Language AS Bahasa_di_Indonesia
FROM countrylanguage
WHERE CountryCode='IDN';
````
![image](https://github.com/user-attachments/assets/28b2a48e-a1e1-4752-8efb-8ead74315b9e)


**9. Tampilkan GNP dari 5 negara di Asia yang populasinya di atas 100 juta penduduk!**
→ Display the GNP of 5 countries in Asia with populations over 100 million people!

````sql
SELECT Name, GNP FROM country
WHERE continent='Asia' AND population > 1e8
LIMIT 5;
````
![image](https://github.com/user-attachments/assets/d17e5bf7-3c6d-4463-8e45-6fab6b5d755d)


**10. Tampilkan negara di Afrika yang memiliki SurfaceArea di atas 1.200.000!**
→ Display the countries in Africa with a surface area greater than 1,200,000!

````sql
SELECT Name   
FROM country
WHERE continent='Africa' AND SurfaceArea > 1200000;
````

![image](https://github.com/user-attachments/assets/96e47989-2b81-4497-8c14-90ce32905dd6)



**11. Tampilkan negara di Afrika yang memiliki huruf akhir 'i'!**
→ Display the countries in Africa whose names end with the letter 'i'!

````sql
SELECT Name   
FROM country
WHERE continent='Africa' AND Name LIKE '%i';
````

![image](https://github.com/user-attachments/assets/2e8705d0-c2fe-4839-84b4-ae412e3001ff)


**12. Tampilkan jumlah negara di Asia yang sistem pemerintahannya adalah republik.**
→ Display the number of countries in Asia whose form of government is a republic.

````sql
SELECT COUNT(Name) AS Banyaknya_Negara_Republik
FROM country
WHERE GovernmentForm='Republic' AND Continent='Asia';
````

![image](https://github.com/user-attachments/assets/3fff92cd-3980-49c1-9dcd-b47b19212b8c)


**13. Tampilkan jumlah negara di Eropa yang merdeka sebelum 1940!**
→ Display the number of countries in Europe that gained independence before 1940!

````sql
SELECT COUNT(Name) AS Banyaknya_Negara
FROM country
WHERE IndepYear < 1940 AND Continent='Europe';
````

![image](https://github.com/user-attachments/assets/b12a21e2-025f-49e4-8840-9b67e617f45e)


**14. Tampilkan 5 nama kota yang berada di provinsi Jawa Barat!**
→ Display the names of 5 cities located in the West Java province!

````sql
SELECT Name FROM city
WHERE District='West Java'
LIMIT 5;
````

![image](https://github.com/user-attachments/assets/73b4a160-afbe-470e-a54f-f2bad7e47d3b)


**15. Tampilkan 3 nama kota yang memiliki id genap di negara Jepang!**
→ Display the names of 3 cities with even IDs in Japan!

````sql
SELECT *
FROM city
WHERE CountryCode='JPN' AND ID%2=0
LIMIT 3;

````
![image](https://github.com/user-attachments/assets/87c4c911-23a8-4526-a8da-5b0856c156a4)

