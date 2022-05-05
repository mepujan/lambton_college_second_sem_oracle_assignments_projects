-- c0842623
-- PUJAN GAUTAM

--1
declare
    v_section_id  GL_SECTIONS.SECTION_ID%TYPE := :ENTER_SECTION_ID;   
    total_student integer := 0;    
begin
    select count(*)
    into total_student
    from GL_ENROLLMENTS
    where section_id = v_section_id;
    DBMS_OUTPUT.PUT_LINE('There are '||total_student||' students in section '||v_section_id);
    EXCEPTION
    WHEN OTHER THEN
    DBMS_OUTPUT.PUT_LINE('   SQL ERROR CODE: '|| SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;

--end of question 1

--2
declare
    v_section_id  GL_SECTIONS.SECTION_ID%TYPE := :ENTER_SECTION_ID;   
    average_grade number(4,2) := 0;    
begin
    select AVG(NUMERIC_GRADE)
    into average_grade
    from GL_ENROLLMENTS
    where section_id = v_section_id;
    DBMS_OUTPUT.PUT_LINE('The average grade in section '||v_section_id||' is '||average_grade);
    EXCEPTION
    WHEN OTHER THEN
    DBMS_OUTPUT.PUT_LINE('   SQL ERROR CODE: '|| SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;

--end of question 2


--3
declare
    v_course_code GL_SECTIONS.COURSE_CODE%TYPE:= UPPER(:ENTER_COURSE_CODE);
    v_sections_count integer := 0;
begin
    select count(COURSE_CODE)
    into v_sections_count
    from GL_SECTIONS
    where course_code = v_course_code;
    DBMS_OUTPUT.PUT_LINE('There are '||v_sections_count||' section(s) offered in course '||v_course_code);
    EXCEPTION
    WHEN OTHER THEN
    DBMS_OUTPUT.PUT_LINE('   SQL ERROR CODE: '|| SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;

--end of question 3


--4
create or replace view gl_stdv1 as 
    select st.student_no,
           st.first_name as st_first_name,
           st.last_name as st_last_name,
           pg.program_name,
           co.course_title,
           en.section_id,
           pf.first_name as pr_first_name,
           pf.last_name as pr_last_name,
           en.letter_grade
    from gl_students st
    join gl_enrollments en on (st.student_no = en.student_no)
    join gl_sections se on (en.section_id = se.section_id )
    join gl_courses co on (se.course_code = co.course_code)
    join gl_programs pg on (st.major_code = pg.program_code)
    join gl_professors pf on (se.professor_no = pf.professor_no);

select * from g1_stdv1;

declare
    student_record       gl_stdv1%ROWTYPE;
    heading1      varchar2(80) := 'Student Grade:   '||TO_CHAR(CURRENT_DATE,'FMDay, Month DD, YYYY');
    heading2      varchar2(80) := LPAD('-',length(heading1),'-');
begin
    select * 
    into student_record
    from g1_stdv1
    where student_no = :Enter_Student_Number and
          section_id = :ENter_Section_id;
    DBMS_OUTPUT.PUT_LINE(heading1);
    DBMS_OUTPUT.PUT_LINE(heading2);
    DBMS_OUTPUT.PUT_LINE('Student:     ' || student_record.st_first_name || ' ' || student_record.st_last_name);
    DBMS_OUTPUT.PUT_LINE('Major:       ' || student_record.program_name);
    DBMS_OUTPUT.PUT_LINE('Course:      ' || student_record.course_title);
    DBMS_OUTPUT.PUT_LINE('Section:     ' || student_record.section_id);
    DBMS_OUTPUT.PUT_LINE('Professor:   ' || student_record.pr_first_name || ' ' || student_record.pr_last_name);
    DBMS_OUTPUT.PUT_LINE('Grade:       ' || student_record.letter_grade);
    EXCEPTION
    WHEN OTHER THEN
    DBMS_OUTPUT.PUT_LINE('   SQL ERROR CODE: '|| SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;


--end of question 4


--5

create or replace view gl_prov1 as
    select p.*,s.school_name
    from gl_professors p
         join gl_schools s
         on(p.school_code = s.school_code); 

select * from gl_prov1;

declare
    professor_record     gl_prov1%ROWTYPE;
    v_professor_no       gl_professors.professor_no%TYPE:= :Enter_Professor_No;
begin
     select *
     into professor_record
     from gl_prov1
     where professor_no = v_professor_no;
     DBMS_OUTPUT.PUT_LINE('Professor Information');
     DBMS_OUTPUT.PUT_LINE('-----------------------');
     DBMS_OUTPUT.PUT_LINE('Professor No: ' || professor_record.professor_no);
     DBMS_OUTPUT.PUT_LINE('        Name: ' || professor_record.first_name || ' ' || professor_record.last_name);
     DBMS_OUTPUT.PUT_LINE('   Office No: ' || professor_record.office_no);
     DBMS_OUTPUT.PUT_LINE('  Office ext: ' || professor_record.office_ext);
     DBMS_OUTPUT.PUT_LINE(' School Name: ' || professor_record.school_name);
    EXCEPTION
    WHEN OTHER THEN
    DBMS_OUTPUT.PUT_LINE('   SQL ERROR CODE: '|| SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;

--end of question 5


--6
declare
    professor_record    gl_professors_copy%ROWTYPE;
    v_professor_no      gl_professors_copy.professor_no%TYPE := :Enter_Professor_No;
    v_first_name        gl_professors_copy.first_name%TYPE := :Enter_first_name;
    v_last_name         gl_professors_copy.last_name%TYPE := :Enter_last_name;
    v_office_no         gl_professors_copy.office_no%TYPE := :Enter_office_no;
    v_office_ext        gl_professors_copy.office_ext%TYPE := :Enter_office_ext;
    v_school_code       gl_professors_copy.school_code%TYPE := UPPER(:Enter_School_Code);
begin 
    insert into gl_professors_copy
    values (v_professor_no,
            initcap(v_first_name),
            initcap(v_last_name),
            v_office_no,
            v_office_ext,
            v_school_code
    );
    select * 
    into professor_record
    from gl_professors_copy
    where professor_no = v_professor_no;
    DBMS_OUTPUT.PUT_LINE('Professor Added');
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE('  Professor No: ' || professor_record.professor_no);
    DBMS_OUTPUT.PUT_LINE('          Name: ' || professor_record.first_name || ' ' || professor_record.last_name);
    DBMS_OUTPUT.PUT_LINE(' Old Office No: ' || professor_record.office_no);
    DBMS_OUTPUT.PUT_LINE('Old Office ext: ' || professor_record.office_ext);
    DBMS_OUTPUT.PUT_LINE('   School Name: ' || professor_record.school_name);
    EXCEPTION
    WHEN OTHER THEN
    DBMS_OUTPUT.PUT_LINE('   SQL ERROR CODE: '|| SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;


--end of question 6

--7
declare
    professor_rec_old        gl_professors_copy%ROWTYPE;
    professor_rec_new        gl_professors_copy%ROWTYPE;
    v_professor_no           gl_professors_copy.professor_no%TYPE := :Enter_professor_no;
    v_office_no              gl_professors_copy.office_no%TYPE := :Enter_office_no;
    v_office_ext             gl_professors_copy.office_ext%TYPE := :Enter_office_ext;
begin
    select * 
    into professor_rec_old
    from gl_professors_copy
    where professor_no = v_professor_no;

    update gl_professors_copy
    set    office_no = v_office_no
           office_ext = v_office_ext
    where professor_no = v_professor_no;

    DBMS_OUTPUT.PUT_LINE('Professor Updated');
    DBMS_OUTPUT.PUT_LINE('------------------');
    DBMS_OUTPUT.PUT_LINE('  Professor No: ' || professor_rec_new.professor_no);
    DBMS_OUTPUT.PUT_LINE('    First Name: ' || professor_rec_new.first_name);
    DBMS_OUTPUT.PUT_LINE('     Last Name: ' || professor_rec_new.last_name);
    DBMS_OUTPUT.PUT_LINE(' Old Office No: ' || professor_rec_old.office_no || 'New Office no: '|| professor_rec_new.office_no);
    DBMS_OUTPUT.PUT_LINE('Old Office ext: ' || professor_rec_old.office_ext|| 'New Office ext: '|| professor_rec_new.office_ext);
    DBMS_OUTPUT.PUT_LINE('   School Code: ' || professor_rec_new.school_code);
    EXCEPTION
    WHEN OTHER THEN
    DBMS_OUTPUT.PUT_LINE('   SQL ERROR CODE: '|| SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;

--end of question 7


--8
declare
    professor_rec       gl_professors_copy%ROWTYPE;
    v_professor_no      gl_professors_copy.professor_no%TYPE := :Enter_professor_no;
begin
    select * 
    into professor_rec
    from gl_professors_copy
    where professor_no = v_professor_no;

    delete gl_professors_copy
    where professor_no = v_professor_no;

    DBMS_OUTPUT.PUT_LINE('Professor Deleted');
    DBMS_OUTPUT.PUT_LINE('------------------');
    DBMS_OUTPUT.PUT_LINE('  Professor No: ' || professor_rec.professor_no);
    DBMS_OUTPUT.PUT_LINE('    First Name: ' || professor_rec.first_name);
    DBMS_OUTPUT.PUT_LINE('     Last Name: ' || professor_rec.last_name);
    DBMS_OUTPUT.PUT_LINE(' Old Office No: ' || professor_rec.office_no);
    DBMS_OUTPUT.PUT_LINE('Old Office ext: ' || professor_rec.office_ext);
    DBMS_OUTPUT.PUT_LINE('   School Code: ' || professor_rec.school_code);
    EXCEPTION
    WHEN OTHER THEN
    DBMS_OUTPUT.PUT_LINE('   SQL ERROR CODE: '|| SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '|| SQLERRM);
end;

--end of question 8
