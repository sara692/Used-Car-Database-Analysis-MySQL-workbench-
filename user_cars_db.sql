-- 1. Create the database
CREATE DATABASE used_car_db;

-- 2. Switch to the database
USE used_car_db;

-- 3. Create the table
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

-- Data Cleaning

SELECT
    SUM(listing_id IS NULL) AS listing_id_nulls,
    SUM(vin IS NULL OR TRIM(vin) = '') AS vin_missing,
    SUM(make IS NULL OR TRIM(make) = '') AS make_missing,
    SUM(model IS NULL OR TRIM(model) = '') AS model_missing,
    SUM(year IS NULL) AS year_missing,
    SUM(trim IS NULL OR TRIM(trim) = '') AS trim_missing,
    SUM(body_type IS NULL OR TRIM(body_type) = '') AS body_type_missing,
    SUM(fuel_type IS NULL OR TRIM(fuel_type) = '') AS fuel_type_missing,
    SUM(transmission IS NULL OR TRIM(transmission) = '') AS transmission_missing,
    SUM(mileage IS NULL) AS mileage_missing,
    SUM(price IS NULL) AS price_missing,
    SUM(`condition` IS NULL OR TRIM(`condition`) = '') AS condition_missing,
    SUM(subregion IS NULL OR TRIM(subregion) = '') AS subregion_missing,
    SUM(region IS NULL OR TRIM(region) = '') AS region_missing,
    SUM(country IS NULL OR TRIM(country) = '') AS country_missing,
    SUM(seller_type IS NULL OR TRIM(seller_type) = '') AS seller_type_missing
FROM used_cars;

SELECT *
FROM used_cars
WHERE listing_id IS NULL
   OR vin IS NULL OR TRIM(vin) = ''
   OR make IS NULL OR TRIM(make) = ''
   OR model IS NULL OR TRIM(model) = ''
   OR year IS NULL
   OR trim IS NULL OR TRIM(trim) = ''
   OR body_type IS NULL OR TRIM(body_type) = ''
   OR fuel_type IS NULL OR TRIM(fuel_type) = ''
   OR transmission IS NULL OR TRIM(transmission) = ''
   OR mileage IS NULL
   OR price IS NULL
   OR `condition` IS NULL OR TRIM(`condition`) = ''
   OR subregion IS NULL OR TRIM(subregion) = ''
   OR region IS NULL OR TRIM(region) = ''
   OR country IS NULL OR TRIM(country) = ''
   OR seller_type IS NULL OR TRIM(seller_type) = '';

SET SQL_SAFE_UPDATES = 0;
UPDATE used_cars
SET `condition` = 'Not specified'
WHERE `condition` IS NULL OR TRIM(`condition`) = '';
SET SQL_SAFE_UPDATES = 1;

-- Data Exploration

-- 1. Average Price by Year, Transmission, Fuel Type, and Country
SELECT year, transmission, fuel_type, country,'condition',
       AVG(price) AS avg_price
FROM used_cars
GROUP BY year, transmission, fuel_type, country,'condition'
order by year ;

-- 2. Mileage Category Analysis
CREATE VIEW mileage_category_stats AS
WITH mileage_case AS (
    SELECT 
        listing_id,
        year,
        mileage,
        price,
        CASE 
            WHEN mileage < 50000 THEN 'Low'
            WHEN mileage BETWEEN 50000 AND 150000 THEN 'Medium'
            ELSE 'High'
        END AS mileage_category
    FROM used_cars
)
SELECT 
    mileage_category,
    year,
    COUNT(*) AS total_cars,
    AVG(price) AS avg_price
FROM mileage_case
GROUP BY mileage_category, year
ORDER BY mileage_category;
SELECT * 
FROM mileage_category_stats;

-- 3. Most Common Car Models by Country
SELECT country, model, COUNT(*) AS total_listings
FROM used_cars
GROUP BY country, model
ORDER BY total_listings DESC,country;

-- 4. Price Range Distribution by Body Type
SELECT body_type,
       MIN(price) AS min_price,
       MAX(price) AS max_price,
       AVG(price) AS avg_price
FROM used_cars
GROUP BY body_type
order by avg_price;

-- 5. Price Trend Over Years
SELECT year, AVG(price) AS avg_price, COUNT(*) AS total_cars
FROM used_cars
GROUP BY year
ORDER BY year;

-- 6. Top 10 Most Expensive Cars
SELECT make, model, year, price, mileage, country
FROM used_cars
ORDER BY price DESC
LIMIT 10;

-- 7. Seller Type Analysis
SELECT seller_type, COUNT(*) AS total_cars, AVG(price) AS avg_price
FROM used_cars
GROUP BY seller_type
ORDER BY total_cars DESC;

-- 8. Transmission Preference by Country
SELECT country, transmission, COUNT(*) AS total_cars
FROM used_cars
GROUP BY country, transmission
ORDER BY country, total_cars DESC;

-- 9. Fuel Type Popularity by Region
SELECT region, fuel_type, COUNT(*) AS total_cars, AVG(price) AS avg_price
FROM used_cars
GROUP BY region, fuel_type
ORDER BY region, total_cars DESC;
