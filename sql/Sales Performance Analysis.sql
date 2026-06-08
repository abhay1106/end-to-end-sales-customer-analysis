/*
Objective:- To analyze sales performance, customer behavior, and profitability trends to identify key drivers of 
revenue and opportunities for business growth.
*/

--Creating The Database:-
CREATE DATABASE superstore_analysis;

--Using The Database:-
USE superstore_analysis;

--Data Preparation:-
--Creating Customers Table:-
CREATE TABLE customers (
  customer_id VARCHAR(50) PRIMARY KEY,
  customer_name VARCHAR (50),
  segment VARCHAR(50),
  country VARCHAR(50),
  city VARCHAR(50),
  state VARCHAR(50),
  postal_code VARCHAR(20),
  region VARCHAR(50)
);

--Creating Products Table:-
CREATE TABLE products (
  product_id VARCHAR(50) PRIMARY KEY,
  category VARCHAR(200),
  sub_category VARCHAR(200),
  product_name VARCHAR(200)
);

--Creating Orders Table:-
CREATE TABLE orders (
  order_id VARCHAR(50),
  order_date DATE,
  ship_date DATE,
  ship_mode VARCHAR(50),
  sales FLOAT,
  quantity INT,
  discount FLOAT,
  profit FLOAT,
  customer_id VARCHAR(50),
  product_id VARCHAR(50)
);

--Adding Foreign Key To Orders Table To Create Link Between Tables:-
ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE orders
ADD CONSTRAINT fk_product
FOREIGN KEY (product_id) REFERENCES products(product_id);

--Creating Temporary Customers Table To Import Data With Duplicates And Nulls:-
CREATE TABLE customers_temp (
    customer_id VARCHAR(50),
    customer_name VARCHAR(50),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50)
);

--Inserting Data To Temporary Customers Table:-
BULK INSERT customers_temp
FROM 'D:\Downloads\Customer.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

--Inspecting The Data:-
SELECT COUNT(*) FROM customers_temp;
SELECT DISTINCT *
FROM customers_temp;
SELECT COUNT(DISTINCT customer_id)
FROM customers_temp;

--Inserting Data From temporary Customers Table To Main Customers Table:-
INSERT INTO customers
SELECT 
    customer_id,
    MAX(customer_name),
    MAX(segment),
    MAX(country),
    MAX(city),
    MAX(state),
    MAX(postal_code),
    MAX(region)
FROM customers_temp
WHERE customer_id IS NOT NULL
GROUP BY customer_id;

--Checking Dataset:-
SELECT * FROM customers;

--Creating Temporary Products Table To Import Data With Duplicates And Nulls:-
CREATE TABLE products_temp (
    product_id VARCHAR(50),
    category VARCHAR(200),
    sub_category VARCHAR(200),
	product_name VARCHAR(200)
);

--Inserting Data To Temporary Products Table:-
BULK INSERT products_temp
FROM 'D:\Downloads\Product.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

--Inspecting The Data:-
SELECT COUNT(*) FROM products_temp;
SELECT DISTINCT *
FROM products_temp;
SELECT COUNT(DISTINCT product_id) AS number_of_products
FROM products_temp;

--Inserting Data From temporary Products Table To Main Products Table:-
INSERT INTO products
SELECT 
    product_id,
    MAX(category),
    MAX(sub_category),
	MAX(product_name)
FROM products_temp
WHERE product_id IS NOT NULL
GROUP BY product_id;

--Checking The Dataset:-
SELECT * FROM products;

--Creating Temporary Orders Table To Import Data With Duplicates And Nulls:-
CREATE TABLE orders_temp (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    sales FLOAT,
    quantity INT,
    discount FLOAT,
    profit FLOAT,
    customer_id VARCHAR(50),
    product_id VARCHAR(50)
);

--Inserting Data To Temporary Orders Table:-
BULK INSERT orders_temp
FROM 'D:\Downloads\Orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

--Inspecting The Data:-
SELECT COUNT(*) AS number_of_transaction
FROM orders_temp;
SELECT DISTINCT *
FROM orders_temp;
SELECT COUNT(DISTINCT order_id) AS number_of_orders
FROM orders_temp;

