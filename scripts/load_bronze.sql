-- Script: 02_load_bronze_crm.sql
-- Purpose: Fully reload CRM source files into bronze-layer tables.

-- Process:
-- 1. Clear existing data from the CRM bronze tables.
-- 2. Load each source CSV.
-- 3. Validate row counts after loading.

-- Important:
-- - This is a FULL LOAD process.

/*
=================================================================
Section: ETL Load Timing Setup
Purpose: Store timing details for each individual CSV load during
         the current MySQL Workbench session.

Note:
TEMPORARY tables exist only for the current database session and
are automatically removed when the connection closes.
=================================================================
*/

DROP TEMPORARY TABLE IF EXISTS etl_load_timing;

CREATE TEMPORARY TABLE etl_load_timing (
    load_step       VARCHAR(100) NOT NULL,
    target_table    VARCHAR(100) NOT NULL,
    start_time      DATETIME(6) NOT NULL,
    end_time        DATETIME(6) NOT NULL,
    duration_ms     DECIMAL(12, 3) NOT NULL,
    row_count       BIGINT NOT NULL
);
-- =============================================================
-- Load: CRM Product
-- =============================================================

TRUNCATE TABLE bronze.crm_product;

SET @start_crm_product = NOW(6);

LOAD DATA LOCAL INFILE
'/Users/sabalgurung/Desktop/warehouse project /sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
INTO TABLE bronze.crm_product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_crm_product = NOW(6);

INSERT INTO etl_load_timing
SELECT
    'Load CRM Product',
    'bronze.crm_product',
    @start_crm_product,
    @end_crm_product,
    ROUND(TIMESTAMPDIFF(MICROSECOND, @start_crm_product, @end_crm_product) / 1000, 3),
    COUNT(*)
FROM bronze.crm_product;


-- =============================================================
-- Load: CRM Sales Details
-- =============================================================

TRUNCATE TABLE bronze.crm_sales_details;

SET @start_crm_sales_details = NOW(6);

LOAD DATA LOCAL INFILE
'/Users/sabalgurung/Desktop/warehouse project /sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_crm_sales_details = NOW(6);

INSERT INTO etl_load_timing
SELECT
    'Load CRM Sales Details',
    'bronze.crm_sales_details',
    @start_crm_sales_details,
    @end_crm_sales_details,
    ROUND(TIMESTAMPDIFF(MICROSECOND, @start_crm_sales_details, @end_crm_sales_details) / 1000, 3),
    COUNT(*)
FROM bronze.crm_sales_details;


-- =============================================================
-- Load: ERP Customer
-- =============================================================

TRUNCATE TABLE bronze.erp_customer_az12;

SET @start_erp_customer = NOW(6);

LOAD DATA LOCAL INFILE
'/Users/sabalgurung/Downloads/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE bronze.erp_customer_az12
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_erp_customer = NOW(6);

INSERT INTO etl_load_timing
SELECT
    'Load ERP Customer',
    'bronze.erp_customer_az12',
    @start_erp_customer,
    @end_erp_customer,
    ROUND(TIMESTAMPDIFF(MICROSECOND, @start_erp_customer, @end_erp_customer) / 1000, 3),
    COUNT(*)
FROM bronze.erp_customer_az12;


-- =============================================================
-- Load: ERP Location
-- =============================================================

TRUNCATE TABLE bronze.erp_location_a101;

SET @start_erp_location = NOW(6);

LOAD DATA LOCAL INFILE
'/Users/sabalgurung/Downloads/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
INTO TABLE bronze.erp_location_a101
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_erp_location = NOW(6);

INSERT INTO etl_load_timing
SELECT
    'Load ERP Location',
    'bronze.erp_location_a101',
    @start_erp_location,
    @end_erp_location,
    ROUND(TIMESTAMPDIFF(MICROSECOND, @start_erp_location, @end_erp_location) / 1000, 3),
    COUNT(*)
FROM bronze.erp_location_a101;


-- =============================================================
-- Load: ERP Product Category
-- =============================================================

TRUNCATE TABLE bronze.erp_product_category_g1v2;

SET @start_erp_product_category = NOW(6);

LOAD DATA LOCAL INFILE
'/Users/sabalgurung/Downloads/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE bronze.erp_product_category_g1v2
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_erp_product_category = NOW(6);

INSERT INTO etl_load_timing
SELECT
    'Load ERP Product Category',
    'bronze.erp_product_category_g1v2',
    @start_erp_product_category,
    @end_erp_product_category,
    ROUND(TIMESTAMPDIFF(MICROSECOND, @start_erp_product_category, @end_erp_product_category) / 1000, 3),
    COUNT(*)
FROM bronze.erp_product_category_g1v2;

SELECT
    'crm_customer' AS table_name,
    COUNT(*) AS row_count
FROM bronze.crm_customer

UNION ALL

SELECT
    'crm_product' AS table_name,
    COUNT(*) AS row_count
FROM bronze.crm_product

UNION ALL

SELECT
    'crm_sales_details' AS table_name,
    COUNT(*) AS row_count
FROM bronze.crm_sales_details

UNION ALL 

SELECT
    'erp_loc_a101' AS table_name,
    COUNT(*) AS row_count
FROM bronze.erp_location_a101

UNION ALL

SELECT
    'erp_cust_az12' AS table_name,
    COUNT(*) AS row_count
FROM bronze.erp_customer_az12

UNION ALL

SELECT
    'erp_px_cat_g1v2' AS table_name,
    COUNT(*) AS row_count
FROM bronze.erp_product_category_g1v2;






-- 	 Warning categories:
-- 	  - Blank or space-only decimal values in `sls_price`
-- 	  - Blank decimal values in `sls_sales`
-- 	  - Invalid or out-of-range values in `sls_order_dt`

-- warning checks 

--  Check 1 :  Find suspicious price or sales values
-- Purpose: Identifies records where price or sales may have
-- been blank in the CSV and stored as 0 or NULL in MySQL.
SELECT *
FROM bronze.crm_sales_details
WHERE sls_price IS NULL
   OR sls_price = 0
   OR sls_sales IS NULL
   OR sls_sales = 0;

-- - Check 2 : Find invalid order dates
-- Purpose: Identifies missing, zero, or out-of-range order
-- dates that require cleaning in the silver layer.
-- ===================================================
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt IS NULL
   OR sls_order_dt = 0
   OR sls_order_dt NOT BETWEEN 19000101 AND 21000101;


/*
=================================================================
Section: ETL Timing Summary
Purpose: Display the individual load performance results for the
         current ETL execution.
=================================================================
*/

SELECT
    load_step,
    target_table,
    start_time,
    end_time,
    row_count,
    duration_ms,
    ROUND(duration_ms / 1000, 3) AS duration_seconds
FROM etl_load_timing
ORDER BY start_time;
