# Architecture Decisions

## Overview

This document explains the architectural and modeling decisions made throughout the project.

The goal is to provide context for how the pipeline was designed and why certain implementation choices were made. These decisions are intended to improve maintainability, usability, and analytical value while keeping the solution aligned with the project requirements.

---

## Why Medallion Architecture Was Used

The pipeline was organized using Medallion Architecture, which separates data into Bronze, Silver, and Gold layers.

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
```

### Decision

Separate raw, cleaned, and business-ready data into distinct layers.

### Rationale

Keeping each stage of processing isolated makes the pipeline easier to understand and maintain.

This approach allows:

- Raw data to remain unchanged
- Data quality rules to be applied in a dedicated layer
- Business models to remain independent of source system complexity

### Benefits

- Clear separation of responsibilities
- Easier troubleshooting
- Improved reproducibility
- Better scalability for future enhancements

---

## Why Bronze Tables Preserve Raw Data

The Bronze layer intentionally avoids business transformations.

### Decision

Load source files with minimal modification.

### Rationale

The source data should remain available in its original form.

Preserving raw data makes it possible to:

- Rebuild downstream layers
- Validate transformations
- Investigate data quality issues
- Compare transformed data with source records

### Benefits

- Improved traceability
- Simplified debugging
- Reproducible processing

---

## Why Prior and Train Datasets Were Combined

The Instacart dataset separates product purchases into two files:

```text
order_products__prior
order_products__train
```

### Decision

Combine both datasets into a single Silver-layer table.

```text
order_products__prior
           +
order_products__train
           │
           ▼
clean_order_products
```

### Rationale

The original dataset was designed for a machine learning competition.

In that context:

- Prior represents historical customer purchases.
- Train represents a customer's next labeled purchase.

For analytics, however, both datasets describe the same business event:

> A customer purchased a product within an order.

The distinction between prior and train is important for predictive modeling but not necessary for reporting and business analysis.

### Benefits

- Creates a single source of truth for product purchases
- Reduces duplicate transformation logic
- Simplifies downstream processing
- Makes dimensional modeling easier

---

## Why the Test Dataset Was Not Included

### Decision

Exclude the test dataset from the pipeline.

### Rationale

The Instacart dataset does not provide product-level purchase records for test orders.

Because the project focuses on transactional analysis, the required product-level information is unavailable.

Including incomplete orders would add complexity without contributing meaningful analytical value.

### Benefits

- Maintains dataset consistency
- Avoids incomplete transaction records
- Simplifies modeling logic

---

## Why clean_order_merge Was Created

Order information and product-purchase information exist in separate datasets.

### Decision

Create an integrated Silver-layer transaction table.

```text
clean_orders
       +
clean_order_products
       │
       ▼
clean_order_merge
```

### Rationale

Several business questions require attributes from both datasets.

Examples include:

- Product purchases by hour of day
- Product purchases by customer
- Reorder behavior by product
- Product demand over time

Without integration, the same joins would need to be repeated throughout the Gold layer.

By combining the datasets once in Silver, the integration logic becomes centralized and reusable.

### Benefits

- Reduces duplication
- Simplifies Gold-layer development
- Creates a reusable transactional dataset
- Improves maintainability

---

## Why Business Logic Was Centralized in Silver

### Decision

Perform cleansing, standardization, and integration in Silver rather than Gold.

### Rationale

The purpose of Silver is to prepare data for analytical consumption.

The purpose of Gold is to model business entities and metrics.

Separating these responsibilities keeps the architecture easier to understand and maintain.

### Benefits

- Cleaner Gold layer logic
- Easier testing
- Better separation of concerns
- More reusable datasets

---

## Why CREATE TABLE IF NOT EXISTS Was Used in Silver

### Decision

Use `CREATE TABLE IF NOT EXISTS` when creating Silver-layer tables.

### Rationale

The Silver layer serves as an intermediate processing layer responsible for cleaning, standardizing, and integrating data before it is consumed by downstream models.

Using `CREATE TABLE IF NOT EXISTS` allows the required table structures to be established while avoiding unnecessary recreation of tables during development and testing.

Since Silver tables may be inspected repeatedly for validation and troubleshooting, preserving the table definitions and intermediate datasets can be useful while iterating on transformation logic.

### Benefits

- Supports repeatable execution
- Reduces unnecessary table recreation
- Preserves intermediate datasets for validation
- Simplifies development and testing

---

## Why CTAS Was Used in Gold

### Decision

Use CTAS (Create Table As Select) when creating Gold-layer tables.

### Rationale

The Gold layer contains business-facing datasets that are derived entirely from the latest Silver-layer data.

Because Gold tables can always be regenerated from Silver, recreating them during execution ensures that the dimensional model remains aligned with the latest transformation logic and source data.

CTAS also combines table creation and data population into a single operation, making the modeling process simpler and easier to reproduce.

### Benefits

- Produces a clean analytical model
- Keeps Gold synchronized with Silver
- Simplifies reruns and maintenance
- Reduces implementation complexity

---

## Why a Full Refresh Strategy Was Appropriate

### Decision

Rebuild Gold tables from the latest Silver data during execution.

### Rationale

The Instacart dataset is static and the project focuses on demonstrating data engineering concepts rather than handling continuously arriving production data.

A full refresh approach prioritizes reproducibility, simplicity, and ease of validation.

Because the source data remains unchanged, rebuilding the Gold model produces predictable
