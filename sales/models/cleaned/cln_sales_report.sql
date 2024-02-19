with source as (
      select * from {{ source('staged', 'amazon_sale_report') }}
),
renamed as (
    select
        {{ adapter.quote("index") }},
        {{ adapter.quote("Order ID") }},
        {{ adapter.quote("Date") }},
        {{ adapter.quote("Status") }},
        {{ adapter.quote("Fulfilment") }},
        {{ adapter.quote("Sales Channel") }},
        {{ adapter.quote("ship-service-level") }},
        {{ adapter.quote("Style") }},
        {{ adapter.quote("SKU") }},
        {{ adapter.quote("Category") }},
        {{ adapter.quote("Size") }},
        {{ adapter.quote("ASIN") }},
        {{ adapter.quote("Courier Status") }},
        {{ adapter.quote("Qty") }},
        {{ adapter.quote("currency") }},
        {{ adapter.quote("Amount") }},
        {{ adapter.quote("ship-city") }},
        {{ adapter.quote("ship-state") }},
        {{ adapter.quote("ship-postal-code") }},
        {{ adapter.quote("ship-country") }},
        {{ adapter.quote("promotion-ids") }},
        {{ adapter.quote("B2B") }},
        {{ adapter.quote("fulfilled-by") }},
        {{ adapter.quote("Unnamed: 22") }}

    from source
)
select * from renamed
  