--Checking Invalid Customers:-
SELECT *
FROM orders_temp
WHERE customer_id NOT IN (SELECT customer_id FROM customers);

--Checking Invalid Products:-
SELECT *
FROM orders_temp
WHERE product_id NOT IN (SELECT product_id FROM products);

--Inserting Data From temporary orders Table To Main Orders Table:-
INSERT INTO orders
SELECT *
FROM orders_temp
WHERE customer_id IN (SELECT customer_id FROM customers)
AND product_id IN (SELECT product_id FROM products);

--Checking The Dataset:-
SELECT * FROM orders;

--Data Cleaning:-
--Checking Inconsistency In Customers Name:-
SELECT *
FROM customers
WHERE customer_name LIKE '%  %'
   OR customer_name LIKE '%"%';

--Checking State-Wise Customer Base:-
SELECT DISTINCT state FROM customers;

--Checking City-Wise Customer Base:-
SELECT DISTINCT city FROM customers;

--Checking Null Values In Customers Table:-
SELECT *
FROM customers
WHERE 
    customer_id IS NULL
    OR customer_name IS NULL
    OR city IS NULL
    OR state IS NULL;

--Checking Inconsistency In Products Name:-
SELECT *
FROM products
WHERE product_name LIKE '%  %'
   OR product_name LIKE '%"%';

--Cleaning Inconsistencies From Product Names:-
UPDATE products
SET product_name = 
    CASE 
        WHEN LEFT(product_name, 1) = '"' 
             AND RIGHT(product_name, 1) = '"' 
        THEN SUBSTRING(product_name, 2, LEN(product_name) - 2)
        ELSE product_name
    END;

--Checking Product Categories:-
SELECT DISTINCT category FROM products;

--Checking Product Sub-Categories:-
SELECT DISTINCT sub_category FROM products;

--Finding Products Having Similar Products_id(Duplicates):-
SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

--Checking Nulls Values In Products Table:-
SELECT *
FROM products
WHERE 
    product_id IS NULL
    OR product_name IS NULL;

--Checking Null Values In Orders Table:-
SELECT *
FROM orders
WHERE 
    order_id IS NULL
    OR customer_id IS NULL
    OR product_id IS NULL;

--Checking Invalid Orders:-
SELECT *
FROM orders
WHERE 
    sales < 0
    OR quantity <= 0;

--Checking Invalid Dates:-
SELECT *
FROM orders
WHERE order_date > ship_date;

--Checking Orders 
SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

--Checking Invalid Customers Using JOINs:-
SELECT *
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

--Checking Invalid Products Using JOINs:-
SELECT *
FROM orders o
LEFT JOIN products p ON o.product_id = p.product_id
WHERE p.product_id IS NULL;

--Sales Performance Analysis:-
--High-Level Overview (KPIs):-
SELECT 
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    SUM(profit)/SUM(sales) AS profit_margin
FROM orders;
/*
Insight:- The business generated approximately 2.29M in total sales with a profit margin of 12.46% 
from 37.8K units sold, indicating moderate profitability. 

Recommendation:- This suggests an opportunity to improve margins by optimizing pricing strategies, 
reducing discounts, or focusing on higher-margin products.
*/

--Overall Business Overview:-
--Order And Customer Overview:-
--Total Orders:-
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;
/*
Insight:- The business has processed a total of 5009 orders from 793 customers showing consistent transaction
activity and reflecting good level of customer engagement and repeat purchase.

Recommendation:- This indicates strong customer retention and business can further improve revenue by loyalty 
programs and targeted marketing to increase repeat purchase.*/

--Total Customers:-
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM customers;
/*
Insight:- The business has relatively smaller customers base but generating decent amount of sales indicating higher 
order value and strong repeat purchasing behaviour.

Recommendation:-To further scale revenue, the business should focus on expanding its customer base through targeted 
marketing campaigns while maintaining customer retention strategies.
*/

--Time based Analysis:-
--Monthly Sales Trend:-
SELECT FORMAT(order_date, 'yyyy-MM') AS month,
       SUM(sales) AS monthly_sales
FROM orders
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY month;
/*
Insight:- The business sales is evenly distributed over the year but show drop during January and February and 
sudden spike in last quarter of the year indicating seasonal demand pattern.

Recommendation:- To maximize revenue, business should offer personalized combos and attractive discounts during
seasonal demand which also helps in onboarding new customers.
*/

