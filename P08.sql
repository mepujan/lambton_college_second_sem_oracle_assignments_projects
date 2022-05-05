-- Pujan Gautam - C0842623
-- P08 - Packages
-- Date of Submission: 4/5/2022

-- P0801

--Creating the environment

drop table gl_professors_copy;

create table gl_professors_copy as(
    select professor_no,first_name, last_name, ext_no,office_no
    from gl_professors;
);

alter table gl_professors_copy 
add primary key (professor_no);

-- creating college_pkg package
create or replace package college_pkg as
-- get professor
    procedure get_professor(
        p_professor_id  in   gl_professors.professor_no%type,
        professor_data out  gl_professors_copy%rowtype
    );
-- add professor
    procedure add_professor(
        p_professor_no              gl_professors.professor_no%type,
        p_professor_first_name      gl_professors.first_name%type,
        p_professor_last_name       gl_professors.last_name%type,
        p_office_ext                gl_professors.office_ext%type,
        p_office_no                 gl_professors.office_no%type
    );

-- delete professor 
    procedure delete_professor(
        p_professor_id      gl_professors.professor_no%type
    );
end college_pkg;


create or replace package body college_pkg as 
    -- get_professor body

    procedure get_professor(
        p_professor_id   in   gl_professors.professor_no%type,
        professor_data out  gl_professors_copy%rowtype
    )
    is
    begin
        select * 
        into professor_data 
        from gl_professors_copy 
        where professor_no = p_professor_id;
    end get_professor;

    -- add procedure body
    procedure add_professor(
        p_professor_no              gl_professors.professor_no%type,
        p_professor_first_name      gl_professors.first_name%type,
        p_professor_last_name       gl_professors.last_name%type,
        p_office_ext                gl_professors.office_ext%type,
        p_office_no                 gl_professors.office_no%type
    )
    is 
    begin 
    insert into gl_professors_copy values
    (p_professor_no,
    p_professor_first_name,
    p_professor_last_name,
    p_office_ext,
    p_office_no);
    end add_professor;

    --delete professor body
    procedure delete_professor(
        p_professor_id      gl_professors.professor_no%type
    )
    is
    begin 
        delete * from gl_professors_copy where professor_no = p_professor_id;
    end delete_professor;

end college_pkg;

--get professor anonymous block


declare
    v_professor_no  gl_professors.professor_no%type := :Professor_no;
    professor_data  gl_professors_copy%rowtype;
begin
    dbms_output.put_line('Professor Information:');
    college_pkg.get_professor(v_professor_no,professor_data);
    dbms_output.put_line('professor Number: '||professor_data.professor_no);
    dbms_output.put_line('Name: '||professor_data.first_name || ' ' ||professor_data.last_name);
    dbms_output.put_line('Office Ext: '||professor_data.office_ext);
    dbms_output.put_line('Office No: '||professor_data.office_no);

    exception
        WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Professor with id  '||v_professor_no||' not found.');

        when others then 
        DBMS_OUTPUT.PUT_LINE('**The following undetermined error occurred. Contact Software Support.');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: '|| SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;

-- add professor anonymous block
declare
        v_professor_no    gl_professors.professor_no%type := :Enter_Professor_no;
        v_first_name      gl_professors.first_name%type := :First_Name;
        v_last_name       gl_professors.last_name%type := :Last_Name;
        v_office_ext      gl_professors.office_ext%type := :Office_Ext;
        v_office_no       gl_professors.office_no%type := :Office_No;
begin 
    college_pkg.add_professor(v_professor_no,v_first_name,v_last_name,v_office_ext,v_office_no);
    dbms_output.put_line('Professor with id '|| v_professor_no||' added Successfully.');
    college_pkg.get_professor(v_professor_no,professor_data);
    dbms_output.put_line('professor Number: '||v_professor_no);
    dbms_output.put_line('Name: '||v_first_name || ' ' ||v_last_name);
    dbms_output.put_line('Office Ext: '||v_office_ext);
    dbms_output.put_line('Office No: '||v_office_no);
    exception
    when others then 
        DBMS_OUTPUT.PUT_LINE('**The following undetermined error occurred. Contact Software Support.');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: '|| SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;




