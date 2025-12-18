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

---------------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_generate_schedule(p_loan_id NUMBER) AS
  v_principal NUMBER;
  v_rate      NUMBER;
  v_term      NUMBER;
  v_emi       NUMBER;
  v_balance   NUMBER;
  v_interest  NUMBER;
  v_princ_amt NUMBER;
  v_due       DATE;
BEGIN
  -- Fetch loan details
  SELECT principal, annual_rate, term_months, start_date
    INTO v_principal, v_rate, v_term, v_due
    FROM loans
   WHERE loan_id = p_loan_id;

  v_emi     := fn_calc_emi(v_principal, v_rate, v_term);
  v_balance := v_principal;

  FOR i IN 1 .. v_term LOOP
    v_interest  := ROUND(v_balance * (v_rate / 1200), 2); -- monthly interest
    v_princ_amt := ROUND(v_emi - v_interest, 2); -- principal part
    v_balance   := ROUND(v_balance - v_princ_amt, 2); -- remaining balance
    v_due       := ADD_MONTHS(v_due, 1); -- next due date
  
    INSERT INTO loan_schedule
    VALUES
      (seq_sched.NEXTVAL,
       p_loan_id,
       i,
       v_due,
       v_princ_amt,
       v_interest,
       GREATEST(v_balance, 0));
  
    EXIT WHEN v_balance <= 0;
  END LOOP;
END;

---------------------------------------------------------





