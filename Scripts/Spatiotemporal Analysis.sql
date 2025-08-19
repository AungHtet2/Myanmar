-- 1️⃣ Spatiotemporal Analysis

-- How has the food price index (o_food_price_index) evolved over time across different administrative levels (adm1_name, adm2_name), and can we detect seasonal patterns or anomalies in specific markets?

-- SQL focus: window functions, GROUP BY, PARTITION BY, moving averages, or EXTRACT(MONTH FROM price_date) for seasonality.

-- Data analysis focus: trends, peaks, and dips in specific regions.


SELECT 
	adm1_name, 
	EXTRACT(YEAR FROM (price_date)) AS Year, 
	avg(o_food_price_index) AS avg_food_price_index
FROM myanmar_food_prices mfp 
GROUP BY adm1_name, EXTRACT(YEAR FROM (price_date))
ORDER BY 2 asc;



SELECT EXTRACT(YEAR FROM (price_date)) AS Year,avg(mfp.o_oil * 1.44) AS retail_price
FROM myanmar_food_prices mfp 
GROUP BY EXTRACT(YEAR FROM (price_date))
ORDER BY 1 asc;
