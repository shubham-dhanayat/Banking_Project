CREATE OR REPLACE VIEW v_account_summary AS
SELECT c.customer_id, c.full_name, a.account_no, a.account_type, a.status, a.balance, a.opened_date
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id;

---------------------------------------------------------

-- View: Daily transaction summary
CREATE OR REPLACE VIEW v_daily_transactions AS
SELECT TRUNC(txn_date) AS txn_day,
       COUNT(*) AS txn_count,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY TRUNC(txn_date);

---------------------------------------------------------

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
