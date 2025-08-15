# Used-Car-Database-Analysis-MySQL-workbench-Project

## Project Overview

**Project Title**: Used Car Analysis  
**Level**: Beginner  
**Database**: `used_car_db`

This project focuses on data cleaning, transformation, and exploratory analysis of a used car dataset using MySQL.
It includes database creation, handling missing data, categorizing mileage, and generating various insights such as price trends, popular models, and seller analysis.
This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a used car database**: Create and populate a used car database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `used_car_db`.
- **Table Creation**: A table named `used_cars` is created to store the used car data. The table structure includes columns for listing_id,	vin, make,	model, year, trim, body_type, fuel_type, transmission, mileage, price, condition, subregion, region, country , seller_type


```sql
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
    seller_type VARCHAR(3
);
```

### 2. Data Exploration & Cleaning

- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Average Price by Year, Transmission, Fuel Type, and Country.**:
```sql
SELECT year, transmission, fuel_type, country,'condition',
       AVG(price) AS avg_price
FROM used_cars
GROUP BY year, transmission, fuel_type, country,'condition'
order by year ;
```

2. **Mileage Category Analysis.**:
```sql
REATE VIEW mileage_category_stats AS
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
```

3. **Most Common Car Models by Country.**:
```sql
SELECT country, model, COUNT(*) AS total_listings
FROM used_cars
GROUP BY country, model
ORDER BY total_listings DESC,country;
```

4. **Price Range Distribution by Body Type.**:
```sql
SELECT body_type,
       MIN(price) AS min_price,
       MAX(price) AS max_price,
       AVG(price) AS avg_price
FROM used_cars
GROUP BY body_type
order by avg_price;
```

5. **Price Trend Over Years.**:
```sql
SELECT year, AVG(price) AS avg_price, COUNT(*) AS total_cars
FROM used_cars
GROUP BY year
ORDER BY year;
```

6. **Top 10 Most Expensive Cars.**:
```sql
SELECT make, model, year, price, mileage, country
FROM used_cars
ORDER BY price DESC
LIMIT 10;
```

7. **Seller Type Analysis**:
```sql
SELECT seller_type, COUNT(*) AS total_cars, AVG(price) AS avg_price
FROM used_cars
GROUP BY seller_type
ORDER BY total_cars DESC;
```

8. **Transmission Preference by Country.**:
```sql
SELECT country, transmission, COUNT(*) AS total_cars
FROM used_cars
GROUP BY country, transmission
ORDER BY country, total_cars DESC;
```

9. **Fuel Type Popularity by Region.**:
```sql
SELECT region, fuel_type, COUNT(*) AS total_cars, AVG(price) AS avg_price
FROM used_cars
GROUP BY region, fuel_type
ORDER BY region, total_cars DESC;
```

## Key Insights You Can Extract

- **Average car prices by year, transmission type, fuel type, and country.**
- **Categorized mileage analysis for easy interpretation.**
- **Most common models by country.**
- **Price ranges per body type.**
- **Price trends over the years.**
- **Top high-value listings.**
- **Seller type performance.**
- **Transmission and fuel preferences by region.**


## Tools & Technologies

- **Database**: MySQL.
- **Techniques**: Data cleaning, handling missing values, grouping & aggregation, Common Table Expressions (CTE), Views.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Run the Queries**: Use the SQL queries provided in the `user_cars_db` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Sara Ibrahim

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
