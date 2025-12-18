/*1. Customer & KYC Management
Schema: CUSTOMERS table with fields for PAN (10-char), Aadhaar (12-digit), KYC status, etc., and an audit table.
Constraints/Validation: CHECK constraints or PL/SQL functions for PAN/Aadhaar format.
Sequences: SEQ_CUSTOMERS for unique customer IDs.
Triggers: TRG_CUSTOMERS_AUDIT logs INSERT/UPDATE/DELETE into an audit table (CUSTOMER_AUDIT).
Sample Data: 50+ customer records with realistic PAN/Aadhaar (e.g., 'ABCDE1234F', '123412341234').*/


-- Customer schema and audit logging
CREATE SEQUENCE seq_customers START WITH 1000 INCREMENT BY 1;

CREATE TABLE customers (
  customer_id NUMBER PRIMARY KEY,
  full_name VARCHAR2(100) NOT NULL,
  date_of_birth DATE,
  pan VARCHAR2(10) UNIQUE NOT NULL,
  aadhaar VARCHAR2(12) UNIQUE NOT NULL,
  email VARCHAR2(100),
  phone VARCHAR2(15),
  kyc_status VARCHAR2(10)  DEFAULT 'Pending' CHECK (kyc_status IN ('Verified','Pending')),
  created_at DATE DEFAULT SYSDATE,
  updated_at DATE
);

CREATE SEQUENCE seq_customer_audit START WITH 1;

CREATE TABLE customer_audit (
  audit_id NUMBER PRIMARY KEY,
  customer_id NUMBER,
  action_type VARCHAR2(10),
  action_date TIMESTAMP DEFAULT SYSTIMESTAMP,
  old_data CLOB,
  new_data CLOB
);

CREATE OR REPLACE TRIGGER trg_customers_audit
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW
DECLARE
  v_old CLOB := NULL;
  v_new CLOB := NULL;
BEGIN
  IF INSERTING THEN
    v_new := 'Name:'||:NEW.full_name||', PAN:'||:NEW.pan||', Aadhaar:'||:NEW.aadhaar;
    INSERT INTO customer_audit VALUES (
      seq_customer_audit.NEXTVAL, :NEW.customer_id, 'INSERT', SYSTIMESTAMP, NULL, v_new);
  ELSIF UPDATING THEN
    v_old := 'Name:'||:OLD.full_name||', PAN:'||:OLD.pan||', Aadhaar:'||:OLD.aadhaar;
    v_new := 'Name:'||:NEW.full_name||', PAN:'||:NEW.pan||', Aadhaar:'||:NEW.aadhaar;
    INSERT INTO customer_audit VALUES (
      seq_customer_audit.NEXTVAL, :OLD.customer_id, 'UPDATE', SYSTIMESTAMP, v_old, v_new);
  ELSIF DELETING THEN
    v_old := 'Name:'||:OLD.full_name||', PAN:'||:OLD.pan||', Aadhaar:'||:OLD.aadhaar;
    INSERT INTO customer_audit VALUES (
      seq_customer_audit.NEXTVAL, :OLD.customer_id, 'DELETE', SYSTIMESTAMP, v_old, NULL);
  END IF;
END;


-- Sample customer data (5 shown, extend to 50+)
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Rahul Verma', DATE '1985-06-15', 'ABCDE1234F', '123456789012', 'rahul.verma@example.com', '9876543210', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Priya Singh', DATE '1990-03-22', 'FGHIJ5678K', '567856785678', 'priya.singh@example.com', '9123456789', 'Pending', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Anil Kumar',  DATE '1978-11-05', 'KLMNO9101P', '345678901234', 'anil.kumar@example.com', '9987654321', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Suresh Patel', DATE '1982-01-12', 'PQRSX1111A', '234567890123', 'suresh.patel@example.com', '9001112233', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Neha Sharma', DATE '1993-07-19', 'LMNOP2222B', '345678901345', 'neha.sharma@example.com', '9002223344', 'Pending', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Vikas Mehta', DATE '1987-04-03', 'QWERT3333C', '456789012456', 'vikas.mehta@example.com', '9003334455', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Pooja Nair', DATE '1991-12-28', 'ASDFG4444D', '567890123567', 'pooja.nair@example.com', '9004445566', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Rohit Agarwal', DATE '1984-09-14', 'ZXCVB5555E', '678901234678', 'rohit.agarwal@example.com', '9005556677', 'Pending', SYSDATE, SYSDATE);

INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Kavita Joshi', DATE '1979-02-17', 'YUIOP6666F', '789012345789', 'kavita.joshi@example.com', '9006667788', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Manish Gupta', DATE '1988-06-25', 'HJKLA7777G', '890123456890', 'manish.gupta@example.com', '9007778899', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Sneha Kulkarni', DATE '1994-05-08', 'BNMQW8888H', '901234567901', 'sneha.kulkarni@example.com', '9011112222', 'Pending', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Arjun Reddy', DATE '1986-10-11', 'TREWY9999J', '912345678912', 'arjun.reddy@example.com', '9012223333', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Divya Iyer', DATE '1992-08-30', 'PLMKO1010K', '923456789023', 'divya.iyer@example.com', '9013334444', 'Verified', SYSDATE, SYSDATE);

INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Nitin Malhotra', DATE '1976-03-21', 'QAZWS2020L', '934567890134', 'nitin.malhotra@example.com', '9014445555', 'Pending', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Aarti Chawla', DATE '1989-11-09', 'EDCRF3030M', '945678901245', 'aarti.chawla@example.com', '9015556666', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Sanjay Rao', DATE '1981-01-27', 'TGBNH4040N', '956789012356', 'sanjay.rao@example.com', '9016667777', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Meenal Deshpande', DATE '1995-09-13', 'YHNJU5050P', '967890123467', 'meenal.deshpande@example.com', '9017778888', 'Pending', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Rakesh Bansal', DATE '1974-07-06', 'UJMKI6060Q', '978901234578', 'rakesh.bansal@example.com', '9018889999', 'Verified', SYSDATE, SYSDATE);

INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Sunita Mishra', DATE '1983-05-18', 'IKMJU7070R', '989012345689', 'sunita.mishra@example.com', '9021112222', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Akhil Menon', DATE '1990-02-02', 'LOPKI8080S', '990123456790', 'akhil.menon@example.com', '9022223333', 'Pending', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Pankaj Tiwari', DATE '1985-12-19', 'MNBCD9090T', '991234567891', 'pankaj.tiwari@example.com', '9023334444', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Ritu Saxena', DATE '1993-06-07', 'WERFG1111U', '992345678902', 'ritu.saxena@example.com', '9024445555', 'Pending', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Deepak Yadav', DATE '1980-10-24', 'ASZXV2222V', '993456789013', 'deepak.yadav@example.com', '9025556666', 'Verified', SYSDATE, SYSDATE);

INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Monika Bhatia', DATE '1991-04-15', 'BNMJK3333W', '994567890124', 'monika.bhatia@example.com', '9026667777', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Kunal Arora', DATE '1987-08-29', 'ZXCAS4444X', '995678901235', 'kunal.arora@example.com', '9027778888', 'Pending', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Shilpa Ghosh', DATE '1994-01-03', 'QWASD5555Y', '996789012346', 'shilpa.ghosh@example.com', '9028889999', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Abhishek Roy', DATE '1986-09-17', 'EDCVF6666Z', '997890123457', 'abhishek.roy@example.com', '9031112222', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Nandita Sen', DATE '1992-11-26', 'RFVTG7777A', '998901234568', 'nandita.sen@example.com', '9032223333', 'Pending', SYSDATE, SYSDATE);

INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Harish Pillai', DATE '1978-06-12', 'TGBYH8888B', '999012345679', 'harish.pillai@example.com', '9033334444', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Ishita Kapoor', DATE '1995-03-05', 'YHNUJ9999C', '100123456780', 'ishita.kapoor@example.com', '9034445555', 'Pending', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Gaurav Singhal', DATE '1989-12-01', 'UJMKI1212D', '101234567891', 'gaurav.singhal@example.com', '9035556666', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Ankita Bhardwaj', DATE '1991-07-20', 'IKMJU1313E', '102345678902', 'ankita.bhardwaj@example.com', '9036667777', 'Verified', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (seq_customers.NEXTVAL, 'Siddharth Jain', DATE '1984-02-14', 'LOPKI1414F', '103456789013', 'siddharth.jain@example.com', '9037778888', 'Pending', SYSDATE, SYSDATE);


select * from customers ;
select * from customer_audit;

commit ;
/*2. Account Lifecycle Management
Schema: ACCOUNTS table with types (Savings, Current, Salary, FD), status (Open, Frozen, Closed), balance, etc.
Sequences: SEQ_ACCOUNT for generating unique account numbers.
Triggers/Procedures: A BEFORE INSERT trigger (TRG_ACCOUNTS_NUMBER) auto-generates account_no (e.g. 'ACCT' || seq). 
Procedures to open/close/freeze accounts with balance checks.
Views: V_ACCOUNT_SUMMARY joins customers/accounts for summary.
Sample Data: 50+ account records linking to customer IDs.*/

-- Accounts schema and triggers
-- Internal surrogate key
CREATE SEQUENCE seq_account_id START WITH 1 INCREMENT BY 1;

-- Customer-facing account number
CREATE SEQUENCE seq_account_no START WITH 5000001 INCREMENT BY 1;

