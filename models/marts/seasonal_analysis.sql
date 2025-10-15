with monthly_metrics as (
    select 
        extract(year from ordered_at) as year,  -- ← FIXED: ordered_at not order_date
        extract(month from ordered_at) as month,
        date_trunc('month', ordered_at) as month_date,
        
        count(*) as total_orders,
        count(distinct customer_id) as unique_customers,
        sum(order_total) as total_revenue,
        avg(order_total) as avg_order_value,
        
        -- Seasonal indicators
        case 
            when extract(month from ordered_at) in (12, 1, 2) then 'Winter'
            when extract(month from ordered_at) in (3, 4, 5) then 'Spring'
            when extract(month from ordered_at) in (6, 7, 8) then 'Summer'
            else 'Fall'
        end as season
        
    from {{ ref('orders') }}
    group by year, month, month_date
),

year_over_year as (
    select 
        *,
        lag(total_revenue) over (partition by month order by year) as prev_year_revenue,
        lag(total_orders) over (partition by month order by year) as prev_year_orders,
        
        case 
            when lag(total_revenue) over (partition by month order by year) > 0 
            then ((total_revenue - lag(total_revenue) over (partition by month order by year))::float / 
                  lag(total_revenue) over (partition by month order by year)) * 100
            else null 
        end as revenue_yoy_growth,
        
        case 
            when lag(total_orders) over (partition by month order by year) > 0 
            then ((total_orders - lag(total_orders) over (partition by month order by year))::float / 
                  lag(total_orders) over (partition by month order by year)) * 100
            else null 
        end as orders_yoy_growth
        
    from monthly_metrics
)

select * from year_over_year
order by year, month