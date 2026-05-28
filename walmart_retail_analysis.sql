-- 1. DATA PREPARATION & CLEANING
-- Creating a clean view for features to handle NULLs and duplicates
IF OBJECT_ID('vw_CleanFeatures', 'V') IS NOT NULL DROP VIEW vw_CleanFeatures;
GO

CREATE VIEW vw_CleanFeatures AS
SELECT * FROM (
    SELECT 
        store_id, [date], temperature, fuel_price, cpi, unemployment, is_holiday,
        ISNULL(markdown_1, 0) AS markdown_1,
        ISNULL(markdown_2, 0) AS markdown_2,
        ISNULL(markdown_3, 0) AS markdown_3,
        ISNULL(markdown_4, 0) AS markdown_4,
        ISNULL(markdown_5, 0) AS markdown_5,
        ROW_NUMBER() OVER(
            PARTITION BY store_id, [date] 
            ORDER BY [date]
        ) as row_num
    FROM features
) as subquery
WHERE row_num = 1;
GO

---

-- TASK 1: MARKET SHARE BY STORE TYPE
-- Analyzing the contribution of each store type to total sales
WITH CategorySales AS (
    SELECT 
        st.store_type, 
        SUM(sa.weekly_sales) AS total_sales_type
    FROM sales AS sa
    JOIN stores AS st ON sa.store_id = st.store_id
    GROUP BY st.store_type
)
SELECT 
    store_type, 
    total_sales_type,
    ROUND((total_sales_type / SUM(total_sales_type) OVER()) * 100, 2) AS percent_of_all
FROM CategorySales
ORDER BY percent_of_all DESC;

---

-- TASK 2: SALES EFFICIENCY INDEX
-- Measuring performance relative to store size (Sales per Square Foot)
SELECT 
    st.store_type, 
    SUM(sa.weekly_sales) AS total_sales_type,
    SUM(CAST(st.store_size AS BIGINT)) AS total_store_size,
    -- Added * 1.0 to ensure decimal precision
    ROUND(SUM(sa.weekly_sales) * 1.0 / SUM(CAST(st.store_size AS BIGINT)), 2) AS efficiency_index
FROM sales AS sa
JOIN stores AS st ON sa.store_id = st.store_id
GROUP BY st.store_type
ORDER BY efficiency_index DESC;

---

-- TASK 3: EXTERNAL FACTORS ANALYSIS (FUEL PRICE)
-- Grouping sales by fuel price threshold to check impact on consumer behavior
SELECT 
    CASE 
        WHEN fuel_price <= 3.5 THEN 'Cheap Fuel (<= 3.5)'
        ELSE 'Expensive Fuel (> 3.5)' 
    END AS fuel_status,
    ROUND(AVG(weekly_sales), 2) AS avg_sales,
    ROUND(AVG(unemployment), 2) AS avg_unemployment
FROM sales AS sa
JOIN vw_CleanFeatures AS f ON sa.store_id = f.store_id AND sa.[date] = f.[date]
GROUP BY 
    CASE 
        WHEN fuel_price <= 3.5 THEN 'Cheap Fuel (<= 3.5)'
        ELSE 'Expensive Fuel (> 3.5)' 
    END;

---

-- TASK 4: TOP DEPARTMENTS SENSITIVE TO HOLIDAYS
-- Finding departments with the highest sales lift during holiday weeks
SELECT TOP 10 
    department, 
    AVG(CASE WHEN is_holiday = 1 THEN weekly_sales END) AS holiday_avg,
    AVG(CASE WHEN is_holiday = 0 THEN weekly_sales END) AS normal_avg,
    ROUND(AVG(CASE WHEN is_holiday = 1 THEN weekly_sales END) - 
          AVG(CASE WHEN is_holiday = 0 THEN weekly_sales END), 2) AS holiday_lift
FROM sales
GROUP BY department
ORDER BY holiday_lift DESC;

---

-- TASK 5: PRE-HOLIDAY CONSUMER BEHAVIOR (WINDOW FUNCTIONS)
-- Analyzing sales 1 week BEFORE the holiday using LEAD()
WITH WeeklySummary AS (
    SELECT 
        [date],
        is_holiday,
        SUM(weekly_sales) AS total_sales,
        LEAD(is_holiday) OVER (ORDER BY [date]) AS next_week_holiday
    FROM sales
    GROUP BY [date], is_holiday
)
SELECT 
    CASE 
        WHEN is_holiday = 1 THEN 'Holiday Week'
        WHEN is_holiday = 0 AND next_week_holiday = 1 THEN 'Pre-Holiday Week'
        ELSE 'Regular Week'
    END AS week_type,
    FORMAT(AVG(total_sales), 'N0') AS avg_weekly_sales
FROM WeeklySummary
GROUP BY 
    CASE 
        WHEN is_holiday = 1 THEN 'Holiday Week'
        WHEN is_holiday = 0 AND next_week_holiday = 1 THEN 'Pre-Holiday Week'
        ELSE 'Regular Week'
    END;

---

-- TASK 6: YEAR-OVER-YEAR (YoY) GROWTH ANALYSIS
-- Final high-level performance metrics using LAG()
WITH YearlySales AS (
    SELECT 
        YEAR([date]) AS sales_year,
        SUM(weekly_sales) AS total_annual_sales
    FROM sales
    GROUP BY YEAR([date])
)
SELECT 
    sales_year,
    total_annual_sales,
    LAG(total_annual_sales) OVER (ORDER BY sales_year) AS prev_year_sales,
    ROUND(((total_annual_sales - LAG(total_annual_sales) OVER (ORDER BY sales_year)) 
           / LAG(total_annual_sales) OVER (ORDER BY sales_year)) * 100, 2) AS yoy_growth_percent
FROM YearlySales
ORDER BY sales_year DESC;
