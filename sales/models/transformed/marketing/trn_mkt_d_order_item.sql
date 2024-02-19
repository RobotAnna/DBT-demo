with source as (
      select * from {{ source('cleaned', 'd_order_item') }}
),
renamed as (
    select
        

    from source
)
select * from renamed
  