CREATE TABLE accounts (
  account_id   NUMBER PRIMARY KEY,
  account_no   VARCHAR2(20) UNIQUE NOT NULL,
  customer_id  NUMBER NOT NULL,
  account_type VARCHAR2(10)
    CHECK (account_type IN ('Savings','Current','Salary','FD')),
  status       VARCHAR2(10) DEFAULT 'Open'
    CHECK (status IN ('Open','Frozen','Closed')),
  balance      NUMBER(15,2)
    DEFAULT 0
    CHECK (balance >= 0),
  opened_date  DATE DEFAULT SYSDATE,
  closed_date  DATE,
  branch_code  VARCHAR2(5),
  CONSTRAINT fk_accounts_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);


CREATE OR REPLACE TRIGGER trg_accounts_number
BEFORE INSERT ON accounts
FOR EACH ROW
BEGIN
  IF :NEW.account_id IS NULL THEN
    :NEW.account_id := seq_account_id.NEXTVAL;
  END IF;

  IF :NEW.account_no IS NULL THEN
    :NEW.account_no := 'ACCT' || seq_account_no.NEXTVAL;
  END IF;
END;

-- Account summary view per customer
CREATE OR REPLACE VIEW v_account_summary AS
SELECT c.customer_id, c.full_name, a.account_no, a.account_type, a.status, a.balance, a.opened_date
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id;

-- Sample account data
-- Customer 1000
INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (1, 1000, 'Savings', 'Open', 15000, 'BR001');

INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (2, 1000, 'FD', 'Open', 250000, 'BR001');

-- Customer 1001
INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (3, 1001, 'Current', 'Open', 50000, 'BR001');

INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (4, 1001, 'Savings', 'Frozen', 12000, 'BR001');

-- Customer 1002
INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (5, 1002, 'Salary', 'Open', 20000, 'BR002');

INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (6, 1002, 'Savings', 'Open', 8000, 'BR002');

-- Customer 1003
INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (7, 1003, 'Savings', 'Open', 18000, 'BR003');

INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (8, 1003, 'FD', 'Open', 300000, 'BR003');

-- Customer 1004
INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (9, 1004, 'Current', 'Open', 75000, 'BR002');

INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (10, 1004, 'Savings', 'Closed', 0, 'BR002');

-- Customer 1005
INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (11, 1005, 'Salary', 'Open', 28000, 'BR004');

INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (12, 1005, 'Savings', 'Open', 9500, 'BR004');

-- Customer 1006
INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (13, 1006, 'Savings', 'Frozen', 11000, 'BR003');

INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (14, 1006, 'FD', 'Open', 150000, 'BR003');

-- Customer 1007
INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (15, 1007, 'Current', 'Open', 92000, 'BR001');

INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (16, 1007, 'Savings', 'Open', 14000, 'BR001');

-- Customer 1008
INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (17, 1008, 'Salary', 'Open', 32000, 'BR002');

INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (18, 1008, 'Savings', 'Closed', 0, 'BR002');

-- Customer 1009
INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (19, 1009, 'Savings', 'Open', 21000, 'BR005');

INSERT INTO accounts (account_id, customer_id, account_type, status, balance, branch_code)
VALUES (20, 1009, 'FD', 'Open', 500000, 'BR005');

select * from accounts ;
select * from v_account_summary;
commit;


/*3. Fixed and Recurring Deposits
Schema: FIXED_DEPOSITS and RECURRING_DEPOSITS tables with principal, interest rate, start/maturity dates, etc.
Interest Calculation: PL/SQL function to compute maturity amount (monthly/quarterly compounding).
Auto-renewal & Withdrawal: Flags (AUTO_RENEW) and triggers (e.g., on DELETE for premature withdrawal penalty).
TDS Logic: Procedure/function to deduct TDS on interest above exemption limits.
Views/Materialized: Possibly MV_FD_SCHEDULE for projected interest.
Sample Data: 50+ deposit entries.*/


-- Fixed and Recurring Deposits schema
CREATE TABLE fixed_deposits (
  fd_id NUMBER PRIMARY KEY,
  account_no VARCHAR2(16) REFERENCES accounts(account_no),
  principal NUMBER(15,2),
  interest_rate NUMBER(5,2),
  start_date DATE,
  maturity_date DATE,
  interest_frequency VARCHAR2(10) CHECK (interest_frequency IN ('Monthly','Quarterly')),
  auto_renew CHAR(1) DEFAULT 'N'
);

CREATE TABLE recurring_deposits (
  rd_id NUMBER PRIMARY KEY,
  account_no VARCHAR2(16) REFERENCES accounts(account_no),
  monthly_deposit NUMBER(15,2),
  interest_rate NUMBER(5,2),
  start_date DATE,
  tenure_months NUMBER,
  auto_renew CHAR(1) DEFAULT 'N'
);

