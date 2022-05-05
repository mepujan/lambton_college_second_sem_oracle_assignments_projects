-- Pujan Gautam - C0842623
-- Assignment : P07
-- Submission Date : 3/22/2022


-- P0701 : Numeric Grade Function

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


declare
    v_out_of_range_exception exception;
    v_numeric_grade number := :Enter_Numeric_Grade;
    v_letter_grade varchar(1);
begin
    if(v_numeric_grade < 0 or v_numeric_grade > 100) then
        raise v_out_of_range_exception;
    end if;
    v_letter_grade := convert_numeric_grade(v_numeric_grade);
    dbms_output.put_line('Numeric Grade: '||v_numeric_grade);
    dbms_output.put_line('Letter Grade: '||v_letter_grade);

    exception
        when v_out_of_range_exception then
            dbms_output.put_line('Grade Should be in range 0 - 100. ');
        when others then
            dbms_output.put_line('Cannot Convert the numeric grade to letter grade.');
end;


--P702
--Get Numeric Grade Function

create or replace function get_numeric_grade(
    p_section_id in  gl_enrollments.section_id%type,
    p_student_number in gl_enrollments.student_no%type
)
return number
is
v_numeric_grade gl_enrollments.numeric_grade%type;
begin
    select numeric_grade
    into v_numeric_grade
    from gl_enrollments
    where section_id = p_section_id and
    student_no = p_student_number;
    return v_numeric_grade;
end get_numeric_grade;


declare
    v_section_id gl_enrollments.section_id%type := :Enter_Section_Id;
    v_student_num gl_enrollments.student_no%type := :Enter_Student_Num;
    v_numeric_grade gl_enrollments.numeric_grade%type;
begin
    v_numeric_grade := get_numeric_grade(v_section_id,v_student_num);
    dbms_output.put_line('Section Id: '||v_section_id);
    dbms_output.put_line('Student Number: '||v_student_num);
    dbms_output.put_line('Numeric Grade: '|| v_numeric_grade);
end;



--P703
--Get Letter Grade Function

create or replace function get_letter_grade(
    p_section_id in  gl_enrollments.section_id%type,
    p_student_number in gl_enrollments.student_no%type
)
return varchar2
is
v_letter_grade gl_enrollments.letter_grade%type;
begin
    select letter_grade
    into v_letter_grade
    from gl_enrollments
    where section_id = p_section_id and
    student_no = p_student_number;
    return v_letter_grade;
end get_letter_grade;


declare
    v_section_id gl_enrollments.section_id%type := :Enter_Section_Id;
    v_student_num gl_enrollments.student_no%type := :Enter_Student_Num;
    v_letter_grade gl_enrollments.letter_grade%type;
begin
    v_letter_grade := get_letter_grade(v_section_id,v_student_num);
    dbms_output.put_line('Section Id: '||v_section_id);
    dbms_output.put_line('Student Number: '||v_student_num);
    dbms_output.put_line('Letter Grade: '|| v_letter_grade);
end;

--P704
--Get Full Name Function

create or replace function get_full_name(
    p_student_num in gl_students.student_no%type
)
return varchar2
is
v_full_name varchar2(200);
begin
    select first_name || ' ' || last_name
    into v_full_name
    from gl_students
    where student_no = p_student_num;

    exception 
        when NO_DATA_FOUND then
            dbms_output.put_line('No Student Found...');

    return v_full_name;
end get_full_name;

declare
    v_student_no gl_students.student_no%type := :Enter_Student_No;
    v_full_name varchar(200);
begin
    v_full_name := get_full_name(v_student_no);
    dbms_output.put_line('Student: '||v_student_no);
    dbms_output.put_line('Name: '||v_full_name);
end;


--P705
--student grade
declare
    v_section_id gl_enrollments.section_id%type := :Enter_Section_Id;
    v_student_num gl_enrollments.student_no%type := :Enter_Student_Num;
    v_full_name varchar2(200);
    v_numeric_grade gl_enrollments.numeric_grade%type;
    v_letter_grade gl_enrollments.letter_grade%type;
begin
    v_full_name := get_full_name(v_student_num);
    v_numeric_grade := get_numeric_grade(v_section_id,v_student_num);
    v_letter_grade := get_letter_grade(v_section_id,v_student_num);
        dbms_output.put_line('Section Id: '||v_section_id || '    '|| v_full_name);
    dbms_output.put_line('Student Number: '||v_student_num);
    dbms_output.put_line('Letter Grade: '|| v_letter_grade);
end;
