# Monthly rice price estimates by product and market
**Overview**

Monthly rice price estimates in fragile countries

## Business Questions
1. Retail Rice Price across difference region in Myanmar 2025 (8 months)

2. Retail Rice Price over time in Yangon and Mandalay (2008 - 2025)

3. What was the month-over-month growth of official rice prices in Yangon during 2025?

## 1. Retail Rice Price across difference region in Myanmar 2025 (8 months)

### Analysis Approach
I analyzed Myanmar’s rice price data to understand regional variations and trends in 2025. My approach included:

1. **Data Preparation**

    I filtered the dataset for the year 2025 and excluded the “Market Average” to focus on individual regions. I converted the prices to retail per 1 kg using the multiplier *1.91*1.63.

2. **Regional Comparison**

    I calculated the average retail rice price per region to see which areas are more expensive or cheaper than Yangon and other regions.

3. **Trend Observation**

    I compared 2025 prices with historical trends to identify regions with the largest increases.

**Postgresql Querry**
```sql
SELECT 
		DISTINCT adm1_name AS Regions, 
		round(avg(mfp.o_rice * 1.91 * 1.63) OVER(PARTITION BY adm1_name),2) 
		AS Retail_Rice_Price_for_1Kg
FROM myanmar_food_prices mfp 
WHERE EXTRACT(year FROM (price_date)) = '2025' AND adm1_name != 'Market Average'
ORDER BY 2 desc;

```
I used this query to calculate the 2025 retail rice prices per region and rank them from highest to lowest.

**Visualization**
![Retail Rice Price across difference region in Myanmar 2025 (8 months)](/Images/Retail%20Rice%20Price%20across%20difference%20region%20in%20Myanmar%202025%20(8%20months).png)

**Key Finding**

- Shan (East) has the highest retail price in 2025 at 14,654.73 MMK/kg.

- Rakhine has the lowest retail price at 5,676.98 MMK/kg.

- Yangon’s rice price is 6,754.91 MMK/kg, slightly below the market average 6,784.81 MMK/kg.

- Regions like Shan (East), Sagaing, and Shan (North) have seen substantial increases compared to 2008, indicating high volatility.

**Business Insight**

I observed significant regional price differences in 2025:

- Yangon is moderately priced but still higher than several regions.

- Regions with extreme increases may face supply chain or production challenges.

- Retailers could optimize costs by sourcing rice from regions with lower and more stable prices.

## 2. Retail Rice Price over time in Yangon and Mandalay (2008 - 2025)
### Analysis Approach
I focused on comparing rice price trends between Yangon and Mandalay from 2008 to 2025. My approach included:

1. **Data Selection**

    I filtered the dataset to include only the regions Yangon and Mandalay.

2. **Price Calculation**

    I computed the average retail rice price per 1 kg using the multiplier *1.91*1.63 to convert the raw prices into consistent retail values.

3. **Trend Analysis**

    I analyzed year-on-year changes to understand which city had higher prices and how the gap evolved over time.

**Postgresql Querry**
```sql
SELECT 
    adm1_name,
    EXTRACT(YEAR FROM price_date) AS Year,
    ROUND(AVG(mfp.o_rice * 1.91 * 1.63), 2) AS Retail_Rice_Price_for_1Kg
FROM myanmar_food_prices mfp
WHERE adm1_name = 'Yangon' OR adm1_name = 'Mandalay'
GROUP BY adm1_name, EXTRACT(YEAR FROM price_date)
ORDER BY Year ASC;
```
This query calculates the average retail rice price per kg for Yangon and Mandalay for each year and orders the results chronologically.

**Visualization**
![Retail Rice Price over time in Yangon and Mandalay (2008 - 2025)](/Images/retail%20rice%20price%20over%20time%20in%20Yangon%20and%20Mandalay%20(2008%20-%202025).png)

**Key Finding**

- Mandalay consistently had higher rice prices than Yangon in most years, with the gap widening in recent years.

- Both cities experienced steady price growth, with a sharp increase from 2022 onward:

- Yangon: 2,685.04 MMK/kg (2022) → 6,754.91 MMK/kg (2025)

- Mandalay: 3,434.14 MMK/kg (2022) → 7,577.22 MMK/kg (2025)

The overall trend shows prices roughly tripling in Yangon and more than doubling in Mandalay from 2008 to 2025.

**Business Insight**

- Retailers and suppliers in Yangon and Mandalay need to account for significant price escalation when planning procurement and sales strategies.

- Mandalay’s higher prices indicate potential supply constraints or higher demand compared to Yangon.

- Both cities’ increasing trends suggest that long-term contracts or hedging strategies could help stabilize costs for businesses relying on rice as a key commodity.


## 3. What was the month-over-month growth of official rice prices in Yangon during 2025?

**Analysis Approach**

This query calculates the average rice retail price per kg in Yangon for each month of 2025.

1. A CTE (Yangon_Rice_Price) extracts month from the date and computes the monthly average price (avg(mfp.o_rice * 1.91 * 1.63)).

2. The main query uses the LAG() window function to compare each month’s price with the previous month, generating a Market_Growth (%) metric.

3. The result shows both the monthly rice price trend and month-over-month growth rate, highlighting volatility in Yangon’s rice market.

**Postgresql Querry**
```sql
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
```
**Visualization**
![What was the month-over-month growth of official rice prices in Yangon during 2025?](/Images/What%20was%20the%20month-over-month%20growth%20of%20official%20rice%20prices%20(o_rice)%20in%20Yangon%20during%202025.png)
**Key Finding**

- Rice price in Yangon 2025 starts around 6746 MMK/kg and fluctuates.

- Highest monthly growth: +10.40% (Month 8) – indicating a sharp spike.

- Largest decline: -3.72% (Month 7) – a noticeable dip before the rebound.

- Prices remain volatile with alternating periods of slight decline and sudden growth.

**Business Insight**

- The volatility indicates supply chain instability and seasonal influences on rice markets in Yangon.

- Sharp growth in August (Month 8) could reflect harvest shortages, import/export shifts, or inflation shocks.

- Retailers, wholesalers, and policymakers need to anticipate and mitigate risks by monitoring monthly fluctuations.

- A strategy of buffer stock management and price stabilization policies could help reduce consumer impact during sudden spikes.






