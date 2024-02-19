-- IMPORT
with source as (
      select * from {{ source('staged', 'amazon_sale_report') }}
),
select * from {{ ref('Indian_States') }}
;

/*
-- CLEANING

cleaned as (
    select
        {{ adapter.quote("index") }} AS ORDER_INDEX,
        {{ adapter.quote("Order ID") }} AS ORDER_ID,
        {{ adapter.quote("Date") }} AS ORDER_DATE,
        SPLIT_PART({{ adapter.quote("Status") }}, ' - ',1) AS ORDER_STATUS,
        SPLIT_PART({{ adapter.quote("Status") }}, ' - ',2) AS ORDER_SUB_STATUS,
        {{ adapter.quote("Fulfilment") }} AS FULFILMENT,
        {{ adapter.quote("Sales Channel") }} AS SALES_CHANNEL,
        {{ adapter.quote("ship-service-level") }} AS SHIP_SERVICE_LEVEL,
        {{ adapter.quote("Style") }} AS PRODUCT_STYLE,
        {{ adapter.quote("SKU") }} AS SKU,
        {{ adapter.quote("Category") }} AS PRODUCT_CATEGORY,
        {{ adapter.quote("Size") }} AS PRODUCT_SIZE,
        {{ adapter.quote("ASIN") }} AS ASIN,
        {{ adapter.quote("Courier Status") }} AS COURIER_STATUS,
        {{ adapter.quote("Qty") }} AS QUANTITY,
        {{ adapter.quote("currency") }} AS CURRENCY,
        {{ adapter.quote("Amount") }} AS AMOUNT,
        {{ adapter.quote("ship-city") }} AS SHIP_CITY,
        {{ adapter.quote("ship-state") }} AS SHIP_STATE,
        {{ adapter.quote("ship-postal-code") }} AS SHIP_POSTAL_CODE,
        {{ adapter.quote("ship-country") }} AS SHIP_COUNTRY,
        {{ adapter.quote("promotion-ids") }} AS PROMOTION_IDS,
        {{ adapter.quote("B2B") }} AS B2B,
        {{ adapter.quote("fulfilled-by") }} AS FULFILLED_BY

    from source
)

-- CUSTOM LOGIC

-- FINAL CTE


select * from renamed
*/