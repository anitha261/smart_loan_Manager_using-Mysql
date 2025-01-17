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

