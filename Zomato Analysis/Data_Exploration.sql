----Find Datatype

SELECT 
COLUMN_NAME, 
DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'Zomato_Datasets'

-----Find Duplicates

SELECT *, COUNT(*)
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
GROUP BY column1,RestaurantName,CountryCode,City,Address,Locality,LocalityVerbose,Cuisines,Currency,Has_Table_booking,Has_Online_delivery,Is_delivering_now,Switch_to_order_menu,Votes,Average_Cost_for_two,Rating
HAVING COUNT(*)>1

-----Delete unwanted Columns

ALTER TABLE [Portfolio Project].[dbo].[Zomato_Datasets]
DROP COLUMN Address Locality, LocalityVerbose

----- Replace symbols in words with letter

SELECT City
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
WHERE city LIKE '%?%'
UPDATE [Portfolio Project].[dbo].[Zomato_Datasets]
SET City = REPLACE(CITY,'?','i')

SELECT RestaurantName
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
WHERE RestaurantName LIKE '%?%'
UPDATE [Portfolio Project].[dbo].[Zomato_Datasets]
SET RestaurantName = REPLACE(RestaurantName,'?','e')

---- Add Country column From country table as new column 

SELECT A.CountryCode,B.Country
FROM [Portfolio Project].[dbo].[Zomato_Datasets] A 
JOIN Country B
ON A.CountryCode = B.countrycode

ALTER TABLE [Portfolio Project].[dbo].[Zomato_Datasets] 
ADD COUNTRY_NAME VARCHAR(50)

UPDATE [Portfolio Project].[dbo].[Zomato_Datasets]
SET COUNTRY_NAME = B.COUNTRY								
FROM [Portfolio Project].[dbo].[Zomato_Datasets] A 
JOIN Country B
ON A.CountryCode = B.COUNTRYCODE

----Rows with NULL values in Cuisines column

SELECT *
FROM [Portfolio Project].[dbo].[Zomato_Datasets]
WHERE Cuisines IS NULL

---- YES/NO Columns

SELECT DISTINCT Has_Online_delivery   FROM [Portfolio Project].[dbo].[Zomato_Datasets]
SELECT DISTINCT Is_delivering_now   FROM [Portfolio Project].[dbo].[Zomato_Datasets]
SELECT DISTINCT Switch_to_order_menu  FROM [Portfolio Project].[dbo].[Zomato_Datasets]
SELECT DISTINCT Has_Table_booking  FROM [Portfolio Project].[dbo].[Zomato_Datasets]

----Delete Switch_to_Order_Menu column as it has 'no' value in all rows

ALTER TABLE [Portfolio Project].[dbo].[Zomato_Datasets] DROP COLUMN switch_to_order_menu

---- Replace 1&0 in has_table_booking to yes/no 

ALTER TABLE [Portfolio Project].[dbo].[Zomato_Datasets] 
ALTER COLUMN Has_Table_booking VARCHAR(20)

UPDATE [Portfolio Project].[dbo].[Zomato_Datasets]
SET Has_Table_booking = REPLACE (Has_Table_booking,'1','Yes')
UPDATE [Portfolio Project].[dbo].[Zomato_Datasets]
SET Has_Table_booking = REPLACE(Has_Table_booking,'0','No')

----Add new Column Rate Category based on the Rating

ALTER TABLE [Portfolio Project].[dbo].[Zomato_Datasets] 
ADD  Rate_Category VARCHAR(20)

UPDATE [Portfolio Project].[dbo].[Zomato_Datasets] 
SET Rate_Category =
(CASE WHEN rating >=4.0 THEN 'Excellent'
      WHEN rating >= 3.5 AND rating < 4.0 THEN 'Good'
	  WHEN rating >= 2.5 AND rating < 3.5 THEN 'Average'
	  WHEN rating < 2.5 THEN 'Poor' END)

