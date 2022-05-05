-- Pujan Gautam - C0842623
-- Assignment - P09 - Trigger
-- Date of Submission: 4/13/2022

-- 1. Creating log table gl_pro_audit_log

create table gl_pro_audit_log(
    user_id varchar2(20) default user,
    last_change_date date default sysdate,
    trigger_name varchar2(15),
    log_action varchar2(30)
);

--2 creating trigger statement gl_professor_tr
create or replace trigger gl_professor_tr
    after insert on gl_professors_copy
    begin
        insert into gl_pro_audit_log(trigger_name,log_action)
        values ('gl_professor_tr','insert');
        dbms_output.put_line('gl_professor_tr completed after insert operation');
    end;

--3 testing the gl_professor_tr 
declare
    v_professor_no gl_professors_copy.professor_no%type := :Enter_Professor_Number;
    v_first_name gl_professors_copy.first_name%type := initcap(:Enter_First_Name);
    v_last_name gl_professors_copy.last_name%type := initcap(:Enter_Last_Name);
    v_office_ext gl_professors_copy.office_ext%type := :Enter_Office_Ext;
    v_office_no gl_professors_copy.office_no%type := :Enter_Office_No;
    v_school_code gl_professors_copy.school_code%type := UPPER(:Enter_School_Code);
begin
        add_professor(v_professor_no,v_first_name,v_last_name,v_office_no,v_office_ext,v_school_code);
        exception
        when dup_val_on_index then
        dbms_output.put_line('Professor with professor number '||v_professor_no || ' already exist.');
        when others then
        dbms_output.put_line('Error Adding Professor ' || v_professor_no);
end;


-- 4. Displaying gl_pro_audit_log records

select * from gl_pro_audit_log;

--5(a) creating convert_numeric_grade function
create or replace function convert_numeric_grade(
    p_numeric_grade in number
)
return varchar2
is 
v_letter_grade varchar2(1);
begin
    case 
        when p_numeric_grade >= 90 then v_letter_grade := 'A';
        when p_numeric_grade >= 80 then v_letter_grade := 'B';
        when p_numeric_grade >= 70 then v_letter_grade := 'C';
        when p_numeric_grade >= 60 then v_letter_grade := 'D';
        else v_letter_grade := 'F';  
    end case;
    return v_letter_grade;
end convert_numeric_grade;

-- 5(b) creating table gl_enroll_update_log
create table gl_enroll_update_log(
    user_id varchar2(30) default user,
    last_change_date date default sysdate,
    section_id  number(5,0),
    student_no  number(7,0),
    old_grade   varchar2(2),
    new_grade   varchar2(2),
    log_action  varchar(30)
);


-- 5(c) creating before update table gl_enroll_update_tr

create or replace trigger gl_enroll_update_tr
    before update of letter_grade on gl_enrollments_copy
    for each row
    declare 
        v_log_action varchar2(30);
    begin
        case
            when :old.letter_grade = :new.letter_grade then 
                v_log_action := 'grade is the same';
            when :old.letter_grade < :new.letter_grade then 
                v_log_action := 'grade went down';
            when :old.letter_grade > :new.letter_grade then
                v_log_action := 'grade went up';
        end case;
        insert into gl_enroll_update_log(section_id,student_no,old_grade,new_grade,log_action)
        values (:old.section_id,:old.student_no,:old.letter_grade,:new.letter_grade,v_log_action);
    end gl_enroll_update_tr;


-- 5(d) Invoke trigger
declare
    v_section_id    gl_enrollments_copy.section_id%type := :Enter_Section_id;
    v_student_no    gl_enrollments_copy.student_no%type := :Enter_Student_no;
    v_numeric_grade gl_enrollments_copy.numeric_grade%type := :Enter_New_Numeric_Grade;
    v_letter_grade gl_enrollments_copy.letter_grade%type;
begin
    update gl_enrollments_copy
    set numeric_grade = v_numeric_grade,
        letter_grade = convert_numeric_grade(numeric_grade)
        where section_id = v_section_id and
              student_no = v_student_no;
end;

select * from gl_enroll_update_log;