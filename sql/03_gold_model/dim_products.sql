/*
Purpose: Create the DimProducts dimension table for reporting and analysis.

SCD Type: Type 1 (Overwrite)

Reason:
- Product attributes rarely change.
- Historical tracking is not required for this project.
- The latest product attributes always overwrite previous values.
- Future changes can be handled through MERGE operations if CDC becomes available.

MERGE / UPSERT Strategy:
- This project uses a full-refresh approach with CREATE OR REPLACE TABLE
  rather than a MERGE statement.
- The dataset is small and static.
- SCD Type 1 is implemented.
- Rebuilding the dimension is simpler and more cost-effective for this
  portfolio project.

Backfill Approach:
- Perform a full load from the cleaned products, aisles, and departments tables.

Future Change Handling:
- New products are inserted.
- Existing products are updated using Type 1 overwrite logic.

Attribute Normalization:
- Product names are standardized using TRIM() and INITCAP().
- This removes leading/trailing spaces and applies consistent capitalization.
- Canonicalization ensures similar values are represented consistently in reporting.

Example:
' organic bananas ' -> 'Organic Bananas'
'ORGANIC BANANAS' -> 'Organic Bananas'

Missing Foreign Key Handling:
- LEFT JOINs are used to preserve all product records.
- Clean dimension tables enforce data quality by removing invalid business keys,
  null values, blank names, and duplicate keys.
- Any unmatched aisle_id or department_id values can be identified through
  validation queries.
*/

-- Create DimProducts
CREATE OR REPLACE TABLE instacart.instacart_gold.dim_products AS

SELECT
    p.product_id,
    INITCAP(TRIM(p.product_name)) AS product_name,

    a.aisle_id,
    a.aisle_name AS aisle,

    d.department_id,
    d.department AS department

FROM instacart.instacart_clean.products_clean p

LEFT JOIN instacart.instacart_clean.aisles_clean a
    ON p.aisle_id = a.aisle_id

LEFT JOIN instacart.instacart_clean.departments_clean d
    ON p.department_id = d.department_id;



