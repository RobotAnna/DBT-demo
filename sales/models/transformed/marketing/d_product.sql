{{ config(schema='transformed') }}


-- IMPORT
WITH source AS (
    SELECT DISTINCT 
       sku, 
       product_style, 
       product_category, 
       product_size, 
       product_color, 
       asin
    FROM {{ source('cleaned', 'cln_sales_report') }}
),


-- CLEANING
renamed AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY sku, asin)  AS PRODUCT_ID,
        sc.sku                                  AS SKU,
        sc.product_style                        AS PRODUCT_STYLE,
        sc.product_category                     AS PRODUCT_CATEGORY,
        sc.product_size                         AS PRODUCT_SIZE,
        sc.product_color                        AS PRODUCT_COLOR,
        sc.asin                                 AS ASIN,
        CURRENT_DATE                            AS LOAD_DATE
    FROM source sc
)


-- CUSTOM
-- (Not required)


-- FINAL SELECT
select * from renamed
