-- Pujan Gautam
--C0842623

-- CP1

declare
    v_loan_id gl_loans.loan_id%type := :Enter_loan_id;
    v_loan_record gl_loans%rowtype;
    v_new_annual_interest_rate gl_loans.annual_interest_rate%type;
    v_interest_discount number;
    v_interest_rate_discount number;
    v_monthly_interest number;
    v_month_count integer := 0;
    v_years_to_pay number := 0;
    v_months_to_pay integer := 0;
begin
    select *
    into v_loan_record
    from gl_loans
    where loan_id = v_loan_id;

    -- Calculating New Annual Interest Rate
    case 
        when v_loan_record.credit_score >=800 then v_interest_rate_discount := 1.00;
        when v_loan_record.credit_score >= 740 then v_interest_rate_discount := 0.75;
        when v_loan_record.credit_score >= 670 then v_interest_rate_discount := 0.50;
        when v_loan_record.credit_score >= 580 then v_interest_rate_discount := 0.25;
        when v_loan_record.credit_score >= 300 then v_interest_rate_discount := 0.0;
    end case;
    v_interest_discount := v_loan_record.annual_interest_rate - v_interest_rate_discount;

    --Displaying the loan information
    DBMS_OUTPUT.PUT_LINE('Payment Schedule');
    DBMS_OUTPUT.PUT_LINE('-------------------------');
    DBMS_OUTPUT.PUT_LINE('Name: '||v_loan_record.first_name||' '||v_loan_record.last_name);
    DBMS_OUTPUT.PUT_LINE('Loan Amount: '|| to_char(v_loan_record.loan_amount,'FM$99,999.00'));
    DBMS_OUTPUT.PUT_LINE('Annual Interest Rate: '||v_loan_record.annual_interest_rate);
    DBMS_OUTPUT.PUT_LINE('Credit Score: '||v_loan_record.credit_score ||' Interest Discount: '||v_interest_rate_discount);
    DBMS_OUTPUT.PUT_LINE('New Annual Interest Rate: '||v_interest_discount);
    DBMS_OUTPUT.PUT_LINE('Monthly Payment: '||to_char(v_loan_record.monthly_payment,'FM$99,999.00'));

    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.NEW_LINE;

-- calculating the loan payment schedule
    DBMS_OUTPUT.PUT_LINE('Month'||Lpad('Interest',10) || lpad('Payment',10)||lpad('Balance',10));
    while v_loan_record.loan_amount > 0
    loop
        v_month_count := v_month_count + 1; 
        v_monthly_interest := v_loan_record.loan_amount*(v_interest_discount/1200);
        v_loan_record.loan_amount := (v_loan_record.loan_amount - v_loan_record.monthly_payment) + v_monthly_interest;
        if v_loan_record.loan_amount <=0 then
            v_loan_record.loan_amount := 0;
        end if;
        DBMS_OUTPUT.PUT_LINE(v_month_count||LPAD(to_char(v_monthly_interest,'FM$99,999.00'),12) || LPAD(to_char(v_loan_record.monthly_payment,'FM$99,999.00'),10) || LPAD(to_char(v_loan_record.loan_amount,'FM$99,999.00'),15));
        
    end loop;

    -- calaculating years and month required to pay the loan
    v_years_to_pay := (v_month_count)/12;
    v_months_to_pay :=  mod(v_month_count,12);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('It takes '||trunc(v_years_to_pay,0)||' years and '||v_months_to_pay||' months to pay the loan.');

    -- exception handling
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO DATA FOUND FOR LOAN ID: '||v_loan_id);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('**The following undetermined error occurred. Contact Software Support.');
            DBMS_OUTPUT.PUT_LINE('** ' || SQLCODE || ' '||SQLERRM);
end;