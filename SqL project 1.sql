create database Sales_retail_db_P1;

use Sales_retail_db_P1;

create table retail (
transactions_id	varchar(5) primary Key,
sale_date date,
sale_time time,
customer_id	varchar(5),
gender varchar(8),
age int,
category varchar(15),
quantiy int,	
price_per_unit float,
cog float,
total_sale float);

drop table Retail;


select * from retail;

----Objectives
----Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
----Data Cleaning: Identify and remove any records with missing or null values.
----Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
----Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.


----2. Data Cleaning

select * from retail
where gender is null
	  or
	  category is null
	  or
	  quantiy is null
	  or
	  price_per_unit is null
	  or
	  cogs is null
	  or
	  total_sale is null;

Delete from retail
where gender is null
	  or
	  category is null
	  or
	  quantiy is null
	  or
	  price_per_unit is null
	  or
	  cogs is null
	  or
	  total_sale is null;

select count (*) from retail;


----Data Exploration 

---Q) How many sales we have?

select count(transactions_id) as No_of_sales from retail;

---Q) How many customers we have?

Select * from retail;

select count(distinct(customer_id)) as Total_customer from retail;

---Q) How many categories we have?

select count(distinct(category)) as Total_customer from retail;

---3. Data Analysis & Findings
---The following SQL queries were developed to answer specific business questions:

------Write a SQL query to retrieve all columns for sales made on '2022-11-05':

select * from retail
where sale_date = '2022-11-05';  

------Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity 
------sold is more than 2 in the month of Nov-2022:


SELECT transactions_id, quantiy, sale_date
FROM retail
WHERE category = 'Clothing'
  AND quantiy > 2
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';

---q3) Write a SQL query to calculate the total sales (total_sale) for each category.:

Select category, sum(total_sale) as total_sale from Retail
group by category;

----Q4)Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail
WHERE category = 'Beauty'

----Q5)Write a SQL query to find all transactions where the total_sale is greater than 1000.:

Select * from retail 
where total_sale>1000;

----Q6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select count(*) as transactions, gender, category from retail
group by category, gender;

---Q7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

Select month, year, avg_sales
from (select month(sale_date) as month,
             year(sale_date) as year,
			 avg(total_sale) as avg_sales,
			 RANK()over(partition by year(sale_date) order by avg(total_sale) desc) as rank
from retail group by year(sale_date),month(sale_date)) as t1
where rank=1

     

---Q8) Write a SQL query to find the top 5 customers based on the highest total sales

SELECT top 5 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail
GROUP BY customer_id
ORDER BY total_sales DESC

----Q9) Write a SQL query to find the number of unique customers who purchased items from each category.:

select count(distinct(customer_id)) as Customers, category 
from Retail 
group by category;

----Q10) Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hourly_sale as
(
    select *,
          case
	        when DATEPART(HOUR, sale_time) < 12 then 'Morning'
		    when DATEPART(HOUR, sale_time) between 12 and 17 then 'Afternoon'
		    else 'evening'
	      End as shifts 
from retail
)
select shifts, count(transactions_id) as total_orders
from hourly_sale
group by shifts 
order by total_orders desc;


