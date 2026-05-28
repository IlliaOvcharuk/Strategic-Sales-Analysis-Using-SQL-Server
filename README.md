# Strategic-Sales-Analysis-Using-SQL-Server
End-to-end data analysis from cleaning to advanced time-series insights using CTEs, Window Functions (LEAD/LAG), and Aggregations.

# Walmart Retail Sales Analysis (Advanced SQL)

## Project Overview
This project performs an end-to-end data analysis of Walmart's retail sales using **Microsoft SQL Server**. The goal was to extract actionable business insights from messy raw data, focusing on holiday impacts, store efficiency, and year-over-year growth trends.

---

## Key Features & SQL Techniques
- **Data Cleaning:** Built automated views to handle missing values (ISNULL) and used `ROW_NUMBER()` for deduplication.
- **Advanced Analytics:** Implemented Complex Window Functions:
  - `LEAD()` to analyze consumer behavior in pre-holiday weeks.
  - `LAG()` to calculate Year-over-Year (YoY) sales growth.
  - `RANK()` to identify top-performing stores.
- **Business Logic:** Applied conditional aggregations (`CASE WHEN`) to segment stores by fuel price impact and holiday sensitivity.
- **Efficiency Metrics:** Developed a custom "Efficiency Index" to measure sales performance relative to store size.

---

## Key Business Insights Discovered
Based on the SQL queries executed, the following trends were identified:
* **Market Share:** Store Type A dominates the business, generating over 50% of total revenue. 
* **Sales Efficiency:** While Type A brings the most revenue, Type B often shows a higher *Efficiency Index* (Sales per Square Foot), making it cheaper to scale.
* **External Factors:** Fuel price fluctuations (above/below \$3.5) showed minimal correlation with overall weekly sales, indicating high customer loyalty and inelastic demand.
* **Holiday Sensitivity:** Certain departments experience a massive sales lift (up to 2-3x) strictly during holiday weeks, while others remain completely flat.
* **The "Pre-Holiday" Effect:** Using `LEAD()`, the analysis proved that sales start spiking **one week BEFORE** the actual holiday, allowing supply chain managers to optimize stock levels in advance.

---

## Analysis Workflow
1. **Cleaning & Pre-processing:** Deduplicating the `features` table and normalizing `markdown` data.
2. **Market Share Analysis:** Determining the sales contribution of different store types (A, B, C).
3. **External Factor Impact:** Analyzing how fuel prices and unemployment rates correlate with weekly sales.
4. **Time-Series Analysis:** Comparing current performance against historical data to track growth.

---

## Database Schema Reference
The analysis joins three main relational tables:
* `sales`: Contains weekly sales data per store and department.
* `stores`: Metadata about store types and sizes.
* `features`: External economic indicators (CPI, Unemployment, Fuel Price).

---

## How to Run
1. Ensure you have the Walmart dataset imported into your SQL Server instance.
2. Run the `walmart_retail_analysis.sql` script.
3. The script will automatically create the necessary views and output the analytical reports.

## Author
**Illia**  
*Aspiring Data Analyst / BI Developer*
