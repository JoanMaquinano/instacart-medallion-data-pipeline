-- Dim_products validation
/*
Validation

Expected:
- source_count = dim_count
- duplicate_product_ids = 0
- unmatched_aisle_records = 0
- unmatched_department_records = 0
*/

SELECT
    (SELECT COUNT(*)
     FROM instacart.instacart_clean.products_clean) AS source_count,

    (SELECT COUNT(*)
     FROM instacart.instacart_gold.dim_products) AS dim_count,

    (SELECT COUNT(*)
     FROM (
         SELECT product_id
         FROM instacart.instacart_gold.dim_products
         GROUP BY product_id
         HAVING COUNT(*) > 1
     )) AS duplicate_product_ids,

    (SELECT COUNT(*)
     FROM instacart.instacart_gold.dim_products
     WHERE aisle_id IS NULL) AS unmatched_aisle_records,

    (SELECT COUNT(*)
     FROM instacart.instacart_gold.dim_products
     WHERE department_id IS NULL) AS unmatched_department_records;


/*
Since this dimension uses SCD Type 1,
historical versions are not retained.

Each product_id should have exactly one current record.

The clean aisles and departments tables enforce:
- No duplicate business keys
- No NULL IDs
- No NULL names
- No blank names
- No non-positive IDs

These rules help ensure referential consistency when building DimProducts.
*/
