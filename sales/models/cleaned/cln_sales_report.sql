{{ config(schema='cleaned') }}


-- IMPORT
with source as (
      select * from {{ source('staged', 'amazon_sale_report') }}
),


-- CLEANING
-- Rename columns, populate nulls, derive product color, normalize shipping state
cleaned AS (
    SELECT
        sc.index                                                        AS ORDER_INDEX,
        sc."Order ID"                                                   AS ORDER_ID,
        to_date(sc."Date", 'mm-dd-yy')                                  AS ORDER_DATE,
        SPLIT_PART(sc."Status", ' - ',1)                                AS ORDER_STATUS,
        SPLIT_PART(sc."Status", ' - ',2)                                AS ORDER_SUB_STATUS,
        sc."Fulfilment"                                                 AS FULFILMENT,
        sc."Sales Channel"                                              AS SALES_CHANNEL,
        sc."ship-service-level"                                         AS SHIP_SERVICE_LEVEL,
        sc."Style"                                                      AS PRODUCT_STYLE,
        sc."SKU"                                                        AS SKU,
        sc."Category"                                                   AS PRODUCT_CATEGORY,
        sc."Size"                                                       AS PRODUCT_SIZE,
        pc.color                                                        AS PRODUCT_COLOR,
        sc."ASIN"                                                       AS ASIN,
        COALESCE(sc."Courier Status", SPLIT_PART(sc."Status", ' - ',1)) AS COURIER_STATUS, /* if empty then derive from order status */
        sc."Qty"                                                        AS QUANTITY,
        COALESCE(sc."currency", 'INR')                                  AS CURRENCY,
        COALESCE(sc."Amount", 0)                                        AS AMOUNT,
        UPPER(sc."ship-city")                                           AS SHIP_CITY,
        CASE
            WHEN UPPER(sc."ship-state") = 'ANDAMAN & NICOBAR '      THEN 'ANDAMAN AND NICOBAR ISLANDS'
            WHEN UPPER(sc."ship-state") = 'APO'                     THEN 'ANDHRA PRADESH'
            WHEN UPPER(sc."ship-state") = 'AR'                      THEN 'ARUNACHAL PRADESH'
            WHEN UPPER(sc."ship-state") = 'DADRA AND NAGAR'         THEN 'MAHARASHTRA'
            WHEN UPPER(sc."ship-state") = 'JAMMU & KASHMIR'         THEN 'JAMMU AND KASHMIR'
            WHEN UPPER(sc."ship-state") = 'NEW DELHI'               THEN 'DELHI'
            WHEN UPPER(sc."ship-state") = 'NL'                      THEN 'NAGALAND'
            WHEN UPPER(sc."ship-state") = 'PB'                      THEN 'PUNJAB'
            WHEN UPPER(sc."ship-state") = 'PUNJAB/MOHALI/ZIRAKPUR'  THEN 'PUNJAB'
            WHEN UPPER(sc."ship-state") = 'PONDICHERRY'             THEN 'PUDUCHERRY'
            WHEN UPPER(sc."ship-state") = 'RAJSHTHAN'               THEN 'RAJASTHAN'
            WHEN UPPER(sc."ship-state") = 'RAJSTHAN'                THEN 'RAJASTHAN'
            WHEN UPPER(sc."ship-state") = 'RJ'                      THEN 'RAJASTHAN'
            WHEN UPPER(sc."ship-state") = 'ORISSA'                  THEN 'ODISHA'
            ELSE UPPER(st.state_name)
        END                                                             AS SHIP_STATE,
        CASE
            WHEN UPPER(sc."ship-state") = 'ANDAMAN & NICOBAR '      THEN 'AN'
            WHEN UPPER(sc."ship-state") = 'APO'                     THEN 'AP'
            WHEN UPPER(sc."ship-state") = 'AR'                      THEN 'AR'
            WHEN UPPER(sc."ship-state") = 'DADRA AND NAGAR'         THEN 'DH'
            WHEN UPPER(sc."ship-state") = 'JAMMU & KASHMIR'         THEN 'JK'
            WHEN UPPER(sc."ship-state") = 'NEW DELHI'               THEN 'DL'
            WHEN UPPER(sc."ship-state") = 'NL'                      THEN 'NL'
            WHEN UPPER(sc."ship-state") = 'ORISSA'                  THEN 'OD'
            WHEN UPPER(sc."ship-state") = 'PB'                      THEN 'PB'
            WHEN UPPER(sc."ship-state") = 'PONDICHERRY'             THEN 'PY'
            WHEN UPPER(sc."ship-state") = 'PUNJAB/MOHALI/ZIRAKPUR'  THEN 'PB'
            WHEN UPPER(sc."ship-state") = 'RAJSHTHAN'               THEN 'RJ'
            WHEN UPPER(sc."ship-state") = 'RAJSTHAN'                THEN 'RJ'
            WHEN UPPER(sc."ship-state") = 'RJ'                      THEN 'RJ'
            ELSE st.state_initials
        END                                                             AS SHIP_STATE_INITIALS,
        sc."ship-postal-code"                                           AS SHIP_POSTAL_CODE,
        COALESCE(sc."ship-country", 'IN')                               AS SHIP_COUNTRY,
        sc."promotion-ids"                                              AS PROMOTION_IDS,
        sc."B2B"                                                        AS B2B,
        sc."fulfilled-by"                                               AS FULFILLED_BY

    FROM source sc
    LEFT OUTER JOIN {{ ref('product_catalog') }} pc ON pc.sku_code          = sc."SKU"
    LEFT OUTER JOIN {{ ref('indian_states') }}   st ON UPPER(st.state_name) = UPPER(sc."ship-state")
)


-- CUSTOM LOGIC
-- (not required)


-- FINAL SELECT
SELECT * FROM cleaned
