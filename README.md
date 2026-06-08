# 📊 End-to-End Sales & Customer Analysis

## 📌 Project Overview

This project demonstrates a complete data analytics workflow using Excel, SQL, and Power BI. The objective was to transform raw retail transaction data into meaningful business insights by analyzing sales performance, profitability, customer behavior, product performance, and regional trends.

The project follows an end-to-end approach, starting from data preparation and normalization in Excel, moving through business analysis in SQL, and culminating in the development of an interactive Power BI dashboard for decision-making.

---

## 🎯 Business Objective

The primary objective of this project is to identify key business drivers, uncover profit leakage areas, and generate actionable recommendations to improve sales performance and profitability.

Key business questions addressed:

* Which categories and products generate the highest revenue?
* Which regions contribute the most to profitability?
* How do discounts affect profit margins?
* Which customer segments drive sales and profits?
* Which products generate losses despite strong sales?
* Where should management focus improvement efforts?

---

## 📂 Dataset Overview

### Source

Kaggle – Retail Sales Transaction Dataset

### Dataset Information

* Total Records: ~10,000
* Total Attributes: 21
* Time Period: 2014–2017
* Categories: 3
* Customer Segments: 3
* Regions: 4

### Key Data Fields

* Order Information
* Customer Details
* Product Information
* Category & Sub-Category
* Sales
* Profit
* Discount
* Region
* Segment

---

## 🔄 Project Workflow

```text
Raw Transaction Dataset
          ↓
Excel Data Cleaning
          ↓
Data Normalization
(Customer, Orders, Product)
          ↓
SQL Business Analysis
          ↓
Power BI Dashboard Development
          ↓
Business Insights & Recommendations
```

---

## 🛠 Tools & Technologies

### Excel

* Data Validation
* Data Cleaning
* Data Normalization

### SQL

* Data Analysis
* Business Query Development
* Aggregations
* Joins
* Filtering
* CASE Statements

### Power BI

* Dashboard Development
* KPI Tracking
* Business Visualization
* Interactive Reporting

---

## 📋 Data Preparation & Normalization

The original transactional dataset was prepared and structured using Microsoft Excel.

### Activities Performed

* Removed duplicate records
* Validated data consistency
* Standardized formats
* Reviewed business dimensions
* Prepared data for analysis

### Database Normalization

The dataset was normalized into separate tables:

* Customer Table
* Orders Table
* Product Table

This structure reduced redundancy and improved analytical efficiency before SQL analysis.

---

## 🗄 SQL Analysis

SQL was used to perform exploratory and business-focused analysis.

### SQL Techniques Used

* Aggregations
* GROUP BY
* ORDER BY
* CASE Statements
* Joins
* Filtering
* Business Query Development

### Business Questions Solved

* Top revenue-generating products
* Most profitable categories
* Region-wise sales and profit analysis
* Customer segment performance
* High-sales but loss-making products
* Impact of discount on profitability
* Profit margin comparison across regions

---

## 📈 Power BI Dashboard

The project includes an interactive Power BI dashboard with eight analytical pages.

### Dashboard Sections

1. Executive Summary
2. Sales Trend Analysis
3. Category Performance Analysis
4. Regional Performance Analysis
5. Customer Segment Analysis
6. Discount Impact Analysis
7. Top Product Drivers
8. Loss Analysis

---

## 🖼 Dashboard Screenshots

### Executive Summary

<img width="1917" height="1015" alt="excutive_summary" src="https://github.com/user-attachments/assets/84253c58-afa3-421f-9f50-9647db2c2e07" />


### Sales Trend Analysis

<img width="1917" height="1015" alt="sales_trend_analysis" src="https://github.com/user-attachments/assets/9855977c-5951-4115-9280-a0910a33471e" />


### Category Performance Analysis

<img width="1915" height="1015" alt="category_performance_analysis" src="https://github.com/user-attachments/assets/1030909c-aa81-4bc3-baba-1395571a4095" />


### Regional Performance Analysis

<img width="1912" height="1012" alt="regional_performance_analysis" src="https://github.com/user-attachments/assets/33b02d81-5e7e-4f71-9e39-33cf5d2afc0d" />


### Customer Segment Analysis

<img width="1917" height="1017" alt="customer_segment_analysis" src="https://github.com/user-attachments/assets/7eb9e509-1820-4733-937c-3dc454ec6230" />


### Discount Impact Analysis

<img width="1917" height="1020" alt="discount_impact_analysis" src="https://github.com/user-attachments/assets/a643fbdd-e4e1-4f16-96cf-01700b46f918" />


### Top Product Drivers

<img width="1917" height="1022" alt="top_product_drivers" src="https://github.com/user-attachments/assets/4adac985-3b18-429a-85cc-56f84f5f0454" />


### Loss Analysis

<img width="1917" height="1017" alt="loss_analysis" src="https://github.com/user-attachments/assets/2c183798-d71f-45aa-8953-083076da5d36" />


---

## 🔍 Key Findings

### Sales Trends

* Sales and profit show a consistent upward trend.
* Significant spikes occur during Q4, indicating seasonal demand.

### Category Performance

* Technology is the highest-performing category in terms of revenue and profit.
* Furniture contributes strong sales but lower profitability.

### Regional Performance

* West region generates the highest sales and profit.
* Central region consistently underperforms and records losses.

### Customer Insights

* Consumer segment drives the highest sales volume.
* Home Office customers generate stronger profit margins.

### Discount Impact

* Profitability declines significantly when discounts exceed 40–50%.
* Excessive discounting contributes directly to profit leakage.

### Product Performance

* Several products generate high revenue while remaining unprofitable.
* Pricing and discount strategies require optimization.

---

## 💡 Business Recommendations

* Implement approval-based discounting beyond 40%.
* Increase focus on high-margin Technology products.
* Review pricing strategies for loss-making products.
* Improve operational efficiency within the Central region.
* Prioritize profitability alongside revenue growth.
* Monitor discount effectiveness using profitability KPIs.

---

## 📊 Business Impact

This analysis helps organizations:

* Reduce profit leakage
* Improve pricing decisions
* Strengthen regional performance
* Optimize product portfolios
* Increase overall profitability
* Support data-driven decision-making

---

## 📁 Repository Structure

```text
end-to-end-sales-customer-analysis
│
├── data
│   ├── Sample - Superstore.csv
│   ├── Customer.csv
│   ├── Orders.csv
│   └── Product.csv
│
├── sql
│   └── sales_performance_analysis.sql
│
├── powerbi
│   └── sales_performance_dashboard.pbix
│
├── images
│   ├── executive_summary.png
│   ├── sales_trend_analysis.png
│   ├── category_performance_analysis.png
│   ├── regional_performance_analysis.png
│   ├── customer_segment_analysis.png
│   ├── discount_impact_analysis.png
│   ├── top_product_drivers.png
│   └── loss_analysis.png
│
├── reports
│   └── sales_customer_analysis_report.pdf
│
└── README.md
```

---

## ✅ Conclusion

This project demonstrates a complete end-to-end analytics workflow using Excel, SQL, and Power BI. By transforming raw transactional data into actionable business insights, the project highlights how data-driven analysis can support strategic decision-making, improve profitability, and identify opportunities for business growth.
