-- Create Accounts table to store unique account information
CREATE TABLE Accounts (
    ACCOUNT_ID NUMBER PRIMARY KEY
    -- You can add more fields related to accounts if needed
);
-- Create FinancialTransactions table
CREATE TABLE FinancialTransactions (
    TRANSACTION_ID NUMBER PRIMARY KEY,
    ACCOUNT_ID NUMBER NOT NULL,
    TRANSACTION_DATE DATE NOT NULL,
    AMOUNT NUMBER NOT NULL,
    DESCRIPTION VARCHAR2(255),
    FOREIGN KEY (ACCOUNT_ID) REFERENCES Accounts(ACCOUNT_ID)
);

-- Create AccountReconciliations table with foreign key reference to ACCOUNT_ID
CREATE TABLE AccountReconciliations (
    RECONCILIATION_ID NUMBER PRIMARY KEY,
    ACCOUNT_ID NUMBER NOT NULL,
    RECONCILIATION_DATE DATE NOT NULL,
    BALANCE NUMBER NOT NULL,
    STATUS VARCHAR2(50),
    CONSTRAINT fk_account_reconciliation
    FOREIGN KEY (ACCOUNT_ID) REFERENCES Accounts(ACCOUNT_ID)
);

-- Create FinancialReports table
CREATE TABLE FinancialReports (
    REPORT_ID NUMBER PRIMARY KEY,
    REPORT_DATE DATE NOT NULL,
    ACCOUNT_BALANCES CLOB,
    TRANSACTION_SUMMARY CLOB,
    RECONCILIATION_STATUS VARCHAR2(50)
);

-- Insert sample data into Accounts table
INSERT INTO Accounts (ACCOUNT_ID) VALUES (101);
INSERT INTO Accounts (ACCOUNT_ID) VALUES (102);
INSERT INTO Accounts (ACCOUNT_ID) VALUES (103);
INSERT INTO Accounts (ACCOUNT_ID) VALUES (104);
INSERT INTO Accounts (ACCOUNT_ID) VALUES (105);
INSERT INTO Accounts (ACCOUNT_ID) VALUES (106);
INSERT INTO Accounts (ACCOUNT_ID) VALUES (107);
INSERT INTO Accounts (ACCOUNT_ID) VALUES (108);

SELECT * FROM Accounts;

-- Insert sample data into FinancialTransactions
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (1, 101, TO_DATE('2024-08-01', 'YYYY-MM-DD'), 100.00, 'Office supplies purchase');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (2, 102, TO_DATE('2024-08-02', 'YYYY-MM-DD'), 250.00, 'Client project materials');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (3, 103, TO_DATE('2024-08-03', 'YYYY-MM-DD'), 150.00, 'Software subscription renewal');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (4, 104, TO_DATE('2024-08-04', 'YYYY-MM-DD'), 200.00, 'Employee travel reimbursement');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (5, 105, TO_DATE('2024-08-05', 'YYYY-MM-DD'), 300.00, 'Monthly utilities payment');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (6, 106, TO_DATE('2024-08-06', 'YYYY-MM-DD'), 120.00, 'Marketing campaign expenses');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (7, 107, TO_DATE('2024-08-07', 'YYYY-MM-DD'), 180.00, 'Office rent payment');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (8, 108, TO_DATE('2024-08-08', 'YYYY-MM-DD'), 220.00, 'Hardware repair services');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (9, 101, TO_DATE('2024-08-09', 'YYYY-MM-DD'), 110.00, 'Client meeting expenses');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (10, 102, TO_DATE('2024-08-10', 'YYYY-MM-DD'), 260.00, 'IT infrastructure upgrade');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (11, 103, TO_DATE('2024-08-11', 'YYYY-MM-DD'), 160.00, 'Training program fees');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (12, 104, TO_DATE('2024-08-12', 'YYYY-MM-DD'), 210.00, 'Conference registration');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (13, 105, TO_DATE('2024-08-13', 'YYYY-MM-DD'), 310.00, 'New equipment purchase');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (14, 106, TO_DATE('2024-08-14', 'YYYY-MM-DD'), 130.00, 'Web hosting services');
INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
VALUES (15, 107, TO_DATE('2024-08-15', 'YYYY-MM-DD'), 190.00, 'Annual maintenance contract');


SELECT * FROM FinancialTransactions;


--*******************************************************************-----
----------------------Procedure for Handling Financial Transactions---------------------
CREATE OR REPLACE PROCEDURE ManageTransaction (
    p_transaction_id IN NUMBER,
    p_account_id IN NUMBER,
    p_transaction_date IN DATE,
    p_amount IN NUMBER,
    p_description IN VARCHAR2,
    p_action IN VARCHAR2 -- 'INSERT', 'UPDATE', 'DELETE'
) AS
BEGIN
    IF p_action = 'INSERT' THEN
        INSERT INTO FinancialTransactions (TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, DESCRIPTION)
        VALUES (p_transaction_id, p_account_id, p_transaction_date, p_amount, p_description);
        
    ELSIF p_action = 'UPDATE' THEN
        UPDATE FinancialTransactions
        SET ACCOUNT_ID = p_account_id,
            TRANSACTION_DATE = p_transaction_date,
            AMOUNT = p_amount,
            DESCRIPTION = p_description
        WHERE TRANSACTION_ID = p_transaction_id;
        
    ELSIF p_action = 'DELETE' THEN
        DELETE FROM FinancialTransactions
        WHERE TRANSACTION_ID = p_transaction_id;
        
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Invalid action specified');
    END IF;
    
    COMMIT;