--Customer Analysis:-
--Top Customers:-
SELECT TOP 10 c.customer_name,
       SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC;
/*
Insight:- The top 10 customers contributing a significant portion of sales and indicating a high dependency on
a small group of high value customers.

Recommendation:- To retain these valuable customers, the business should implement loyalty programs, personalized
offers, and targeted engagement strategies to ensure long-term retention and sustained revenue.
*/

--Customer Segmentation:-
SELECT 
    customer_id,
    SUM(sales) AS total_sales
FROM orders
GROUP BY customer_id;

SELECT 
    customer_id,
    SUM(sales) AS total_sales,
    CASE 
        WHEN SUM(sales) > 10000 THEN 'High Value'
        WHEN SUM(sales) BETWEEN 5000 AND 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM orders
GROUP BY customer_id;

SELECT 
    customer_segment,
    COUNT(*) AS total_customers,
    SUM(total_sales) AS total_revenue
FROM (
    SELECT 
        customer_id,
        SUM(sales) AS total_sales,
        CASE 
            WHEN SUM(sales) > 10000 THEN 'High Value'
            WHEN SUM(sales) BETWEEN 5000 AND 10000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM orders
    GROUP BY customer_id
) t
GROUP BY customer_segment;
/*
Insight:- Customer segmentation analysis reveals that the majority of customers fall under the low-value segment, 
and this segment contributes the largest share of total revenue. This indicates that the business is 
primarily driven by a high volume of low-value customers rather than a small group of high-value customers.

Recommendation:- The business should focus on converting low-value customers into medium and high-value segments 
through targeted upselling, cross-selling, and personalized marketing strategies. Additionally, efforts should be
made to grow the high-value customer segment by identifying and nurturing potential high-spending customer.
*/

--Repeat VS One-Time Customers:-
SELECT customer_id,
       CASE
	       WHEN COUNT(order_id) = 1 THEN 'One Time'
		   ELSE 'Repeat'
	   END AS customer_type
FROM orders
GROUP BY customer_id;

--Summary:-
SELECT customer_type,
       COUNT(*) AS total_customers
FROM (
       SELECT customer_id,
	          CASE
			      WHEN COUNT(order_id) = 1 THEN 'One-Time'
				  ELSE 'Repeat'
			  END AS customer_type
	   FROM orders
	   GROUP BY customer_id
	 ) t
GROUP BY customer_type;
/*
Insight:- The analysis shows that approximately 99% of customers are repeat buyers, indicating exceptionally strong 
customer retention and consistent engagement with the business.

Recommendation:- The business should continue to strengthen retention strategies through loyalty programs, 
personalized offers,  and enhanced customer experience. Additionally, there is an opportunity to invest in customer 
acquisition strategies to expand the customer base and drive further growth.
*/

--Repeat Revenue Analysis:-
SELECT customer_type,
       COUNT(DISTINCT customer_id) AS total_customers,
	   SUM(sales) AS total_revenue
FROM (
      SELECT o.*,
	         CASE
	             WHEN COUNT(o.order_id) OVER (PARTITION BY o.customer_id) = 1 THEN 'One-Time'
		         ELSE 'Repeat'
	         END AS customer_type
	  FROM orders o
	 ) t
GROUP BY customer_type;
/*
Insight:- The analysis shows that the majority of revenue is generated from repeat customers, indicating a strong 
dependency on existing customers for revenue generation and highlighting high customer retention.

Recommendation:- The business should continue to strengthen retention strategies through personalized engagement and
loyalty programs. Additionally, increasing focus on new customer acquisition can help diversify the revenue base and
reduce dependency on repeat customers, ensuring more sustainable growth.
*/

--Product Analysis:-
--Top Products:-
SELECT TOP 10 p.product_name,
       SUM(o.sales) AS total_sales
FROM orders o
JOIN products p
  ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC;
/*
Insight:- A significant portion of sales is driven by top 10 products indicating their high demand and strong
product performance.

Recommendation:- Business should ensure consistent availability of these high demand product by maintaining inventory
and similar products can be promoted or bundled to maximize revenue and reduce dependency on set of products.
*/

