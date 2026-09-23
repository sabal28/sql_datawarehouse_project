CREATE SCHEMA IF NOT EXISTS silver;

CREATE TABLE IF NOT EXISTS silver.crm_customer (
    cst_id              INT,
    cst_key             VARCHAR(50),
    cst_firstname       VARCHAR(100),
    cst_lastname        VARCHAR(100),
    cst_marital_status  VARCHAR(10),
    cst_gndr            VARCHAR(10),
    cst_create_date     DATE,
    dwh_create_date     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS silver.crm_product (
    prd_id              INT,
    prd_key             VARCHAR(50),
    prd_nm              VARCHAR(255),
    prd_cost            DECIMAL(18,2),
    prd_line            VARCHAR(10),
    prd_start_dt        DATE,
    prd_end_dt          DATE,
    dwh_create_date     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS silver.crm_sales_details (
    sls_ord_num         VARCHAR(50),
    sls_prd_key         VARCHAR(50),
    sls_cust_id         INT,
    sls_order_dt        DATE,
    sls_ship_dt         DATE,
    sls_due_dt          DATE,
    sls_sales           DECIMAL(18,2),
    sls_quantity        INT,
    sls_price           DECIMAL(18,2),
    dwh_create_date     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS silver.erp_customer_az12 (
    cid                 VARCHAR(50),
    bdate               DATE,
    gen                 VARCHAR(10),
    dwh_create_date     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS silver.erp_location_a101 (
    cid                 VARCHAR(50),
    cntry               VARCHAR(100),
    dwh_create_date     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS silver.erp_product_category_g1v2 (
    id                  VARCHAR(50),
    cat                 VARCHAR(100),
    subcat              VARCHAR(100),
    maintenance         VARCHAR(100),
    dwh_create_date     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
