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

## Project Context

The Instacart dataset consists of multiple normalized source files, including:

- orders
- order_products__prior
- order_products__train
- products
- aisles
- departments

The goal of this project was not to replicate the source schema but to transform the raw data into a dimensional model that supports business reporting and analysis.

### Business Questions

This pipeline was designed to support the following business questions:

1. Which products and departments are purchased most frequently?
2. How does purchasing behavior change by day of week and hour of day?
3. Which products have the highest reorder rates?
4. What additional insights can be generated from customer purchasing behavior?

### Target Data Model

A star schema was provided as the target analytical model:

- Fact_Order
- Dim_Product
- Dim_Order_Time
- Dim_User

To support this model, the raw Instacart data was transformed through Bronze, Silver, and Gold layers.

---

## Architecture

The pipeline follows a Medallion Architecture pattern.

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

The Bronze layer stores raw source data with minimal transformation.

Tables:

- bronze_orders
- bronze_order_products_prior
- bronze_order_products_train
- bronze_products
- bronze_aisles
- bronze_departments

Purpose:

- Preserve source data
- Maintain data lineage
- Support reproducibility
- Enable reprocessing if needed

### Silver Layer

The Silver layer applies cleaning, standardization, validation, and integration logic.

Tables:

- clean_orders
- clean_order_products
- clean_products
- clean_aisles
- clean_departments
- clean_order_merge

Purpose:

- Remove duplicates
- Standardize data types
- Handle null and invalid values
- Consolidate related datasets
- Prepare data for dimensional modeling

### Gold Layer

The Gold layer contains analytics-ready tables aligned with the target star schema.

Tables:

- dim_products
- dim_users
- dim_order_time
- fact_orders

Purpose:

- Support business reporting
- Improve query performance
- Simplify analytical workflows

---

## Silver Layer Design Decisions

### Why I Combined Prior and Train Datasets

The Instacart dataset was originally created for a machine learning competition and separates product-order records into two files:

- `order_products__prior`
- `order_products__train`

The `prior` dataset contains historical customer purchases, while the `train` dataset contains purchases from a customer's most recent labeled order.

Although the datasets serve different purposes in machine learning workflows, both contain valid product purchase transactions and share the same schema.

Because the goal of this project was analytics engineering rather than reorder prediction, I combined both datasets into a single Silver table:

```text
order_products__prior
           +
order_products__train
           │
           ▼
clean_order_products
```

This created a unified transaction dataset that simplified downstream transformations and dimensional modeling while preserving all available purchase records.

The Instacart test dataset was not included because product-level records are not provided.

### Why I Created clean_order_merge

The target dimensional model requires both order-level and product-level attributes in the fact table.

Order information originates from:

```text
orders
```

Product purchase information originates from:

```text
order_products__prior
order_products__train
```

To simplify fact table creation, I joined these datasets in the Silver layer:

```text
clean_orders
        +
clean_order_products
        │
        ▼
clean_order_merge
```

The resulting dataset contains:

- order_id
- user_id
- order_number
- order_dow
- order_hour_of_day
- days_since_prior_order
- product_id
- add_to_cart_order
- reordered

Creating this consolidated table reduced repeated joins in the Gold layer and established a reusable foundation for dimensional modeling.

---

## Data Model

### Dimension Tables

#### dim_products

Stores product attributes.

**Columns**

- product_id
- product_name
- aisle_id
- department_id

#### dim_users

Stores customer-related attributes.

**Columns**

- user_id

#### dim_order_time

Stores order timing attributes.

**Columns**

- order_id
- order_number
- order_dow
- order_hour_of_day
- days_since_prior_order

### Fact Table

#### fact_orders

Stores product-level order transactions.

**Columns**

- order_id
- user_id
- product_id
- reordered
- add_to_cart_order

### Star Schema

```text
                    dim_order_time
                           │
                           │
dim_users ──── fact_orders ──── dim_products
```

---

## How to Run

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/instacart-medallion-data-pipeline.git

cd instacart-medallion-data-pipeline
```

### 2. Upload Source Files

Upload the Instacart dataset to Databricks FileStore or cloud storage.

Required files:

```text
orders.csv
products.csv
aisles.csv
departments.csv
order_products__prior.csv
order_products__train.csv
```

### 3. Execute Bronze Layer

Run Bronze ingestion scripts to:

- Load CSV files
- Create Delta tables
- Capture ingestion metadata

### 4. Execute Silver Layer

Run Silver transformation scripts to:

- Clean source data
- Standardize schemas
- Apply validation rules
- Consolidate order-product datasets

### 5. Execute Gold Layer

Run Gold scripts to:

- Create dimensions
- Build the fact table
- Produce analytics-ready datasets

---

## Validation

Data quality checks were performed throughout the pipeline.

### Row Count Validation

```sql
SELECT COUNT(*) FROM bronze_products;
SELECT COUNT(*) FROM clean_products;
```

### Duplicate Validation

```sql
SELECT product_id, COUNT(*)
FROM clean_products
GROUP BY product_id
HAVING COUNT(*) > 1;
```

### Null Validation

```sql
SELECT COUNT(*)
FROM clean_products
WHERE product_id IS NULL;
```

### Referential Integrity Validation

```sql
SELECT *
FROM fact_orders f
LEFT JOIN dim_products p
    ON f.product_id = p.product_id
WHERE p.product_id IS NULL;
```

### Schema Validation

```sql
DESCRIBE TABLE dim_products;
```

---

## Decisions

### Why Medallion Architecture?

Medallion Architecture separates raw, cleaned, and business-ready data into distinct layers. This improves maintainability, traceability, and data quality management.

### Why Delta Lake?

Delta tables provide:

- ACID transactions
- Schema enforcement
- Reliable ETL processing
- Consistent data management

### Why Dimensional Modeling?

A star schema simplifies analytical queries by:

- Reducing join complexity
- Supporting BI and reporting tools
- Improving query performance
- Providing business-friendly datasets

### Why Build Business Logic in Silver?

Data integration and transformation logic were centralized in the Silver layer so that Gold tables could focus on analytical modeling rather than data preparation.

### Incremental Loading Considerations

This project uses a full-refresh strategy for simplicity and reproducibility.

In a production environment, incremental processing could be implemented using `MERGE INTO` operations. Surrogate keys could be generated using identity columns or sequence-based approaches to support slowly changing dimensions and incremental fact table loading.

---

## Repository Structure

```text
instacart-medallion-data-pipeline/
│
├── 01_bronze_ingest/
│   ├── ingest_orders.sql
│   ├── ingest_order_products_prior.sql
│   ├── ingest_order_products_train.sql
│   ├── ingest_products.sql
│   ├── ingest_aisles.sql
│   └── ingest_departments.sql
│
├── 02_silver_clean/
│   ├── clean_orders.sql
│   ├── clean_order_products.sql
│   ├── clean_order_merge.sql
│   ├── clean_products.sql
│   ├── clean_aisles.sql
│   └── clean_departments.sql
│
├── 03_gold_model/
│   ├── dim_products.sql
│   ├── dim_users.sql
│   ├── dim_order_time.sql
│   └── fact_orders.sql
│
├── validation/
│   ├── bronze_validation.sql
│   ├── silver_validation.sql
│   └── gold_validation.sql
│
└── README.md
```

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

## Outcome

Successfully built an end-to-end ETL pipeline that transforms raw Instacart grocery order data into trusted, analytics-ready dimensional tables. The project demonstrates data ingestion, cleansing, integration, validation, and dimensional modeling using Databricks and Delta Lake following Medallion Architecture principles.