--Loss Making Products:-
SELECT TOP 10 p.product_name,
       SUM(o.profit) AS total_profit
FROM orders o
JOIN products p
  ON o.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(o.profit) < 0
ORDER BY total_profit ASC;
/*
Insight:- The analysis identifies a set of products that are generating negative profit, indicating that these 
products are contributing to overall losses and this can be due to inefficient pricing or excessive discounts.

Recommendation:- Business should review and optimize product cost and reduce excessive discounts to minimize
overall losses.
*/

--Category Analysis:-
--Category Profitability Analysis:-
SELECT p.category,
       SUM(o.sales) AS total_sales,
	   SUM(o.profit) AS total_profit,
	   SUM(o.profit)/SUM(o.sales) AS profit_margin
FROM orders o
JOIN products p
  ON o.product_id = p.product_id
GROUP BY p.category;
/*
Insight:- Sales are evenly distributed across all three product categories. However, profitability varies 
significantly, with Office Supplies and Technology generating strong profit margins of approximately 17%, while 
Furniture has a very low profit margin of around 2%.

Recommendation:- The business should focus on improving profitability in the Furniture category by optimizing costs, 
reviewing pricing strategies, and minimizing excessive discounts. Additionally, bundled offerings and targeted 
promotions can be used to boost sales and overall revenue in this category.
*/

--Category Contribution:-
SELECT p.category,
       SUM(o.sales) * 100.0 / SUM(SUM(o.sales)) OVER() AS contribution_pct
FROM orders o
JOIN products p
  ON o.product_id = p.product_id
GROUP BY p.category;
/*
Insight:- The sales contribution is relatively evenly distributed across all three product categories, with 
Technology contributing slightly higher (~36%), followed by Furniture (~32%) and Office Supplies (~31%). This 
indicates a well-balanced revenue distribution without heavy reliance on a single category.

Recommendation:- The business should continue to maintain this balanced portfolio by ensuring consistent performance 
across all categories. Additionally, it can focus on slightly scaling high-performing categories like Technology 
while also improving profitability in lower-margin categories such as Furniture to maximize overall returns.
*/


--Region Analysis:-
--Sales By Region:-
SELECT c.region, SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
GROUP BY c.region;
/*
Insight:- The sales is extremely concentrated in west region, contributing more than 90% of total sales, while 
other regions contribute minimally indicating significant regional imbalance in business performance.

Recommendation:- The business should investigate the reasons behind the strong performance in the West region and
replicate successful strategies in other regions. Additionally, targeted marketing campaigns, localized product
offerings, and region-specific pricing should be implemented to boost sales in underperforming regions.
*/

--Category VS Region Analysis:-
SELECT c.region, p.category,
       SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN products p
  ON o.product_id = p.product_id
GROUP BY c.region, p.category;
/*
Insight:- The analysis shows that in west region all three product categories are performing well where as other 
regions shows comparatively weaker performance across all categories indicating that west region is the primary driver
of sales regardless of product category.

Recommendation:- The business should investigate the key factors driving success in the West region, such as pricing 
strategies, product availability, and customer demand patterns, and replicate these strategies in underperforming 
regions.
*/

--Profit And Discount Analysis:-
--Profit Segmentation:-
--Profit Per Customer:-
SELECT customer_id,
       SUM(profit) AS total_profit
FROM orders
GROUP BY customer_id;

--Case Segmentation:-
SELECT customer_id,
       SUM(profit) AS total_profit,
	   CASE
	       WHEN SUM(profit) < 0 THEN 'Loss'
	       WHEN SUM(profit) > 2000 THEN 'High Profit'
		   WHEN SUM (profit) BETWEEN 500 AND 2000 THEN 'Medium Profit'
		   ELSE 'Low Profit'
	   END AS profit_segment
FROM orders
GROUP BY customer_id;

--Segment Summary:-
SELECT profit_segment,
       COUNT(*) AS total_customers,
	   SUM(total_profit) AS total_profit
