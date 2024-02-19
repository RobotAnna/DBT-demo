{{ config(schema='transformed') }}


-- IMPORT
WITH source AS (
    SELECT DISTINCT
        order_id,
        order_date,
        order_status, 
        order_sub_status,
        ship_city, 
        ship_state, 
        ship_postal_code,
        sales_channel, 
        fulfilment, 
        ship_service_level, 
        courier_status, 
        promotion_ids, 
        b2b, 
        fulfilled_by
    FROM {{ source('cleaned', 'cln_sales_report') }}
),


-- JOIN
joined AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY sc.order_id) AS ORDER_INDEX,
        sc.order_id                              AS ORDER_ID, 
        sc.order_date                            AS ORDER_DATE, 
        os.order_status_id                       AS ORDER_STATUS_ID,
        ad.address_id                            AS SHIPPING_ADDRESS_ID,
        sc.sales_channel                         AS SALES_CHANNEL,
        sc.fulfilment                            AS FULFILMENT,
        sc.ship_service_level                    AS SHIP_SERVICE_LEVEL,
        cs.courier_status_id                     AS COURIER_STATUS_ID,
        sc.promotion_ids                         AS PROMOTION_IDS,
        sc.b2b                                   AS B2B,
        sc.fulfilled_by                          AS FULFILLED_BY,
        CURRENT_DATE                             AS LOAD_DATE
    FROM source sc
    LEFT OUTER JOIN {{ source('transformed', 'd_address') }}        ad ON sc.ship_city = ad.city AND sc.ship_state = ad.state_name AND sc.ship_postal_code = ad.postal_code
    LEFT OUTER JOIN {{ source('transformed', 'd_courier_status') }} cs ON sc.courier_status = cs.courier_status
    LEFT OUTER JOIN {{ source('transformed', 'd_order_status') }}   os ON sc.order_status = os.order_status AND sc.order_sub_status = os.order_sub_status
)


-- CUSTOM
-- (Not required)


-- FINAL SELECT
select * from joined
