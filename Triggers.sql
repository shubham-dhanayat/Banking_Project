-- All triggers related to the Banking_project.

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

---------------------------------------------------------

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

---------------------------------------------------------

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

---------------------------------------------------------

-- Trigger: Cheque bounce penalty (e.g., Rs.500)
CREATE OR REPLACE TRIGGER trg_cheque_bounce
  AFTER INSERT ON transactions
  FOR EACH ROW
  WHEN (NEW.txn_type = 'Cheque' AND NEW.status = 'Bounced')
BEGIN
  UPDATE accounts
     SET balance = balance - 500
   WHERE account_no = :NEW.from_account;
END;

---------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_journal_debit_credit_check
  BEFORE INSERT OR UPDATE ON journal_entries
  FOR EACH ROW
BEGIN
  IF :NEW.gl_debit = :NEW.gl_credit THEN
    RAISE_APPLICATION_ERROR(-20001,
                            'Debit and Credit cannot be the same account.');
  END IF;
END;
