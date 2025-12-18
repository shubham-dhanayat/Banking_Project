-- Below all tables related to the banking project.

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

---------------------------------------------------------

CREATE TABLE customer_audit (
  audit_id NUMBER PRIMARY KEY,
  customer_id NUMBER,
  action_type VARCHAR2(10),
  action_date TIMESTAMP DEFAULT SYSTIMESTAMP,
  old_data CLOB,
  new_data CLOB
);

---------------------------------------------------------

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

---------------------------------------------------------

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

---------------------------------------------------------

CREATE TABLE recurring_deposits (
  rd_id NUMBER PRIMARY KEY,
  account_no VARCHAR2(16) REFERENCES accounts(account_no),
  monthly_deposit NUMBER(15,2),
  interest_rate NUMBER(5,2),
  start_date DATE,
  tenure_months NUMBER,
  auto_renew CHAR(1) DEFAULT 'N'
);

---------------------------------------------------------

CREATE TABLE transactions (
  txn_id NUMBER PRIMARY KEY,
  txn_date DATE DEFAULT SYSDATE,
  from_account VARCHAR2(16) REFERENCES accounts(account_no),
  to_account VARCHAR2(16) REFERENCES accounts(account_no),
  amount NUMBER(15,2),
  txn_type VARCHAR2(10) CHECK (txn_type IN ('Deposit','Withdrawal','Transfer','UPI','NEFT','RTGS','Cheque')),
  status VARCHAR2(10) DEFAULT 'Pending'
);

---------------------------------------------------------

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

---------------------------------------------------------

CREATE TABLE loan_schedule (
  schedule_id NUMBER PRIMARY KEY,
  loan_id NUMBER REFERENCES loans(loan_id),
  installment_no NUMBER NOT NULL,
  due_date DATE NOT NULL,
  principal_component NUMBER(15,2),
  interest_component NUMBER(15,2),
  remaining_principal NUMBER(15,2)
);

---------------------------------------------------------

CREATE TABLE gl_accounts (
  gl_id NUMBER PRIMARY KEY,
  gl_name VARCHAR2(100),
  gl_type VARCHAR2(10) CHECK (gl_type IN ('Asset','Liability','Income','Expense','Equity'))
);

---------------------------------------------------------

CREATE TABLE journal_entries (
  je_id NUMBER PRIMARY KEY,
  je_date DATE DEFAULT SYSDATE,
  gl_debit NUMBER REFERENCES gl_accounts(gl_id),
  gl_credit NUMBER REFERENCES gl_accounts(gl_id),
  amount NUMBER(15,2) NOT NULL CHECK (amount > 0),
  description VARCHAR2(200)
);



