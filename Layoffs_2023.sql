
SELECT *
  FROM [Portfolio Project].[dbo].[layoffs_2023];
  
---- Finding Duplicates

  SELECT *,count(*)
  FROM [Portfolio Project].[dbo].[layoffs_2023]
  GROUP BY company,location, industry, total_laid_off,percentage_laid_off,date,stage, country,funds_raised
  HAVING Count(*)>1;

---- Delete Duplicates

WITH cte AS(
SELECT* ,ROW_NUMBER() OVER (PARTITION BY company,location, industry, total_laid_off,percentage_laid_off,date,stage, country,funds_raised ORDER BY company) AS Duplicate_count
FROM [Portfolio Project].[dbo].[layoffs_2023])
DELETE FROM cte
WHERE Duplicate_count>1;  

---- Delete rows with null values in total_laid_off and percentage_laid_off

DELETE FROM layoffs_2023 
WHERE total_laid_off = ' ' AND percentage_laid_off = ' ';

----- Change Datatype of total_laid_off column

ALTER TABLE [Portfolio Project].[dbo].[layoffs_2023] 
ALTER COLUMN [total_laid_off] FLOAT

----- Top 5 Companies with highest number of layoffs 

SELECT  TOP 5 company, SUM(total_laid_off ) AS maximum_layoff
FROM [Portfolio Project].[dbo].[layoffs_2023]
GROUP BY company
ORDER BY maximum_layoff DESC;

----Top 5 Countries which has maximum layoffs

SELECT TOP 5 SUM(total_laid_off ) AS layoffs_number, country
FROM [Portfolio Project].[dbo].[layoffs_2023]
GROUP BY country
ORDER BY layoffs_number DESC;

-----Percentage of Layoff per country over total number layoffs

WITH cte AS(
SELECT country, SUM( total_laid_off )AS sum_of_layoffs
FROM [Portfolio Project].[dbo].[layoffs_2023]
WHERE total_laid_off !=0
GROUP BY country)
SELECT country,ROUND(100.0*sum_of_layoffs/(SELECT SUM( total_laid_off) 
FROM  [Portfolio Project].[dbo].[layoffs_2023]),2) AS Percentage_of_layoffs
FROM cte
ORDER BY Percentage_of_layoffs DESC;

-----Which industries are highly risky? 

WITH cte AS(
SELECT DISTINCT INDUSTRY, COUNT(industry) OVER(PARTITION BY industry) AS Count
FROM [Portfolio Project].[dbo].[layoffs_2023]
),
cte_median AS (SELECT  INDUSTRY, Count,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY count desc) OVER() AS Median
FROM CTE)

SELECT Industry,Count,
CASE WHEN count> median THEN 'High_Layoffs'
     WHEN count< median THEN 'Low_Layoffs' END AS Status
FROM cte_median;

-----Company which had maximum layoffs in each country

WITH cte AS(
SELECT company, SUM(total_laid_off) AS layoffs_number,country, ROW_NUMBER()OVER(PARTITION BY country ORDER BY SUM(total_laid_off) DESC) AS rank
FROM [Portfolio Project].[dbo].[layoffs_2023]
GROUP BY company,country
)
SELECT company,layoffs_number, country
FROM cte
WHERE rank =1 AND layoffs_number !=0
ORDER BY layoffs_number DESC;

-----Update blank date

UPDATE [Portfolio Project].[dbo].[layoffs_2023]
SET  date = '2023-02-23' 
WHERE company = 'blackbaud';

-----Which month had maximum layoffs

SELECT SUM(CAST(total_laid_off AS FLOAT)) AS layoffs_number,DATEPART(Month,date) as month
FROM [Portfolio Project].[dbo].[layoffs_2023]
GROUP BY DATEPART(month,date)
ORDER BY layoffs_number DESC;

-----Number of layoffs yearwise
SELECT SUM(total_laid_off ) AS layoffs_number,DATEPART(YEAR,date) as year
FROM [Portfolio Project].[dbo].[layoffs_2023]
GROUP BY DATEPART(YEAR,date)
ORDER BY year;

-----Top 3 Locations where most layoffs happened year-wise

SELECT location, layoffs_number, year,rank
FROM (SELECT location, SUM(total_laid_off) AS layoffs_number, DATEPART(YEAR,date) as year, 
ROW_NUMBER() OVER(PARTITION BY DATEPART(YEAR,date)  ORDER BY  SUM(total_laid_off ) DESC ) AS rank
FROM [Portfolio Project].[dbo].[layoffs_2023]
GROUP BY location,DATEPART(YEAR,date)
) AS location
WHERE rank <=3
ORDER BY rank,year;

-----Top 10 Industries with maximum  layoffs

SELECT TOP 10 Industry, SUM(total_laid_off ) AS layoffs_number
FROM [Portfolio Project].[dbo].[layoffs_2023]
GROUP BY industry
ORDER BY layoffs_number DESC;

-----Companies which raised maximum fund and with Maximum Percentage of Layoffs

WITH cte_fund AS(
SELECT company,SUM(CAST(funds_raised AS FLOAT)) as Maximum_fund_raised
FROM [Portfolio Project].[dbo].[layoffs_2023]
GROUP BY company
HAVING SUM(CAST(funds_raised AS FLOAT)) !=0),
cte_percent AS(
SELECT company,max(CAST(percentage_laid_off AS FLOAT)) as maximum_percentage
FROM [Portfolio Project].[dbo].[layoffs_2023]
GROUP BY company)
SELECT cf.company, cf.Maximum_fund_raised, cp.maximum_percentage
FROM cte_fund AS cf
INNER JOIN cte_percent AS cp
ON cf.company = cp.company
ORDER BY Maximum_fund_raised DESC;

-----At what stage maximum number of employees are laid off 

SELECT stage, SUM(total_laid_off ) AS layoffs_number, count(*) AS Count
FROM [Portfolio Project].[dbo].[layoffs_2023]
WHERE stage!=' '
GROUP BY stage
ORDER BY Count DESC;

-----Layoffs in each city of USA

SELECT location,SUM(total_laid_off) AS layoffs_number
FROM [Portfolio Project].[dbo].[layoffs_2023]
WHERE country = 'United States'
GROUP BY location
ORDER BY layoffs_number DESC;

-----Companies in India that laid off employees

SELECT company,location,SUM(total_laid_off)) AS layoffs_number
FROM [Portfolio Project].[dbo].[layoffs_2023]
WHERE country = 'India' AND total_laid_off !=0
GROUP BY location,company
ORDER BY layoffs_number DESC;

-----Number of companies laid off in India locationwise

SELECT location,SUM(total_laid_off ) AS layoffs_number, count(*) AS Number_of_Companies
FROM [Portfolio Project].[dbo].[layoffs_2023]
WHERE country = 'India' AND total_laid_off !=0
GROUP BY location
ORDER BY Number_of_Companies DESC;

-----Number of companies laid off  in each countries

SELECT Country,SUM(total_laid_off ) AS layoffs_number, count(*) AS Number_of_Companies
FROM [Portfolio Project].[dbo].[layoffs_2023]
GROUP BY country
ORDER BY Number_of_Companies DESC;

-----Rolling/Moving Count of Lay offs in India

SELECT company,location,SUM( total_laid_off ) OVER(PARTITION BY location ORDER BY total_laid_off) AS Running_Total
FROM [Portfolio Project].[dbo].[layoffs_2023]
WHERE country = 'India' AND total_laid_off !=0
ORDER BY location;


