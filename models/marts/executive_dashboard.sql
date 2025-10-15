with monthly_metrics as (
    select 
        date_trunc('month', ordered_at) as month,
        count(*) as total_orders,
        count(distinct customer_id) as unique_customers,
        sum(order_total) as total_revenue,
        avg(order_total) as avg_order_value
    from {{ ref('orders') }}
    group by month
),

quarterly_metrics as (
    select 
        date_trunc('quarter', ordered_at) as quarter,
        count(*) as total_orders,
        count(distinct customer_id) as unique_customers,
        sum(order_total) as total_revenue,
        avg(order_total) as avg_order_value
    from {{ ref('orders') }}
    group by quarter
),

yearly_metrics as (
    select 
        extract(year from ordered_at) as year,
        count(*) as total_orders,
        count(distinct customer_id) as unique_customers,
        sum(order_total) as total_revenue,
        avg(order_total) as avg_order_value
    from {{ ref('orders') }}
    group by year
),

executive_summary as (
    select 
        'Monthly' as period_type,
        month::date as period_date,
        total_orders,
        unique_customers,
        total_revenue,
        avg_order_value,
        total_revenue / nullif(unique_customers, 0) as revenue_per_customer
    from monthly_metrics
    
    union all
    
    select 
        'Quarterly' as period_type,
        quarter::date as period_date,
        total_orders,
        unique_customers,
        total_revenue,
        avg_order_value,
        total_revenue / nullif(unique_customers, 0) as revenue_per_customer
    from quarterly_metrics
    
    union all
    
    select 
        'Yearly' as period_type,
        date_from_parts(year, 1, 1) as period_date,
        total_orders,
        unique_customers,
        total_revenue,
        avg_order_value,
        total_revenue / nullif(unique_customers, 0) as revenue_per_customer
    from yearly_metrics
)

select * from executive_summary
order by period_type, period_date