# Healthcare Provider Utilization & Payment Analysis
# Overview

  An end-to-end healthcare analytics project analyzing Medicare provider service utilization and payment patterns to identify significant and 
  potentially unusual patterns requiring further investigation.

# Business Question

  How do healthcare provider utilization and payment patterns vary across provider types and individual providers, and are there potentially 
  unusual patterns that require further investigation?

# Tools

  Python (Pandas)
  MySQL
  Power BI

# Project Workflow

  Python/Pandas

    Cleaned and profiled the dataset
    Investigated missing values and data quality issues
    Checked numeric fields for extreme values and potential outliers

  MySQL

    Analyzed provider-type and provider-level utilization and payment
    Investigated high-volume providers and services
    Performed peer benchmarking using a 100-service minimum threshold
    Investigated potentially unusual payment patterns

  Power BI

    Created DAX measures, KPI cards, charts, and tables
    Built an interactive dashboard to compare utilization and payment patterns
    Highlighted key findings from the SQL analysis
    
# Key Findings
    1. Clinical Laboratory recorded 13.55M services, with COVID-19 testing and P9603 accounting for more than half of the volume.
    2. Vcare Testing Centre Corp. recorded approximately 3.64M services, primarily driven by COVID-19 testing.
    3. Caris MPI generated approximately $60.2M in estimated Medicare payments from 20,456 services.
    4. Caris's payment per service was approximately 165× its Clinical Laboratory peer benchmark.
    5. For HCPCS 81479, Caris's payment per service was approximately 4.2× higher than the other provider performing the same service.

# Conclusion

The analysis identified potentially unusual utilization and payment patterns for further investigation. These findings do not establish inappropriate payment or fraud and would require more detailed claim-level and reimbursement data for validation.

Dashboard

Power BI Dashboard: ![https://github.com/ristakhadka013/healthcare-provider-utilization-analysis/blob/main/power%20bi/Dashboard.pbix]
