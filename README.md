Instacart Medallion Data Pipeline
Purpose

This project demonstrates the design and implementation of an end-to-end data pipeline using Databricks and Delta Lake. The pipeline processes the Instacart Online Grocery Shopping Dataset through a Medallion Architecture approach, progressively transforming raw data into business-ready analytics tables.

The project focuses on:

Data ingestion and storage
Data quality validation
Data cleaning and standardization
Dimensional modeling
Analytics-ready data products
Reproducible ETL workflows
Architecture

The pipeline follows the Medallion Architecture pattern:

Raw CSV Files
      │
      ▼
 ┌─────────┐
 │ Bronze  │
 │ Raw Data│
 └─────────┘
      │
      ▼
 ┌─────────┐
 │ Silver  │
 │ Cleaned │
 │ Data    │
 └─────────┘
      │
      ▼
 ┌─────────┐
 │  Gold   │
 │ Business│
 │ Models  │
 └─────────┘

Bronze Layer

Purpose:

Ingest source CSV files
Preserve original raw data
Add ingestion metadata
Establish auditability

Tables:

orders
order_products_prior
order_products_train
products
aisles
departments
Silver Layer

Purpose:

Remove duplicates
Handle null values
Standardize data types
Apply business rules
Improve data quality

Examples:

Validate IDs
Standardize column datatypes
Deduplicate records using window functions
Remove invalid records
Gold Layer

Purpose:

Create analytics-ready tables
Build dimensional models
Support reporting and business insights

Tables:

dim_products
dim_aisles
dim_departments
fact_orders
Data Model
Dimension Tables
dim_products

Contains product information.

Columnproduct_id
product_name
aisle_id
department_id
dim_aisles

Contains aisle information.

Columnaisle_id
aisle
dim_departments

Contains department information.

Columndepartment_id
department
Fact Table
fact_orders

Contains transactional order records.

Columnorder_id
user_id
product_id
quantity
order_number
order_dow
order_hour_of_day
days_since_prior_order
Star Schema
Plain Text
1
dim_departments
2
│
3
│
4
dim_products
5
│
6
│
7
dim_aisles ─────── fact_orders
Show more lines
How to Run
1. Clone Repository
Shell
1
git clone https://github.com/<your-username>/instacart-medallion-data-pipeline.git
2
cd instacart-medallion-data-pipeline
Show more lines
2. Upload Source Data

Upload the Instacart dataset files into Databricks storage.

Example:

Plain Text
1
dbfs:/FileStore/instacart/
Show more lines

Required files:

Plain Text
1
orders.csv
2
products.csv
3
aisles.csv
4
departments.csv
5
order_products_prior.csv
6
order_products_train.csv
Show more lines
3. Run Bronze Layer

Execute notebooks or SQL scripts responsible for:

Data ingestion
Delta table creation
Metadata capture
4. Run Silver Layer

Execute transformation scripts to:

Clean data
Remove duplicates
Enforce schema consistency
Validate records
5. Run Gold Layer

Execute modeling scripts to:

Create dimensions
Build fact tables
Generate analytics-ready datasets
Validation

Data quality checks were performed throughout the pipeline.

Completeness Checks

Verify required fields are populated.

SQL
1
SELECT COUNT(*)
2
FROM silver_products
3
WHERE product_id IS NULL;
Show more lines
Duplicate Checks

Verify unique business keys.

SQL
1
SELECT product_id, COUNT(*)
2
FROM silver_products
3
GROUP BY product_id
4
HAVING COUNT(*) > 1;
Show more lines
Referential Integrity Checks

Verify foreign key relationships.

SQL
1
SELECT *
2
FROM fact_orders f
3
LEFT JOIN dim_products p
4
ON f.product_id = p.product_id
5
WHERE p.product_id IS NULL;
Show more lines
Row Count Reconciliation

Compare layer counts after transformations.

SQL
1
SELECT COUNT(*) FROM bronze_products;
2
SELECT COUNT(*) FROM silver_products;
Show more lines
Key Design Decisions
Why Medallion Architecture?

Medallion Architecture provides:

Clear separation of concerns
Improved data quality
Better maintainability
Reproducible ETL processes
Why Delta Lake?

Delta Lake offers:

ACID transactions
Schema enforcement
Time travel capabilities
Reliable batch processing
Why Dimensional Modeling?

A star schema simplifies analytics by:

Improving query performance
Supporting BI tools
Enabling easier reporting
Providing business-friendly datasets
Why Separate Bronze, Silver, and Gold Layers?

Each layer serves a specific purpose:

Layer	PurposeBronze	Raw ingestion
Silver	Data cleaning and standardization
Gold	Analytics and reporting

This separation improves traceability, debugging, and maintainability across the pipeline.

Technologies Used
Databricks
Delta Lake
SQL
Apache Spark
Medallion Architecture
Dimensional Modeling
Git & GitHub
Project Outcome

Successfully built an end-to-end data pipeline that transforms raw Instacart grocery order data into trusted, analytics-ready datasets using Databricks, Delta Lake, and Medallion Architecture best practices.
