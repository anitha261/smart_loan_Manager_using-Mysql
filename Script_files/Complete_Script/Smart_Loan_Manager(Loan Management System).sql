create table customer_income_status (
Loan_ID varchar(20),
Customer_ID varchar(15),
Applicant_Income int,
Co_Applicant_Income int,
Property_Area varchar(20),
Loan_Status varchar(10)
);

-- Import Data from source 'customer_income.csv'

select * from customer_income_status;

-- Creating New field Income grade based on applicant income

CREATE TABLE customer_criteria (
    Customer_ID VARCHAR(15),
    Applicant_Income int,
    Income_Grade VARCHAR(25)
);

-- Income Grade Criteria

INSERT INTO customer_criteria (Customer_ID, Applicant_Income, Income_Grade)
SELECT Customer_ID, Applicant_Income,
       CASE
           WHEN Applicant_Income > 15000 THEN 'Grade A'
           WHEN Applicant_Income > 9000 THEN 'Grade B'
           WHEN Applicant_Income > 5000 THEN 'Middle Class'
           ELSE 'Low Class'
       END AS Income_Grade
FROM customer_income_status;

SELECT * FROM customer_criteria;

CREATE TABLE monthly_interest (
	Loan_ID varchar(20),
    Applicant_Income INT,
    Property_Area VARCHAR(20),
    Monthly_Interest_Percentage DECIMAL(5, 2),
	PRIMARY KEY (Loan_ID)
);

-- Finding Monthly Interest Percentage through their Property Area

INSERT INTO monthly_interest (Loan_ID, Applicant_Income, Property_Area, Monthly_Interest_Percentage)
SELECT Loan_ID,
	   Applicant_Income,
       Property_Area,
       CASE
           WHEN Applicant_Income < 5000 AND Property_Area = 'Rural' THEN 0.03
           WHEN Applicant_Income < 5000 AND Property_Area = 'Semirural' THEN 0.035
           WHEN Applicant_Income < 5000 AND Property_Area = 'Urban' THEN 0.05
           WHEN Applicant_Income < 5000 AND Property_Area = 'Semiurban' THEN 0.025
           ELSE 0.07
       END AS Monthly_Interest_Percentage
FROM customer_income_status;

SELECT * FROM monthly_interest;

-- To Create New field Monthly_Interest_Amount and Annual_Interest_Amount we need to know Loan_Amount

-- Getting Loan_Amount from Loan_Status

CREATE TABLE loan_status(
Loan_ID varchar(20),
Customer_ID varchar(15),
Loan_Amount Varchar(40),
Loan_Amount_Term int,
Cibil_score int,
primary key (Loan_ID)
);

-- Import Data from source 'loan_status.csv'

SELECT * FROM loan_status;

CREATE TABLE customer_interest_analysis (
    Loan_ID VARCHAR(20),
    Loan_Amount VARCHAR(40),
    Monthly_Interest_Percentage DECIMAL(5,2),
    Monthly_Interest_Amount DECIMAL(10, 2),
    Annual_Interest_Amount DECIMAL(10, 2),
    PRIMARY KEY (Loan_ID)
);

INSERT INTO customer_interest_analysis (Loan_ID, Loan_Amount, Monthly_Interest_Percentage, Monthly_Interest_Amount, Annual_Interest_Amount)
SELECT cs.Loan_ID,
	   cs.Loan_Amount,
       mi.Monthly_Interest_Percentage,
       (cs.Loan_Amount * mi.Monthly_Interest_Percentage) AS Monthly_Interest_Amount,
       (cs.Loan_Amount * (mi.Monthly_Interest_Percentage) * 12) AS Annual_Interest_Amount
FROM loan_status cs
JOIN monthly_interest mi ON cs.Loan_ID = mi.Loan_ID
WHERE cs.Loan_Amount IS NOT NULL;  -- Ensure only loans with a non-null amount are included

SELECT * FROM customer_interest_analysis;

CREATE TABLE loan_cibil_score_status_details (
    Loan_ID VARCHAR(20),
    Cibil_Score INT,
    Loan_Amount VARCHAR(40),
    Loan_Status VARCHAR(50),
    PRIMARY KEY (Loan_ID)
);

-- Creating Row Level Trigger to Insert only Not Null Loan_Amount. If Null exists Ensuring it to set as 'Loan still Processing' while Inserting Data

DELIMITER //

CREATE TRIGGER trg_loan_processing_check BEFORE INSERT ON loan_cibil_score_status_details
FOR EACH ROW
BEGIN
    IF NEW.Loan_Amount IS NULL THEN
        SET NEW.Loan_Status = 'Loan still Processing';
    END IF;
