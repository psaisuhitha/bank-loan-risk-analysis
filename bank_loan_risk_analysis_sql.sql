use bank_loan_analysis;
CREATE TABLE loans (
    LoanID VARCHAR(20),
    Age INT,
    Income FLOAT,
    LoanAmount FLOAT,
    CreditScore INT,
    MonthsEmployed INT,
    NumCreditLines INT,
    InterestRate FLOAT,
    LoanTerm INT,
    DTIRatio FLOAT,
    Education VARCHAR(50),
    EmploymentType VARCHAR(50),
    MaritalStatus VARCHAR(50),
    HasMortgage VARCHAR(10),
    HasDependents VARCHAR(10),
    LoanPurpose VARCHAR(50),
    HasCoSigner VARCHAR(10),
    LoanDefault INT,
    Income_Category VARCHAR(20),
    Risk_Level VARCHAR(20),
    Age_Group VARCHAR(50)
);
DROP TABLE loans;
CREATE TABLE loans (
    LoanID VARCHAR(20),
    Age INT,
    Income FLOAT,
    LoanAmount FLOAT,
    CreditScore INT,
    MonthsEmployed INT,
    NumCreditLines INT,
    InterestRate FLOAT,
    LoanTerm INT,
    DTIRatio FLOAT,
    Education VARCHAR(50),
    EmploymentType VARCHAR(50),
    MaritalStatus VARCHAR(50),
    HasMortgage VARCHAR(10),
    HasDependents VARCHAR(10),
    LoanPurpose VARCHAR(50),
    HasCoSigner VARCHAR(10),
    LoanDefault INT,
    Income_Category VARCHAR(20),
    Risk_Level VARCHAR(20),
    Age_Group VARCHAR(50),
    Advanced_Risk VARCHAR(20)
);
SELECT COUNT(*) FROM loans;
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'C:/cleaned_loans.csv'
INTO TABLE loans
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SHOW VARIABLES LIKE 'local_infile';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cleaned_loans.csv'
INTO TABLE loans
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
select count(*) from loans;
SELECT 
    COUNT(*) AS total_customers,
    SUM(LoanDefault) AS total_defaults,
    ROUND(AVG(LoanDefault) * 100, 2) AS default_rate_percentage
FROM loans;
SELECT 
    Income_Category,
    COUNT(*) AS total_customers,
    SUM(LoanDefault) AS total_defaults,
    ROUND(AVG(LoanDefault) * 100, 2) AS default_rate_percentage
FROM loans
GROUP BY Income_Category
ORDER BY default_rate_percentage DESC;
SELECT 
    EmploymentType,
    COUNT(*) AS total_customers,
    ROUND(AVG(LoanDefault) * 100, 2) AS default_rate_percentage
FROM loans
GROUP BY EmploymentType
ORDER BY default_rate_percentage DESC;
SELECT 
    LoanID,
    CreditScore,
    DTIRatio,
    Income,
    LoanAmount
FROM loans
WHERE CreditScore < 600 
AND DTIRatio > 0.4
ORDER BY DTIRatio DESC
LIMIT 10;
SELECT COUNT(*) FROM loans;
SELECT 
    Advanced_Risk,
    COUNT(*) AS total_customers,
    SUM(LoanDefault) AS total_defaults,
    ROUND(AVG(LoanDefault) * 100, 2) AS default_rate_percentage
FROM loans
GROUP BY Advanced_Risk
ORDER BY default_rate_percentage DESC;
SELECT 
    Advanced_Risk,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loans), 2) AS percentage_of_total
FROM loans
GROUP BY Advanced_Risk;
SELECT 
    CASE 
        WHEN CreditScore < 600 THEN 'Poor'
        WHEN CreditScore BETWEEN 600 AND 700 THEN 'Average'
        ELSE 'Good'
    END AS CreditScore_Band,
    COUNT(*) AS total_customers,
    ROUND(AVG(LoanDefault) * 100, 2) AS default_rate_percentage
FROM loans
GROUP BY CreditScore_Band
ORDER BY default_rate_percentage DESC;
SELECT 
    CASE 
        WHEN DTIRatio < 0.3 THEN 'Low DTI (<30%)'
        WHEN DTIRatio BETWEEN 0.3 AND 0.5 THEN 'Medium DTI (30-50%)'
        ELSE 'High DTI (>50%)'
    END AS DTI_Band,
    COUNT(*) AS total_customers,
    ROUND(AVG(LoanDefault) * 100, 2) AS default_rate_percentage
FROM loans
GROUP BY DTI_Band
ORDER BY default_rate_percentage DESC;
SELECT 
    CASE 
        WHEN CreditScore < 600 THEN 'Poor'
        WHEN CreditScore BETWEEN 600 AND 700 THEN 'Average'
        ELSE 'Good'
    END AS CreditScore_Band,
    
    CASE 
        WHEN DTIRatio < 0.3 THEN 'Low DTI'
        WHEN DTIRatio BETWEEN 0.3 AND 0.5 THEN 'Medium DTI'
        ELSE 'High DTI'
    END AS DTI_Band,

    ROUND(AVG(LoanDefault) * 100, 2) AS default_rate_percentage,
    COUNT(*) AS total_customers

FROM loans
GROUP BY CreditScore_Band, DTI_Band
ORDER BY default_rate_percentage DESC;