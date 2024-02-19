{{ config(schema='transformed') }}


-- IMPORT
WITH source AS (
    SELECT DISTINCT 
       order_status,
       order_sub_status
    FROM {{ source('cleaned', 'cln_sales_report') }}
),


-- CLEANING
renamed AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY order_status, order_sub_status) AS ORDER_STATUS_ID,
        sc.order_status                                             AS ORDER_STATUS,
        sc.order_sub_status                                         AS ORDER_SUB_STATUS,
        CURRENT_DATE                                                AS LOAD_DATE
    FROM source sc
)


-- CUSTOM
-- (Not required)


-- FINAL SELECT
select * from renamed
