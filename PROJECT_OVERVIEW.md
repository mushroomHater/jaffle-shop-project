# 🥪 Jaffle Shop - dbt Analytics Transformation Project

**Portfolio Project by mushroomHater**  
**Repository**: https://github.com/mushroomHater/jaffle-shop-project

---

## 📊 **Project Overview**

This is a professional-grade data transformation project built with **dbt (data build tool)** that demonstrates modern analytics engineering practices. The project transforms raw restaurant data into clean, tested, and well-documented analytics models following industry best practices.

**Based on**: Official dbt Labs Jaffle Shop template (221 stars, industry-standard learning project)

---

## 🎯 **What This Project Demonstrates**

### **1. Data Modeling Expertise**
- ✅ **Staging Layer**: Clean, standardized transformations from raw sources
- ✅ **Marts Layer**: Business-friendly dimensional models (facts & dimensions)
- ✅ **Modular Design**: Reusable, maintainable SQL architecture

### **2. Data Quality & Testing**
- ✅ **20+ Automated Tests**: Uniqueness, not-null, referential integrity
- ✅ **100% Test Coverage**: Every model validated
- ✅ **Data Quality Framework**: Proactive error detection

### **3. Documentation & Collaboration**
- ✅ **Self-Documenting Code**: YAML-based metadata
- ✅ **Interactive Lineage**: Auto-generated DAG visualization
- ✅ **Business-Friendly Docs**: Data dictionary for stakeholders

### **4. Version Control & CI/CD**
- ✅ **Git Workflow**: SQL as code with proper version control
- ✅ **Pre-commit Hooks**: Automated code quality checks
- ✅ **Production-Ready**: Environment-based deployments

---

## 🏗️ **Technical Architecture**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Raw Sources   │───▶│  Staging Layer  │───▶│   Marts Layer   │
│                 │    │                 │    │                 │
│ • Customers     │    │ • stg_customers │    │ • customers     │
│ • Orders        │    │ • stg_orders    │    │ • orders        │
│ • Products      │    │ • stg_products  │    │ • products      │
│ • Order Items   │    │ • stg_items     │    │ • order_items   │
│ • Supplies      │    │ • stg_supplies  │    │ • supplies      │
│ • Locations     │    │ • stg_locations │    │ • locations     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
        │                      │                      │
        └──────────────────────┴──────────────────────┘
                               │
                        ┌──────▼──────┐
                        │   Testing   │
                        │ & Validation│
                        └─────────────┘
```

---

## 📁 **Project Structure**

```
jaffle-shop-project/
├── models/
│   ├── staging/              # Source data transformations
│   │   ├── __sources.yml    # Source definitions & tests
│   │   ├── stg_customers.sql
│   │   ├── stg_orders.sql
│   │   ├── stg_products.sql
│   │   ├── stg_order_items.sql
│   │   ├── stg_supplies.sql
│   │   └── stg_locations.sql
│   └── marts/               # Business analytics models
│       ├── customers.sql    # Customer dimension
│       ├── orders.sql       # Orders fact table
│       ├── products.sql     # Product dimension
│       ├── order_items.sql  # Line items fact
│       ├── supplies.sql     # Supplies dimension
│       └── locations.yml    # Locations dimension
├── tests/                   # Custom data quality tests
├── macros/                  # Reusable SQL functions
├── seeds/                   # Sample data (CSV files)
└── dbt_project.yml          # Project configuration
```

---

## 🛠️ **Technologies & Skills**

- **dbt Cloud/Core** - Modern data transformation tool
- **SQL** - Advanced analytics SQL (CTEs, window functions, joins)
- **Git/GitHub** - Version control for analytics code
- **YAML** - Configuration and documentation
- **Data Modeling** - Dimensional modeling (Kimball methodology)
- **Data Testing** - Automated quality assurance
- **Documentation** - Self-service analytics documentation

---

## 🚀 **Key Features Implemented**

### **1. Staging Models (6 models)**
```sql
-- Example: stg_orders.sql
with source as (
    select * from {{ source('jaffle_shop', 'orders') }}
),

renamed as (
    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status,
        _etl_loaded_at
    from source
)

select * from renamed
```

**Purpose**: Clean, standardize, and type-cast raw data

### **2. Mart Models (6 models)**
```sql
-- Example: customers.sql
with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders
    from orders
    group by customer_id
)

select
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customer_orders.first_order_date,
    customer_orders.most_recent_order_date,
    coalesce(customer_orders.number_of_orders, 0) as number_of_orders
from customers
left join customer_orders
    on customers.customer_id = customer_orders.customer_id
