-- Monthly Price Growth

-- What was the month-over-month growth of official rice prices (o_rice) in Yangon during 2025?


WITH Yangon_Rice_Price AS 
(
	SELECT 
		EXTRACT(month FROM (price_date)) AS MONTH_2025,
		avg(o_rice) AS Official_Rice_Price_for_1Kg
	FROM myanmar_food_prices mfp 
	WHERE EXTRACT(YEAR FROM (price_date)) = '2025' AND adm1_name = 'Yangon'
	GROUP BY price_date
)


SELECT 
		*, 
		round(100 * (Official_Rice_Price_for_1Kg - lag(Official_Rice_Price_for_1Kg) over(ORDER BY MONTH_2025)) 
									/ lag(Official_Rice_Price_for_1Kg) over(ORDER BY MONTH_2025),2) AS Market_Growth
FROM Yangon_Rice_Price ;