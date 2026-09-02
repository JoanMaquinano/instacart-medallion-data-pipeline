# Business Questions

## Overview

The dimensional model was designed to support exploratory analysis of customer purchasing behavior, product demand, and ordering patterns within the Instacart dataset.

This document identifies the primary business questions the model can answer and the tables required for each analysis.

---

## Question 1

### Which Products Are Purchased Most Frequently?

#### Business Value

Identifying the most frequently purchased products helps stakeholders understand customer demand and product popularity.

This insight can support:

- Inventory planning
- Product recommendations
- Marketing campaigns
- Product assortment decisions

#### Tables Used

```text
Fact_Order
Dim_Product
```

#### Example Metrics

- Total purchases by product
- Top-selling products
- Product purchase rankings
- Product purchase share

---

## Question 2

### Which Departments Generate the Most Purchases?

#### Business Value

Understanding department performance highlights which product categories drive the largest share of customer purchases.

This insight can support:

- Category management
- Merchandising decisions
- Promotional planning
- Department-level reporting

#### Tables Used

```text
Fact_Order
Dim_Product
```

#### Example Metrics

- Total purchases by department
- Department rankings
- Department contribution to overall purchases
- Product mix within departments

---

## Question 3

### How Does Purchasing Behavior Change by Day of Week?

#### Business Value

Analyzing ordering patterns by day helps identify customer shopping habits and peak purchasing periods.

This insight can support:

- Workforce planning
- Marketing scheduling
- Promotional timing
- Demand forecasting

#### Tables Used

```text
Fact_Order
Dim_Order_Time
```

#### Example Metrics

- Orders by day of week
- Purchase volume by day
- Peak shopping days
- Average purchases per day

---

## Question 4

### How Does Purchasing Behavior Change by Hour of Day?

#### Business Value

Understanding hourly purchasing trends provides visibility into customer activity throughout the day.

This insight can support:

- Operational planning
- Marketing strategy
- Delivery scheduling
- Peak-hour identification

#### Tables Used

```text
Fact_Order
Dim_Order_Time
```

#### Example Metrics

- Orders by hour
- Purchase volume by hour
- Peak ordering hours
- Hourly purchase distribution

---

## Question 5

### Which Products Have the Highest Reorder Rates?

#### Business Value

Products with high reorder rates often indicate customer loyalty, recurring demand, or essential household items.

This insight can support:

- Customer retention strategies
- Product recommendation engines
- Demand planning
- Product performance analysis

#### Tables Used

```text
Fact_Order
Dim_Product
```

#### Example Metrics

- Reorder rate by product
- Most reordered products
- Reorder rankings
- Reorder
