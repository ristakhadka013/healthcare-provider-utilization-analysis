# 🏥 Healthcare Provider Utilization & Payment Analysis

> **Analyzing Medicare provider utilization and payment patterns to identify significant and potentially unusual patterns requiring further investigation.**

---

## 📌 Overview

This is an **end-to-end healthcare analytics project** analyzing Medicare provider-service data to understand how utilization and payment patterns vary across provider types and individual providers.

The analysis focuses on identifying:

* High-volume provider types and services
* Differences in payment per service
* Provider-level utilization patterns
* Unusual payment patterns relative to peers
* Areas requiring further investigation

The project combines **Python/Pandas, MySQL, and Power BI** across the complete analytics workflow.

---

## 🎯 Business Question

> **How do healthcare provider utilization and payment patterns vary across provider types and individual providers, and are there potentially unusual patterns that require further investigation?**

---

## 🛠️ Tools & Technologies

| Tool                | Purpose                                                |
| ------------------- | ------------------------------------------------------ |
| **Python / Pandas** | Data cleaning, profiling & quality checks              |
| **MySQL / SQL**     | Provider, service & payment analysis                   |
| **Power BI**        | KPI development, visualization & interactive reporting |

---

# 🔄 Project Workflow

```text
Raw Healthcare Data
        ↓
Data Cleaning & Validation
        ↓
Exploratory Analysis
        ↓
SQL Analysis
        ↓
Peer Benchmarking
        ↓
Anomaly Investigation
        ↓
Power BI Dashboard
        ↓
Business Insights
```

---

# 🐍 1. Python / Pandas — Data Preparation

The dataset was first profiled and cleaned to ensure the analysis was based on reliable data.

### Key activities

* Profiled the dataset and examined data distributions
* Investigated missing values and data-quality issues
* Checked numeric fields for extreme values and potential outliers
* Validated fields used in downstream analysis
* Prepared the dataset for SQL-based analysis

---

# 🗄️ 2. MySQL — Analytical Analysis

SQL was used to investigate utilization and payment patterns at both the **provider-type and individual-provider levels**.

### Key analysis

* Compared service utilization across provider types
* Identified high-volume providers and services
* Calculated estimated Medicare payments
* Analyzed payment per service
* Performed peer benchmarking
* Investigated potentially unusual provider-level payment patterns

### Peer Benchmarking Approach

To reduce distortion from providers with very small service volumes, a **minimum threshold of 100 services** was applied before comparing providers against their peers.

This helped avoid conclusions being driven by very small denominators.

---

# 📊 3. Power BI — Dashboard Development

The final analysis was presented through an interactive Power BI dashboard.

### Dashboard components

* KPI cards
* Provider-type comparisons
* Utilization analysis
* Payment analysis
* Provider-level tables
* Service-level analysis
* Peer benchmarking insights

The dashboard was designed to make the SQL findings easier to explore and communicate to non-technical users.

---

# 🔍 Key Findings

## 1. 🧪 Clinical Laboratory Had the Highest Service Volume

Clinical Laboratory recorded approximately:

### **13.55M services**

COVID-19 testing and **P9603** together accounted for more than half of the total service volume.

**Insight:** A small number of high-volume services were responsible for a substantial portion of Clinical Laboratory utilization.

---

## 2. 🏢 Vcare Testing Centre Corp. Had the Highest Utilization

Vcare Testing Centre Corp. recorded approximately:

### **3.64M services**

The majority of this volume was driven by COVID-19 testing.

**Insight:** Provider-level utilization was heavily influenced by specific high-volume services rather than being evenly distributed across providers.

---

## 3. 💰 Caris MPI Had Approximately $60.2M in Estimated Payments

Caris MPI generated approximately:

* **20,456 services**
* **$60.2M estimated Medicare payments**

This resulted in a substantially higher estimated payment per service compared with its Clinical Laboratory peers.

---

## 4. ⚠️ Caris MPI's Payment per Service Was ~165× the Peer Benchmark

Caris MPI's estimated payment per service was approximately:

### **$2,942 per service**

compared with a Clinical Laboratory peer benchmark of approximately:

### **$17.80 per service**

This represents an estimated payment-per-service level approximately:

### **165× the peer benchmark**

**Insight:** This represents a significant statistical outlier that warrants further investigation.

---

## 5. 🔬 Same-Service Comparison Strengthened the Finding

For **HCPCS 81479**, Caris MPI's estimated payment per service was approximately:

### **4.2× higher**

than the other provider performing the same service.

This comparison provides additional context because it evaluates providers performing the **same service**, rather than comparing across different services.

---

# 💡 Overall Business Insight

The analysis identified several significant differences in provider utilization and payment patterns.

The most notable finding was an unusually high estimated payment per service for **Caris MPI relative to its Clinical Laboratory peers**, which remained elevated even when comparing the same HCPCS service.

These patterns should be treated as **investigative signals rather than conclusions of inappropriate payment or fraud**.

---

# 🚨 Important Interpretation

> **An unusual payment pattern does not establish fraud, improper payment, or wrongdoing.**

The analysis is based on aggregated provider-service data and estimated payments.

Further investigation would require additional information such as:

* Claim-level payment details
* Individual claim records
* Reimbursement information
* Services performed
* Claim-level utilization
* Patient and procedure context

These additional data would be necessary to determine the underlying reason for the observed payment differences.

---

# 📊 Dashboard

The Power BI dashboard brings together the key utilization, payment, provider, and benchmarking insights identified during the analysis.

![Healthcare Provider Utilization & Payment Analysis Dashboard](https://github.com/ristakhadka013/healthcare-provider-utilization-analysis/blob/main/power%20bi/Dashboard.png)

---

# 🎯 Conclusion

This project demonstrates an end-to-end healthcare analytics workflow using **Python, SQL, MySQL, and Power BI**.

The analysis examined provider utilization, service volume, estimated Medicare payments, and peer-level payment patterns.

The investigation identified significant payment-per-service differences that could serve as **signals for further review**, while recognizing that aggregated data alone cannot determine whether a payment pattern is inappropriate.

The project demonstrates how data analysis can be used to move from **data quality and exploration → analytical investigation → benchmarking → visualization → actionable investigative signals**.

---

### 🔗 Skills Demonstrated

**Python • Pandas • SQL • MySQL • Power BI • Data Cleaning • Data Validation • Exploratory Data Analysis • KPI Analysis • Peer Benchmarking • Data Visualization**
