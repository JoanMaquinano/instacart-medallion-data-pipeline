# Data Dictionary

## Overview

This document defines the business purpose, grain, and attributes of the Gold-layer tables.

The Gold layer represents the final analytics-ready dimensional model used for reporting and business analysis.

---

# Fact_Order

## Description

Stores transactional purchase events and serves as the central fact table in the star schema.

Each record represents a product purchased within a specific order.

## Grain

One product purchased within one order.

## Source

```text
clean_order_merge
```

## Primary Key

```text
order_id + product_id
```

## Foreign Keys

```text
user_id          → Dim_User
product_id       → Dim_Product
order_id         → Dim_Order_Time
```

## Columns

### order_id

Unique identifier for an order.

---

### user_id

Unique identifier for a customer.

---

### product_id

Unique identifier for a purchased product.

---

### add_to_cart_order

Position of the product in the customer's cart during checkout.

Lower numbers indicate products added earlier.

---

### reordered

Indicator showing whether the product had been purchased previously by the customer.

Values:

```text
0 = First-time purchase
1 = Reordered purchase
```

---

# Dim_Product

## Description

Stores descriptive product information used for product, aisle, and department analysis.

## Grain

One record per product.

## Source

```text
clean_products
```

## Primary Key

```text
product_id
```

## Columns

### product_id

Unique identifier for a product.

---

### product_name

Name of the product.

---

### aisle_id

Identifier for the aisle associated with the product.

---

### department_id

Identifier for the department associated with the product.

---

### aisle

Name of the aisle associated with the product.

---

### department

Name of the department associated with the product.

---

## Business Purpose

Supports analysis such as:

- Product popularity
- Product performance
- Aisle performance
- Department performance
- Reorder behavior by product

---

# Dim_User

## Description

Stores customer identifiers used for customer-level analysis.

## Grain

One record per customer.

## Source

```text
clean_orders
```

## Primary Key

```text
user_id
```

## Columns

### user_id

Unique identifier for a customer.

---

## Business Purpose

Supports analysis such as:

- Customer purchasing activity
- Customer order frequency
- Customer segmentation
- User-level behavioral trends

---

# Dim_Order_Time

## Description

Stores order timing attributes used for time-based analysis.

## Grain

One record per order.

## Source

```text
clean_orders
```

## Primary Key

```text
order_id
```

## Columns

### order_id

Unique identifier for an order.

---

### order_number

Sequence number of the order for the customer.

Example:

```text
1 = First order
2 = Second order
3 = Third order
```

---

### order_dow

Day of week on which the order was placed.

---

### order_hour_of_day

Hour of day when the order was placed.

Values range from:

```text
0 - 23
```

---

### days_since_prior_order

Number of days since the customer's previous order.

Null values typically occur for a customer's first order.

---

## Business Purpose

Supports analysis such as:

- Purchasing behavior by weekday
- Purchasing behavior by hour
- Order frequency analysis
- Customer shopping patterns

---

# Entity Relationship Summary

```text
                    Dim_Order_Time
                           │
                           │
Dim_User ───── Fact_Order ───── Dim_Product
```

---

# Business Definitions

## Purchase

A product included in a completed customer order.

Represented by:

```text
Fact_Order
```

---

## Reorder

A product that has been purchased previously by the same customer.

Represented by:

```text
reordered = 1
```

---

## Customer

An individual Instacart user who places orders.

Represented by:

```text
Dim_User
```

---

## Product

An item available for purchase through Instacart.

Represented by:

```text
Dim_Product
```

---

## Order

A completed shopping transaction containing one or more products.

Represented by:

```text
Fact_Order
Dim_Order_Time
```

---

# Analytical Use Cases

The model supports:

### Product Analysis

- Most purchased products
- Most reordered products
- Product rankings

### Department Analysis

- Department purchase volume
- Department performance comparisons
- Category-level trends

### Time Analysis

- Orders by day of week
- Orders by hour of day
- Peak purchasing periods
