# Source-to-Target Mapping

## Overview

This document describes how data moves from the original Instacart source files through the Bronze, Silver, and Gold layers.

The purpose of this mapping is to provide transparency into the transformation process and make it easier for other engineers to trace how each Gold-layer table was derived from the original source data.

---

# Source Files

The pipeline begins with six source files:

```text
orders
order_products__prior
order_products__train
products
aisles
departments
```

These files are ingested without business transformations in the Bronze layer.

---

# Bronze Layer Mapping

The Bronze layer preserves raw source data.

## orders

```text
orders
    │
    ▼
bronze_orders
```

Purpose:

- Preserve raw order data
- Capture order-level attributes
- Support downstream transformations

---

## order_products__prior

```text
order_products__prior
          │
          ▼
bronze_order_products_prior
```

Purpose:

- Preserve historical product purchases
- Maintain source lineage

---

## order_products__train

```text
order_products__train
          │
          ▼
bronze_order_products_train
```

Purpose:

- Preserve labeled order purchases
- Maintain source lineage

---

## products

```text
products
    │
    ▼
bronze_products
```

Purpose:

- Preserve product information
- Maintain source hierarchy references

---

## aisles

```text
aisles
   │
   ▼
bronze_aisles
```

Purpose:

- Preserve aisle classifications

---

## departments

```text
departments
      │
      ▼
bronze_departments
```

Purpose:

- Preserve department classifications

---

# Silver Layer Mapping

The Silver layer applies data quality checks, cleaning, standardization, and integration.

---

## Orders

```text
bronze_orders
      │
      ▼
clean_orders
```

Transformations:

- Standardize data types
- Validate required fields
- Prepare order-level attributes for analysis

Output:

```text
clean_orders
```

---

## Products

```text
bronze_products
       │
       ▼
clean_products
```

Transformations:

- Standardize product attributes
- Validate product identifiers
- Prepare product dimension data

Output:

```text
clean_products
```

---

## Aisles

```text
bronze_aisles
      │
      ▼
clean_aisles
```

Transformations:

- Standardize aisle attributes
- Validate aisle identifiers

Output:

```text
clean_aisles
```

---

## Departments

```text
bronze_departments
         │
         ▼
clean_departments
```

Transformations:

- Standardize department attributes
- Validate department identifiers

Output:

```text
clean_departments
```

---

## Order Products Consolidation

The Instacart dataset separates product purchases into two source files.

For analytics purposes, these datasets are combined into a single transaction dataset.

```text
bronze_order_products_prior
               +
bronze_order_products_train
               │
               ▼
      clean_order_products
```

Transformations:

- Standardize schemas
- Combine transaction records
- Create a unified product-purchase dataset

Output:

```text
clean_order_products
```

---

## Transaction Integration

Order-level attributes and product-level attributes are integrated into a consolidated transactional dataset.

```text
clean_orders
      +
clean_order_products
      │
      ▼
clean_order_merge
```

Purpose:

- Centralize business logic
- Eliminate repeated joins
- Simplify Gold-layer modeling

Output:

```text
clean_order_merge
```

---

# Gold Layer Mapping

The Gold layer transforms cleaned transactional data into an analytics-ready dimensional model.

---

## Dim_Product

Source:

```text
clean_products
```

Output:

```text
dim_products
```

Purpose:

- Product reporting
- Product categorization
- Department analysis
- Aisle analysis

---

## Dim_User

Source:

```text
clean_orders
```

Output:

```text
dim_users
```

Purpose:

- Customer analysis
- Purchase behavior analysis
- User-level reporting

---

## Dim_Order_Time

Source:

```text
clean_orders
```

Output:

```text
dim_order_time
```

Purpose:

- Time-series analysis
- Day-of-week analysis
- Hour-of-day analysis

---

## Fact_Order

Source:

```text
clean_order_merge
```

Output:

```text
fact_orders
```

Purpose:

- Store transactional purchase events
- Support business metrics
- Serve as the central fact table

---

# End-to-End Data Flow

```text
orders
order_products__prior
order_products__train
products
aisles
departments

            │
            ▼

       Bronze Layer

            │
            ▼

       Silver Layer

  clean_orders
  clean_products
  clean_aisles
  clean_departments
  clean_order_products
  clean_order_merge

            │
            ▼

        Gold Layer

      dim_products
      dim_users
      dim_order_time
      fact_orders
```

---

# Final Model Mapping

```text
clean_products
        │
        ▼
  dim_products

clean_orders
        │
        ├──────────────► dim_users
        │
        └──────────────► dim_order_time

clean_order_merge
        │
        ▼
    fact_orders
```

The final dimensional model separates descriptive attributes into dimensions and transactional purchase events into a centralized fact table, creating a structure optimized for reporting and analytical workloads.
