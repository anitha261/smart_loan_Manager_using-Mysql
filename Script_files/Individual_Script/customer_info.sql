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

