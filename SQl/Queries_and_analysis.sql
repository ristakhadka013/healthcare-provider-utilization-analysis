/* Business Question
Analyze healthcare provider utilization, cost, and payment patterns to identify significant and potentially unusual patterns 
that may require further investigation. */

# 1. Service Utilization Analysis
-- 1.1 Which provider types have the highest service utilization?

SELECT 
    Rndrng_Prvdr_Type,
    ROUND(SUM(Tot_Srvcs), 2) AS total_services,
    COUNT(DISTINCT Rndrng_NPI) AS total_providers,
    ROUND(
        SUM(Tot_Srvcs) / COUNT(DISTINCT Rndrng_NPI),
        2
    ) AS service_per_provider
FROM healthcare
GROUP BY Rndrng_Prvdr_Type
ORDER BY service_per_provider DESC
LIMIT 15;

/*
Finding :
Clinical Laboratory has the highest average service volume per provider at approximately 11,364 services per provider, 
more than 3× the second-highest provider type, Ambulance Service Provider.

Why we investigated further :
Since Clinical Laboratory had exceptionally high utilization per provider, we investigated which specific services 
were driving this volume.

*/

-- 1.2 What services are driving Clinical Laboratory utilization?

SELECT
    HCPCS_Cd,
    HCPCS_Desc,
    ROUND(SUM(Tot_Srvcs), 2) AS total_services,
    COUNT(DISTINCT Rndrng_NPI) AS unique_providers,
    ROUND(
        SUM(Tot_Srvcs) / COUNT(DISTINCT Rndrng_NPI),
        2
    ) AS service_per_provider,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs),
        2
    ) AS estimated_medicare_payment
FROM healthcare
WHERE Rndrng_Prvdr_Type = 'Clinical Laboratory'
GROUP BY HCPCS_Cd, HCPCS_Desc
ORDER BY total_services DESC
LIMIT 10;

/* 
Findings :
Clinical Laboratories recorded 13.55 million services. More than half of this volume came from two services: COVID-19 testing and 
specimen collection for homebound or nursing-home patients.

COVID-19 testing recorded approximately 4.27 million services across 10 providers, with an estimated Medicare payment of approximately
 $50.2 million.

P9603 had extremely high services per provider but a much lower estimated Medicare payment, showing that high utilization does not 
necessarily mean high payment.
*/

# 2. Payment Analysis
-- 2.1 Do high-utilization services also generate high Medicare payments?

SELECT
    HCPCS_Cd,
    HCPCS_Desc,
    ROUND(SUM(Tot_Srvcs), 2) AS total_services,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs),
        2
    ) AS estimated_medicare_payment,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs)
        / SUM(Tot_Srvcs),
        2
    ) AS estimated_payment_per_service
FROM healthcare
WHERE Rndrng_Prvdr_Type = 'Clinical Laboratory'
GROUP BY HCPCS_Cd, HCPCS_Desc
ORDER BY estimated_medicare_payment DESC
LIMIT 10;

/* 
Finding : 
Molecular pathology procedures have total services of approximately 20,480, estimated Medicare payment as $60.2 million, 
and estimated payment per service is $2,939.64. 
COVID-19 tests have total services 4.3 million, estimated Medicare payment $50.2 million, and estimated payment per services 
is $11.76 million.

This indicates that higher services can have lower estimated payment, whereas lower services can  have high estimated payment 
per services.
*/

-- 2.2 Payment pattern by provider type

SELECT
    Rndrng_Prvdr_Type,
    ROUND(SUM(Tot_Srvcs), 2) AS total_services,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs),
        2
    ) AS estimated_medicare_payment,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs)
        / SUM(Tot_Srvcs),
        2
    ) AS estimated_payment_per_service
FROM healthcare
GROUP BY Rndrng_Prvdr_Type
ORDER BY estimated_medicare_payment DESC
LIMIT 15;

/*
Findings :
High utilization + lower payment per service

Clinical Laboratory → 13.55M services, $17.84/service
Diagnostic Radiology → 6.32M services, $16.10/service
Hematology-Oncology → 7.69M services, $11.78/service

Lower utilization + higher payment per service

Ambulatory Surgical Center → 647K services, $169.36/service
Ophthalmology → 1.66M services, $112.14/service
Emergency Medicine → 650K services, $95.37/service 
*/

# 3. Provider-Level Utilization
-- 3.1 Which individual providers generate the most services?

SELECT
    Rndrng_NPI,
    Rndrng_Prvdr_Last_Org_Name,
    Rndrng_Prvdr_First_Name,
    Rndrng_Prvdr_Type,
    Rndrng_Prvdr_State_Abrvtn,
    ROUND(SUM(Tot_Srvcs), 2) AS total_services,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs),
        2
    ) AS estimated_medicare_payment
