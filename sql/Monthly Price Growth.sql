-- Monthly Price Growth 2025(Rice)

-- What was the month-over-month growth of official rice prices (o_rice) in Yangon during 2025?


WITH Yangon_Rice_Price AS 
(
	SELECT 
		EXTRACT(month FROM (price_date)) AS MONTH_2025,
		avg(mfp.o_rice * 1.91 * 1.63) AS Rice_1_kg_price
	FROM myanmar_food_prices mfp 
	WHERE EXTRACT(YEAR FROM (price_date)) = '2025' AND adm1_name = 'Yangon'
	GROUP BY price_date
)


SELECT 
		*, 
		round(100 * (Rice_1_kg_price - lag(Rice_1_kg_price) over(ORDER BY MONTH_2025)) 
									/ lag(Rice_1_kg_price) over(ORDER BY MONTH_2025),2) AS Market_Growth
FROM Yangon_Rice_Price ;