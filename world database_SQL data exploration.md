**Accessing the database world**

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



**5. Tampilkan rata-rata Populasi pada negara yang luas areanya lebih dari 5 juta km2!**
→ Display the average population in countries with an area greater than 5 million km²!

````sql


````

**6. Tampilkan nama provinsi di Indonesia beserta populasinya yang memiliki populasi di atas 5 juta!**
→ Display the names of cities in Indonesia and their populations for those with a population above 5 million!

````sql


````

**7. Ada berapa bahasa (unique) di dunia?**
→ How many unique languages are there in the world?

````sql


````

**8. Tampilkan bahasa-bahasa apa saja yang dipergunakan di Indonesia!**
→ Display the languages that are used in Indonesia!

````sql


````

**9. Tampilkan GNP dari 5 negara di Asia yang populasinya di atas 100 juta penduduk!**
→ Display the GNP of 5 countries in Asia with populations over 100 million people!

````sql


````

**10. Tampilkan negara di Afrika yang memiliki SurfaceArea di atas 1.200.000!**
→ Display the countries in Africa with a surface area greater than 1,200,000!

````sql


````

**11. Tampilkan negara di Afrika yang memiliki huruf akhir 'i'!**
→ Display the countries in Africa whose names end with the letter 'i'!

````sql


````

**12. Tampilkan jumlah negara di Asia yang sistem pemerintahannya adalah republik.**
→ Display the number of countries in Asia whose form of government is a republic.

````sql


````

**13. Tampilkan jumlah negara di Eropa yang merdeka sebelum 1940!**
→ Display the number of countries in Europe that gained independence before 1940!

````sql


````

**14. Tampilkan 5 nama kota yang berada di provinsi Jawa Barat!**
→ Display the names of 5 cities located in the West Java province!

````sql


````

**15. Tampilkan 3 nama kota yang memiliki id genap di negara Jepang!**
→ Display the names of 3 cities with even IDs in Japan!

````sql


````