FROM healthcare
GROUP BY
    Rndrng_NPI,
    Rndrng_Prvdr_Last_Org_Name,
    Rndrng_Prvdr_First_Name,
    Rndrng_Prvdr_Type,
    Rndrng_Prvdr_State_Abrvtn
ORDER BY total_services DESC
LIMIT 15;

/*
Finding :
Vcare Testing Centre Corp. recorded the highest service volume at approximately 3.64 million services.
*/

-- 3.2 What is driving Vcare's extremely high service volume?

SELECT
    HCPCS_Cd,
    HCPCS_Desc,
    ROUND(SUM(Tot_Srvcs), 2) AS total_services,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs),
        2
    ) AS estimated_medicare_payment
FROM healthcare
WHERE Rndrng_NPI = 1720737786
GROUP BY HCPCS_Cd, HCPCS_Desc
ORDER BY total_services DESC
LIMIT 10;

/* 
Finding :
Vcare's high service volume was primarily driven by COVID-19 testing rather than a broad range of services.
*/

-- 3.3 Who performed the most COVID-19 tests?

SELECT
    Rndrng_NPI,
    Rndrng_Prvdr_Last_Org_Name,
    Rndrng_Prvdr_First_Name,
    Rndrng_Prvdr_Type,
    Rndrng_Prvdr_State_Abrvtn,
    ROUND(SUM(Tot_Srvcs), 2) AS total_covid_tests,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs),
        2
    ) AS estimated_medicare_payment
FROM healthcare
WHERE HCPCS_Cd = 'K1034'
GROUP BY
    Rndrng_NPI,
    Rndrng_Prvdr_Last_Org_Name,
    Rndrng_Prvdr_First_Name,
    Rndrng_Prvdr_Type,
    Rndrng_Prvdr_State_Abrvtn
ORDER BY total_covid_tests DESC
LIMIT 10;

/* 
Finding :
Vcare Testing Centre Corp. recorded approximately 3.64 million COVID-19 tests, generating an estimated $42.8 million in Medicare
 payments. 
 */
 
# 4. Provider Concentration
-- 4.1 How concentrated is service utilization?

SELECT
    ROUND(SUM(total_services), 2) AS top_10_services
FROM (
    SELECT
        Rndrng_NPI,
        SUM(Tot_Srvcs) AS total_services
    FROM healthcare
    GROUP BY Rndrng_NPI
    ORDER BY total_services DESC
    LIMIT 10
) AS top_providers;

SELECT
    ROUND(SUM(Tot_Srvcs), 2) AS total_dataset_services
FROM healthcare;

/* 
Finding :
The top 10 providers account for approximately 13% of all services in the dataset.
*/

-- 4.2 Which providers receive the highest estimated Medicare payments?

SELECT
    Rndrng_NPI,
    Rndrng_Prvdr_Last_Org_Name,
    Rndrng_Prvdr_First_Name,
    Rndrng_Prvdr_Type,
    ROUND(SUM(Tot_Srvcs), 2) AS total_services,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs),
        2
    ) AS estimated_medicare_payment,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs)
        / SUM(Tot_Srvcs),
        2
    ) AS payment_per_service
FROM healthcare
GROUP BY
    Rndrng_NPI,
    Rndrng_Prvdr_Last_Org_Name,
    Rndrng_Prvdr_First_Name,
    Rndrng_Prvdr_Type
ORDER BY estimated_medicare_payment DESC
LIMIT 10;

/* 
Finding :
Caris Mpi generated the highest estimated Medicare payment among individual providers despite having much lower service volume 
than some high-volume providers.
*/

# 5. Peer Benchmarking
-- 5.1 Is a provider's payment per service unusually high compared with other providers of the same type?

WITH provider_metrics AS (
    SELECT
        Rndrng_NPI,
        Rndrng_Prvdr_Last_Org_Name,
        Rndrng_Prvdr_First_Name,
        Rndrng_Prvdr_Type,
        SUM(Tot_Srvcs) AS total_services,
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs) AS estimated_medicare_payment
    FROM healthcare
    GROUP BY
        Rndrng_NPI,
        Rndrng_Prvdr_Last_Org_Name,
        Rndrng_Prvdr_First_Name,
        Rndrng_Prvdr_Type
),

provider_type_benchmark AS (
    SELECT
        Rndrng_Prvdr_Type,
        SUM(estimated_medicare_payment)
            / SUM(total_services)
            AS benchmark_payment_per_service
    FROM provider_metrics
    WHERE total_services >= 100
    GROUP BY Rndrng_Prvdr_Type
),

