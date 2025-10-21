--Average Price and Listings by Brand

  SELECT 
    Brand,
    COUNT(*) AS total_listings,
    ROUND(AVG(Price), 2) AS avg_price
FROM cars
GROUP BY Brand
ORDER BY avg_price DESC;





--Price Rank of Each Brand within City

SELECT 
    city,
    Brand,
    ROUND(AVG(Price),2) AS avg_price,
    RANK() OVER (PARTITION BY city ORDER BY AVG(Price) DESC) AS brand_rank
FROM cars
GROUP BY city, Brand
ORDER BY city, brand_rank;






--Depreciation Rate per Year (Price vs Age)

SELECT 
    Brand,
    ROUND(AVG(Price / NULLIF(age_years,0)), 2) AS avg_price_per_year,
    ROUND(AVG(Price_per_year), 2) AS reported_price_per_year
FROM cars
GROUP BY Brand
ORDER BY avg_price_per_year DESC;

--Top 3 Brands by Average Price per City

WITH BrandCity AS (
    SELECT 
        city,
        Brand,
        ROUND(AVG(Price),2) AS avg_price,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY AVG(Price) DESC) AS rnk
    FROM cars
    GROUP BY city, Brand
)
SELECT city, Brand, avg_price
FROM BrandCity
WHERE rnk <= 3
ORDER BY city, avg_price DESC;






--Fuel Type Mix Percentage per Brand

SELECT 
    Brand,
    ROUND(SUM(CASE WHEN fuel='Petrol' THEN 1 END)*100.0/COUNT(*),2) AS petrol_pct,
    ROUND(SUM(CASE WHEN fuel='Diesel' THEN 1 END)*100.0/COUNT(*),2) AS diesel_pct,
    ROUND(SUM(CASE WHEN fuel='Electric' THEN 1 END)*100.0/COUNT(*),2) AS ev_pct
FROM cars
GROUP BY Brand
ORDER BY petrol_pct DESC;





--transmission Mix by City

SELECT 
    city,
    SUM(CASE WHEN transmission='Manual' THEN 1 ELSE 0 END) AS manual_cars,
    SUM(CASE WHEN transmission='Automatic' THEN 1 ELSE 0 END) AS auto_cars,
    ROUND(SUM(CASE WHEN transmission='Automatic' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS auto_share_pct,
    ROUND(SUM(CASE WHEN transmission='Manual' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS manual_share_pct--,
    --count(transmission) over(partition by city) as total_transmission
FROM cars
GROUP BY city
ORDER BY auto_share_pct DESC;





--Cars Above National Median Price

WITH median_cte AS (
    SELECT PERCENTILE_CONT(0.5)
           WITHIN GROUP (ORDER BY Price)
           OVER () AS median_price
    FROM cars
)
SELECT 
    COUNT(*) AS total_cars,
    SUM(CASE WHEN c.Price > m.median_price THEN 1 ELSE 0 END) AS premium_cars,
    ROUND(SUM(CASE WHEN c.Price > m.median_price THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS premium_pct
FROM cars AS c
CROSS JOIN (SELECT DISTINCT median_price FROM median_cte) AS m;




--Price Segment Buckets   
--alias are executed after grouping so cant use alias in group by keyword

SELECT  
    CASE  
        WHEN Price < 500000 THEN 'Low (<5L)'  
        WHEN Price BETWEEN 500000 AND 1000000 THEN 'Mid (5-10L)'  
        WHEN Price BETWEEN 1000000 AND 2000000 THEN 'Upper (10-20L)'  
        ELSE 'Premium (>20L)'  
    END AS price_segment,  
    COUNT(*) AS car_count,  
    ROUND(AVG(Price),2) AS avg_price
FROM cars
GROUP BY  
    CASE  
        WHEN Price < 500000 THEN 'Low (<5L)'  
        WHEN Price BETWEEN 500000 AND 1000000 THEN 'Mid (5-10L)'  
        WHEN Price BETWEEN 1000000 AND 2000000 THEN 'Upper (10-20L)'  
        ELSE 'Premium (>20L)'  
    END
ORDER BY avg_price;





--Average EMI Burden by Category

SELECT 
    spiny_category,
    ROUND(AVG(emi_perc_price),2) AS avg_emi_pct
FROM cars
GROUP BY spiny_category
ORDER BY avg_emi_pct DESC;




--Year-on-Year Growth in Listings

WITH yearly AS (
    SELECT 
        creation_year,
        COUNT(*) AS total_listings
    FROM cars
    GROUP BY creation_year
)
SELECT 
    creation_year,
    total_listings,
    LAG(total_listings) OVER (ORDER BY creation_year) AS prev_year,
    ROUND(((total_listings - LAG(total_listings) OVER (ORDER BY creation_year)) * 100.0 /
          NULLIF(LAG(total_listings) OVER (ORDER BY creation_year),0)),2) AS growth_pct
FROM yearly
ORDER BY creation_year;




