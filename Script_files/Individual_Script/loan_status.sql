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