FROM (
     SELECT customer_id,
	        SUM(profit) AS total_profit,
			CASE
			    WHEN SUM(profit) < 0 THEN 'Loss'
			    WHEN SUM(profit) > 2000 THEN 'High Profit'
				WHEN SUM(profit) BETWEEN 500 AND 2000 THEN 'Medium Profit'
				ELSE 'Low Profit'
			END AS profit_segment
	 FROM orders
	 GROUP BY customer_id
	) t
GROUP BY profit_segment;
/*
Insight:- Profit segmentation analysis reveals that while a portion of customers contributes positively to
profitability, a significant number of customers fall into the loss-making segment, indicating that certain 
transactions or customer behaviors are negatively impacting overall profit.

Recommendation:- The business should identify the drivers behind loss-making customers, such as high discounting or 
low-margin products, and take corrective actions including revising pricing strategies, limiting discounts, or 
optimizing cost structures.
*/

--Sales VS Profit:-
SELECT 
    SUM(sales) AS total_sales,
	SUM(profit) AS total_profit,
	SUM(sales) - SUM(profit) AS cost_estimation,
	SUM(profit)/SUM(sales) * 100.0 AS profit_pct
FROM orders;
/*
Insight:- The business generates approximately 2.29M in total sales with 12.46% profit margin indicating that a
significant portion of revenue is consumed by costs. 

Recommendation:- Business should closely analyse its cost components including pricing strategies, discounting
practices and operational expenses such as delivery facilities and logistics to identify optimization opportunities
and improve overall profit margin.
*/

--Discount VS Profit:-
SELECT discount,
       AVG(profit) AS avg_profit,
	   COUNT(*) AS total_orders
FROM orders
GROUP BY discount
ORDER BY discount;
/*
Insight:- This analysis clearly shows negative relationship between discount levels and profitability. As discount
increase beyond approximately 20%, the average profit declines significantly and often turns into negative, indicating
that higher discount directly impacts profitability.

Recommendation:- Business should re-evaluate its discounting strategies by setting optimal discount threshold
especially for low margin products. Discount should be applied selectively based on product category and customer
segment to balance sales growth with profitability.
*/

--Basket Analysis:-
--Average Product Per Order:-
SELECT order_id, COUNT(*) AS product_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT AVG(product_count) AS avg_products_per_order
FROM (
      SELECT order_id, COUNT(*) AS product_count
	  FROM orders
	  GROUP BY order_id
	 ) t;

SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN product_count = 1 THEN 1 ELSE 0 END) AS single_product_orders,
    SUM(CASE WHEN product_count > 1 THEN 1 ELSE 0 END) AS multi_product_orders
FROM (
    SELECT order_id, COUNT(*) AS product_count
    FROM orders
    GROUP BY order_id
) t;
/*
Insight:- The analysis shows a balanced distribution between single-product and multi-product orders, with nearly 
half of the orders containing more than one product. However, the overall average basket size remains low, indicating
that even multi-product orders typically include only a small number of items.

Recommendation:- The business should focus on increasing basket size by encouraging customers to add more items per 
order through bundling strategies, volume-based discounts, and personalized recommendations. This can help maximize 
revenue per transaction without relying solely on acquiring new customers.
*/

--Creating VIEW For The Dataset:-
CREATE VIEW sales_data AS
SELECT 
    o.*,
    c.customer_name,
    c.segment,
    c.region,
    p.category,
    p.sub_category,
    p.product_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;

--Checking VIEW:-
SELECT * FROM sales_data;

--Validating Our VIEW:-
--Checking Total Rows:-
SELECT COUNT(*) FROM sales_data;
--Comparing with Orders Table:-
SELECT COUNT(*) FROM orders;

-- Validating Total Sales:-
SELECT SUM(sales) FROM sales_data;
--Comparing With Orders Table:-
SELECT SUM(sales) FROM orders;

--Validating Through Dimensional Columns:-
SELECT DISTINCT category FROM sales_data;
SELECT DISTINCT region FROM sales_data;

/*
Final Summary:- The business demonstrates a balanced revenue distribution across product categories with strong
customer retention driving the majority of revenue. However, performance is heavily concentrated in the West region,
and profitability is impacted by high costs and excessive discounting.
Key opportunities include improving profitability in low-margin categories, optimizing discount strategies,
expanding into underperforming regions, and increasing basket size through cross-selling.
*/
