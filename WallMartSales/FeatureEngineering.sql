-- Feature Enginnering 

-- Creating a new column based on time column
SELECT time,
		(
			CASE WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN  "Morning"
				 WHEN `time` BETWEEN "02:01:00" AND "16:00:00" THEN  "Afternoon"
            ELSE "Evening"
            END
        ) as TimeOfDay
	FROM sales;


-- Adding a new column from time column
ALTER TABLE sales ADD COLUMN TimeOfDay VARCHAR(20);

-- Updating the records of the new column on new value 
UPDATE sales
SET TimeOfDay = (
			CASE WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN  "Morning"
				 WHEN `time` BETWEEN "02:01:00" AND "16:00:00" THEN  "Afternoon"
            ELSE "Evening"
            END
        );
        
        
-- Adding a new column - DayName from Date  
ALTER TABLE sales ADD COLUMN DayName VARCHAR(20);

UPDATE sales 
set DayName = (
SELECT 	dayname(Date)
);
select * from sales;

-- Adding a new column - MonthName from Date  
ALTER TABLE sales ADD COLUMN MonthName VARCHAR(20);

UPDATE sales 
set MonthName = (
SELECT 	monthname(Date)
);