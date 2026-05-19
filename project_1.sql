--1. Database Setup AND Table Creation:
DROP TABLE IF EXISTS retail_sales

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

--2. Data Exploration & Cleaning:


--Record Count: Determine the total number of records in the dataset.--
select * FROM retail_sales  

--Customer Count: Find out how many unique customers are in the dataset.--

SELECT COUNT(DISTINCT CUSTOMER_ID) FROM retail_sales

--Category Count: Identify all unique product categories in the dataset.--

SELECT DISTINCT category FROM retail_sales;

--Null Value Check: Check for any null values in the dataset and delete records with missing data.--
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

--3. Data Analysis & Findings:

--The following SQL queries were developed to answer specific business questions:

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:--

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022:

SELECT * FROM retail_sales
WHERE category = 'Clothing' AND quantity>=4 AND  
YEAR(sale_date)=2022 AND MONTH(sale_date)=11

--Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT ROUND(AVG(age),2) as Avg_age FROM retail_sales
WHERE category='Beauty'; 

--Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales
where total_sale >1000;

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT category,gender, 
COUNT(*) from retail_sales

GROUP BY 1,2
ORDER BY 1

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT 
   year1,
   month1,
   avg_sale
FROM
(
SELECT 
    YEAR(sale_date) as year1,
    MONTH(sale_date) as month1,
    AVG(total_sale) as avg_sale,
    rank() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rank1
FROM retail_sales
GROUP BY 1,2
)as t1
where rank1 = 1

--Write a SQL query to find the top 5 customers based on the highest total sales:

SELECT 
customer_id,
SUM(total_sale) as total_sales
FROM retail_sales

GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

--Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT category, count(DISTINCT (customer_id)) as cnt_unique_cstm  from retail_sales
GROUP BY category

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN HOUR( sale_time) < 12 THEN 'Morning'
        WHEN HOUR( sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
