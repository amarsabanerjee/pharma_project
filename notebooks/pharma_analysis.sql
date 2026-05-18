CREATE DATABASE pharma;
USE pharma;
SHOW TABLES;
-- SALES ANALYSIS
-- 1. Total Revenue
select round(sum(revenue),2) as total_revenue from sales;
-- 2. Total Quantity Sold
select sum(qunatity_sold) as total_quantity from sales;
select * from sales;
-- 3. Top 10 Medicines by Revenue
select sum(revenue) as total_revenue, medicine_id 
from sales group by medicine_id 
ORDER BY total_revenue DESC 
limit 10 ;
-- 4. Monthly Revenue Trend
SELECT
month,
SUM(revenue) AS monthly_revenue
FROM sales
GROUP BY month
ORDER BY month;
-- 5. Average Revenue Per Medicine
SELECT
medicine_id,
AVG(revenue) AS avg_revenue
FROM sales
GROUP BY medicine_id
ORDER BY avg_revenue DESC;
-- WAREHOUSE ANALYSIS
-- 6. Warehouse Revenue Performance
SELECT
warehouse_id,
SUM(revenue) AS warehouse_revenue
FROM sales
GROUP BY warehouse_id
ORDER BY warehouse_revenue DESC;
-- 7. Warehouse Quantity Sold
SELECT
warehouse_id,
SUM(qunatity_sold) AS total_quantity
FROM sales
GROUP BY warehouse_id
ORDER BY total_quantity DESC;
-- 8. Highest Performing Warehouse
SELECT
warehouse_id,
SUM(revenue) AS revenue
FROM sales
GROUP BY warehouse_id
ORDER BY revenue DESC
LIMIT 1;

-- INVENTORY ANALYSIS
-- 9. Total Stock by Warehouse
SELECT
warehouse_id,
SUM(stock) AS total_stock
FROM inventory
GROUP BY warehouse_id
ORDER BY total_stock DESC;
-- 10. Medicines Near Expiry
SELECT
medicine_id,
warehouse_id,
days_to_expiry
FROM inventory
WHERE days_to_expiry < 60
ORDER BY days_to_expiry;
-- 11. Average Days to Expiry
SELECT
AVG(days_to_expiry) AS avg_expiry_days
FROM inventory;
-- SUPPLIER ANALYSIS
-- 12. Supplier Lead Time Ranking
SELECT
supplier_name,
AVG(lead_time) AS avg_lead_time
FROM suppliers
GROUP BY supplier_name
ORDER BY avg_lead_time DESC;
-- 13. Delayed Suppliers
SELECT
supplier_name,
delay_rate
FROM suppliers
ORDER BY delay_rate DESC;

-- Medicine Analysis
-- 14. Top Revenue Wise Medicine
SELECT
s.medicine_id,
m.medicine_name,
SUM(s.revenue) AS total_revenue
FROM sales s
JOIN medicines m
ON s.medicine_id = m.medicine_id
GROUP BY
s.medicine_id,
m.medicine_name
ORDER BY total_revenue DESC limit 10;
-- 15. Top Revenue Wise WareHouse
SELECT
w.warehouse_name,
SUM(s.revenue) AS total_revenue
FROM sales s
JOIN warehouses w
ON s.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_name
ORDER BY total_revenue DESC limit 10;

-- BUSINESS INSIGHT QUERIES
-- 16. Revenue Ranking Using Window Function
SELECT
medicine_id,
SUM(revenue) AS total_revenue,
RANK() OVER(
ORDER BY SUM(revenue) DESC
) AS revenue_rank
FROM sales
GROUP BY medicine_id;

-- 17. Running Revenue Total
SELECT month,
SUM(revenue) AS monthly_revenue,
SUM(SUM(revenue))
OVER(
ORDER BY month
) AS cumulative_revenue
FROM sales
GROUP BY month;

-- 18. Revenue Difference Month-by-Month
SELECT month,
SUM(revenue) AS monthly_revenue,
LAG(SUM(revenue))
OVER(
ORDER BY month
) AS previous_month_revenue
FROM sales
GROUP BY month;

-- 19. Top 3 Medicines Per Warehouse
SELECT *
FROM (
SELECT
warehouse_id,
medicine_id,
SUM(revenue) AS total_revenue,
RANK() OVER(
PARTITION BY warehouse_id
ORDER BY SUM(revenue) DESC
) AS rk
FROM sales
GROUP BY warehouse_id, medicine_id
) t
WHERE rk <= 3;
-- 20. Potential Stockout Risk
SELECT
medicine_id,
warehouse_id,
stock,
reorder_level
FROM inventory
WHERE stock < reorder_level;



