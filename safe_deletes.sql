-- =====================================================
-- SAFE DELETE OPERATIONS
-- =====================================================

CREATE TABLE staging_enrollments AS
SELECT * FROM enrollments;

CREATE TABLE staging_attendance AS
SELECT * FROM attendance;

---

## -- DELETE 1: Remove duplicate enrollments

-- BEFORE

SELECT student_id, course_id, COUNT(*)
FROM staging_enrollments
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

-- DELETE

DELETE FROM staging_enrollments
WHERE enrollment_id NOT IN (
SELECT MIN(enrollment_id)
FROM staging_enrollments
GROUP BY student_id, course_id
);

-- AFTER

SELECT student_id, course_id, COUNT(*)
FROM staging_enrollments
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

-- Safety Note:
-- Earliest enrollment is preserved.
-- Only duplicate copies are removed.

---

## -- DELETE 2: Remove orphan attendance records

-- BEFORE

SELECT a.*
FROM staging_attendance a
LEFT JOIN sessions s
ON a.session_id = s.session_id
WHERE s.session_id IS NULL;

-- DELETE

DELETE FROM staging_attendance
WHERE session_id NOT IN (
SELECT session_id
FROM sessions
);

-- AFTER

SELECT a.*
FROM staging_attendance a
LEFT JOIN sessions s
ON a.session_id = s.session_id
WHERE s.session_id IS NULL;

-- Safety Note:
-- Deletes only attendance rows linked to missing sessions.