END //

DELIMITER ;

-- Creating Row Level Trigger to Insert Cibil_Score_Status based on Given Criteria While inserting Data.

DELIMITER //

CREATE TRIGGER trg_cibil_score_status BEFORE INSERT ON loan_cibil_score_status_details
FOR EACH ROW
BEGIN
    IF NEW.Cibil_Score > 900 THEN
        SET NEW.Loan_Status = 'High Cibil Score';
    ELSEIF NEW.Cibil_Score > 750 THEN
        SET NEW.Loan_Status = 'No Penalty';
    ELSEIF NEW.Cibil_Score > 0 THEN
        SET NEW.Loan_Status = 'Penalty Customers';
    ELSE
        DELETE FROM loan_cibil_score_status_details WHERE Loan_ID = NEW.Loan_ID;
    END IF;
END //

-- After Inserting the Cibil_Score_Status the Data type of Loan_Amount is modified to Integer

ALTER TABLE loan_cibil_score_status_details MODIFY Loan_Amount INT;

SELECT * FROM loan_cibil_score_status_details;

CREATE TABLE customer_info (
    Customer_ID varchar(25),
    Customer_Name varchar(40),
    Gender varchar(10),
    Age int,
    Marital_Status varchar(10),
    Education varchar(25),
    Self_Employed varchar(15),
    Loan_ID varchar(20),
    Region_ID decimal(5,2),
    primary Key (Customer_ID)
);

-- Import Data from source 'customer_info.csv'

SELECT * FROM customer_info;

-- Updating Values which are Incorrect

UPDATE customer_info
SET Gender = CASE 
    WHEN Customer_ID = 'IP43006' THEN 'Female'
    WHEN Customer_ID = 'IP43016' THEN 'Female'
    WHEN Customer_ID = 'IP43018' THEN 'Male'
    WHEN Customer_ID = 'IP43038' THEN 'Male'
    WHEN Customer_ID = 'IP43508' THEN 'Female'
    WHEN Customer_ID = 'IP43577' THEN 'Female'
    WHEN Customer_ID = 'IP43589' THEN 'Female'
    WHEN Customer_ID = 'IP43593' THEN 'Female'
    ELSE Gender
END
WHERE Customer_ID IN ('IP43006', 'IP43016', 'IP43018', 'IP43038', 'IP43508', 'IP43577', 'IP43589', 'IP43593');

UPDATE customer_info
SET Age = CASE 
    WHEN Customer_ID = 'IP43007' THEN 45
    WHEN Customer_ID = 'IP43009' THEN 32
    ELSE Age
END
WHERE Customer_ID IN ('IP43007', 'IP43009');

SELECT * FROM customer_info;

CREATE TABLE region_info (
	Region varchar(15),
    Region_ID decimal(5,2)
    );
    
-- Import Data from source 'region_info.csv'
    
SELECT * FROM region_info;

CREATE TABLE country_state (
    Customer_ID varchar(25),
    Loan_ID varchar(25),
    Customer_name varchar(100),
    Region_id decimal(5,2),
    Postal_Code varchar(20),
    Segment varchar(50),
    State varchar(50),
    Primary key (Customer_ID)
);

-- Import Data from source 'country_state.csv'

SELECT * FROM country_state;

-- Join country_state and region_info tables using join Function

SELECT 
    cs.Customer_id,
    cs.Customer_name,
    cs.Region_id,
    cs.Postal_Code,
    cs.Segment,
    cs.State,
    ri.Region AS Region
FROM 
    country_state cs
JOIN 
    region_info ri
    ON cs.Region_id = ri.Region_id;

-- Final Output Script(Loan_Management_System)

CREATE TABLE customer_home_loan_data AS
SELECT 
    cis.Loan_ID,
    cis.Customer_ID,
    cis.Applicant_Income,
    cis.Co_Applicant_Income,
    cis.Property_Area,
    cc.Income_Grade,
    cia.Loan_Amount,
    cia.Monthly_Interest_Percentage,
    cia.Monthly_Interest_Amount,
    cia.Annual_Interest_Amount,
    lcs.Cibil_Score,
    lcs.Loan_Status AS Loan_Status_Cibil,  -- Renaming Loan_Status to avoid conflict
    ci.Customer_Name,
    ci.Gender,
    ci.Age,
    ci.Marital_Status,
    ci.Education,
    ci.Self_Employed,
    cs.Region_id,
    cs.Postal_Code,
    cs.Segment,
    cs.State,
    ri.Region
FROM 
    customer_income_status cis