-- Function to calculate FD maturity amount (simple interest example)
CREATE OR REPLACE FUNCTION fn_calc_fd_maturity(p_principal NUMBER, p_rate NUMBER, p_months NUMBER) RETURN NUMBER IS
  total_amount NUMBER;
BEGIN
  total_amount := p_principal * POWER(1 + (p_rate/100)/12, p_months);
  RETURN ROUND(total_amount,2);
END;
/

-- Trigger: Penalty on early FD withdrawal (DELETE)
CREATE OR REPLACE TRIGGER trg_fd_withdrawal
BEFORE DELETE ON fixed_deposits
FOR EACH ROW
BEGIN
  IF SYSDATE < :OLD.maturity_date THEN
    -- Deduct 1% penalty on principal from customer's account
    UPDATE accounts SET balance = balance - (:OLD.principal * 0.01)
    WHERE account_no = :OLD.account_no;
  END IF;
END;
/

DROP SEQUENCE seq_rd;
CREATE SEQUENCE seq_fd
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_rd
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

COMMIT;


-- Sample fixed deposit data
INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000001', 100000.00, 6.5,  DATE '2023-01-01', DATE '2025-01-01', 'Monthly',   'N');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000002', 200000.00, 7.0,  DATE '2023-03-15', DATE '2026-03-15', 'Quarterly', 'Y');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000003', 150000.00, 6.75, DATE '2023-02-01', DATE '2025-02-01', 'Monthly',   'N');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000004', 300000.00, 7.10, DATE '2023-04-10', DATE '2026-04-10', 'Quarterly', 'Y');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000005', 50000.00,  6.25, DATE '2023-01-20', DATE '2024-01-20', 'Monthly',   'N');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000006', 400000.00, 7.50, DATE '2023-05-01', DATE '2028-05-01', 'Quarterly', 'Y');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000007', 120000.00, 6.80, DATE '2023-03-15', DATE '2025-03-15', 'Monthly',   'N');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000008', 80000.00,  6.40, DATE '2023-06-01', DATE '2024-06-01', 'Monthly',   'N');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000009', 250000.00, 7.00, DATE '2023-07-10', DATE '2026-07-10', 'Quarterly', 'Y');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000010', 600000.00, 7.80, DATE '2023-08-01', DATE '2028-08-01', 'Quarterly', 'Y');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000011', 90000.00,  6.30, DATE '2023-09-05', DATE '2024-09-05', 'Monthly',   'N');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000012', 175000.00, 6.90, DATE '2023-10-01', DATE '2025-10-01', 'Monthly',   'N');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000013', 350000.00, 7.20, DATE '2023-11-12', DATE '2026-11-12', 'Quarterly', 'Y');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000014', 220000.00, 6.85, DATE '2023-12-01', DATE '2025-12-01', 'Monthly',   'N');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000015', 1000000.00,8.10, DATE '2024-01-01', DATE '2029-01-01', 'Quarterly', 'Y');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000016', 65000.00,  6.10, DATE '2024-02-10', DATE '2025-02-10', 'Monthly',   'N');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000017', 275000.00, 7.05, DATE '2024-03-01', DATE '2027-03-01', 'Quarterly', 'Y');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000018', 130000.00, 6.60, DATE '2024-04-15', DATE '2026-04-15', 'Monthly',   'N');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000019', 480000.00, 7.65, DATE '2024-05-01', DATE '2029-05-01', 'Quarterly', 'Y');

INSERT INTO fixed_deposits VALUES
(seq_fd.NEXTVAL, 'ACCT5000020', 900000.00, 8.00, DATE '2024-06-01', DATE '2029-06-01', 'Quarterly', 'Y');

COMMIT;

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000001', 2000,  6.50, DATE '2023-01-01', 24, 'N');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000002', 5000,  7.00, DATE '2023-02-01', 36, 'Y');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000003', 3000,  6.75, DATE '2023-03-01', 24, 'N');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000004', 8000,  7.25, DATE '2023-04-01', 60, 'Y');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000005', 1500,  6.25, DATE '2023-05-01', 12, 'N');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000006', 10000, 7.50, DATE '2023-06-01', 60, 'Y');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000007', 4000,  6.80, DATE '2023-07-01', 36, 'N');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000008', 2500,  6.40, DATE '2023-08-01', 24, 'N');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000009', 6000,  7.10, DATE '2023-09-01', 48, 'Y');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000010',12000, 7.80, DATE '2023-10-01', 60, 'Y');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000011',1800,  6.30, DATE '2023-11-01', 12, 'N');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000012',3500,  6.90, DATE '2023-12-01', 24, 'N');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000013',9000,  7.20, DATE '2024-01-01', 60, 'Y');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000014',4500,  6.85, DATE '2024-02-01', 36, 'N');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000015',15000, 8.10, DATE '2024-03-01', 60, 'Y');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000016',2200,  6.10, DATE '2024-04-01', 12, 'N');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000017',7000,  7.05, DATE '2024-05-01', 48, 'Y');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000018',3800,  6.60, DATE '2024-06-01', 24, 'N');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000019',11000, 7.65, DATE '2024-07-01', 60, 'Y');

