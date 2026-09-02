# Instacart Medallion Data Pipeline

## Purpose

This project demonstrates an end-to-end ETL pipeline built in Databricks using Medallion Architecture (Bronze, Silver, Gold).

The pipeline transforms raw Instacart transaction data into analytics-ready fact and dimension tables that support reporting and business analysis.

The repository is designed so other data engineers can:

- Understand the pipeline design
- Reproduce the workflow
- Validate transformation results
- Extend the model for additional use cases

Detailed design documentation is available in the `docs/` directory.

---

## Architecture

The pipeline follows a Medallion Architecture pattern.

```text
Raw Source Files
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

The Bronze layer ingests source files with minimal transformation.

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
- Enable reprocessing from raw data

---

### Silver Layer

The Silver layer applies data quality checks, standardization, cleansing, and integration.

Tables:

- clean_orders
- clean_order_products
- clean_order_merge
- clean_products
- clean_aisles
- clean_departments

Purpose:

- Improve data quality
- Standardize schemas
- Consolidate related datasets
- Prepare data for dimensional modeling

---

### Gold Layer

The Gold layer contains analytics-ready tables optimized for reporting and business analysis.

Tables:

- dim_products
- dim_users
- dim_order_time
- fact_orders

Purpose:

- Simplify analytical queries
- Support reporting and dashboards
- Deliver trusted business datasets

---

## Data Model

The final model follows a star schema design.

```text
                    Dim_Order_Time
                           │
                           │
Dim_User ───── Fact_Order ───── Dim_Product
```

### Dimension Tables

#### Dim_Product

Stores descriptive product information used for product, aisle, and department analysis.

#### Dim_User

Stores customer identifiers used for user-level analysis.

#### Dim_Order_Time

Stores order timing attributes used for trend analysis and time-based reporting.

### Fact Table

#### Fact_Order

Stores transactional purchase events and serves as the central table for analysis.

### Model Benefits

- Simplifies reporting queries
- Separates transactions from descriptive attributes
- Supports aggregation and business metrics
- Improves usability for analysts and BI tools

Detailed modeling decisions are available in:

```text
docs/architecture_decisions.md
```

---

## How to Run

### 1. Upload Source Files

Upload the Instacart dataset files to Databricks.

Required files:

```text
orders.csv
order_products__prior.csv
order_products__train.csv
products.csv
aisles.csv
departments.csv
```

---

### 2. Execute Bronze Layer

Run all scripts in:

```text
01_bronze_ingest/
```

Execution order:

1. ingest_orders.sql
2. ingest_order_products_prior.sql
3. ingest_order_products_train.sql
4. ingest_products.sql
5. ingest_aisles.sql
6. ingest_departments.sql

---

### 3. Execute Silver Layer

Run all scripts in:

```text
02_silver_clean/
```

Execution order:

1. clean_orders.sql
2. clean_products.sql
3. clean_aisles.sql
4. clean_departments.sql
5. clean_order_products.sql
6. clean_order_merge.sql

---

### 4. Execute Gold Layer

Run all scripts in:

```text
03_gold_model/
```

Execution order:

1. dim_products.sql
2. dim_users.sql
3. dim_order_time.sql
4. fact_orders.sql

---

### 5. Execute Validation Scripts

Run validation scripts after each layer.

Location:

```text
validation/
```

Recommended order:

1. bronze_validation.sql
2. silver_validation.sql
3. gold_validation.sql

---

## Validation

Validation is performed throughout the pipeline to ensure data quality and transformation accuracy.

### Bronze Validation

Verifies:

- Source files loaded successfully
- Row counts match source data
- Required columns exist

### Silver Validation

Verifies:

- Cleaning rules were applied correctly
- Duplicates are handled appropriately
- Required fields are populated
- Data types are standardized

### Gold Validation

Verifies:

- Fact and dimension tables were created successfully
- Relationships remain valid
- Model supports expected reporting requirements
- Business-facing tables contain expected records

Validation scripts are located in:

```text
validation/
```

---

## Decisions

This repository separates implementation from design documentation.

Detailed explanations for architectural and modeling decisions are available in the `docs/` directory.

Key topics include:

- Project context
- Source-to-target mapping
- Medallion Architecture rationale
- Prior and train dataset consolidation
- Creation of the consolidated Silver transaction layer
- Dimensional modeling decisions
- Business question alignment

Documentation location:

```text
docs/
```

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
├── docs/
│   ├── project_context.md
│   ├── architecture_decisions.md
│   ├── source_to_target_mapping.md
│   ├── data_dictionary.md
│   └── business_questions.md
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

Built an end-to-end ETL pipeline that transforms raw Instacart transaction data into an analytics-ready dimensional model.

The project demonstrates data ingestion, cleansing, integration, validation, and dimensional modeling practices commonly used in modern data engineering workflows.
