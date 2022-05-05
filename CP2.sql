-- Pujan Gautam
-- c0842623
-- CP2
--No Grade Enrollment Report

--  step 1: Creating P404V view

CREATE OR REPLACE VIEW P404V as
    select sem.semester_year,
           sem.semester_term,
           se.section_id,
           std.student_no,
           std.enroll_date
    from gl_semesters sem
    join gl_sections se on (sem.semester_id = se.semester_id)
    join gl_enrollments en on (se.section_id = en.section_id)
    join gl_students std on (en.student_no = std.student_no)
    where en.numeric_grade is null or en.letter_grade is null;



-- step 2: Making P0404a sql query

select * from P404V 
where lower(semester_term) = 'w';


--Step 3:  Making P0404b sql query

declare
    v_semester_year  gl_semesters.semester_year%TYPE := :Enter_Semester_Year;
    v_semester_term gl_semesters.semester_term%TYPE := upper(:Enter_Semester_term);
    v_section_id    gl_sections.section_id%TYPE;
    v_student_no    gl_students.student_no%TYPE;
    v_enroll_date   gl_students.enroll_date%TYPE;
    cursor c_students_record is
    select section_id, student_no,enroll_date from P404V
    where semester_term = v_semester_term and semester_year = v_semester_year;
begin
    open c_students_record;
    dbms_output.put_line('Enrollment Missing Grade Verification');
    dbms_output.put_line('---------------------------------------------------------');
    dbms_output.put_line('Year: '||v_semester_year||lpad('Term: ',10)||v_semester_term);
    dbms_output.new_line;
    dbms_output.put_line('Section'||lpad('Student No',20)||lpad('Enroll Date',20));
    dbms_output.put_line('--------------------------------------------------------');
    loop
        fetch c_students_record
        into v_section_id,v_student_no,v_enroll_date;
        exit when c_students_record%notfound;
        dbms_output.put_line(v_section_id || lpad(v_student_no,20) || lpad(v_enroll_date,20));
    end loop;
    close c_students_record;
end;


--step 4: P0404c
declare
    v_semester_year  gl_semesters.semester_year%TYPE := :Enter_Semester_Year;
    v_semester_term gl_semesters.semester_term%TYPE := upper(:Enter_Semester_term);
    v_section_id    gl_sections.section_id%TYPE;
    v_student_no    gl_students.student_no%TYPE;
    v_enroll_date   gl_students.enroll_date%TYPE;
 
    cursor c_students_record is
    select section_id, student_no,enroll_date from P404V
    where semester_year = coalesce(v_semester_year,to_number(to_char(sysdate,'YYYY')));
begin
    open c_students_record;
    dbms_output.put_line(v_current_month);
    if v_semester_year is null or v_semester_term is null then
        dbms_output.put_line('**Either Year or Term were not entered. The Listing Shows missing Grade for current term **.');
        dbms_output.new_line;
    end if;
    dbms_output.put_line('Enrollment Missing Grade Verification');
    dbms_output.put_line('---------------------------------------------------------');
    dbms_output.put_line('Year: '||coalesce(v_semester_year,to_char(sysdate,'YYYY'))||lpad('Term: ',10)||v_semester_term);
    dbms_output.new_line;
    dbms_output.put_line('Section'||lpad('Student No',20)||lpad('Enroll Date',20));
    dbms_output.put_line('--------------------------------------------------------');
    loop
        fetch c_students_record
        into v_section_id,v_student_no,v_enroll_date;
        exit when c_students_record%notfound;
        dbms_output.put_line(v_section_id || lpad(v_student_no,20) || lpad(v_enroll_date,20));
    end loop;
    close c_students_record;
end;


-- step 5: Exceptional Handling catching no data found exception

declare
    v_semester_year  gl_semesters.semester_year%TYPE := :Enter_Semester_Year;
    v_semester_term gl_semesters.semester_term%TYPE := upper(:Enter_Semester_term);
    v_section_id    gl_sections.section_id%TYPE;
    v_student_no    gl_students.student_no%TYPE;
    v_enroll_date   gl_students.enroll_date%TYPE;
 
    cursor c_students_record is
    select section_id, student_no,enroll_date from P404V
    where semester_term = v_semester_term and semester_year = coalesce(v_semester_year,to_number(to_char(sysdate,'YYYY')));
begin
    open c_students_record;
    if v_semester_year is null or v_semester_term is null then
        dbms_output.put_line('**Either Year or Term were not entered. The Listing Shows missing Grade for current term **.');
        dbms_output.new_line;
    end if;
    dbms_output.put_line('Enrollment Missing Grade Verification');
    dbms_output.put_line('---------------------------------------------------------');
    dbms_output.put_line('Year: '||coalesce(v_semester_year,to_char(sysdate,'YYYY'))||lpad('Term: ',10)||v_semester_term);
    dbms_output.new_line;
    dbms_output.put_line('Section'||lpad('Student No',20)||lpad('Enroll Date',20));
    dbms_output.put_line('--------------------------------------------------------');
    loop
        fetch c_students_record
        into v_section_id,v_student_no,v_enroll_date;
        exit when c_students_record%notfound;
        dbms_output.put_line(v_section_id || lpad(v_student_no,20) || lpad(v_enroll_date,20));
    end loop;
    exception when NO_DATA_FOUND then
        dbms_output.put_line('There are no missing grade for '||v_semester_year||v_semester_term);
    close c_students_record;  
    
end;



-- step 6 defining catch all error handler
declare
    v_semester_year  gl_semesters.semester_year%TYPE := :Enter_Semester_Year;
    v_semester_term gl_semesters.semester_term%TYPE := upper(:Enter_Semester_term);
    v_section_id    gl_sections.section_id%TYPE;
    v_student_no    gl_students.student_no%TYPE;
    v_enroll_date   gl_students.enroll_date%TYPE;
 
    cursor c_students_record is
    select section_id, student_no,enroll_date from P404V
    where semester_year = coalesce(v_semester_year,to_number(to_char(sysdate,'YYYY')));
begin
    open c_students_record;
    if v_semester_year is null or v_semester_term is null then
        dbms_output.put_line('**Either Year or Term were not entered. The Listing Shows missing Grade for current term **.');
        dbms_output.new_line;
    end if;
    dbms_output.put_line('Enrollment Missing Grade Verification');
    dbms_output.put_line('---------------------------------------------------------');
    dbms_output.put_line('Year: '||coalesce(v_semester_year,to_char(sysdate,'YYYY'))||lpad('Term: ',10)||v_semester_term);
    dbms_output.new_line;
    dbms_output.put_line('Section'||lpad('Student No',20)||lpad('Enroll Date',20));
    dbms_output.put_line('--------------------------------------------------------');
    loop
        fetch c_students_record
        into v_section_id,v_student_no,v_enroll_date;
        exit when c_students_record%notfound;
        dbms_output.put_line(v_section_id || lpad(v_student_no,20) || lpad(v_enroll_date,20));
    end loop;
    exception when NO_DATA_FOUND then
        dbms_output.put_line('There are no missing grade for '||v_semester_year||v_semester_term);
    exception when others then
        DBMS_OUTPUT.PUT_LINE('**The following undetermined error occurred. Contact Software Support.');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: '|| SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
    close c_students_record;   
end;




