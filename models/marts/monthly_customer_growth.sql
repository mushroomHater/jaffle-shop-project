with monthly_customers as (
    select 
        date_trunc('month', ordered_at) as month,
        count(distinct customer_id) as unique_customers,
        count(*) as total_orders,
        sum(order_total) as total_revenue,
        avg(order_total) as avg_order_value
    from {{ ref('orders') }}
    group by month
    order by month
),

monthly_growth as (
    select 
        *,
        lag(unique_customers) over (order by month) as prev_month_customers,
        lag(total_revenue) over (order by month) as prev_month_revenue,
        
        case 
            when lag(unique_customers) over (order by month) > 0 
            then ((unique_customers - lag(unique_customers) over (order by month))::float / 
                  lag(unique_customers) over (order by month)) * 100
            else null 
        end as customer_growth_rate,
        
        case 
            when lag(total_revenue) over (order by month) > 0 
            then ((total_revenue - lag(total_revenue) over (order by month))::float / 
                  lag(total_revenue) over (order by month)) * 100
            else null 
        end as revenue_growth_rate
        
    from monthly_customers
)

select * from monthly_growth