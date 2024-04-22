CREATE TABLE universitytest.trig (
employee_id CHAR(8) PRIMARY KEY, 
employee_name VARCHAR(50) NOT NULL, 
degree VARCHAR(50) DEFAULT NULL, 
start_date DATE NOT NULL,
days_since_start INT DEFAULT 0,
timecategory VARCHAR(50) DEFAULT 'A',
timedescription VARCHAR(50) DEFAULT 'Under 1 Year',
last_edited TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE PROCEDURE universitytest.days_update()
BEGIN
    UPDATE universitytest.trig
    SET days_since_start = DATEDIFF(CURDATE(), start_date);
    
    UPDATE universitytest.trig
    SET timecategory = CASE
        WHEN days_since_start < 365 THEN 'A'
        WHEN days_since_start BETWEEN 365 AND 1825 THEN 'B'
        ELSE 'C'
    END;
    
	UPDATE universitytest.trig
    SET timedescription = CASE
        WHEN days_since_start < 365 THEN 'Under 1 Year'
        WHEN days_since_start BETWEEN 365 AND 1460 THEN '1-4 Years'
        ELSE 'Over 4 Years'
    END;
    
    -- Could display if you wanted
    -- SELECT*FROM universitytest.trig
    -- ORDER BY days_since_start;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE universitytest.promotion()
BEGIN
    SELECT*FROM universitytest.trig
    WHERE timecategory = 'C'
    AND degree = 'PHD'
    ORDER BY employee_id;
END//
DELIMITER ;

-- Create trigger that automatically adds update timestamp when a row is updated
DELIMITER //
CREATE TRIGGER universitytest.updatetrigger
BEFORE UPDATE ON universitytest.trig
FOR EACH ROW
BEGIN
    IF NEW.employee_id <> OLD.employee_id OR NEW.employee_name <> OLD.employee_name OR NEW.start_date <> OLD.start_date THEN
    SET NEW.last_edited = CURRENT_TIMESTAMP();
    END IF;
END;
//
DELIMITER ;

-- DROP TRIGGER IF EXISTS universitytest.inserttrigger;