JOIN 
    customer_criteria cc
    ON cis.Customer_ID = cc.Customer_ID
JOIN 
    customer_interest_analysis cia
    ON cis.Loan_ID = cia.Loan_ID
JOIN 
    loan_cibil_score_status_details lcs
    ON cis.Loan_ID = lcs.Loan_ID
JOIN 
    customer_info ci
    ON cis.Loan_ID = ci.Loan_ID
JOIN 
    country_state cs
    ON cis.Customer_ID = cs.Customer_ID
JOIN 
    region_info ri
    ON cs.Region_id = ri.Region_ID;
    
-- Output 1: Join all the 5 tables without repeating the fields

SELECT * FROM customer_home_loan_data;

-- Output 2: find the mismatch details using joins

SELECT 
    c.loan_id,
    c.customer_id,
    c.customer_name,
    c.region_id,
    c.postal_code,
    c.segment,
    c.state,
    r.region
FROM 
    country_state c
RIGHT JOIN 
    region_info r 
    ON c.region_id = r.region_id
WHERE 
    c.loan_id IS NULL;

-- Output 3: Filtered High CIBIL Score Customers

SELECT 
    cis.Loan_ID,
    cis.Customer_ID,
    cis.Applicant_Income,
    cis.Co_Applicant_Income,
    cis.Property_Area,
    cc.Income_Grade,
    cia.Loan_Amount,
    cia.Monthly_Interest_Percentage,
    cia.Monthly_Interest_Amount,
    cia.Annual_Interest_Amount,
    lcs.Cibil_Score,
    lcs.Loan_Status AS Loan_Status_Cibil,
    ci.Customer_Name,
    ci.Gender,
    ci.Age,
    ci.Marital_Status,
    ci.Education,
    ci.Self_Employed,
    cs.Region_id,
    cs.Postal_Code,
    cs.Segment,
    cs.State,
    ri.Region
FROM 
    customer_income_status cis
JOIN 
    customer_criteria cc ON cis.Customer_ID = cc.Customer_ID
JOIN 
    customer_interest_analysis cia ON cis.Loan_ID = cia.Loan_ID
JOIN 
    loan_cibil_score_status_details lcs ON cis.Loan_ID = lcs.Loan_ID
JOIN 
    customer_info ci ON cis.Loan_ID = ci.Loan_ID
JOIN 
    country_state cs ON cis.Customer_ID = cs.Customer_ID
JOIN 
    region_info ri ON cs.Region_id = ri.Region_id
WHERE 
    lcs.Cibil_Score > 700;

-- Output 4: Filter Home Office and Corporate Customers

SELECT 
    cis.Loan_ID,
    cis.Customer_ID,
    cis.Applicant_Income,
    cis.Co_Applicant_Income,
    cis.Property_Area,
    cc.Income_Grade,
    cia.Loan_Amount,
    cia.Monthly_Interest_Percentage,
    cia.Monthly_Interest_Amount,
    cia.Annual_Interest_Amount,
    lcs.Cibil_Score,
    lcs.Loan_Status AS Loan_Status_Cibil,
    ci.Customer_Name,
    ci.Gender,
    ci.Age,
    ci.Marital_Status,
    ci.Education,
    ci.Self_Employed,
    cs.Region_id,
    cs.Postal_Code,
    cs.Segment,
    cs.State,
    ri.Region
FROM 
    customer_income_status cis
JOIN 
    customer_criteria cc ON cis.Customer_ID = cc.Customer_ID
JOIN 
    customer_interest_analysis cia ON cis.Loan_ID = cia.Loan_ID
JOIN 
    loan_cibil_score_status_details lcs ON cis.Loan_ID = lcs.Loan_ID
JOIN 
    customer_info ci ON cis.Loan_ID = ci.Loan_ID
JOIN 
    country_state cs ON cis.Customer_ID = cs.Customer_ID
JOIN 
    region_info ri ON cs.Region_id = ri.Region_id
WHERE 
    cs.Segment IN ('Home Office', 'Corporate');
    
-- Output 5: Store all the outputs as procedures

delimiter $$
create procedure project_data()
begin

select * from customer_home_loan_data;

select c.loan_ID, c.customer_ID, c.Customer_Name, c.Region_id, c.Postal_Code, c.Segment, c.state, r.Region from country_state c 
right join region_info r on c.Region_id= r.Region_id where loan_ID is null;

select * from customer_home_loan_data where cibil_score_status = 'High_Cibil Score';

select * from customer_home_loan_data where Segment in ('Home Office', 'Corporate');
end $$

delimiter ;

call project_data;
    
-- End Script

