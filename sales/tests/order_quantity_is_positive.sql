with order_item as (
    select * from {{ source('transformed', 'd_order_item') }} 
)

select sum(quantity)
from order_item
group by order_id
having sum(quantity) < 0