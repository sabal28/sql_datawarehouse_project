/*
===============================================================================
Script: init_database.sql
Purpose: Initialise the MySQL databases used in the data warehouse project.

===============================================================================
*/

-- Create the Bronze database.
-- Purpose: Store raw data copied from source systems with minimal changes.
CREATE DATABASE IF NOT EXISTS bronze
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Create the Silver database.
-- Purpose: Store cleaned, standardised, validated, and integrated data.
CREATE DATABASE IF NOT EXISTS silver
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Create the Gold database.
-- Purpose: Store business-ready warehouse tables, data marts,
-- star schemas, views, and reporting tables.
CREATE DATABASE IF NOT EXISTS gold
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Verify that the three databases were created successfully.
SHOW DATABASES LIKE 'bronze';
SHOW DATABASES LIKE 'silver';
SHOW DATABASES LIKE 'gold';
