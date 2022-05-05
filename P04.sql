-- Pujan Gautam
-- c0842623


--Question no 1
declare
    CURSOR c_course IS
        select course_code,course_title
        from gl_courses;
    v_course_code gl_courses.course_code%TYPE;
    v_course_title gl_courses.course_title%TYPE;

begin
    open c_course;
    dbms_output.put_line('Course Code          Course Title');
    dbms_output.put_line('------------         -------------');
    loop
        fetch c_course 
        into v_course_code,v_course_title;
        exit when c_course%notfound;
        dbms_output.put_line(v_course_code || lpad(v_course_title,30));
    end loop;
    close c_course;
end;

-- Question no 2
declare
    v_semester_year gl_semesters.semester_year%TYPE  := :Enter_Semester_Year;
    v_semester_term gl_semesters.semester_term%TYPE := UPPER(:Enter_Semester_Term);
    v_professor_num gl_professors.professor_no%TYPE := :Enter_Professor_Number;
    cursor c_professor IS
        select prof.first_name ||' ' || prof.last_name as professor_name,
               sem.semester_year || sem.semester_term as semester
               course.course_title,
               sec.section_code
               from gl_sections sec
               join gl_professors prof on (sec.professor_no = prof.professor_no)
               join gl_courses course on (sec.course_code = course.course_code)
        where sem.semester_year = v_semester_year && sem.semester_term = v_semester_term && v_professor_num = prof.professor_no;

begin
    open c_professor;
    dbms_output.put_line('Teaching load for '|| c_professor.professor_name);
    dbms_output.put_line('--------------------');
    dbms_output.put_line('Semester: ');
    dbms_output-put_line('Course(s)      Section(s)');
    dbms_output.put_line('---------      -----------');


close c_professor;
end;