END ManageTransaction;
/

--Testing the Procedures
--Test 1: Add/INSERT a New Transaction
BEGIN
    ManageTransaction(
        p_transaction_id => 17,
        p_account_id => 101,
        p_transaction_date => TO_DATE('2024-08-16', 'YYYY-MM-DD'),
        p_amount => 300.00,
        p_description => 'Payment for invoice #017',
        p_action => 'INSERT'
    );
END;
/
--Check Transaction Where Added--
SELECT * FROM FinancialTransactions;

--Test 2: Update an Existing Transaction
BEGIN
    ManageTransaction(
        p_transaction_id => 1,
        p_account_id => 101,
        p_transaction_date => TO_DATE('2024-08-17', 'YYYY-MM-DD'),
        p_amount => 130.00,
        p_description => 'Updated payment for invoice #001',
        p_action => 'UPDATE'
    );
END;
/
--Check Transaction Where Updated--
SELECT * FROM FinancialTransactions;

--Test 3: Delete a Transaction
BEGIN
    ManageTransaction(
        p_transaction_id => 17,
        p_account_id => 101,
        p_transaction_date => NULL,
        p_amount => NULL,
        p_description => NULL,
        p_action => 'DELETE'
    );
END;
/
--Check Transaction Where Deleted--
SELECT * FROM FinancialTransactions;


----------------------------Procedure for Account Reconciliation-----------------------------
--Creating Sequences Account Reconciliation
CREATE SEQUENCE AccountReconciliations_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
/
--Procedure for Account Reconciliation
CREATE OR REPLACE PROCEDURE ReconcileAccount (
    p_account_id IN NUMBER,
    p_reconciliation_date IN DATE
) AS
    v_balance NUMBER;
    v_status VARCHAR2(50);
BEGIN
    -- Calculate the balance for the given account
    BEGIN
        SELECT NVL(SUM(AMOUNT), 0)
        INTO v_balance
        FROM FinancialTransactions
        WHERE ACCOUNT_ID = p_account_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_balance := 0;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error calculating balance: ' || SQLERRM);
    END;
    
    -- Determine reconciliation status
    v_status := 'Completed'; -- Example status, adjust as needed
    
    -- Check if a reconciliation record exists for the account
    DECLARE
        v_exists NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_exists
        FROM AccountReconciliations
        WHERE ACCOUNT_ID = p_account_id
          AND RECONCILIATION_DATE = p_reconciliation_date;
          
        IF v_exists > 0 THEN
            -- Update existing reconciliation record
            UPDATE AccountReconciliations
            SET BALANCE = v_balance,
                STATUS = v_status
            WHERE ACCOUNT_ID = p_account_id
              AND RECONCILIATION_DATE = p_reconciliation_date;
        ELSE
            -- Insert new reconciliation record
            INSERT INTO AccountReconciliations (RECONCILIATION_ID, ACCOUNT_ID, RECONCILIATION_DATE, BALANCE, STATUS)
            VALUES (AccountReconciliations_seq.NEXTVAL, p_account_id, p_reconciliation_date, v_balance, v_status);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20003, 'Error reconciling account: ' || SQLERRM);
    END;
    
    COMMIT;
END ReconcileAccount;
/

--Check Existing Reports Verify if there's already a report with the same REPORT_ID
SELECT * FROM AccountReconciliations WHERE ACCOUNT_ID = 101;

--Test 4: Reconcile an Account
BEGIN
    ReconcileAccount(
        p_account_id => 101,
        p_reconciliation_date => TO_DATE('2024-08-31', 'YYYY-MM-DD')
    );
END;
/

--Check 
SELECT * FROM AccountReconciliations;


---------------------------Procedure for Generating Financial Reports---------------------------------
--Sequence for FinancialReports Table
CREATE SEQUENCE FinancialReports_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
/

--Procedure for Generating Financial Reports
CREATE OR REPLACE PROCEDURE GenerateFinancialReport (
    p_report_date IN DATE
) AS
    v_account_balances CLOB;
    v_transaction_summary CLOB;
    v_reconciliation_status VARCHAR2(50);
BEGIN
    -- Aggregate account balances
    SELECT LISTAGG('   Account no ' || ACCOUNT_ID || ': ' || NVL(SUM(AMOUNT), 0), ' , ') WITHIN GROUP (ORDER BY ACCOUNT_ID)
    INTO v_account_balances
    FROM FinancialTransactions
    GROUP BY ACCOUNT_ID;

    -- Summarize transactions
    SELECT 'Total Transactions: ' || COUNT(*) || ', Total Amount: ' || SUM(AMOUNT)
    INTO v_transaction_summary
    FROM FinancialTransactions;

    -- Determine reconciliation status
    v_reconciliation_status := 'All reconciliations completed'; -- Example status, adjust as needed

    -- Insert report into FinancialReports table
    INSERT INTO FinancialReports (REPORT_ID, REPORT_DATE, ACCOUNT_BALANCES, TRANSACTION_SUMMARY, RECONCILIATION_STATUS)
    VALUES (
        FinancialReports_seq.NEXTVAL,  -- Ensure FinancialReports_seq exists
        p_report_date,
        v_account_balances,
        v_transaction_summary,
        v_reconciliation_status
    );

    COMMIT;
END GenerateFinancialReport;
/

--Test 5: Generate a Financial Report
BEGIN
    GenerateFinancialReport(
        p_report_date => TO_DATE('2024-08-31', 'YYYY-MM-DD')
    );
END;
/
--Verify Results
SELECT * FROM FinancialReports;
