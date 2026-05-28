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

## 🔍 Analysis Tasks & Results

### Task 1 — Market Share by Store Type
*Analyzing each store type's contribution to total revenue.*

<img width="644" height="136" alt="image" src="https://github.com/user-attachments/assets/a2adb60f-10a7-41fa-aadc-fd21ce2c0b77" />

> **Insight:** Type A stores dominate with nearly 3/4 of all revenue, but that alone doesn't mean they're the most efficient.

---

### Task 2 — Sales Efficiency Index (Sales per Sq. Ft.)
*Measuring actual performance relative to store size.*

<img width="824" height="141" alt="image" src="https://github.com/user-attachments/assets/6e0dfc7c-40f7-4c1c-b918-aefb04232b10" />


> **Insight:** While Type A generates the most revenue in absolute numbers, its efficiency per square foot is only marginally better than Type B — making Type B potentially more cost-effective to scale.

---

### Task 3 — External Factors: Fuel Price Impact
*Grouping weeks by fuel price threshold to test sensitivity of consumer behavior.*

<img width="655" height="104" alt="image" src="https://github.com/user-attachments/assets/8f1ffe07-82e1-4fd8-98ce-4c2d3de7a770" />


> **Insight:** Sales difference is negligible (~$195). Fuel price has minimal correlation with weekly sales, indicating strong customer loyalty and inelastic demand at Walmart.

---

### Task 4 — Holiday-Sensitive Departments (Top 10)
*Finding departments with the highest sales lift during holiday weeks.*

<img width="742" height="365" alt="image" src="https://github.com/user-attachments/assets/4ef79d00-6a50-48af-acd5-9254b147c0e8" />


> **Insight:** Department 72 (and others in Top 10) shows high holiday sensitivity. These specific departments should be prioritized for seasonal stock planning and marketing campaigns.

---

### Task 5 — Pre-Holiday Consumer Behavior (LEAD Window Function)
*Using `LEAD()` to look ahead and classify weeks before a holiday.*

<img width="613" height="138" alt="image" src="https://github.com/user-attachments/assets/ef0d128b-9cca-4816-98aa-66ad6d6f4fc5" />


> **Insight:** Sales begin spiking **one week BEFORE** the actual holiday. This validates the need for supply chain managers to pre-position stock at least 7 days in advance.
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

