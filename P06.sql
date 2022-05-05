-- Pujan Gautam - c0842623
-- Assignment 06

-- P0601

--creating a procedure add_professor
create or replace procedure add_professor(
    p_professor_num in gl_professors_copy.professor_no%type,
    P_first_name in gl_professors_copy.first_name%type,
    p_last_name in gl_professors_copy.last_name%type,
    p_office_num in gl_professors_copy.office_no%type,
    p_office_ext in gl_professors_copy.office_ext%type,
    p_school_code in gl_professors_copy.school_code%type
)
IS
BEGIN
    insert into gl_professors_copy 
    values (p_professor_num,p_first_name,p_last_name,p_office_num,p_office_ext,p_school_code);
    dbms_output.put_line('Inserted ' || SQL%ROWCOUNT || ' rows.')
    dbms_output.put_line('Added Professor '|| p_professor_num);
    dbms_output.new_line;
END;

--calling the add_professor from anonyous block
declare
    v_professor_num  gl_professors_copy.professor_no%type := :Enter_Professor_Number;
    v_first_name gl_professors_copy.first_name%type := initcap(:Enter_First_Name);
    v_last_name  gl_professors_copy.last_name%type := initcap(:Enter_Last_Name);
    v_office_num  gl_professors_copy.office_no%type := :Enter_Office_Number;
    v_office_ext  gl_professors_copy.office_ext%type := :Enter_Office_Ext;
    v_school_code  gl_professors_copy.school_code%type := upper(:Enter_School_Code);
begin
    add_professor(v_professor_num,v_first_name,v_last_name,v_office_num,v_office_ext,v_school_code);
    exception
        when dup_val_on_index then
        dbms_output.put_line('Professor with professor number '||v_professor_num || ' already exist.')
        when others then
        dbms_output.put_line('Error Adding Professor ' || v_professor_num);
end;


-- P0602
--creating a procedure convert_grade
create or replace procedure convert_grade(
    p_grade_num in number,
    p_grade_letter out varchar2
)
IS
BEGIN
    case
        when p_grade_num >= 90 then p_grade_letter := 'A';
        when p_grade_num >= 80 then p_grade_letter := 'B';
        when p_grade_num >= 70 then p_grade_letter := 'C';
        when p_grade_num >= 60 then p_grade_letter := 'D';
        else p_grade_letter := 'F';
    end case;
END;

--calling procedure convert_grade from anonymous block
declare
    not_in_range exception;
    v_grade_num Number := :Enter_Number_Grade;
    v_grade_letter char(1);
begin 
    if (v_grade_num > 100 or v_grade_num < 0) then
        raise not_in_range;
    end if;
    convert_grade(v_grade_num,v_grade_letter);
    dbms_output.put_line('Numeric Grade : '|| v_grade_num);
    dbms_output.put_line('Letter Grade : '|| v_grade_letter);
    exception
        when not_in_range then
            dbms_output.put_line('Grade '||v_grade_num|| ' Invalid. Not in range 0 - 100.');
        when others then
            dbms_output.put_line('Grade Cannot be Converted.');
end;


--P0603
create or replace procedure update_grade(
    p_section_id in gl_enrollments.section_id%type,
    p_student_num in gl_enrollments.student_no%type,
    p_new_numeric_grade in gl_enrollments.numeric_grade%type,
    p_new_letter_grade in gl_enrollments.letter_grade%type,
    p_old_numeric_grade out gl_enrollments.numeric_grade%type,
    p_old_letter_grade out gl_enrollments.letter_grade%type
)
IS
begin
    --fetching the old values
    select numeric_grade,letter_grade
    into p_old_numeric_grade,p_old_letter_grade
    from gl_enrollments_copy
    where section_id = p_section_id and
    student_no = p_student_num;

    --updating with new values
    update gl_enrollments_copy
    set numeric_grade = p_new_numeric_grade, letter_grade = p_new_letter_grade
    where section_id = p_section_id and
    student_no = p_student_num;
    dbms_output.put_line('Updated ' || SQL%ROWCOUNT || ' rows.');
    dbms_output.new_line;
end;

declare
    v_section_id  gl_enrollments.section_id%type := :Enter_Section_Id;
    v_student_num  gl_enrollments.student_no%type := :Enter_Student_Number;
    v_new_numeric_grade gl_enrollments.numeric_grade%type := :Enter_New_Numeric_Grade;
    v_new_letter_grade gl_enrollments.letter_grade%type;
    v_old_numeric_grade gl_enrollments.numeric_grade%type;
    v_old_letter_grade gl_enrollments.letter_grade%type;
begin
    convert_grade(v_new_numeric_grade,v_new_letter_grade);
    update_grade(v_section_id,v_student_num,v_new_numeric_grade,v_new_letter_grade,v_old_numeric_grade,v_old_letter_grade);
    dbms_output.put_line('Student: ' || v_student_num);
    dbms_output.put_line('Section: '||v_section_id);
    
    dbms_output.put_line('Numeric Grade: Old - '|| COALESCE(to_char(v_old_numeric_grade),'NA') || ' New - '||COALESCE(to_char(v_new_numeric_grade),'NA'));
    dbms_output.put_line('Letter Grade: Old - '|| COALESCE(v_old_letter_grade,'NA') ||' New - ' || COALESCE(v_new_letter_grade,'NA'));
        exception 
        when NO_DATA_FOUND then
            dbms_output.put_line('No Data Found...');
        when others then
            dbms_output.put_line('Error in Updating Data.');
end;



--P0604
--creating a procedure get_grade
create or replace procedure get_grade(
    p_section_id in gl_enrollments.section_id%type,
    p_student_num in gl_enrollments.student_no%type,
    p_numeric_grade out gl_enrollments.numeric_grade%type,
    p_letter_grade out gl_enrollments.letter_grade%type
)
is
begin
    select numeric_grade,letter_grade
    into p_numeric_grade,p_letter_grade
    from gl_enrollments
    where section_id = p_section_id 
    and student_no = p_student_num;
end;

--calling procedure get_grade from an anonymous block
declare
    v_section_id gl_enrollments.section_id%type := :Enter_Section_Id;
    v_student_no gl_enrollments.student_no%type := :Enter_Student_Number;
    v_letter_grade gl_enrollments.letter_grade%type;
    v_numeric_grade gl_enrollments.numeric_grade%type;
begin
    get_grade(v_section_id,v_student_no,v_numeric_grade,v_letter_grade);
    dbms_output.put_line('Student Number: '|| v_student_no);
    dbms_output.put_line('Section Id: '||v_section_id);
    dbms_output.put_line('Numeric Grade: '||COALESCE(to_char(v_numeric_grade),'NG'));
    dbms_output.put_line('Letter Grade: '||COALESCE(v_letter_grade,'NG'));

    exception 
        when NO_DATA_FOUND then
            dbms_output.put_line('No Data Found...');
        when others then
            dbms_output.put_line('Error in Fetching Data.');
end;