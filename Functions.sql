-- Function to calculate FD maturity amount (simple interest example)
CREATE OR REPLACE FUNCTION fn_calc_fd_maturity(p_principal NUMBER, p_rate NUMBER, p_months NUMBER) RETURN NUMBER IS
  total_amount NUMBER;
BEGIN
  total_amount := p_principal * POWER(1 + (p_rate/100)/12, p_months);
  RETURN ROUND(total_amount,2);
END;

---------------------------------------------------------

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

---------------------------------------------------------

