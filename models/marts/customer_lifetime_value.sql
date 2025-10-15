with customer_orders as (
    select 
        customer_id,
        ordered_at as order_date,  
        order_total,
        row_number() over (partition by customer_id order by ordered_at) as order_number
    from {{ ref('orders') }}
),

customer_metrics as (
    select 
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        count(*) as total_orders,
        sum(order_total) as total_spent,
        avg(order_total) as avg_order_value,
        max(order_total) as max_order_value,
        datediff('day', min(order_date), max(order_date)) as customer_lifespan_days
    from customer_orders
    group by customer_id
),

customer_segments as (
    select 
        *,
        case 
            when total_spent >= 5000 then 'High Value'
            when total_spent >= 2000 then 'Medium Value'
            when total_spent >= 1000 then 'Low Value'
            else 'New Customer'
        end as customer_segment,
        
        case 
            when total_orders >= 20 then 'Frequent Buyer'
            when total_orders >= 10 then 'Regular Buyer'
            when total_orders >= 5 then 'Occasional Buyer'
            else 'One-time Buyer'
        end as purchase_frequency_segment,
        
        case 
            when datediff('day', last_order_date, current_date()) <= 30 then 'Active'
            when datediff('day', last_order_date, current_date()) <= 90 then 'At Risk'
            when datediff('day', last_order_date, current_date()) <= 180 then 'Dormant'
            else 'Churned'
        end as customer_status
        
    from customer_metrics
)

select * from customer_segments