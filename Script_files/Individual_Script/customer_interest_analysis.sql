
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






