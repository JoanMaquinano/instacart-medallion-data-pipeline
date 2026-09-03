-- Validation Summary
SELECT
    (SELECT COUNT(*) FROM instacart.instacart_bronze.aisles_bronze) AS bronze_row_count,
    (SELECT COUNT(*) FROM instacart.instacart_silver.aisles_silver) AS clean_row_count,


    (SELECT COUNT(*)
     FROM (
         SELECT aisle_id
         FROM instacart.instacart_silver.aisles_silver
         GROUP BY aisle_id
         HAVING COUNT(*) > 1
     )) AS duplicate_aisle_ids,


    (SELECT COUNT(*)
     FROM instacart.instacart_silver.aisles_silver
     WHERE aisle_id IS NULL) AS null_aisle_ids,


    (SELECT COUNT(*)
     FROM instacart.instacart_silver.aisles_silver
     WHERE aisle_name IS NULL) AS null_aisle_names,


    (SELECT COUNT(*)
     FROM instacart.instacart_silver.aisles_silver
     WHERE TRIM(aisle_name) = '') AS blank_aisle_names,


    (SELECT COUNT(*)
     FROM instacart.instacart_silver.aisles_silver
     WHERE aisle_id <= 0) AS invalid_aisle_ids,


    (SELECT COUNT(DISTINCT aisle_id)
     FROM instacart.instacart_bronze.aisles_bronze) AS bronze_distinct_aisles,


    (SELECT COUNT(DISTINCT aisle_id)
FROM instacart.instacart_silver.aisles_silver) AS clean_distinct_aisles;
