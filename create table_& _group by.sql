CREATE TABLE sales_data (   
Row_ID INT,  
Order_ID VARCHAR(20),  
Order_Date DATE,  
Ship_Date DATE,   
Ship_Mode VARCHAR(30),  
Customer_ID VARCHAR(20), 
Customer_Name VARCHAR(100),  
Segment VARCHAR(30), 
Country VARCHAR(50),   
City VARCHAR(50),    
State VARCHAR(50),   
Region VARCHAR(20), 
Product_ID VARCHAR(20),  
Category VARCHAR(30),  
Sub_Category VARCHAR(30), 
Product_Name VARCHAR(100),  
Sales DECIMAL(12,2),  
Quantity INT,   
Discount DECIMAL(5,2),   
Profit DECIMAL(12,2),   
PRIMARY KEY (Row_ID));

SELECT Customer_ID, Customer_Name, COUNT(DISTINCT Order_ID) AS order_count, COUNT(*) AS line_items, SUM(Sales) AS total_sales
FROM sales_data
GROUP BY Customer_ID, Customer_Name
ORDER BY order_count DESC;