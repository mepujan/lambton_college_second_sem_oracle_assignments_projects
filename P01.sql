-- Pujan Gautam 
-- c0842623

-- 1.
declare
    todays_date date := sysdate;
begin
    dbms_output.put_line(to_char(todays_date,'dd-MM-YYYY'));
end;

-- end of question 1 block

--2
declare
    v_counter integer;
begin
    v_counter := v_counter + 1;
    dbms_output.put_line(v_counter);
end;

-- end of question 2

--3
declare
    v_counter integer := 300;
begin
    v_counter := v_counter + 1;
    dbms_output.put_line(v_counter);
end;

-- end of question 3


--4
declare
    v_counter integer not null;
begin
    v_counter := v_counter + 1;
    dbms_output.put_line(v_counter);
end;

-- end of question 4

--5
declare
    v_counter integer not null := 500;
begin
    v_counter := v_counter + 1;
    dbms_output.put_line(v_counter);
end;

-- end of question 5

--6
declare
    v_book_type varchar(20) := 'fiction.';
begin
    dbms_output.put_line('The book type is '|| v_book_type);
end;

-- end of question 6

-- 7
declare 
    v_text varchar(50);
begin
    v_text := 'PL/SQL is easy';
    dbms_output.put_line(v_text);
end;

-- end of question 7

-- 8
declare
    v_test_date date := '2025-01-31';
begin
    dbms_output.put_line('The test date is '|| v_test_date);
end;

-- end of question 8


-- 9
declare
    v_today date := sysdate;
begin
    dbms_output.put_line('Today is '||v_today);
end;

-- end of question 9


-- 10
declare
    v_default_date date DEFAULT sysdate;
begin
    if sysdate = '2025-01-31' then
        dbms_output.put_line('Today is ' || v_default_date);
    else
        dbms_output.put_line('The default date is '||v_default_date);
    end if;
end;

-- end of question 10

-- 11
declare
    TAX_RATE NUMBER(9,2) := .13;
begin 
    TAX_RATE := TAX_RATE * 100;
    dbms_output.put_line('The tax rate is ' || TAX_RATE || ' percent.');
end;
-- end of question 11

-- 12
declare
    CONSTANT1 CONSTANT VARCHAR2(20) := 'Lambton';
begin
    dbms_output.put_line('The value is '|| CONSTANT1);
end;
-- end of question 12


-- 13
declare
    v_myname varchar2(30) := 'Pujan';
begin
    v_myname := 'Gautam';
    dbms_output.put_line('My name is ' || v_myname);
end;
-- end of question 13

--14
declare
    TAX_RATE CONSTANT NUMBER(2,2) := .13;
    v_total_amount NUMBER(9,2) := 1025.00;
    v_tax_amount NUMBER(5,2);
begin
    v_tax_amount := v_total_amount * TAX_RATE;
    dbms_output.put_line('Total Tax Amount : '||v_tax_amount);
end;
-- end of question 14