--Pujan Gautam - c0842623
-- P10
-- Date of Submission: 4/14/2022

DROP TABLE gl_sections_copy;

DROP TABLE gl_professors_copy;

CREATE TABLE gl_professors_copy AS(
SELECT * FROM gl_professors);

ALTER TABLE gl_professors_copy
ADD CONSTRAINT gl_professors_copy_pk
PRIMARY KEY (professor_no);

CREATE TABLE gl_sections_copy AS(
SELECT * FROM gl_sections);

ALTER TABLE gl_sections_copy
ADD CONSTRAINT gl_sections_copy_pk
PRIMARY KEY (section_id);

ALTER TABLE gl_sections_copy
ADD CONSTRAINT gl_sections_copy_professor_no_fk
FOREIGN KEY (professor_no)
REFERENCES gl_professors_copy (professor_no);

SELECT * FROM gl_professors_copy;

SELECT * FROM gl_sections_copy;


-- creating views professor_section_view

create or replace view professor_section_view as
    select professor_no,count(section_id) as total_sections
    from gl_professors_copy
    join gl_sections_copy using(professor_no)
    group by professor_no
    order by professor_no;

select * from professor_section_view;


--trying to delete professor 5001 from the views

delete from professor_section_view where professor_no = 5001;


--creating instead of trigger professor_delete_tr

create or replace trigger professor_delete_tr 
instead of delete on professor_section_view
for each row
begin
    delete from gl_sections_copy where professor_no = :old.professor_no;
    delete from gl_professors_copy where professor_no = :old.professor_no;
    
end;

-- trying to delete row after trigger is created
delete from professor_section_view where professor_no = 5001;

select * from professor_section_view;


