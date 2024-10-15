--************************************--
-- PROBLEM ONE: UNIVERSITY ENROLLMENT --
--************************************--

-- By: William Moss--
--  10-13-2024   --

----------------------------------------`
--    TABLE CREATION                  --
----------------------------------------

-- STUDENTS TABLE --
CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    enrollment_date DATE NOT NULL
);

-- PROFESSORS TABLE --
CREATE TABLE IF NOT EXISTS professors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(100) NOT NULL
);

-- COURSES TABLE --
CREATE TABLE IF NOT EXISTS courses (
    id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_description TEXT NOT NULL,
    professor_id INTEGER NOT NULL,
	FOREIGN KEY (professor_id) REFERENCES professors(id)
);

-- ENROLLMENTS TABLE --
CREATE TABLE IF NOT EXISTS enrollments (
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_date DATE NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

----------------------------------------
--    ADD INFO TO SCRIPT              --
----------------------------------------


-- INSERT data into the STUDENTS table
INSERT INTO students (first_name, last_name, email, enrollment_date) VALUES
('Duke', 'Nukem', 'Duke.Nukem@universitymail.com', '2024-02-04'),
('Alex', 'Ample', 'Alex.Ample@universitymail.com', '2024-04-03'),
('Noah', 'Scuses', 'Noah.Scuses@universitymail.com', '2024-07-15'),
('Barry', 'Mealive', 'Barry.Mealive@universitymail.com', '2024-07-24'),
('Ida', 'Student', 'Ida.Student@universitymail.com', '2024-09-01');

-- Confirmation query for students
SELECT * FROM students;


-- INSERT information into the PROFESSORS table
INSERT INTO professors (first_name, last_name, department) VALUES
('Khan', 'Pewter', 'Computer Science'),
('Heisen', 'Burg', 'Chemistry'),
('Jenny', 'Talia', 'Body Anatomy'),
('Frasier', 'Wordswright', 'English Literature');

-- Confirmation query for professors
SELECT * FROM professors;


-- INSERT data into the COURSES table
-- Professor IDs are sequential(Serial); 1 for Khan, 2 Heisen, etc
INSERT INTO courses (course_name, course_description, professor_id) VALUES
('Introduction to Computer Science', 'Fundamentals of SQL and pgAdmin4.', 1),
('Chemistry 101', 'Basics of Cold Fusion.', 2),
('Meta-Body Anatomy', 'How to Grow Extra Limbs.', 3),
('English And Its Derivates', 'Words; The Discourse', 4);


-- Confirmation query for courses
SELECT * FROM courses;


-- INSERT data into the ENROLLMENTS table
-- Student IDs and Course IDs start from 1 and increment by 1(Serial)
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES
(1, 1, '2024-02-04'),  -- Duke Nukem enrolls in Introduction to Computer Science
(1, 2, '2024-02-04'),  -- Duke Nukem enrolls in Chemistry 101
(2, 1, '2024-04-03'),  -- Alex Ample enrolls in Introduction to Computer Science
(3, 3, '2024-07-15'),  -- Noah Scuses enrolls in Meta-Body Anatomy
(4, 2, '2024-07-24');  -- Barry Mealive enrolls in Chemistry 101

-- BONUS: INSERT Ida Studen in English And Its Derivatives
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES
(5, 4, '2024-09-01');


-- Confirmation query for enrollments
SELECT 
    e.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    e.course_id,
    c.course_name,
    e.enrollment_date
FROM 
    enrollments e
JOIN 
    students s ON e.student_id = s.id
JOIN 
    courses c ON e.course_id = c.id;


----------------------------------------
--    ASSIGNED QUERIES                --
----------------------------------------

-- 1. Retrieve Full Names of Students Enrolled in "Chemistry 101"
-- Using Chemistry instead of Physics as this is a fictional scenario and I already have my courses created. 

SELECT
    s.first_name || ' ' || s.last_name AS full_name
FROM
    students s
JOIN
    enrollments e ON s.id = e.student_id
JOIN
    courses c ON e.course_id = c.id
WHERE
    c.course_name = 'Chemistry 101';

----------------------------------------

-- 2. Retrieve Courses with Professor's Full Names

SELECT
    c.course_name,
    p.first_name || ' ' || p.last_name AS professor_full_name
FROM
    courses c
JOIN
    professors p ON c.professor_id = p.id;

----------------------------------------

-- 3. Retrieve Courses with Enrolled Students

SELECT DISTINCT
    c.course_name
FROM
    courses c
JOIN
    enrollments e ON c.id = e.course_id;


----------------------------------------
--    Updating Data                   --
----------------------------------------

-- 1. Identify the Student by id
SELECT * FROM students WHERE id = 2;

-- Alternatively, identify by name
-- SELECT * FROM students WHERE first_name = 'Alex' AND last_name = 'Ample';

----------------------------------------

-- 2. Update the Student's Email
UPDATE students
SET email = 'Alex.Ample@updatemail.com'
WHERE id = 2;

----------------------------------------

-- 3. Verify the Update
SELECT * FROM students WHERE id = 2;

----------------------------------------
--    Deleting Data                   --
----------------------------------------

-- 1. Identify the Enrollment Record

-- Retrieve the enrollment record for Duke Nukem in Chemistry 101
SELECT
    e.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    e.course_id,
    c.course_name,
    e.enrollment_date
FROM
    enrollments e
JOIN
    students s ON e.student_id = s.id
JOIN
    courses c ON e.course_id = c.id
WHERE
    e.student_id = 1 AND e.course_id = 2;

----------------------------------------

-- 2. Delete the Enrollment Record

DELETE FROM enrollments
WHERE student_id = 1 AND course_id = 2;

----------------------------------------

-- 3. Verify the Deletion

-- Attempt to retrieve the deleted enrollment record
SELECT
    e.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    e.course_id,
    c.course_name,
    e.enrollment_date
FROM
    enrollments e
JOIN
    students s ON e.student_id = s.id
JOIN
    courses c ON e.course_id = c.id
WHERE
    e.student_id = 1 AND e.course_id = 2;

-- View all remaining enrollments
SELECT
    e.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    e.course_id,
    c.course_name,
    e.enrollment_date
FROM
    enrollments e
JOIN
    students s ON e.student_id = s.id
JOIN
    courses c ON e.course_id = c.id
ORDER BY
    e.student_id;