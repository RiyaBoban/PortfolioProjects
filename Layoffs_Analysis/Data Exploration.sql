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

---- Find data type of columns

SELECT 
COLUMN_NAME, 
DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'ZomatoData1'

----- Change Datatype of total_laid_off column

ALTER TABLE [Portfolio Project].[dbo].[layoffs_2023] 
ALTER COLUMN [total_laid_off] FLOAT


-----Update blank date

UPDATE [Portfolio Project].[dbo].[layoffs_2023]
SET  date = '2023-02-23' 
WHERE company = 'blackbaud'

-----Rolling/Moving Count of Lay offs in India

SELECT company,location,SUM( total_laid_off ) OVER(PARTITION BY location ORDER BY total_laid_off) AS Running_Total
FROM [Portfolio Project].[dbo].[layoffs_2023]
WHERE country = 'India' AND total_laid_off !=0
ORDER BY location;