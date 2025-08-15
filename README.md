# Used-Car-Database-Analysis-MySQL-workbench-

## Project Overview

This project focuses on data cleaning, transformation, and exploratory analysis of a used car dataset using MySQL.
It includes database creation, handling missing data, categorizing mileage, and generating various insights such as price trends, popular models, and seller analysis.

📂 Steps & SQL Workflow
1️⃣ Database & Table Creation

'''sql
CREATE DATABASE used_car_db;

USE used_car_db;

CREATE TABLE used_cars (
    listing_id INT PRIMARY KEY,
    vin VARCHAR(17),
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    trim VARCHAR(50),
    body_type VARCHAR(50),
    fuel_type VARCHAR(30),
    transmission VARCHAR(30),
    mileage INT,
    price DECIMAL(10,2),
    `condition` VARCHAR(30),
    subregion VARCHAR(50),
    region VARCHAR(50),
    country VARCHAR(50),
    seller_type VARCHAR(30)
);
'''
2️⃣ Data Cleaning
Check Missing Data in Each Column
SELECT
    SUM(listing_id IS NULL) AS listing_id_nulls,
    SUM(vin IS NULL OR TRIM(vin) = '') AS vin_missing,
    ...
    SUM(seller_type IS NULL OR TRIM(seller_type) = '') AS seller_type_missing
FROM used_cars;

Retrieve Rows with Any Missing or Empty Values
SELECT *
FROM used_cars
WHERE listing_id IS NULL
   OR vin IS NULL OR TRIM(vin) = ''
   ...
   OR seller_type IS NULL OR TRIM(seller_type) = '';

Replace Null or Empty condition Values with “Not specified”
SET SQL_SAFE_UPDATES = 0;
UPDATE used_cars
SET `condition` = 'Not specified'
WHERE `condition` IS NULL OR TRIM(`condition`) = '';
SET SQL_SAFE_UPDATES = 1;

3️⃣ Data Exploration Queries
1. Average Price by Year, Transmission, Fuel Type, and Country
SELECT year, transmission, fuel_type, country, `condition`,
       AVG(price) AS avg_price
FROM used_cars
GROUP BY year, transmission, fuel_type, country, `condition`
ORDER BY year;

2. Mileage Category Analysis (Using CTE + View)
CREATE VIEW mileage_category_stats AS
WITH mileage_case AS (
    SELECT 
        listing_id, year, mileage, price,
        CASE 
            WHEN mileage < 50000 THEN 'Low'
            WHEN mileage BETWEEN 50000 AND 150000 THEN 'Medium'
            ELSE 'High'
        END AS mileage_category
    FROM used_cars
)
SELECT mileage_category, year,
       COUNT(*) AS total_cars,
       AVG(price) AS avg_price
FROM mileage_case
GROUP BY mileage_category, year
ORDER BY mileage_category;

SELECT * FROM mileage_category_stats;

3. Most Common Car Models by Country
SELECT country, model, COUNT(*) AS total_listings
FROM used_cars
GROUP BY country, model
ORDER BY total_listings DESC, country;

4. Price Range by Body Type
SELECT body_type,
       MIN(price) AS min_price,
       MAX(price) AS max_price,
       AVG(price) AS avg_price
FROM used_cars
GROUP BY body_type
ORDER BY avg_price;

5. Price Trend Over Years
SELECT year, AVG(price) AS avg_price, COUNT(*) AS total_cars
FROM used_cars
GROUP BY year
ORDER BY year;

6. Top 10 Most Expensive Cars
SELECT make, model, year, price, mileage, country
FROM used_cars
ORDER BY price DESC
LIMIT 10;

7. Seller Type Analysis
SELECT seller_type, COUNT(*) AS total_cars, AVG(price) AS avg_price
FROM used_cars
GROUP BY seller_type
ORDER BY total_cars DESC;

8. Transmission Preference by Country
SELECT country, transmission, COUNT(*) AS total_cars
FROM used_cars
GROUP BY country, transmission
ORDER BY country, total_cars DESC;

9. Fuel Type Popularity by Region
SELECT region, fuel_type, COUNT(*) AS total_cars, AVG(price) AS avg_price
FROM used_cars
GROUP BY region, fuel_type
ORDER BY region, total_cars DESC;

📊 Key Insights You Can Extract

Average car prices by year, transmission type, fuel type, and country.

Categorized mileage analysis for easy interpretation.

Most common models by country.

Price ranges per body type.

Price trends over the years.

Top high-value listings.

Seller type performance.

Transmission and fuel preferences by region.

🛠️ Tools & Technologies

Database: MySQL

Techniques: Data cleaning, handling missing values, grouping & aggregation, Common Table Expressions (CTE), Views.

📌 How to Run

Install MySQL.

Create the database and table using the provided SQL script.

Load your dataset into the used_cars table.

Run the cleaning queries to handle missing values.

Execute exploration queries for insights.
