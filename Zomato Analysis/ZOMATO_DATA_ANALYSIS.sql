SELECT *
FROM [Portfolio Project].[dbo].[Zomato_Datasets]

-----Rolling/Moving count of Restaurants in different cities of a country

SELECT city,Country_name, SUM(COUNT(Restaurantname)) OVER(PARTITION BY country_name ORDER BY COUNT(Restaurantname))AS Restaurant_Count 
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
GROUP BY Country_name,city

----Percentage of Restaurants in each country

SELECT DISTINCT Country_name, 
ROUND(100.0*COUNT(RestaurantID) OVER(PARTITION BY Country_name ORDER BY Country_name)/(SELECT COUNT(RestaurantID) FROM [Portfolio Project].[dbo].[Zomato_Datasets]),2) AS Percentage
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
GROUP BY Country_name, RestaurantID
ORDER BY Percentage DESC


----Which countries have online delivery by percentage of restaurant

WITH cte AS(
SELECT country_name,COUNT(has_online_delivery) AS No_of_Restaurants
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
WHERE has_online_delivery ='Yes'
GROUP BY country_name)
SELECT country_name, No_of_Restaurants, ROUND(100.0* No_of_Restaurants/(SELECT COUNT(*) FROM [Portfolio Project].[dbo].[Zomato_Datasets]),2) AS Percentage
FROM cte

----Finding which restaurant is most popular in each city

WITH cte AS(
SELECT Restaurantname,city,country_name,rating,ROW_NUMBER() OVER (PARTITION BY City ORDER BY rating DESC) AS Rank
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
GROUP BY city,country_name, Restaurantname,rating)
SELECT Restaurantname,city,country_name,rating
FROM cte 
WHERE rank = 1
ORDER BY rating DESC

-----FINDING FROM WHICH CITY  IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO

WITH cte AS(
SELECT DISTINCT city,COUNT(restaurantname) AS Restaurant_Count
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
WHERE country_name = 'India'
GROUP BY city)
SELECT city, Restaurant_Count
FROM cte
WHERE Restaurant_Count = (SELECT MAX(Restaurant_Count) FROM cte)

----- How table Booking affects rating in India

SELECT 'With_Table' Table_Booking_Option,COUNT(Has_Table_booking) AS Restaurant_Count, ROUND(AVG(Rating),2) AVG_RATING
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
WHERE Has_Table_booking = 'YES'
AND COUNTRY_NAME= 'India'
UNION ALL
SELECT 'Without_Table' Table_Booking_Option,COUNT(Has_Table_booking) AS Restaurant_Count, ROUND(AVG(Rating),2) AVG_RATING
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
WHERE Has_Table_booking = 'NO'
AND COUNTRY_NAME= 'India'

-----Which all restaurants have both table booking and online delivery

SELECT Restaurantname,city
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
WHERE Has_Table_booking ='yes' AND Has_Online_delivery ='Yes'

----Which cuisine is famous in each country

WITH cte AS(
SELECT Country_Name, Value AS Cuisine
FROM [Portfolio Project].[dbo].[Zomato_Datasets] Z
OUTER APPLY STRING_SPLIT (Z.Cuisines,'|')),
cte_Rank AS(
SELECT Country_name,Cuisine, COUNT(Cuisine) AS Count, DENSE_RANK()OVER(PARTITION BY Country_Name ORDER BY COUNT(Cuisine) DESC) AS Rank
FROM cte
GROUP BY COUNTRY_NAME,Cuisine)
SELECT Country_name, STRING_AGG(Cuisine,',') WITHIN GROUP (ORDER BY Country_name) AS Famous_Cuisines
FROM cte_Rank
WHERE Rank =1
GROUP BY Country_Name


----Expensive Restaurants in Each City that also falls in Excellent rate category

WITH cte AS(
SELECT country_name, RestaurantName, city,Average_Cost_for_Two, DENSE_RANK() OVER(PARTITION BY City Order by Average_Cost_for_Two DESC) AS Rank
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
WHERE Rate_Category ='Excellent' ),
cte_rank AS(
SELECT RestaurantName, city,Average_Cost_for_Two,country_name
FROM cte
WHERE Rank =1
)
 SELECT STRING_AGG(RestaurantName,', ') WITHIN GROUP (ORDER BY city) AS Restaurant_Name, city,country_name,Average_Cost_for_Two
 FROM cte_rank
 GROUP BY city,Average_Cost_for_Two,country_name
 ORDER BY Average_Cost_for_Two DESC

 ----In each country find the number of restaurants that falls in each rate category

 WITH cte AS(
 SELECT DISTINCT Country_Name, 
 CASE WHEN rate_category = 'Excellent' THEN COUNT(rate_category) END AS Excellent,
 CASE WHEN rate_category = 'Good' THEN COUNT(rate_category) END AS Good,
 CASE WHEN rate_category = 'Average' THEN COUNT(rate_category) ELSE 0 END AS Avg,
 CASE WHEN rate_category = 'Poor' THEN COUNT(rate_category) ELSE 0 END AS Poor
 FROM [Portfolio Project].[dbo].[Zomato_Datasets]
 GROUP BY COUNTRY_NAME,rate_category)
 SELECT Country_Name,SUM(Excellent) AS Excellent_Restaurants, SUM(Good)AS Good_Restaurants,SUM(Avg)AS Average_Restaurants,SUM(Poor)AS Poor_Restaurants
 FROM cte
 GROUP BY COUNTRY_NAME
 ORDER BY Excellent_Restaurants DESC


 ----Does Average Cost for two affects rating in India

WITH cte AS(
SELECT  Average_Cost_for_two, COUNTRY_NAME, CASE WHEN rate_category = 'Excellent' THEN COUNT(rate_category) END AS Excellent,
 CASE WHEN rate_category = 'Good' THEN COUNT(rate_category) END AS Good,
 CASE WHEN rate_category = 'Average' THEN COUNT(rate_category) END AS Avg,
 CASE WHEN rate_category = 'Poor' THEN COUNT(rate_category)  ELSE 0 END AS Poor
 FROM [Portfolio Project].[dbo].[Zomato_Datasets]
 WHERE COUNTRY_NAME = 'India'
GROUP BY rate_category,Average_Cost_for_two, COUNTRY_NAME)
 SELECT '>=4000' AS Avg_Cost_For_Two,SUM(Excellent) AS Excellent_Rest_Count,SUM(Good) AS Good_Rest_Count, SUM(Avg) AS Avg_Rest_Count,SUM(Poor) AS Poor_Rest_Count
 FROM cte
 WHERE Average_Cost_for_two >= 4000 

 UNION ALL
SELECT '>=2000 & <4000' , SUM(Excellent) AS Excellent_Rest_Count,SUM(Good) AS Good_Rest_Count, SUM(Avg) AS Avg_Rest_Count,SUM(Poor) AS Poor_Rest_Count 
FROM cte
WHERE Average_Cost_for_two>=2000 AND Average_Cost_for_two <4000 

   UNION ALL
SELECT '>=500 & <2000', SUM(Excellent) AS Excellent_Rest_Count,SUM(Good) AS Good_Rest_Count, SUM(Avg) AS Avg_Rest_Count,SUM(Poor) AS Poor_Rest_Count 
FROM cte
WHERE Average_Cost_for_two>=500 AND Average_Cost_for_two <2000
   UNION ALL
SELECT '<500' , SUM(Excellent) AS Excellent_Rest_Count,SUM(Good) AS Good_Rest_Count, SUM(Avg) AS Avg_Rest_Count,SUM(Poor) AS Poor_Rest_Count 
FROM cte
WHERE Average_Cost_for_two<500 