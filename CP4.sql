-- Pujan Gautam - c0842623
-- CP4

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


-- creating professor section view

CREATE OR REPLACE VIEW professor_section_view
AS
SELECT professor_no,
COUNT(section_id) AS total_sections
FROM gl_professors_copy
LEFT OUTER JOIN gl_sections_copy USING(professor_no)
GROUP BY professor_no;


select * from professor_section_view;

DELETE FROM professor_section_view
WHERE professor_no = 5001;


CREATE OR REPLACE TRIGGER professor_delete_trg
INSTEAD OF DELETE ON professor_section_view
FOR EACH ROW
BEGIN
DELETE FROM gl_sections_copy
WHERE professor_no = :OLD.professor_no;
DELETE FROM gl_professors_copy
WHERE professor_no = :OLD.professor_no;
END;

DELETE FROM professor_section_view
WHERE professor_no = 5001;

SELECT *
FROM professor_section_view
WHERE professor_no = 5001;

SELECT *
FROM gl_professors_copy
WHERE professor_no = 5001;

SELECT *
FROM gl_sections_copy
WHERE professor_no = 5001;