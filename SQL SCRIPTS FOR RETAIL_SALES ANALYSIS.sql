Create database Sql_Projects;
use sql_projects;

create table retail_sales (
transactions_id	 INT 	,
sale_date DATE ,
sale_time time, 
customer_id INT , 
gender VARCHAR(20),
age	INT ,
category varchar(25)	,
quantiy	INT,
price_per_unit	FLOAT,
cogs FLOAT	,
total_sale FLOAT
);

SELECT * FROM RETAIL_SALES;

-- Data cleaning --
select count(*) from retail_sales;

alter table retail_sales 
rename column transactions_id to transaction_id;

select * 
from retail_sales 
where transaction_id is null 
	or sale_date is null 
    or sale_time is null 
    or customer_id is null 
    or gender is null 
    or age is null 
    or category is  null 
    or quantity is null 
    or price_per_unit is null 
    or cogs is null
    or total_sale is null;
-- Data Exploration-->

-- How many sales we have?
select count(*) as total_sales
from retail_sales;   

-- How many customers we have ?
select count(distinct customer_id)  as customers 
from retail_sales; 

-- How many unique category we have?
select count(distinct category ) as category_count
from retail_sales;
select distinct category  as category_count
from retail_sales;

-- Data Analysis & Business key Problems and answers
-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * 
from retail_sales 
where sale_date ="2022-11-05";

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and
--      the quantity sold is more than and equal to 4 in the month of Nov-2022
select * 
from retail_sales 
where category ="Clothing" 
	  and quantity >=4
      and month(sale_date) =11 
      and year(sale_date)=2022;
      
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category , sum(total_sale) as total_sales  , COUNT(*) as total_orders
from retail_sales 
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category , 
round(avg(age),0) as average_age_of_customer
from retail_sales
where category="Beauty" 
group by category ;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * 
from retail_sales
where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category , gender  , count(transaction_id) as count_of_tid
from retail_sales 
group by    category , gender
order by category , gender;

select * from retail_sales;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

with cte as (select year_sale , month_sale , avg_sale ,
dense_rank() over(partition by year_sale order by avg_sale desc) as ranking 
from (
select  year(sale_date) as year_sale, 
		month(sale_date) as month_sale,
		avg(total_sale) as avg_sale
from retail_sales
group by year(sale_date), month(sale_date)
order by avg_sale desc) as a ) 
select year_sale, month_sale , avg_Sale 
from cte 
where ranking=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

with customer_total_sale as (select customer_id ,
							 sum(total_sale) as total_sale
							 from retail_sales
							 group by customer_id),
ranking as (select  customer_id ,
					total_sale, 
                    dense_rank() over(order by total_sale desc) as ranking
			from customer_total_sale )
select customer_id , total_sale
from ranking 
where ranking<=5;
                             
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category , count(distinct customer_id) as customer_count
from retail_sales 
group by category
order by customer_count desc;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
select * from retail_sales;

with table_shifts as (select * , case when sale_time <"12:00:00" then "Morning" 
			when sale_time between "12:00:00" and "17:00:00" then "Afternoon"
            else "Evening" 
            end as shifts
		from retail_sales) 
select shifts , count(*) as number_of_orders 
from table_shifts
group by shifts ;















