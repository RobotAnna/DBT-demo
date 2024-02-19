{{ config(schema='transformed') }}


-- IMPORT
WITH source AS (
    SELECT
        date_day,
        day_of_week,
        day_of_week_name,
        day_of_week_name_short,
        day_of_month,
        day_of_year,
        week_of_year,
        month_of_year,
        month_name,
        month_name_short,
        quarter_of_year,
        year_number
    FROM {{ ref('all_dates') }}
),


-- CLEANING
renamed AS (
    SELECT
        CONCAT(year_number, LPAD(month_of_year::text, 2, '0'), LPAD(day_of_month::text, 2, '0'))  AS DATE_KEY,
        sc.date_day,
        sc.day_of_week,
        sc.day_of_week_name,
        sc.day_of_week_name_short,
        sc.day_of_month,
        sc.day_of_year,
        sc.week_of_year,
        sc.month_of_year,
        sc.month_name,
        sc.month_name_short,
        sc.quarter_of_year,
        sc.year_number,
        CURRENT_DATE                                    AS LOAD_DATE
    FROM source sc
)


-- CUSTOM
-- (Not required)


-- FINAL SELECT
select * from renamed
