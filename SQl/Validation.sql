USE provider_utilization_analysis;
DESC healthcare;

SELECT 
	'Total Data' AS 'Name',
	COUNT(*) AS 'total_number'
FROM healthcare
UNION ALL
SELECT 
	'Unique Provider',
	COUNT(DISTINCT Rndrng_NPI)
FROM healthcare
UNION ALL
SELECT 
	'unique service',
    COUNT(DISTINCT HCPCS_Cd)
FROM healthcare
UNION ALL
SELECT 
	'Unique Provider type',
    COUNT(DISTINCT Rndrng_Prvdr_Type)
FROM healthcare
UNION ALL
SELECT 
	'Total Place of service',
    COUNT(DISTINCT Place_Of_Srvc)
FROM healthcare;

SELECT 
	SUM(CASE WHEN Tot_Srvcs < 0 THEN 1 ELSE 0 END) AS negative_services,
    SUM(CASE WHEN Tot_Srvcs IS NULL THEN 1 ELSE 0 END) AS null_services,
    SUM(CASE WHEN Tot_Benes < 0 THEN 1 ELSE 0 END) AS negative_bene,
    SUM(CASE WHEN Tot_Benes IS NULL THEN 1 ELSE 0 END) AS null_bene
FROM healthcare;

SELECT
    SUM(CASE WHEN Avg_Sbmtd_Chrg < 0 THEN 1 ELSE 0 END) AS negative_submitted_charge,
    SUM(CASE WHEN Avg_Mdcr_Alowd_Amt < 0 THEN 1 ELSE 0 END) AS negative_allowed_amount,
    SUM(CASE WHEN Avg_Mdcr_Pymt_Amt < 0 THEN 1 ELSE 0 END) AS negative_medicare_payment,
    SUM(CASE WHEN Avg_Mdcr_Stdzd_Amt < 0 THEN 1 ELSE 0 END) AS negative_standardized_payment
FROM healthcare;
