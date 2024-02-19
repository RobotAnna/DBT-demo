{{ config(schema='transformed') }}


-- IMPORT
with source as (
      select * from {{ source('cleaned', 'cln_sales_report') }}
),


-- CLEANING
renamed as (
    select *
    from source
)


-- CUSTOM


-- FINAL SELECT
select * from renamed
