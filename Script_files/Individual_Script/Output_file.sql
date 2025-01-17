SELECT * FROM loan_management_system.customer_home_loan_data;

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

-- Output 3: Filter High CIBIL Score Customers

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