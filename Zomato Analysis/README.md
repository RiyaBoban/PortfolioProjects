


**Zomato Data Exploration and Analysis with SQL (SQL SERVER)**

Most of us know that Zomato is an Indian multinational restaurant aggregator and food delivery company.
The idea of analysing the Zomato_dataset is to get the overview of what actutally is happening in their business. 
Zomato Dataset consist of more than 9000 rows with columns such as Restaurants_id, Restaurants_name, City, Location, Cuisines and many more...

**Created New Table named Country**

      Created a new table which gives the country name based on the country_code in Zomato_dataset.

**While Exploring Data with SQL, I was working on the following things...**

1. Checked all the details of table such as column name, data types and constraints.
2. Checked for duplicate values in [RestaurantId] column.
3. Removed unwanted columns from table.
4. Identitfied and corrected the mis-spelled city names.
5. Merged 2 differnt tables and added the new column of Country_Name with the help of primary key as [CountryCode] column
6. Created new category column for rating.
7. Replaced values from 1 & 0 to yes & no in has_table_booking table.
8. Counted the no.of restaurants by rolling count/moving count.

**After Data Exploration with SQL, I started working on Analysing the Data with SQL where I found insights such as...**

1. According to the Zomato Dataset, 90.67% of data is related to restaurants listed in India followed by USA(4.45%).
2. Only India and UAE provide online delivery of which only 27% of Indian and 0.3% of UAE restaurants provides.
3. Learned most popular restaurants in each city. 
4. In Zomato dataset maximum restaurants are found in New Delhi, India.
5. Average Ratings for restaurants with table booking facility is 3.4/5 compared to restaurants without table booking facility is 2.7/5 in India.
6. 435 restaurants in Zomato has both table bookings and online delivery.
7. Figured out famous cuisines in each country.
8. Listed out renowned restaurants in each city that also falls in Excellent rate category.
9. The number of restaurants that fall in Excellent category are higher than other rating category in all countries except for India, Australia and Singapore. 
10. In India,as the average cost of two reduces to <500 the rating decreases and falls in poor category.




