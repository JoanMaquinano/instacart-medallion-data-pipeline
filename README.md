# Instacart Medallion Data Pipeline

## Purpose

This project demonstrates an end-to-end ETL pipeline built in Databricks using Medallion Architecture (Bronze, Silver, Gold).

The pipeline transforms raw Instacart transaction data into analytics-ready fact and dimension tables that support reporting and business analysis.

The repository is structured to allow other data engineers to understand, reproduce, validate, and extend the pipeline.

---

## Architecture

### Bronze Layer

Stores raw source data with minimal transformation.

Source tables:

- orders
- order_products__prior
- order_products__train
- products
- aisles
- departments

### Silver Layer

Applies data quality checks, standardization, cleansing, and integration.

Tables:

- clean_orders
- clean_order_products
- clean_order_merge
- clean_products
- clean_aisles
- clean_departments

### Gold Layer

Creates analytics-ready dimensional models.

Tables:

- dim_products
- dim_users
- dim_order_time
- fact_orders

```text
Raw Files
    │
    ▼
 Bronze
    │
    ▼
 Silver
    │
    ▼
 Gold
