with source as (
      select * from {{ source('cleaned', 'd_product') }}
),
renamed as (
    select
        

    from source
)
select * from renamed
  