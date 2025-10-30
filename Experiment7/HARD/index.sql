-- Step 1: Create the main employee table
CREATE TABLE tbl_employee (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    emp_salary NUMERIC
);

-- Step 2: Create the audit table
CREATE TABLE tbl_employee_audit (
    sno SERIAL PRIMARY KEY,
    message TEXT
);

-- Step 3: Create the trigger function
CREATE OR REPLACE FUNCTION audit_employee_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN
    -- When a new employee is inserted
    IF TG_OP = 'INSERT' THEN
        INSERT INTO tbl_employee_audit(message)
        VALUES ('Employee name ' || NEW.emp_name || ' has been added at ' || NOW());
        RETURN NEW;

    -- When an employee is deleted
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO tbl_employee_audit(message)
        VALUES ('Employee name ' || OLD.emp_name || ' has been deleted at ' || NOW());
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$;

-- Step 4: Create the trigger
CREATE TRIGGER trg_employee_audit
AFTER INSERT OR DELETE
ON tbl_employee
FOR EACH ROW
EXECUTE FUNCTION audit_employee_changes();

-- Step 5: Test the trigger

-- Insert an employee
INSERT INTO tbl_employee (emp_name, emp_salary)
VALUES ('Aman', 50000);

-- Delete an employee
DELETE FROM tbl_employee
WHERE emp_name = 'Aman';

-- Step 6: View the audit log
SELECT * FROM tbl_employee_audit;