INSERT INTO recurring_deposits VALUES
(seq_rd.NEXTVAL, 'ACCT5000020',9500,  8.00, DATE '2024-08-01', 60, 'Y');

COMMIT;


select * from recurring_deposits ;

commit;
/*4. Transactions and Payments
Schema: TRANSACTIONS table capturing deposits, withdrawals, transfers (including UPI/NEFT/RTGS).
Procedures: e.g., SP_TRANSFER debits one account and credits another, recording a transaction.
Triggers: Handle special cases—e.g., TRG_CHEQUE_BOUNCE levies a penalty for bounced cheques.
Ledger Entries: Upon each transaction, insert corresponding debit/credit entries (GL integration).
Reporting: Views for daily/monthly summaries (V_DAILY_TXNS, V_MONTHLY_TXNS).
Sample Data: 50+ transaction rows.*/

-- Transactions schema and logic
CREATE SEQUENCE seq_txn START WITH 10000 INCREMENT BY 1;

CREATE TABLE transactions (
  txn_id NUMBER PRIMARY KEY,
  txn_date DATE DEFAULT SYSDATE,
  from_account VARCHAR2(16) REFERENCES accounts(account_no),
  to_account VARCHAR2(16) REFERENCES accounts(account_no),
  amount NUMBER(15,2),
  txn_type VARCHAR2(10) CHECK (txn_type IN ('Deposit','Withdrawal','Transfer','UPI','NEFT','RTGS','Cheque')),
  status VARCHAR2(10) DEFAULT 'Pending'
);

-- Procedure: Fund transfer between accounts
CREATE OR REPLACE PROCEDURE sp_transfer (
    p_from_acc IN VARCHAR2,
    p_to_acc   IN VARCHAR2,
    p_amount   IN NUMBER
) IS
    v_balance NUMBER;
BEGIN
    -- Lock source account
    SELECT balance
    INTO v_balance
    FROM accounts
    WHERE account_no = p_from_acc
    AND status = 'Open'
    FOR UPDATE;

    IF v_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance');
    END IF;

    -- Debit
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_no = p_from_acc;

    -- Credit
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_no = p_to_acc;

    -- Transaction log
    INSERT INTO transactions
    VALUES (seq_txn.NEXTVAL, SYSDATE, p_from_acc, p_to_acc,
            p_amount, 'Transfer', 'Completed');

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        raise;
END;

-- Trigger: Cheque bounce penalty (e.g., Rs.500)
CREATE OR REPLACE TRIGGER trg_cheque_bounce
AFTER INSERT ON transactions
FOR EACH ROW
WHEN (NEW.txn_type = 'Cheque' AND NEW.status = 'Bounced')
BEGIN
  UPDATE accounts SET balance = balance - 500 WHERE account_no = :NEW.from_account;
END;
/

-- View: Daily transaction summary
CREATE OR REPLACE VIEW v_daily_transactions AS
SELECT TRUNC(txn_date) AS txn_day,
       COUNT(*) AS txn_count,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY TRUNC(txn_date);

-- Sample transactions data
--Deposits
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, NULL, 'ACCT5000001', 50000, 'Deposit', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, NULL, 'ACCT5000002', 75000, 'Deposit', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, NULL, 'ACCT5000003', 25000, 'Deposit', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, NULL, 'ACCT5000004', 60000, 'Deposit', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, NULL, 'ACCT5000005', 30000, 'Deposit', 'Completed');

--Withdrawals
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000001', NULL, 10000, 'Withdrawal', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000002', NULL, 20000, 'Withdrawal', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000003', NULL, 5000,  'Withdrawal', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000004', NULL, 12000, 'Withdrawal', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000005', NULL, 8000,  'Withdrawal', 'Completed');

--UPI Transactions  
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000006', 'ACCT5000007', 2500, 'UPI', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000008', 'ACCT5000009', 4000, 'UPI', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000010', 'ACCT5000011', 1500, 'UPI', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000012', 'ACCT5000013', 3000, 'UPI', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000014', 'ACCT5000015', 7000, 'UPI', 'Completed');

--NEFT Transfers
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000016', 'ACCT5000017', 50000, 'NEFT', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000018', 'ACCT5000019', 75000, 'NEFT', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000020', 'ACCT5000001', 90000, 'NEFT', 'Completed');

--RTGS (High Value)
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000002', 'ACCT5000003', 250000, 'RTGS', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000004', 'ACCT5000005', 400000, 'RTGS', 'Completed');

