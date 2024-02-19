{{ config(schema='transformed') }}


-- IMPORT
WITH source AS (
    SELECT DISTINCT 
        ship_city, 
        ship_state, 
        ship_state_initials, 
        ship_postal_code, 
        ship_country
    FROM {{ source('cleaned', 'cln_sales_report') }}
),


-- CLEANING
renamed AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY ship_postal_code, ship_city) AS ADDRESS_ID,
        sc.ship_city                                             AS CITY,
        sc.ship_state                                            AS STATE_NAME,
        sc.ship_state_initials                                   AS STATE_INITIALS,
        sc.ship_postal_code                                      AS POSTAL_CODE,
        sc.ship_country                                          AS COUNTRY,
        CURRENT_DATE                                             AS LOAD_DATE
    FROM source sc
)


-- CUSTOM
-- (Not required)


-- FINAL SELECT
select * from renamed
