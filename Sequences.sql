-- Below all sequence related to the banking project.


CREATE SEQUENCE seq_customers START WITH 1000 INCREMENT BY 1;
-- related to customers table 

CREATE SEQUENCE seq_customer_audit START WITH 1;
-- related to customer_audit table

CREATE SEQUENCE seq_account_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_account_no START WITH 5000001 INCREMENT BY 1;
-- related to accounts table

CREATE SEQUENCE seq_fd
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
-- related to fix_deposite

CREATE SEQUENCE seq_rd
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
-- related to recursive_deposite

CREATE SEQUENCE seq_txn START WITH 10000 INCREMENT BY 1;
-- related to transaction

CREATE SEQUENCE seq_loan
START WITH 5001
INCREMENT BY 1
NOCACHE
NOCYCLE;
-- related to loans

CREATE SEQUENCE seq_sched
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
-- related to loan schedule

CREATE SEQUENCE seq_gl START WITH 101 INCREMENT BY 1;
-- related to gl_accounts

CREATE SEQUENCE seq_je START WITH 1 INCREMENT BY 1;
-- related to journal entries