--Cheque Transactions (Bounce Included)
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000006', NULL, 15000, 'Cheque', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000007', NULL, 22000, 'Cheque', 'Bounced');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000008', NULL, 18000, 'Cheque', 'Completed');
INSERT INTO transactions VALUES (seq_txn.NEXTVAL, SYSDATE, 'ACCT5000009', NULL, 27000, 'Cheque', 'Bounced');

SELECT * FROM v_daily_transactions;

SELECT COUNT(*) FROM transactions;
SELECT * FROM transactions ORDER BY txn_id;
SELECT * FROM accounts;
COMMIT;

SELECT * FROM customers;
SELECT * FROM customer_audit;

SELECT * FROM accounts;
SELECT * FROM v_account_summary;

SELECT * FROM fixed_deposits;
SELECT * FROM recurring_deposits;

SELECT * FROM transactions;
SELECT * FROM v_daily_transactions;

COMMIT;

/*5. Loan and EMI Module
Schema: LOANS table (principal, rate, term, etc.) and LOAN_SCHEDULE for installment details. 
Collateral/risk fields could be added.
EMI Calculation: Function FN_CALC_EMI using the standard formula.
Procedures: SP_GENERATE_SCHEDULE creates amortization entries in LOAN_SCHEDULE.
Prepayment/Overdue: Flags in loan table; procedure to recalc schedule on prepayment. 
NPA view identifies loans >90 days overdue.
Sample Data: 50+ loans (personal, home, auto) with various terms.*/

-- Sequence for loans
CREATE SEQUENCE seq_loan
START WITH 5001
INCREMENT BY 1
NOCACHE
NOCYCLE;

drop sequence seq_loan ;
-- Sequence for loan schedule
CREATE SEQUENCE seq_sched
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

drop sequence seq_sched ;

COMMIT;

-- Loans and schedule schema
-- Loans table
CREATE TABLE loans (
  loan_id NUMBER PRIMARY KEY,
  account_id VARCHAR2(16) REFERENCES accounts(account_no),
  principal NUMBER(15,2) NOT NULL,
  annual_rate NUMBER(5,2) NOT NULL,  -- annual interest %
  term_months NUMBER NOT NULL,        -- total months
  monthly_emi NUMBER(15,2),
  start_date DATE NOT NULL,
  status VARCHAR2(10) DEFAULT 'Active' CHECK (status IN ('Active','Closed','NPA'))
);

-- Loan schedule table
CREATE TABLE loan_schedule (
  schedule_id NUMBER PRIMARY KEY,
  loan_id NUMBER REFERENCES loans(loan_id),
  installment_no NUMBER NOT NULL,
  due_date DATE NOT NULL,
  principal_component NUMBER(15,2),
  interest_component NUMBER(15,2),
  remaining_principal NUMBER(15,2)
);

  -- Function: Calculate fixed EMI
  CREATE OR REPLACE FUNCTION fn_calc_emi(p_principal NUMBER,
                                         p_rate      NUMBER,
                                         p_term      NUMBER) RETURN NUMBER IS
  monthly_rate NUMBER := p_rate / 1200; -- annual % to monthly fraction
  factor       NUMBER;
  emi          NUMBER;
BEGIN
  IF monthly_rate = 0 THEN
    emi := p_principal / p_term;
  ELSE
    factor := POWER(1 + monthly_rate, p_term);
    emi    := p_principal * monthly_rate * factor / (factor - 1);
  END IF;
  RETURN ROUND(emi, 2);
END;


-- Procedure: Generate amortization schedule

CREATE OR REPLACE PROCEDURE sp_generate_schedule(p_loan_id NUMBER) AS
    v_principal NUMBER;
    v_rate NUMBER;
    v_term NUMBER;
    v_emi NUMBER;
    v_balance NUMBER;
    v_interest NUMBER;
    v_princ_amt NUMBER;
    v_due DATE;
BEGIN
    -- Fetch loan details
    SELECT principal, annual_rate, term_months, start_date
    INTO v_principal, v_rate, v_term, v_due
    FROM loans
    WHERE loan_id = p_loan_id;

    v_emi := fn_calc_emi(v_principal, v_rate, v_term);
    v_balance := v_principal;

    FOR i IN 1..v_term LOOP
        v_interest := ROUND(v_balance * (v_rate/1200),2);  -- monthly interest
        v_princ_amt := ROUND(v_emi - v_interest,2);        -- principal part
        v_balance := ROUND(v_balance - v_princ_amt,2);     -- remaining balance
        v_due := ADD_MONTHS(v_due, 1);                     -- next due date

        INSERT INTO loan_schedule VALUES (
            seq_sched.NEXTVAL,
            p_loan_id,
            i,
            v_due,
            v_princ_amt,
            v_interest,
            GREATEST(v_balance,0)
        );

        EXIT WHEN v_balance <= 0;
    END LOOP;
END;



