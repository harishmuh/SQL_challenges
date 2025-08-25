-- Latihan SQL di Bigquery platform


-- Tingkat Mudah

-- Tampilkan semua record dengan ship_mode yang first class
SELECT * 
FROM `halogen-framing-470104-t1.superstore.transaksi_gsheet` 
WHERE Ship_Mode = 'First Class' 
LIMIT 100;

-- Hitung jumlah total baris dalam tabel superstore
SELECT count(*) AS total_rows
FROM `superstore.transaksi_gsheet`;


-- Soal : Tampilkan semua kolom dari tabel superstore, tetapi hanya untuk kategori Furniture.
SELECT *
FROM `superstore.transaksi_gsheet`
WHERE Category = 'Furniture'
limit 10;

-- Soal : Hitung total penjualan (Sales) di seluruh dataset.
SELECT SUM(Sales) AS total_sales
FROM `superstore.transaksi_gsheet`;

-- Soal : Tampilkan daftar kota unik yang ada di dataset.
SELECT DISTINCT City
FROM `superstore.transaksi_gsheet`;

-- Apa saja daftar kategori
SELECT DISTINCT Category
FROM `superstore.transaksi_gsheet`;





-- Tingkat menengah

-- Hitung total Sales per Category.
SELECT Category, SUM(Sales) as total_sales
FROM `superstore.transaksi_gsheet`
GROUP BY Category;

-- Soal : Hitung rata-rata Profit per Region.
SELECT Region, avg(Profit) as avg_profit
FROM `superstore.transaksi_gsheet`
GROUP BY 1;


-- Cari 5 produk dengan penjualan (Sales) tertinggi.
SELECT Product_Name, SUM(Sales) AS total_sales
FROM `superstore.transaksi_gsheet`
GROUP BY Product_Name
ORDER BY total_sales DESC
LIMIT 5;

-- Tampilkan semua 100 sub-produk, tampilkan dari jumlah terbanyak
SELECT DISTINCT(Sub_Category) as Subcategory, COUNT(*) as Total_Number
FROM `superstore.transaksi_gsheet`
GROUP BY 1
ORDER BY 2 DESC
LIMIT 100;

-- Tampilkan rata-rata profit per Region
SELECT Region, avg(Profit) as avg_profit
FROM `superstore.transaksi_gsheet`
GROUP BY 1
ORDER BY 2 DESC;

-- Hitung total sales, profit, dan quantity per kategori produk
SELECT 
  Category,
  SUM(Sales) AS total_sales,
  SUM(Profit) AS total_profit,
  SUM(Quantity) AS total_quantity
FROM `superstore.transaksi_gsheet`
GROUP BY Category;

-- Tentukan sub-category dengan profit margin tertinggi (profit margin = profit/sales)
SELECT 
  Sub_Category,
  SUM(Profit) / SUM(Sales) AS profit_margin
FROM `superstore.transaksi_gsheet`
GROUP BY Sub_Category
ORDER BY profit_margin DESC
LIMIT 5;

-- Cari region dengan rata-rata discount terbesar
SELECT 
  Region,
  AVG(Discount) AS avg_discount
FROM `superstore.transaksi_gsheet`
GROUP BY Region
ORDER BY avg_discount DESC;


-- Buat kolom baru “Profitability” dengan kategori: (High: jika profit>500, medium: profit antara 0 dan 500, loss jika profit < 0)
SELECT 
  Order_ID,
  Product_Name,
  Profit,
  CASE 
    WHEN Profit > 500 THEN 'High'
    WHEN Profit >= 0 THEN 'Medium'
    ELSE 'Loss'
  END AS Profitability
FROM `superstore.transaksi_gsheet`
LIMIT 100;


-- Hitung rata-rata sales per customer, lalu cari 10 customer dengan rata-rata tertinggi
SELECT 
  Customer_Name,
  AVG(Sales) AS avg_sales
FROM `superstore.transaksi_gsheet`
GROUP BY Customer_Name
ORDER BY avg_sales DESC
LIMIT 10;


-- Cari kategori dengan kontribusi paling besar terhadap sales
WITH total AS (
  SELECT SUM(Sales) AS total_sales
  FROM `superstore.transaksi_gsheet`
)
SELECT 
  Category,
  SUM(Sales) AS category_sales,
  ROUND(SUM(Sales) / total_sales * 100, 2) AS contribution_percent
FROM `superstore.transaksi_gsheet`, total
GROUP BY Category, total_sales
ORDER BY contribution_percent DESC;



-- Tingkat Sulit

-- Tampilkan Monthly sales per bulan
SELECT
  FORMAT_DATE('%Y-%m', Order_Date) as month,
  sum(Sales) as total_sales
FROM `superstore.transaksi_gsheet`
GROUP BY month
ORDER BY month;


-- Buat cohort analysis sederhana: jumlah customer baru per tahun
WITH first_purchase AS (
  SELECT 
    Customer_ID,
    MIN(EXTRACT(YEAR FROM Order_Date)) AS first_year
  FROM `superstore.transaksi_gsheet`
  GROUP BY Customer_ID
)
SELECT 
  first_year,
  COUNT(DISTINCT Customer_ID) AS new_customers
FROM first_purchase
GROUP BY first_year
ORDER BY first_year;


-- Buatlah analisis RFM (recency, frequency, monetary) untuk top 10 pelanggan
-- Urutkan berdasarkan tingkat monetary terbesar
WITH customer_rfm AS (
  SELECT
    Customer_Name,
    DATE_DIFF(CURRENT_DATE(), MAX(Order_Date), DAY) AS Recency,
    COUNT(DISTINCT Order_ID) AS Frequency,
    SUM(Sales) AS Monetary
  FROM `superstore.transaksi_gsheet`
  GROUP BY Customer_Name
)
SELECT *
FROM customer_rfm
ORDER BY Monetary DESC
LIMIT 10;


-- Tampilkan top 5 customer dengan Sales tertinggi 
SELECT Region, Customer_Name, total_sales
FROM (
SELECT 
    Region,
    Customer_Name,
    SUM(Sales) AS total_sales,
    ROW_NUMBER() OVER(PARTITION BY Region ORDER BY SUM(Sales) DESC) AS rank
  FROM `superstore.transaksi_gsheet`
  GROUP BY Region, Customer_Name
)
WHERE rank <= 5
ORDER BY Region, total_sales DESC;

-- Fungsi Transform -- tidak bisa karena pakai external table
--ALTER TABLE `halogen-framing-470104-t1.superstore.transaksi_gsheet` 
--ADD COLUMN Order_Category STRING;

-- CREATE OR REPLACE TABLE`halogen-framing-470104-t1.superstore.transaksi_gsheet` AS
-- SELECT
--   *,
--   CAST(NULL AS STRING) AS kolom_baru
-- FROM `halogen-framing-470104-t1.superstore.transaksi_gsheet`;

