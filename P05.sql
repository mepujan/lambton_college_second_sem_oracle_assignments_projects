-- Pujan Gautam 
-- c0842623


-- question 1
declare
    v_student_number gl_students.student_no%type := :ENTER_STUDENT_NUMBER;
    v_student_first_name gl_students.first_name%type;
    v_student_last_name gl_students.last_name%type;
begin
    select first_name, last_name
    into v_student_first_name,v_student_last_name
    from gl_students
    where student_no = v_student_number;
    DBMS_OUTPUT.PUT_LINE(v_student_first_name || ' ' || v_student_first_name); 
    EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('STUDENT '||v_student_number ||' NOT FOUND');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('**The following undetermined error occurred. Contact Software Support.');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: '|| SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;


-- question 2

declare
    v_major_code gl_students.major_code%type := UPPER(:ENTER_MAJOR_CODE);
    v_student_first_name gl_students.first_name%type;
    v_student_last_name gl_students.last_name%type;
begin
    select first_name,last_name
    into v_student_first_name,v_student_last_name
    from gl_students
    where major_code = v_major_code;
    DBMS_OUTPUT.PUT_LINE(v_student_first_name || ' ' || v_student_last_name);
    EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Multiple Rows Returned.');
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('NO STUDENT FOUND FOR MAJOR '||v_major_code);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('**The following undetermined error occurred. Contact Software Support.');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: '|| SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;


--question  3

declare
    e_program_code_not_found_ex EXCEPTION;
    v_program_code gl_programs.program_code%type := :ENTER_PROGRAM_CODE;
    v_program_name gl_programs.program_name%type := :ENTER_NEW_PROGRAM_NAME;
begin
    update gl_programs
    set program_name = v_program_name
    where program_code = v_program_code;
    IF SQL%NOTFOUND THEN 
    RAISE e_program_code_not_found_ex;
    END IF;
    EXCEPTION
    WHEN e_program_code_not_found_ex THEN
        DBMS_OUTPUT.PUT_LINE('Program '|| v_program_code||' Not Found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('**The following undetermined error occurred. Contact Software Support.');
        DBMS_OUTPUT.PUT_LINE('   SQL ERROR CODE: '|| SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;


--question 4

declare
    e_school_code_not_found_ex EXCEPTION;
    e_fk_exception_ex EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_fk_exception_ex,-2292);
    e_input_string_too_large_ex EXCEPTION;
    PRAGMA_INIT(e_input_string_too_large_ex,-06502)
    v_school_code gl_schools.school_code%type := :ENTER_SCHOOL_CODE;
begin
    delete gl_schools
    where school_code = v_school_code;
    IF SQL%NOTFOUND THEN 
    RAISE e_school_code_not_found_ex;
    END IF;
    Exception
    when e_school_code_not_found_ex then
        DBMS_OUTPUT.PUT_LINE('School Code '||v_school_code||' not Found.');
    WHEN e_fk_exception_ex then
        DBMS_OUTPUT.PUT_LINE('Cannot Delete Row Because Of Integrity Constraint Error.'||chr(10)||
                              'There are child foreign key relationship with GL_SCHOOLS table.');
    when e_input_string_too_large_ex then
        DBMS_OUTPUT.PUT_LINE('School Code is too long.Can only be two character.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('**The following undetermined error occurred. Contact Software Support.');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: '|| SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;