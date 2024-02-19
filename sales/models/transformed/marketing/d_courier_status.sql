{{ config(schema='transformed') }}


-- IMPORT
WITH source AS (
    SELECT DISTINCT 
       courier_status
    FROM {{ source('cleaned', 'cln_sales_report') }}
),


-- CLEANING
renamed AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY courier_status) AS COURIER_STATUS_ID,
        sc.courier_status                           AS COURIER_STATUS,
        CURRENT_DATE                                AS LOAD_DATE
    FROM source sc
)


-- CUSTOM
-- (Not required)


-- FINAL SELECT
select * from renamed
