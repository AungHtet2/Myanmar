-- retail rice price over time in Yangon and Mandalay (2008 - 2025)

SELECT 
		adm1_name,
		EXTRACT(year FROM (price_date)) AS Year,
		round(avg(mfp.o_rice * 1.91 * 1.63),2) AS Retail_Rice_Price_for_1Kg
FROM myanmar_food_prices mfp 
GROUP BY adm1_name,EXTRACT(year FROM (price_date))
ORDER BY 2 asc;



SELECT DISTINCT mkt_name, round(avg(mfp.o_rice * 1.91 * 1.63),2) AS Retail_Rice_Price_for_1Kg
FROM myanmar_food_prices mfp 
WHERE mfp.adm1_name = 'Yangon' AND EXTRACT(year FROM (price_date)) = '2025'
GROUP BY mkt_name;
