# Sales Data — Excel to SQL Database

## Objective
Convert the raw order-line data in `Sales_Data.xlsx` (sheet: "Sales Data") into a proper SQL database table — with explicit column data types, a primary key, and validated data integrity — so it can be queried directly instead of through Excel formulas.

## Tool
SQL (MySQL/MariaDB-compatible; portable to PostgreSQL/SQLite with a quoting swap)

## Source
- File: `Sales_Data.xlsx`, sheet **Sales Data**
- 3,000 order-line rows, 20 columns
- Each row = one product within one order (an order can span multiple rows)

## Schema

Table: `sales_data` — Primary key: `Row_ID`

| Column | Data Type | Description |
|---|---|---|
| Row_ID | INT | Unique row identifier (Primary Key) |
| Order_ID | VARCHAR(20) | Order reference number |
| Order_Date | DATE | Date the order was placed |
| Ship_Date | DATE | Date the order shipped |
| Ship_Mode | VARCHAR(30) | Shipping method |
| Customer_ID | VARCHAR(20) | Unique customer identifier |
| Customer_Name | VARCHAR(100) | Customer full name |
| Segment | VARCHAR(30) | Customer segment |
| Country | VARCHAR(50) | Country |
| City | VARCHAR(50) | City |
| State | VARCHAR(50) | State |
| Region | VARCHAR(20) | Sales region |
| Product_ID | VARCHAR(20) | Unique product identifier |
| Category | VARCHAR(30) | Product category |
| Sub_Category | VARCHAR(30) | Product sub-category |
| Product_Name | VARCHAR(100) | Product name |
| Sales | DECIMAL(12,2) | Sale amount (USD) |
| Quantity | INT | Units sold in this order line |
| Discount | DECIMAL(5,2) | Discount applied |
| Profit | DECIMAL(12,2) | Profit amount (USD) |

## Table Creation
```sql
CREATE TABLE `sales_data` (
    `Row_ID` INT,
    `Order_ID` VARCHAR(20),
    `Order_Date` DATE,
    `Ship_Date` DATE,
    `Ship_Mode` VARCHAR(30),
    `Customer_ID` VARCHAR(20),
    `Customer_Name` VARCHAR(100),
    ... (remaining columns — see Schema above)
    `Profit` DECIMAL(12,2),
    PRIMARY KEY (`Row_ID`)
);
```
Data loaded via batched `INSERT` statements (200 rows per statement) covering all 3,000 rows.

## Validation
The script was executed end-to-end against a fresh database (not just checked by eye):
- Row count after load: **3,000** — matches the source sheet exactly.
- Sample rows spot-checked against the original Excel data — match exactly.
- Two independent queries (Top 10 products by Sales, Top customers by distinct order count) re-run against the new table returned **identical results** to the earlier Excel/pandas analysis, confirming the conversion preserved data integrity.

## Sample Queries

**Top 10 products by total sales:**
```sql
SELECT Product_Name, SUM(Sales) AS total_sales
FROM sales_data
GROUP BY Product_Name
ORDER BY total_sales DESC
LIMIT 10;
```

**Top customers by distinct order count** (avoids duplicate order-line overcounting):
```sql
SELECT Customer_ID, Customer_Name,
       COUNT(DISTINCT Order_ID) AS order_count,
       COUNT(*) AS line_items,
       SUM(Sales) AS total_sales
FROM sales_data
GROUP BY Customer_ID, Customer_Name
ORDER BY order_count DESC;
```

## Deliverables
- `create table_&_group_by.sql` — create table + data script
- `superstore_inserted_value.sql` — ready-to-use SQLite database, pre-loaded with all 3,000 rows

## Notes / Lessons Learned
- An inline SQL comment placed before a trailing comma comments out the comma too, silently breaking the statement — comments belong on their own line, never at the end of a column definition.
- Column names with spaces or hyphens (e.g. "Sub-Category") were normalized to underscore_case (`Sub_Category`) since unquoted identifiers can't contain spaces or hyphens across most SQL engines.
- Backtick-quoted identifiers work directly in MySQL/MariaDB; PostgreSQL, SQLite, and SQL Server expect double quotes or square brackets instead.

