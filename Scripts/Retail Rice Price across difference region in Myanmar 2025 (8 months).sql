-- Retail Rice Price across difference region in Myanmar 2025 (8 months)

SELECT 
		DISTINCT adm1_name AS Regions, 
		round(avg(mfp.o_rice * 2 * 1.63) OVER(PARTITION BY adm1_name),2) 
		AS Retail_Rice_Price_for_1Kg
FROM myanmar_food_prices mfp 
WHERE EXTRACT(year FROM (price_date)) = '2025' AND adm1_name != 'Market Average'
ORDER BY 2 desc;
