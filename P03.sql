-- c0842623
-- Pujan Gautam



-- Question no. 5

declare
    v_loan_amount number := :Enter_Loan_Amount;
    v_loan_payment number := :Enter_Loan_Payment;
    v_equal_payment number;
begin
    v_equal_payment := trunc(v_loan_amount / v_loan_payment,0);
    DBMS_OUTPUT.PUT_LINE('Loan Amount: '|| to_char(v_loan_amount,'FM$99,999.00'));
    DBMS_OUTPUT.PUT_LINE('Loan Payment: ' || to_char(v_loan_payment,'FM$99,999.00'));
    DBMS_OUTPUT.PUT_LINE('Equal Payments: ' || v_equal_payment);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Payment#      Balance');
    for i in 1 .. v_equal_payment loop
        v_loan_amount := v_loan_amount - v_loan_payment;
        DBMS_OUTPUT.PUT_LINE(i || '             ' ||to_char(v_loan_amount,'FM$99,999.00'));
    end loop;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Outstanding Balance: $' || to_char(v_loan_amount,'FM$99,999.00'));
    EXCEPTION
    WHEN OTHER THEN
    DBMS_OUTPUT.PUT_LINE('   SQL ERROR CODE: '|| SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;

--Question no. 6

declare
    donor_record gl_donors%ROWTYPE;
    v_donor_id gl_donors.donor_id%type := :Enter_Donor_Id;
    v_amount_pledge number;
    v_donor_type varchar2(50);
    v_matched_amount number;
begin
    select * 
    into donor_record
    from gl_donors
    where donor_id = v_donor_id;
    v_amount_pledge := donor_record.monthly_pledge_amount * donor_record.pledge_months;
    case donor_record.donor_type
        when 'I' 
            then case
                when v_amount_pledge < 100 then v_matched_amount := 0;
                when v_amount_pledge < 250 then v_matched_amount := v_amount_pledge * 0.5;
                when v_amount_pledge < 500 then v_matched_amount := v_amount_pledge * 0.3;
                when v_amount_pledge >= 500 then v_matched_amount := v_amount_pledge * 0.2;
            end case;
            v_donor_type := 'Individual';
        when 'B' 
            then case
                when v_amount_pledge < 100 then v_matched_amount := 0;
                when v_amount_pledge < 500 then v_matched_amount := v_amount_pledge * 0.2;
                when v_amount_pledge < 1000 then v_matched_amount := v_amount_pledge * 0.1;
                when v_amount_pledge >= 1000 then v_matched_amount := v_amount_pledge * 0.05;
        end case;
        v_donor_type := 'Business Organization';
        when 'G' 
            then case
                when v_amount_pledge < 100 then v_matched_amount := 0;
                when v_amount_pledge >= 100 then v_matched_amount := v_amount_pledge * 0.05;
            end case;
            v_donor_type := 'Grant Funds';
    end case;
    DBMS_OUTPUT.PUT_LINE('Donor Pledge For ' || donor_record.donor_name);
    DBMS_OUTPUT.PUT_LINE('Donor Type: ' || v_donor_type);
    DBMS_OUTPUT.PUT_LINE('Amount Pledge: $' || v_amount_pledge);
    DBMS_OUTPUT.PUT_LINE('Matched Amount: $' || ceil(v_matched_amount));
    EXCEPTION
    WHEN OTHER THEN
    DBMS_OUTPUT.PUT_LINE('   SQL ERROR CODE: '|| SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;


-- Question no 7

declare
    donor_record gl_donors%ROWTYPE;
    v_donor_id gl_donors.donor_id%type := :Enter_Donor_Id;
    v_amount_pledge number;
begin
    select * 
    into donor_record
    from gl_donors
    where donor_id = v_donor_id;
     v_amount_pledge := donor_record.monthly_pledge_amount * donor_record.pledge_months;
    DBMS_OUTPUT.PUT_LINE('Donor Pledge ' || donor_record.donor_name);
    DBMS_OUTPUT.PUT_LINE('Registration date: '||to_char(donor_record.registration_date,'Month DD, YYYY'));
    DBMS_OUTPUT.PUT_LINE('Amount Pledge: $'|| v_amount_pledge);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Pledge#       Due Date        Amount      Balance');
    for 

end;

