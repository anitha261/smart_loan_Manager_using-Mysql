CREATE TABLE customer_criteria (
    Customer_ID VARCHAR(15),
    Applicant_Income int,
    Income_Grade VARCHAR(25)
);

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


