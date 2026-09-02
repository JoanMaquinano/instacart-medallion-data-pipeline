# Instacart Medallion Data Pipeline

## Purpose

This project demonstrates the implementation of an end-to-end ETL pipeline in Databricks using Medallion Architecture (Bronze, Silver, Gold). The pipeline ingests raw Instacart grocery order data, applies data quality and transformation rules, and produces analytics-ready dimensional tables for reporting and business analysis.

Key objectives include:

- Building a scalable ETL workflow
- Applying data quality validation and cleansing
- Implementing Medallion Architecture using Delta tables
- Creating analytics-ready fact and dimension tables
- Supporting reproducible and maintainable data processing

---

## Architecture

The pipeline follows a Medallion Architecture approach:

```text
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
```

### Bronze Layer

Purpose:

- Ingest raw source files
- Preserve source data
- Add ingestion metadata
- Support data lineage and auditing

Tables:

- bronze_orders
- bronze_order_products_prior
- bronze_order_products_train
- bronze_products
- bronze_aisles
- bronze_departments

### Silver Layer

Purpose:

- Standardize data types
- Remove duplicates
- Handle null and invalid values
- Apply business validation rules

Tables:

- silver_orders
- silver_order_products_prior
- silver_order_products_train
- silver_products
- silver_aisles
- silver_departments

### Gold Layer

Purpose:

- Create analytics-ready datasets
- Build dimensional models
- Support reporting and dashboard development

Tables:

- dim_products
- dim_aisles
- dim_departments
- fact_orders

---

## Data Model

### Dimension Tables

#### dim_products

Stores product-related attributes.

**Columns**

- product_id
- product_name
- aisle_id
- department_id

#### dim_aisles

Stores aisle information.

**Columns**

- aisle_id
- aisle

#### dim_departments

Stores department information.

**Columns**

- department_id
- department

### Fact Table

#### fact_orders

Stores transactional order records.

**Columns**

- order_id
- user_id
- product_id
- order_number
- order_dow
- order_hour_of_day
- days_since_prior_order
- quantity

### Star Schema

```text
                    dim_departments
                           │
                           │
                    dim_products
                           │
                           │
dim_aisles ─────── fact_orders
```

---

## How to Run

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/instacart-medallion-data-pipeline.git

cd instacart-medallion-data-pipeline
```

### 2. Upload Source Files

Upload the Instacart dataset into Databricks FileStore or cloud storage.

Required files:

```text
orders.csv
products.csv
aisles.csv
departments.csv
order_products_prior.csv
order_products_train.csv
```

### 3. Execute Bronze Layer

Run Bronze scripts to:

- Ingest raw CSV files
- Create Delta tables
- Capture ingestion metadata

### 4. Execute Silver Layer

Run Silver scripts to:

- Clean and standardize data
- Remove duplicates
- Apply validation rules
- Enforce schema consistency

### 5. Execute Gold Layer

Run Gold scripts to:

- Build dimensions
- Create fact tables
- Prepare analytics-ready datasets

---

## Validation

The following quality checks were performed throughout the pipeline.

### Row Count Validation

```sql
SELECT COUNT(*) FROM bronze_products;
SELECT COUNT(*) FROM silver_products;
```

### Duplicate Check

```sql
SELECT product_id, COUNT(*)
FROM silver_products
GROUP BY product_id
HAVING COUNT(*) > 1;
```

### Null Check

```sql
SELECT COUNT(*)
FROM silver_products
WHERE product_id IS NULL;
```

### Referential Integrity Check

```sql
SELECT *
FROM fact_orders f
LEFT JOIN dim_products p
    ON f.product_id = p.product_id
WHERE p.product_id IS NULL;
```

### Data Type Validation

```sql
DESCRIBE TABLE dim_products;
```

---

## Decisions

### Medallion Architecture

The Medallion Architecture was selected to separate raw, cleansed, and business-ready data. This improves maintainability, traceability, and data quality management across the pipeline.

### Delta Lake

Delta tables were used to provide:

- ACID transactions
- Schema enforcement
- Reliable ETL processing
- Improved data consistency

### Dimensional Modeling

A star schema was implemented to simplify analytical queries and improve reporting performance.

### Layered Data Processing

Data transformations were separated across Bronze, Silver, and Gold layers to ensure:

- Reproducibility
- Clear ownership of transformations
- Easier troubleshooting
- Better scalability

### Initial Load Strategy

This project uses a full-load approach where Gold tables are recreated from the latest Silver layer data during execution.

**UPSERT / MERGE Consideration**

For production pipelines, incremental loading can be implemented using `MERGE INTO` statements. Surrogate keys can be generated using identity columns or sequence-based strategies to support Slowly Changing Dimension (SCD) processes and incremental fact table updates.

---

## Technologies Used

- Databricks
- Apache Spark
- Delta Lake
- SQL
- Medallion Architecture
- Dimensional Modeling
- Git
- GitHub

---

## Repository Structure

```text
instacart-medallion-data-pipeline/
│
├── bronze/
│   ├── orders.sql
│   ├── products.sql
│   ├── aisles.sql
│   └── departments.sql
│
├── silver/
│   ├── orders.sql
│   ├── products.sql
│   ├── aisles.sql
│   └── departments.sql
│
├── gold/
│   ├── dim_products.sql
│   ├── dim_aisles.sql
│   ├── dim_departments.sql
│   └── fact_orders.sql
│
├── validation/
│   └── validation_queries.sql
│
└── README.md
```

## Outcome

Successfully developed an end-to-end Databricks ETL pipeline that transforms raw Instacart grocery order data into trusted, analytics-ready dimension and fact tables using Delta Lake and Medallion Architecture principles.
