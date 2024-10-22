--************************************--
-- PROBLEM ONE: UNIVERSITY ENROLLMENT --
--************************************--

-- Created by: William Moss --
-- Date: 10-13-2024 --

----------------------------------------
--    SETTING UP THE DATABASE          --
----------------------------------------

-- First, let's create a table for our students.
CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,              -- Each student gets a unique ID
    first_name VARCHAR(50) NOT NULL,   -- Student's first name
    last_name VARCHAR(50) NOT NULL,    -- Student's last name
    email VARCHAR(100) UNIQUE NOT NULL, -- Unique email for each student
    enrollment_date DATE NOT NULL       -- The date they enrolled
);

-- Now, let's create a table for our professors.
CREATE TABLE IF NOT EXISTS professors (
    id SERIAL PRIMARY KEY,              -- Each professor gets a unique ID
    first_name VARCHAR(50) NOT NULL,   -- Professor's first name
    last_name VARCHAR(50) NOT NULL,    -- Professor's last name
    department VARCHAR(100) NOT NULL    -- Department they belong to
);

-- Next up, we need a table for the courses offered.
CREATE TABLE IF NOT EXISTS courses (
    id SERIAL PRIMARY KEY,              -- Each course gets a unique ID
    course_name VARCHAR(100) NOT NULL,  -- Name of the course
    course_description TEXT NOT NULL,   -- Description of the course
    professor_id INTEGER NOT NULL,      -- Which professor teaches this course
    FOREIGN KEY (professor_id) REFERENCES professors(id) -- Links to the professors table
);

-- Finally, let’s create a table to track enrollments.
CREATE TABLE IF NOT EXISTS enrollments (
    student_id INTEGER NOT NULL,        -- Links to the student
    course_id INTEGER NOT NULL,         -- Links to the course
    enrollment_date DATE NOT NULL,      -- When the student enrolled
    PRIMARY KEY (student_id, course_id), -- Each student can only enroll in a course once
    FOREIGN KEY (student_id) REFERENCES students(id), -- Links to students table
    FOREIGN KEY (course_id) REFERENCES courses(id) -- Links to courses table
);

----------------------------------------
--    ADDING DATA TO THE DATABASE     --
----------------------------------------

-- Let's add some students to our students table.
INSERT INTO students (first_name, last_name, email, enrollment_date) VALUES
('Duke', 'Nukem', 'Duke.Nukem@universitymail.com', '2024-02-04'),
('Alex', 'Ample', 'Alex.Ample@universitymail.com', '2024-04-03'),
('Noah', 'Scuses', 'Noah.Scuses@universitymail.com', '2024-07-15'),
('Barry', 'Mealive', 'Barry.Mealive@universitymail.com', '2024-07-24'),
('Ida', 'Student', 'Ida.Student@universitymail.com', '2024-09-01');

-- Let’s see if our students were added successfully.
SELECT * FROM students;

-- Now, let's add some professors.
INSERT INTO professors (first_name, last_name, department) VALUES
('Khan', 'Pewter', 'Computer Science'),
('Heisen', 'Burg', 'Chemistry'),
('Jenny', 'Talia', 'Body Anatomy'),
('Frasier', 'Wordswright', 'English Literature');

-- Confirming that professors were added.
SELECT * FROM professors;

-- Next, we’ll add some courses.
INSERT INTO courses (course_name, course_description, professor_id) VALUES
('Introduction to Computer Science', 'Fundamentals of SQL and pgAdmin4.', 1),
('Chemistry 101', 'Basics of Cold Fusion.', 2),
('Meta-Body Anatomy', 'How to Grow Extra Limbs.', 3),
('English And Its Derivatives', 'Words; The Discourse', 4);

-- Let’s check our courses.
SELECT * FROM courses;

-- Now we’ll enroll some students in these courses.
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES
(1, 1, '2024-02-04'),  -- Duke Nukem enrolls in Introduction to Computer Science
(1, 2, '2024-02-04'),  -- Duke Nukem enrolls in Chemistry 101
(2, 1, '2024-04-03'),  -- Alex Ample enrolls in Introduction to Computer Science
(3, 3, '2024-07-15'),  -- Noah Scuses enrolls in Meta-Body Anatomy
(4, 2, '2024-07-24');  -- Barry Mealive enrolls in Chemistry 101

-- Bonus: Let's get Ida Student enrolled in a course.
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES
(5, 4, '2024-09-01');

-- Check to see all enrollments.
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
--    QUERYING THE DATABASE            --
----------------------------------------

-- 1. Who's enrolled in "Chemistry 101"? Let's find out!
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

-- 2. Let's see which professors teach which courses.
SELECT
    c.course_name,
    p.first_name || ' ' || p.last_name AS professor_full_name
FROM
    courses c
JOIN
    professors p ON c.professor_id = p.id;

----------------------------------------

-- 3. What courses have students enrolled?
SELECT DISTINCT
    c.course_name
FROM
    courses c
JOIN
    enrollments e ON c.id = e.course_id;

----------------------------------------
--    UPDATING INFORMATION              --
----------------------------------------

-- 1. Let’s look at a specific student by their ID.
SELECT * FROM students WHERE id = 2;

-- You could also look them up by name if you prefer.
-- SELECT * FROM students WHERE first_name = 'Alex' AND last_name = 'Ample';

----------------------------------------

-- 2. Time to update Alex's email.
UPDATE students
SET email = 'Alex.Ample@updatemail.com'
WHERE id = 2;

----------------------------------------

-- 3. Let’s check if the email update worked.
SELECT * FROM students WHERE id = 2;

----------------------------------------
--    DELETING INFORMATION              --
----------------------------------------

-- 1. Let’s confirm the enrollment record for Duke in Chemistry 101.
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

-- 2. Now let's delete Duke's enrollment in Chemistry 101.
DELETE FROM enrollments
WHERE student_id = 1 AND course_id = 2;

----------------------------------------

-- 3. Let’s check to see if Duke's enrollment was successfully deleted.
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

-- And let’s view all the remaining enrollments.
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
