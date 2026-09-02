# Project Context

## Overview

The Instacart Online Grocery Shopping Dataset contains customer order history, product information, aisle classifications, and department classifications. The data is distributed across multiple source files and represents transactional grocery purchases made through the Instacart platform.

The dataset was originally designed for the Instacart Market Basket Analysis competition, where the objective was to predict which products a customer would reorder in their next purchase. As a result, the source data contains datasets intended for machine learning workflows as well as transactional analysis.

This project approaches the dataset from a data engineering perspective rather than a machine learning perspective.

---

## Project Objective

The goal of this project is to design and implement an end-to-end ETL pipeline using Databricks and Medallion Architecture.

Instead of using the source files directly for analysis, the pipeline transforms raw transactional data into analytics-ready datasets that are easier to query, validate, and maintain.

The project demonstrates how raw source data can move through multiple data layers before being delivered as trusted business-ready tables.

---

## Source Dataset

The source dataset consists of six primary files:

```text
orders
order_products__prior
order_products__train
products
aisles
departments
```

Each dataset serves a different purpose:

### orders

Contains order-level information such as:

- Customer identifier
- Order sequence number
- Day of week
- Hour of day
- Days since prior order

### order_products__prior

Contains products purchased in customers' historical orders.

### order_products__train

Contains products purchased in customers' most recent labeled order.

### products

Contains product-level information.

### aisles

Contains aisle classifications.

### departments

Contains department classifications.

Together, these files describe customer purchasing activity and product hierarchy information.

---

## Business Requirements

The project was designed to support the following business questions:

### 1. Which products are purchased most frequently?

Understanding product popularity helps identify customer preferences and high-demand items.

### 2. Which departments generate the highest number of purchases?

Department-level analysis provides insight into purchasing trends across product categories.

### 3. How does purchasing behavior vary by day of week and hour of day?

Analyzing purchasing activity over time helps identify customer shopping patterns.

### 4. Which products have the highest reorder rates?

Reorder behavior helps identify products that customers repeatedly purchase.

---

## Target Data Model

A dimensional model was provided as the target business requirement.

The final analytical model consists of:
