
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




