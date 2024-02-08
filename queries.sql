-- 1) Print the names of professors who work in departments that have fewer than 50 PhD
students
SELECT prof.pname
FROM prof
JOIN dept ON prof.dname = dept.dname
WHERE dept.numphds < 50;

-- 2) Print the names of the students with the lowest GPA.
SELECT sname
FROM student
ORDER BY gpa ASC
LIMIT 1;

-- 3) For each Computer Sciences class, print the class number, section number, and the average gpa of the students enrolled in the class section

SELECT e.cno AS class_number,
       e.sectno AS section_number,
       AVG(s.gpa) AS average_gpa
FROM enroll e
JOIN section sct ON e.dname = sct.dname AND e.cno = sct.cno AND e.sectno = sct.sectno
JOIN student s ON e.sid = s.sid
JOIN course c ON e.dname = c.dname AND e.cno = c.cno
WHERE c.dname = 'Computer Sciences'
GROUP BY e.cno, e.sectno;

-- 4) Print the names and section numbers of all sections with more than six students enrolled in them.

SELECT s.sectno AS section_number,
       COUNT(*) AS num_students
FROM section s
JOIN enroll e ON s.dname = e.dname AND s.cno = e.cno AND s.sectno = e.sectno
GROUP BY s.sectno
HAVING COUNT(*) > 6;

-- 5) Print the name(s) and sid(s) of the student(s) enrolled in the most sections

-- could not do it

-- 6) Print the names of departments that have one or more majors who are under 18 years old.
SELECT DISTINCT d.dname
FROM dept d
JOIN major m ON d.dname = m.dname
JOIN student s ON m.sid = s.sid
WHERE s.age < 18;

-- 7) Print the names and majors of students who are taking one of the College Geometry courses.

SELECT DISTINCT s.sname AS student_name, m.dname AS major
FROM student s
JOIN enroll e ON s.sid = e.sid
JOIN course c ON e.cno = c.cno AND e.dname = c.dname
JOIN major m ON s.sid = m.sid
WHERE c.cname = 'College Geometry';

-- 8) For those departments that have no major taking a College Geometry course print the department name and the number of PhD students in the department.
SELECT d.dname AS department_name,
       d.numphds AS number_of_phd_students
FROM dept d
WHERE d.dname NOT IN (
    SELECT DISTINCT m.dname
    FROM major m
    JOIN student s ON m.sid = s.sid
    JOIN enroll e ON s.sid = e.sid
    JOIN course c ON e.cno = c.cno AND e.dname = c.dname
    WHERE c.cname = 'College Geometry'
)
ORDER BY d.dname;

-- 9) Print the names of students who are taking both a Computer Sciences course and a Mathematics course.
SELECT DISTINCT s.sname AS student_name
FROM student s
JOIN enroll e_cs ON s.sid = e_cs.sid
JOIN course c_cs ON e_cs.cno = c_cs.cno AND e_cs.dname = c_cs.dname
JOIN enroll e_math ON s.sid = e_math.sid
JOIN course c_math ON e_math.cno = c_math.cno AND e_math.dname = c_math.dname
WHERE c_cs.dname = 'Computer Sciences'
  AND c_math.dname = 'Mathematics';

--  10) Print the age difference between the oldest and the youngest Computer Sciences major
SELECT MAX(s.age) - MIN(s.age) AS age_difference
FROM student s
JOIN major m ON s.sid = m.sid
JOIN dept d ON m.dname = d.dname
WHERE d.dname = 'Computer Sciences';

-- 11) For each department that has one or more majors with a GPA under 1.0, print the name of the department and the average GPA of its majors.

-- could not do it

-- 12) Print the ids, names and GPAs of the students who are currently taking all the Civil Engineering courses.
SELECT s.sid, s.sname, s.gpa
FROM student s
WHERE NOT EXISTS (
    SELECT c.cno
    FROM course c
    WHERE c.dname = 'Civil Engineering'
    EXCEPT
    SELECT e.cno
    FROM enroll e
    WHERE e.sid = s.sid
);
