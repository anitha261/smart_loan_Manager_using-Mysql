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