-- Sample loan and schedule generation
-- Sample 50 loans (personal, home, auto) for Module 5
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000001', 500000, 7.5, 60, fn_calc_emi(500000,7.5,60), DATE '2023-01-01','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000002', 300000, 7.0, 36, fn_calc_emi(300000,7.0,36), DATE '2023-02-01','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000003', 450000, 7.5, 48, fn_calc_emi(450000,7.5,48), DATE '2023-03-01','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000004', 600000, 8.0, 60, fn_calc_emi(600000,8.0,60), DATE '2023-04-01','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000005', 250000, 6.75, 24, fn_calc_emi(250000,6.75,24), DATE '2023-05-01','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000006', 800000, 7.8, 72, fn_calc_emi(800000,7.8,72), DATE '2023-06-01','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000007', 150000, 6.5, 18, fn_calc_emi(150000,6.5,18), DATE '2023-07-01','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000008', 350000, 7.2, 36, fn_calc_emi(350000,7.2,36), DATE '2023-08-01','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000009', 400000, 7.5, 48, fn_calc_emi(400000,7.5,48), DATE '2023-09-01','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000010', 600000, 8.0, 60, fn_calc_emi(600000,8.0,60), DATE '2023-10-01','Active');

INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000011', 200000, 6.5, 24, fn_calc_emi(200000,6.5,24), DATE '2023-01-15','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000012', 300000, 7.0, 36, fn_calc_emi(300000,7.0,36), DATE '2023-02-15','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000013', 500000, 7.8, 60, fn_calc_emi(500000,7.8,60), DATE '2023-03-15','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000014', 450000, 7.2, 48, fn_calc_emi(450000,7.2,48), DATE '2023-04-15','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000015', 350000, 6.9, 36, fn_calc_emi(350000,6.9,36), DATE '2023-05-15','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000016', 400000, 7.5, 48, fn_calc_emi(400000,7.5,48), DATE '2023-06-15','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000017', 250000, 6.8, 24, fn_calc_emi(250000,6.8,24), DATE '2023-07-15','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000018', 600000, 8.0, 60, fn_calc_emi(600000,8.0,60), DATE '2023-08-15','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000019', 550000, 7.5, 54, fn_calc_emi(550000,7.5,54), DATE '2023-09-15','Active');
INSERT INTO loans VALUES (seq_loan.NEXTVAL, 'ACCT5000020', 700000, 8.2, 72, fn_calc_emi(700000,8.2,72), DATE '2023-10-15','Active');
-- After inserting, call sp_generate_schedule(5001) to populate LOAN_SCHEDULE

BEGIN
    FOR i IN 5001..5020 LOOP
        sp_generate_schedule(i);
    END LOOP;
END;

select * from loans;
select * from loan_schedule;

/*6. GL and Financial Accounting
Schema: GL_ACCOUNTS (chart of accounts: Cash, Expenses, etc.) and JOURNAL_ENTRIES for every transaction.
Double-Entry: On each business transaction, insert a debit and credit entry. 
E.g., salary payment debits Expense, credits Cash.
Views: V_TRIAL_BALANCE sums debits/credits per account to ensure they match.
Reconciliation: Additional views/procedures for monthly P&L, balance sheet can be built similarly.
Sample Data: Basic GL accounts and journal entries.*/

-- 1. Sequences
CREATE SEQUENCE seq_gl START WITH 101 INCREMENT BY 1;
CREATE SEQUENCE seq_je START WITH 1 INCREMENT BY 1;

-- GL accounts and journal entries schema
CREATE TABLE gl_accounts (
  gl_id NUMBER PRIMARY KEY,
  gl_name VARCHAR2(100),
  gl_type VARCHAR2(10) CHECK (gl_type IN ('Asset','Liability','Income','Expense','Equity'))
);

CREATE TABLE journal_entries (
  je_id NUMBER PRIMARY KEY,
  je_date DATE DEFAULT SYSDATE,
  gl_debit NUMBER REFERENCES gl_accounts(gl_id),
  gl_credit NUMBER REFERENCES gl_accounts(gl_id),
  amount NUMBER(15,2) NOT NULL CHECK (amount > 0),
  description VARCHAR2(200)
);

-- Trigger to prevent same account as debit & credit
CREATE OR REPLACE TRIGGER trg_journal_debit_credit_check
  BEFORE INSERT OR UPDATE ON journal_entries
  FOR EACH ROW
BEGIN
  IF :NEW.gl_debit = :NEW.gl_credit THEN
    RAISE_APPLICATION_ERROR(-20001,
                            'Debit and Credit cannot be the same account.');
  END IF;
END;

-- Trial Balance view
CREATE OR REPLACE VIEW v_trial_balance AS
SELECT 
    gl.gl_id, 
    gl.gl_name,
    SUM(CASE WHEN j.gl_debit = gl.gl_id THEN j.amount ELSE 0 END) AS total_debits,
    SUM(CASE WHEN j.gl_credit = gl.gl_id THEN j.amount ELSE 0 END) AS total_credits
