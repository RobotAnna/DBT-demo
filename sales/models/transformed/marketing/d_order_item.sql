{{ config(schema='transformed') }}


-- IMPORT
WITH source AS (
    SELECT DISTINCT 
       order_id, 
       quantity, 
       currency, 
       amount, 
       sku, 
       asin
    FROM {{ source('cleaned', 'cln_sales_report') }}    
),


-- CLEANING
renamed AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY sc.order_id, pr.product_id) AS ORDER_ITEM_ID,
        sc.order_id                                             AS ORDER_ID, 
        sc.quantity                                             AS QUANTITY, 
        sc.currency                                             AS CURRENCY, 
        sc.amount                                               AS AMOUNT, 
        pr.product_id                                           AS PRODUCT_ID,
        CURRENT_DATE                                            AS LOAD_DATE
    FROM source sc
    LEFT OUTER JOIN {{ source('transformed', 'd_product') }} pr ON sc.sku = pr.sku AND sc.asin = pr.asin
)


-- CUSTOM
-- (Not required)


-- FINAL SELECT
select * from renamed