-- delete professor anonymous block
declare
    no_data_found exception;
    v_professor_no  gl_professors.professor_no%type := :Professor_no;
begin
    college_pkg.delete_professor(v_professor_no);
    dbms_output.put_line('Delete Professor request completed.');
    if SQL%ROWCOUNT = 0 then
        raise no_data_found;
    end if;
    exception
    when no_data_found then 
        dbms_output.put_line('Professor '||v_professor_no ||' doesnot exist in professor table.');
    when others then 
        DBMS_OUTPUT.PUT_LINE('**The following undetermined error occurred. Contact Software Support.');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: '|| SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;


-----------------end of P0801 -------------------

--P0802 - Donor OverLoad Application

create or replace package donor_overload_pkg is
    procedure display_donor_info(
        p_donor_id in gl_donors.donor_id%type,
        donor_info out gl_donors%rowtype
        );
    procedure display_donor_info(
        p_registration_code in gl_donors.registration_code%type,
        donor_info out gl_donors%rowtype
    );
end donor_overload_pkg;


--creating donor_overload_pkg body

create or replace package body donor_overload_pkg is
    procedure display_donor_info(
        p_donor_id in gl_donors.donor_id%type,
        donor_info out gl_donors%rowtype
    ) is
    begin
        select * into donor_info
        from gl_donors 
        where donor_id = p_donor_id;
    end display_donor_info;

    procedure display_donor_info(
        p_registration_code in gl_donors.registration_code%type,
        donor_info out gl_donors%rowtype
    )is
    begin
        select * into donor_info
        from gl_donors 
        where registration_code = p_registration_code;
    end display_donor_info;
end donor_overload_pkg;


--anonymous block for donor_id

declare
    v_donor_id  gl_donors.donor_id%type := :Enter_Donor;
    donor_info  gl_donors%rowtype ;
begin
    donor_overload_pkg.display_donor_info(v_donor_id,donor_info);
    dbms_output.put_line('Donor Name: ' || donor_info.donor_name);
    dbms_output.put_line('Donor Type: ' || donor_info.donor_type);
    dbms_output.put_line('Pledge Amount: ' || to_char(donor_info.monthly_pledge_amount,'$9999'));
    dbms_output.put_line('Pledge Month: ' || donor_info.pledge_months);
    dbms_output.put_line('Total Amount: ' || to_char(donor_info.monthly_pledge_amount * donor_info.pledge_months,'$9999.9'));
    dbms_output.put_line('Donor Request By Donor Id Completed.')
    exception
    when not_found_exception then
        dbms_output.put_line('Donor Not Found.');
end;


--anonymous_block for registration_code
declare
    v_registration_code  gl_donors.registration_code%type := :Enter_Registration_Code;
    donor_info  gl_donors%rowtype ;
begin
    donor_overload_pkg.display_donor_info(v_registration_code,donor_info);
    dbms_output.put_line('Donor Name: ' || donor_info.donor_name);
    dbms_output.put_line('Donor Type: ' || donor_info.donor_type);
    dbms_output.put_line('Pledge Amount: ' || to_char(donor_info.monthly_pledge_amount,'$9999'));
    dbms_output.put_line('Pledge Month: ' || donor_info.pledge_months);
    dbms_output.put_line('Total Amount: ' || to_char(donor_info.monthly_pledge_amount * donor_info.pledge_months,'$9999.9'));
    dbms_output.put_line('Donor Request By Donor Registration Code Completed.')
    exception
    when not_found_exception then
        dbms_output.put_line('Donor Not Found.');
end;

---------------------end of P0802 --------------------------------------