FROM gl_accounts gl
LEFT JOIN journal_entries j ON j.gl_debit = gl.gl_id OR j.gl_credit = gl.gl_id
GROUP BY gl.gl_id, gl.gl_name
ORDER BY gl.gl_id;


-- Sample GL accounts

INSERT INTO gl_accounts (gl_id, gl_name, gl_type) VALUES (seq_gl.NEXTVAL, 'Cash', 'Asset');
INSERT INTO gl_accounts (gl_id, gl_name, gl_type) VALUES (seq_gl.NEXTVAL, 'Bank', 'Asset');
INSERT INTO gl_accounts (gl_id, gl_name, gl_type) VALUES (seq_gl.NEXTVAL, 'Salary Expense', 'Expense');
INSERT INTO gl_accounts (gl_id, gl_name, gl_type) VALUES (seq_gl.NEXTVAL, 'Rent Expense', 'Expense');
INSERT INTO gl_accounts (gl_id, gl_name, gl_type) VALUES (seq_gl.NEXTVAL, 'Accounts Payable', 'Liability');
INSERT INTO gl_accounts (gl_id, gl_name, gl_type) VALUES (seq_gl.NEXTVAL, 'Revenue', 'Income');

INSERT INTO gl_accounts (gl_id, gl_name, gl_type) VALUES (seq_gl.NEXTVAL, 'Utilities Expense', 'Expense');
INSERT INTO gl_accounts (gl_id, gl_name, gl_type) VALUES (seq_gl.NEXTVAL, 'Office Supplies', 'Expense');
INSERT INTO gl_accounts (gl_id, gl_name, gl_type) VALUES (seq_gl.NEXTVAL, 'Loan Payable', 'Liability');
INSERT INTO gl_accounts (gl_id, gl_name, gl_type) VALUES (seq_gl.NEXTVAL, 'Equity Capital', 'Equity');
INSERT INTO gl_accounts (gl_id, gl_name, gl_type) VALUES (seq_gl.NEXTVAL, 'Interest Income', 'Income');
INSERT INTO gl_accounts (gl_id, gl_name, gl_type) VALUES (seq_gl.NEXTVAL, 'Taxes Payable', 'Liability');

select * from gl_accounts

-- Sample journal entry (salary payment)
-- Salary Payment
INSERT INTO journal_entries (je_id, je_date, gl_debit, gl_credit, amount, description)
VALUES (seq_je.NEXTVAL, SYSDATE, 103, 101, 100000, 'Monthly salary payment');

-- Rent Payment
INSERT INTO journal_entries (je_id, je_date, gl_debit, gl_credit, amount, description)
VALUES (seq_je.NEXTVAL, SYSDATE, 104, 101, 25000, 'Office rent payment');

-- Customer Payment Received
INSERT INTO journal_entries (je_id, je_date, gl_debit, gl_credit, amount, description)
VALUES (seq_je.NEXTVAL, SYSDATE, 101, 106, 50000, 'Payment received from customer');

-- Payment to Supplier
INSERT INTO journal_entries (je_id, je_date, gl_debit, gl_credit, amount, description)
VALUES (seq_je.NEXTVAL, SYSDATE, 105, 101, 20000, 'Payment to supplier');

-- Utilities Payment
INSERT INTO journal_entries (je_id, je_date, gl_debit, gl_credit, amount, description)
VALUES (seq_je.NEXTVAL, SYSDATE, 107, 101, 5000, 'Monthly utilities payment');

-- Office Supplies Purchase
INSERT INTO journal_entries (je_id, je_date, gl_debit, gl_credit, amount, description)
VALUES (seq_je.NEXTVAL, SYSDATE, 108, 101, 8000, 'Purchase of office supplies');

-- Loan Taken
INSERT INTO journal_entries (je_id, je_date, gl_debit, gl_credit, amount, description)
VALUES (seq_je.NEXTVAL, SYSDATE, 101, 109, 100000, 'Loan received from bank');

-- Owner Investment
INSERT INTO journal_entries (je_id, je_date, gl_debit, gl_credit, amount, description)
VALUES (seq_je.NEXTVAL, SYSDATE, 101, 110, 500000, 'Owner capital investment');

-- Interest Received
INSERT INTO journal_entries (je_id, je_date, gl_debit, gl_credit, amount, description)
VALUES (seq_je.NEXTVAL, SYSDATE, 101, 111, 2000, 'Interest income received');

-- Tax Payment
INSERT INTO journal_entries (je_id, je_date, gl_debit, gl_credit, amount, description)
VALUES (seq_je.NEXTVAL, SYSDATE, 112, 101, 10000, 'Taxes paid for the month');

select * from journal_entries ;

commit ;








