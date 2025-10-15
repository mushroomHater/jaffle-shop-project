with product_orders as (
    select 
        p.product_id,  
        p.product_name,
        p.product_type,
        p.product_price,
        oi.order_id,
        o.ordered_at as order_date,
        o.order_total
    from {{ ref('products') }} p
    join {{ ref('order_items') }} oi on p.product_id = oi.product_id  
    join {{ ref('orders') }} o on oi.order_id = o.order_id
),

product_metrics as (
    select 
        product_id,  
        product_name,
        product_type,
        product_price,
        count(distinct order_id) as total_orders,
        count(distinct order_date) as days_sold,
        sum(case when order_total > 0 then 1 else 0 end) as successful_orders,
        
        -- Revenue metrics
        sum(order_total) as total_revenue,
        avg(order_total) as avg_order_value,
        
        -- Time metrics
        min(order_date) as first_sold_date,
        max(order_date) as last_sold_date,
        datediff('day', min(order_date), max(order_date)) as sales_period_days,
        
        -- Performance metrics
        count(distinct order_id)::float / 
        nullif(datediff('day', min(order_date), max(order_date)), 0) as orders_per_day
        
    from product_orders
    group by product_id, product_name, product_type, product_price
),

product_rankings as (
    select 
        *,
        rank() over (order by total_orders desc) as order_rank,
        rank() over (order by total_revenue desc) as revenue_rank,
        
        case 
            when order_rank <= 3 then 'Top Performer'
            when order_rank <= 10 then 'Strong Performer'
            when order_rank <= 20 then 'Average Performer'
            else 'Low Performer'
        end as performance_tier
        
    from product_metrics
)

select * from product_rankings