--Pujan Gautam - C0842623
-- Grade Listing Report
-- P0605
-- CP3


-- Step 1: Creating P0605V view
create or replace view P0605V as
    select scl.school_code as "School Code",
           pg.program_code as "Program Code",
           cs.course_code as "Course Code",
           cs.credit_hours as "Credit Hours",
           sec.section_id as "Section Id",
           sem.semester_year as "Semester Year",
           sem.semester_term as "Semester term",
           std.student_no as "Student No",
           std.last_name || ', '||std.first_name as "Student Name",
           coalesce(en.letter_grade,'N/A') as "Letter Grade"
    from gl_schools scl
    join gl_programs  pg on (scl.school_code=pg.school_code)
    join gl_courses cs on(pg.program_code = cs.program_code)
    join gl_sections sec on(sec.course_code = cs.course_code)
    join gl_semesters sem on (sem.semester_id = sec.semester_id)
    join gl_enrollments en on (en.section_id = sec.section_id)
    join gl_students std on (std.student_no = en.student_no);


-- Step 2: Creating Procedure P0605
create or replace procedure P0605(
    p_school_code in gl_schools.school_code%type,
    p_semester_year in gl_semesters.semesters_year%type,
    p_semester_term in gl_semesters.semesters_term%type
)
is
Procedure get_school_name;

-- GET SCHOOL NAME SUB-PROCEDURE

PROCEDURE get_school_name is
begin
    
end get_school_name;

begin

end P0605;



