-- create a table
drop table if exists zepto;

create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

-- data exploration

-- Count Rows
SELECT count(*)
FROM zepto;

-- Sample Data
SELECT * FROM  zepto
LIMIT 10 ;

-- Null values
SELECT * FROM zepto
WHERE NAME IS NULL
OR 
Category IS NULL
OR 
mrp IS NULL
OR 
discountedSellingPrice IS NULL
OR 
availableQuantity IS NULL
OR 
weightInGms IS NULL
OR 
discountPercent IS NULL
OR 
outOfStock IS NULL
OR 
quantity is NULL;

-- different product category
SELECT DISTINCT Category
from zepto
group by Category;

-- inventory out of stock or in stock
-- 0 = False
-- 1 = True
SELECT outOfStock , count(SKU_ID)
FROM zepto
GROUP BY outOfStock;

-- product name present mulitple times
SELECT NAME , count(sku_id) AS "NUMBER OF SKUs"
FROM zepto
GROUP BY NAME
HAVING count(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;


-- DATA CLEANING

-- product where price = 0 
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM ZEPTO 
WHERE mrp = 0 ;

-- convert paise into rupee
UPDATE zepto
SET mrp = mrp/100 ;

UPDATE zepto
SET discountedSellingPrice = discountedSellingPrice/100 ;
select * from zepto;


-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name , mrp , discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT NAME , MRP
FROM zepto
WHERE MRP>300 AND outOfStock = 1
ORDER BY  MRP DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT CATEGORY , SUM(MRP * quantity) AS revenue
FROM zepto 
GROUP BY category
ORDER BY revenue DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT NAME,MRP, discountPercent
FROM zepto
WHERE MRP > 500 AND discountPercent<10
ORDER BY MRP DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT CATEGORY , round(avg(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY CATEGORY
ORDER BY avg(discountPercent) desc
LIMIT 5 ;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT distinct NAME , WEIGHTINGMS , DISCOUNTEDSELLINGPRICE ,
 round(DISCOUNTEDSELLINGPRICE/WEIGHTINGMS,2) AS price_per_gms
FROM zepto
WHERE WEIGHTINGMS > 100
ORDER BY price_per_gms;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT NAME , CATEGORY , WEIGHTINGMS ,
CASE WHEN WEIGHTINGMS < 1000 THEN "LOW"
     WHEN WEIGHTINGMS < 5000 THEN "MEDIUM"
     ELSE "BULK"
     END AS Weight_Category
FROM ZEPTO;

-- Q8.What is the Total Inventory Weight Per Category 
SELECT  category ,
 SUM(weightingms*quantity) AS total_inventory_weight
FROM zepto
GROUP BY CATEGORY
ORDER BY total_inventory_weight DESC ;