provider_comparison AS (
    SELECT
        p.*,
        b.benchmark_payment_per_service
    FROM provider_metrics p
    JOIN provider_type_benchmark b
        ON p.Rndrng_Prvdr_Type = b.Rndrng_Prvdr_Type
    WHERE p.total_services >= 100
)

SELECT
    Rndrng_NPI,
    Rndrng_Prvdr_Last_Org_Name,
    Rndrng_Prvdr_First_Name,
    Rndrng_Prvdr_Type,
    ROUND(total_services, 2) AS total_services,
    ROUND(
        estimated_medicare_payment / total_services,
        2
    ) AS provider_payment_per_service,
    ROUND(benchmark_payment_per_service, 2) AS peer_benchmark,
    ROUND(
        (estimated_medicare_payment / total_services)
        / benchmark_payment_per_service,
        2
    ) AS peer_payment_ratio
FROM provider_comparison
ORDER BY peer_payment_ratio DESC
LIMIT 20;

/*
Finding :
These providers show potentially unusual payment patterns relative to their provider-type peers. These results are signals for 
further investigation, not evidence of inappropriate payment or fraud.

I select Caris Mpi for deeper investigation because it combines:

20,456 services
$2,942 payment per service
165× its peer benchmark
Approximately $60.2M estimated Medicare payment

Most importantly, it has enough service volume to make the signal more meaningful than an extreme ratio based on only a few 
hundred services.
*/

-- 5.2 What services are driving Caris's payment?

SELECT
    HCPCS_Cd,
    HCPCS_Desc,
    ROUND(SUM(Tot_Srvcs), 2) AS total_services,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs),
        2
    ) AS estimated_medicare_payment,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs)
        / SUM(Tot_Srvcs),
        2
    ) AS payment_per_service
FROM healthcare
WHERE Rndrng_NPI = 1013973866
GROUP BY
    HCPCS_Cd,
    HCPCS_Desc
ORDER BY estimated_medicare_payment DESC
LIMIT 10;

/* 
Finding : 
Caris Mpi's high estimated payment was primarily driven by HCPCS 81479 — Molecular pathology procedure, rather than simply having 
an unusually high number of services.
*/ 

-- Now we compare Caris with another provider performing the same HCPCS code. to understand it is really expensive or not

SELECT
    Rndrng_NPI,
    Rndrng_Prvdr_Last_Org_Name,
    Rndrng_Prvdr_First_Name,
    Rndrng_Prvdr_Type,
    ROUND(SUM(Tot_Srvcs), 2) AS total_services,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs),
        2
    ) AS estimated_medicare_payment,
    ROUND(
        SUM(Avg_Mdcr_Pymt_Amt * Tot_Srvcs)
        / SUM(Tot_Srvcs),
        2
    ) AS payment_per_service
FROM healthcare
WHERE HCPCS_Cd = '81479'
GROUP BY
    Rndrng_NPI,
    Rndrng_Prvdr_Last_Org_Name,
    Rndrng_Prvdr_First_Name,
    Rndrng_Prvdr_Type
ORDER BY payment_per_service DESC;

/* 
Finding :
Caris's estimated Medicare payment per 81479 service was approximately 4.2× higher than Gravity Diagnostics.
However, there are only two providers performing this service in this dataset, so this should be treated as a signal 
requiring further investigation, not proof of inappropriate payment.
*/

SELECT
    Rndrng_NPI,
    Rndrng_Prvdr_Last_Org_Name,
    HCPCS_Cd,
    ROUND(AVG(Avg_Sbmtd_Chrg), 2) AS avg_submitted_charge,
    ROUND(AVG(Avg_Mdcr_Alowd_Amt), 2) AS avg_medicare_allowed,
    ROUND(AVG(Avg_Mdcr_Pymt_Amt), 2) AS avg_medicare_payment,
    ROUND(AVG(Avg_Mdcr_Stdzd_Amt), 2) AS avg_standardized_payment
FROM healthcare
WHERE HCPCS_Cd = '81479'
GROUP BY
    Rndrng_NPI,
    Rndrng_Prvdr_Last_Org_Name,
    HCPCS_Cd
ORDER BY avg_medicare_payment DESC;

/*
Caris Mpi shows a potentially unusual payment pattern for HCPCS 81479. Its estimated Medicare payment per service was 
approximately $2,942, compared with $705 for the only other provider performing the same service in the dataset. The difference 
is also reflected in Medicare allowed and standardized payment amounts. Because only two providers performed HCPCS 81479, this 
should be treated as a signal for further investigation rather than evidence of inappropriate payment.
*/


