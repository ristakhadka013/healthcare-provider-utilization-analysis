CREATE DATABASE provider_utilization_analysis;

USE provider_utilization_analysis;

CREATE TABLE healthcare(
	Rndrng_NPI int,
    Rndrng_Prvdr_Last_Org_Name VARCHAR(100),
    Rndrng_Prvdr_First_Name VARCHAR(100),
    Rndrng_Prvdr_MI VARCHAR(100),
    Rndrng_Prvdr_Crdntls VARCHAR(100),
    Rndrng_Prvdr_Gndr VARCHAR(100),
    Rndrng_Prvdr_Ent_Cd VARCHAR(100),
    Rndrng_Prvdr_St1 VARCHAR(100),
    Rndrng_Prvdr_City VARCHAR(100),
    Rndrng_Prvdr_State_Abrvtn VARCHAR(100),
    Rndrng_Prvdr_State_FIPS VARCHAR(100),
    Rndrng_Prvdr_RUCA FLOAT,
    Rndrng_Prvdr_RUCA_Desc VARCHAR(100),
    Rndrng_Prvdr_Cntry VARCHAR(100),
    Rndrng_Prvdr_Type VARCHAR(100),
    Rndrng_Prvdr_Mdcr_Prtcptg_Ind VARCHAR(100),
    HCPCS_Cd VARCHAR(100),
    HCPCS_Desc TEXT,
    HCPCS_Drug_Ind VARCHAR(100),
    Place_Of_Srvc VARCHAR(100),
    Tot_Benes INT,
    Tot_Srvcs FLOAT,
    Tot_Bene_Day_Srvcs INT,
    Avg_Sbmtd_Chrg FLOAT,
    Avg_Mdcr_Alowd_Amt FLOAT,
    Avg_Mdcr_Pymt_Amt FLOAT,
    Avg_Mdcr_Stdzd_Amt FLOAT,
    first_name_missing_individual BOOL,
    credential_missing_individual BOOL
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/ristakhadka/Developer/DATA ANALYTICS/healthcare-provider-utilization-analysis/data/Cleaned_CMS_Data.csv'
INTO TABLE healthcare
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
	Rndrng_NPI,
	Rndrng_Prvdr_Last_Org_Name,
	@Rndrng_Prvdr_First_Name,
	@Rndrng_Prvdr_MI,
	@Rndrng_Prvdr_Crdntls,
	@Rndrng_Prvdr_Gndr,
	Rndrng_Prvdr_Ent_Cd,
	Rndrng_Prvdr_St1,
	Rndrng_Prvdr_City,
	Rndrng_Prvdr_State_Abrvtn,
	Rndrng_Prvdr_State_FIPS,
	@Rndrng_Prvdr_RUCA,
	@Rndrng_Prvdr_RUCA_Desc,
	Rndrng_Prvdr_Cntry,
	Rndrng_Prvdr_Type,
	Rndrng_Prvdr_Mdcr_Prtcptg_Ind,
	HCPCS_Cd,
	HCPCS_Desc,
	HCPCS_Drug_Ind,
	Place_Of_Srvc,
	Tot_Benes,
	Tot_Srvcs,
	Tot_Bene_Day_Srvcs,
	Avg_Sbmtd_Chrg,
	Avg_Mdcr_Alowd_Amt,
	Avg_Mdcr_Pymt_Amt,
	Avg_Mdcr_Stdzd_Amt,
	@first_name_missing_individual,
	@credential_missing_individual
)
SET
	Rndrng_Prvdr_First_Name = NULLIF(@Rndrng_Prvdr_First_Name, ''),
    Rndrng_Prvdr_MI = NULLIF(@Rndrng_Prvdr_MI, ''),
    Rndrng_Prvdr_Crdntls = NULLIF(@Rndrng_Prvdr_Crdntls, ''),
    Rndrng_Prvdr_Gndr = NULLIF(@Rndrng_Prvdr_Gndr, ''),
    Rndrng_Prvdr_RUCA = NULLIF(@Rndrng_Prvdr_RUCA, '' ),
    Rndrng_Prvdr_RUCA_Desc = NULLIF(@Rndrng_Prvdr_RUCA_Desc, ''),
    first_name_missing_individual = CASE
		WHEN @first_name_missing_individual = 'True' THEN 1
        WHEN @first_name_missing_individual = 'False' THEN 0
        ELSE NULL
	END, 
    credential_missing_individual = CASE
		WHEN @credential_missing_individual = 'True' THEN 1
        WHEN @credential_missing_individual = 'False' THEN 0
        ELSE NULL
	END;
    
SELECT COUNT(*) AS TOTALDATA
FROM healthcare;

DESCRIBE healthcare;

SELECT COUNT(*) AS invalid_utilization_records
FROM healthcare
WHERE Tot_Benes <= 0
   OR Tot_Srvcs <= 0
   OR Tot_Bene_Day_Srvcs <= 0;
    
SELECT COUNT(*) AS financial_amount
FROM healthcare
WHERE Avg_Sbmtd_Chrg < 0
	OR Avg_Mdcr_Alowd_Amt < 0
    OR Avg_Mdcr_Pymt_Amt < 0
    OR Avg_Mdcr_Stdzd_Amt < 0;
    
SELECT COUNT(*) AS invalid_payment_records
FROM healthcare
WHERE Avg_Mdcr_Pymt_Amt > Avg_Mdcr_Alowd_Amt;

SELECT 
    Rndrng_Prvdr_Ent_Cd,
    COUNT(*) AS record_count
FROM healthcare
GROUP BY Rndrng_Prvdr_Ent_Cd;
    
SELECT 
    Rndrng_Prvdr_Mdcr_Prtcptg_Ind,
    COUNT(*) AS record_count
FROM healthcare
GROUP BY Rndrng_Prvdr_Mdcr_Prtcptg_Ind;

SELECT COUNT(*) AS invalid_identifier_records
FROM healthcare
WHERE TRIM(Rndrng_NPI) = ''
   OR TRIM(HCPCS_Cd) = '';