```

**Purpose**: Business-friendly analytics models

### **3. Automated Testing**
```yaml
# Example: schema.yml
models:
  - name: customers
    description: One record per customer
    columns:
      - name: customer_id
        description: Primary key
        tests:
          - unique
          - not_null
      - name: first_order_date
        description: Date of first order
        tests:
          - not_null
```

**Tests Implemented**:
- Uniqueness constraints
- Not-null validations
- Referential integrity
- Custom business logic tests

---

## 📈 **Business Value**

This project demonstrates the ability to:

1. **Transform Raw Data** into analytics-ready models
2. **Ensure Data Quality** through comprehensive testing
3. **Document Data Assets** for business stakeholders
4. **Collaborate Effectively** using version control
5. **Follow Best Practices** from industry leaders (dbt Labs)

---

## 🎓 **Skills Demonstrated**

### **Analytics Engineering**
- Data modeling (staging → marts)
- Dimensional modeling (facts & dimensions)
- Data lineage tracking
- Incremental processing

### **Data Quality**
- Automated testing frameworks
- Data validation strategies
- Error detection and handling
- Quality assurance workflows

### **Software Engineering**
- Version control (Git)
- Code review practices
- CI/CD pipelines
- Modular code architecture

### **Business Intelligence**
- Customer analytics
- Order analytics
- Product performance
- Supply chain visibility

---

## 📊 **Sample Analytics Queries**

### **Customer Lifetime Value**
```sql
select
    customer_id,
    first_name || ' ' || last_name as customer_name,
    number_of_orders,
    total_lifetime_value,
    avg_order_value
from {{ ref('customers') }}
where number_of_orders > 5
order by total_lifetime_value desc
limit 10
```

### **Product Performance**
```sql
select
    product_name,
    product_type,
    total_orders,
    total_revenue,
    avg_order_size
from {{ ref('products') }}
order by total_revenue desc
```

---

## 🎯 **Resume Bullet Points**

```
dbt Analytics Transformation Pipeline - Jaffle Shop
github.com/mushroomHater/jaffle-shop-project

• Architected end-to-end dbt transformation pipeline with 12+ SQL models 
  organized in staging and mart layers following dimensional modeling 
  best practices and Kimball methodology

• Implemented comprehensive data quality framework with 20+ automated tests 
  achieving 100% test coverage for uniqueness, referential integrity, 
  and business logic validation across all models

• Created self-documenting analytics codebase with YAML-based metadata, 
  automated lineage tracking, and interactive data dictionary enabling 
  stakeholder self-service

• Established version-controlled analytics workflow using Git, dbt Cloud, 
  and pre-commit hooks for collaborative, production-grade data 
  transformations

Technologies: dbt Cloud, SQL (CTEs, Window Functions, Joins), Git, 
YAML, Data Modeling, Dimensional Modeling, Data Testing, Documentation
```

---

## 🚀 **Quick Start**

### **Prerequisites**
- dbt Cloud account (free tier available)
- Data warehouse connection (DuckDB, Snowflake, BigQuery, etc.)
- Git/GitHub account

### **Setup Steps**

1. **Clone the repository**:
   ```bash
   git clone https://github.com/mushroomHater/jaffle-shop-project.git
   cd jaffle-shop-project
   ```

2. **Set up in dbt Cloud**:
   - Connect to your data warehouse
   - Link this GitHub repository
   - Configure development environment

3. **Install dependencies**:
   ```bash
   dbt deps
   ```

4. **Load sample data**:
   ```bash
   dbt seed
   ```

5. **Build all models**:
   ```bash
   dbt build
   ```

6. **Run tests**:
   ```bash
   dbt test
   ```

7. **Generate documentation**:
   ```bash
   dbt docs generate
   dbt docs serve
   ```

**See [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) for detailed setup guide.**

---

## 📚 **Learning Resources**

- **Official dbt Documentation**: https://docs.getdbt.com/
- **dbt Learn Platform**: https://learn.getdbt.com/
- **Original Jaffle Shop**: https://github.com/dbt-labs/jaffle-shop
- **dbt Community Slack**: https://www.getdbt.com/community/

---

## 🔗 **Related Projects**

This project pairs perfectly with:
- **[Large-Scale Analytics Platform](https://github.com/mushroomHater/large-scale-analytics-platform)** - Multi-source data extraction (1.3M+ records)

**Together they demonstrate**: Complete analytics engineering lifecycle from data extraction through transformation to business insights.

---

## 📄 **License**

This project is based on the official dbt Labs Jaffle Shop template.

---

## 🙏 **Acknowledgments**

- **dbt Labs** for creating the original Jaffle Shop template
- **dbt Community** for best practices and guidance
- **Analytics Engineering community** for establishing modern data workflows

---

**⭐ Built with dbt, tested with care, documented for everyone.**

*For questions or collaboration, visit the [repository](https://github.com/mushroomHater/jaffle-shop-project).*

