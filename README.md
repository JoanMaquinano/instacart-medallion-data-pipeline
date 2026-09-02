# Instacart Medallion Data Pipeline

## Purpose

This project demonstrates how to build an end-to-end ETL pipeline in Databricks using Medallion Architecture (Bronze, Silver, Gold).

The goal is not simply to load the Instacart dataset into tables, but to transform raw transactional data into a structured analytical model that supports reporting, exploration, and business decision-making.

This repository documents not only what was built, but also why specific design decisions were made so that others can understand, reproduce, and extend the pipeline.

---

## Business Problem

The Instacart dataset contains grocery orders, products, aisles, and departments stored across multiple source files.

While the dataset is useful for analysis, it is highly normalized and not structured for easy reporting.

The objective of this project is to create a repeatable pipeline that transforms raw source data into analytics-ready datasets capable of answering business questions such as:

1. Which products are purchased most frequently?
2. Which departments generate the highest number of purchases?
3. How does purchasing behavior vary by day of week and hour of day?
4. Which products have the highest reorder rates?
5. What additional customer purchasing patterns can be identified?

---

## Architecture

The pipeline follows the Medallion Architecture pattern.

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

Each layer has a specific responsibility.

### Bronze Layer

Captures source data with minimal transformation.

Purpose:

- Preserve raw records
- Maintain data lineage
- Support auditability
- Enable reproducible processing

### Silver Layer

Applies data quality rules and business transformations.

Purpose:

- Standardize datasets
- Clean source data
- Integrate related datasets
- Prepare data for modeling

### Gold Layer

Creates analytics-ready tables.

Purpose:

- Support reporting
- Simplify analysis
- Improve usability for business users
- Deliver trusted datasets

---

## Source Data

The Instacart dataset contains six source files:

```text
orders
order_products__prior
order_products__train
products
aisles
departments
```

Each file captures a different part of the ordering process.

The Bronze layer preserves these files in their original structure before any transformations are applied.

---

## Silver Layer Design Decisions

### Why Prior and Train Were Combined

The Instacart dataset was originally created for a machine learning competition.

Product purchases are separated into two files:

```text
order_products__prior
order_products__train
```

The distinction exists because the dataset was designed for reorder prediction.

- Prior records represent historical customer purchases.
- Train records represent a customer's next labeled purchase used for model training.

For analytics purposes, however, both datasets describe the same business event:

> A customer purchased a product within an order.

Because this project focuses on analytics engineering rather than machine learning, both datasets were consolidated into a single Silver-layer dataset.

```text
order_products__prior
           +
order_products__train
           │
           ▼
clean_order_products
```

This decision created a single source of truth for purchased products and simplified downstream transformations.

Benefits include:

- Reduced pipeline complexity
- Less duplicated transformation logic
- Easier fact table creation
- Simpler analytical queries

The Instacart test dataset was not included because product-level records are not provided in the source files.

---

### Why clean_order_merge Was Created

Order information and product information exist in separate datasets.

Order attributes include information such as:

```text
user_id
order_number
order_dow
order_hour_of_day
days_since_prior_order
```

Product-purchase attributes include information such as:

```text
product_id
add_to_cart_order
reordered
```

Answering business questions requires both perspectives to exist together.

To support dimensional modeling, order-level data was joined with product-level data to create a consolidated transactional dataset.

```text
clean_orders
        +
clean_order_products
        │
        ▼
clean_order_merge
```

Creating this intermediate table centralized transformation logic and reduced the need for repeated joins later in the pipeline.

This dataset became the primary source for creating Gold-layer fact tables.

---

## Data Model

The final model was designed to support reporting and business analysis.

### Dimensions

#### Dim_Product

Contains descriptive information about products.

Purpose:

- Categorize purchases
- Support product-level reporting
- Connect purchases to aisles and departments

#### Dim_User

Contains customer identifiers.

Purpose:

- Support customer-level analysis
- Enable user segmentation
- Track purchasing patterns

#### Dim_Order_Time

Contains order timing information.

Purpose:

- Analyze ordering behavior
- Identify temporal trends
- Support day-of-week and hour-of-day reporting

---

### Fact_Order

Contains transactional purchase events.

Purpose:

- Record product purchases
- Measure purchasing activity
- Support aggregation and reporting

---

## Star Schema

### Why a Star Schema

The source Instacart dataset is highly normalized because it was designed to store transactional data efficiently.

While this structure works well for operational systems, answering business questions often requires joining multiple tables together. As the number of tables grows, queries become more complex and harder to maintain.

To improve usability, the final Gold layer was modeled as a star schema.

```text
            Dim_Order_Time
                  │
                  │
Dim_User ───── Fact_Order ───── Dim_Product
```

In this design:

- Fact_Order stores the business events, which are individual product purchases within orders.
- Dim_Product provides descriptive information about products.
- Dim_User provides customer-level context.
- Dim_Order_Time provides the temporal attributes needed for trend analysis.

Separating facts and dimensions makes it easier to answer business questions because analysts can focus on the information they need without repeatedly rebuilding complex joins.

Benefits of this approach include:

- Simpler analytical queries
- Easier dashboard and report development
- Clear separation between transactions and descriptive attributes
- Better support for aggregations and business metrics
- Improved maintainability as the model evolves

For example, questions such as:

- Which products are purchased most frequently?
- Which departments generate the most purchases?
- When are customers most likely to place orders?
- Which products have the highest reorder rates?

can be answered directly from the dimensional model without navigating the complexity of the original source schema.

The Gold layer therefore serves as the business-facing representation of the Instacart dataset, optimized for analysis rather than transaction processing.
