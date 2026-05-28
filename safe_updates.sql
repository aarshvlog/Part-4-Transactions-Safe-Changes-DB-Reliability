-- =====================================================
-- SAFE UPDATE OPERATIONS
-- =====================================================

-- Create staging copy

CREATE TABLE staging_students AS
SELECT * FROM students;

CREATE TABLE staging_submissions AS
SELECT * FROM submissions;

---

## -- UPDATE 1: Correct invalid email values

-- BEFORE

SELECT student_id, email
FROM staging_students
WHERE email NOT LIKE '%@%.%';

-- UPDATE

UPDATE staging_students
SET email = CONCAT(student_id, '@codejudge.com')
WHERE email NOT LIKE '%@%.%';

-- AFTER

SELECT student_id, email
FROM staging_students
WHERE student_id IN (
SELECT student_id
FROM staging_students
WHERE email LIKE '%@codejudge.com'
);

-- Safety Note:
-- WHERE clause updates only clearly invalid emails.

---

## -- UPDATE 2: Fix missing batch values

-- BEFORE

SELECT *
FROM staging_students
WHERE batch_id IS NULL;

-- UPDATE

UPDATE staging_students
SET batch_id = 1
WHERE batch_id IS NULL;

-- AFTER

SELECT *
FROM staging_students
WHERE batch_id = 1;

-- Safety Note:
-- Only NULL batch assignments are updated.

---

## -- UPDATE 3: Correct negative scores

-- BEFORE

SELECT submission_id, score
FROM staging_submissions
WHERE score < 0;

-- UPDATE

UPDATE staging_submissions
SET score = 0
WHERE score < 0;

-- AFTER

SELECT submission_id, score
FROM staging_submissions
WHERE score = 0;

-- Safety Note:
-- WHERE clause prevents modification of valid scores.

---

## -- UPDATE 4: Fix submission status using test results

-- BEFORE

SELECT submission_id, status
FROM staging_submissions
WHERE submission_id = 5001;

-- UPDATE

UPDATE staging_submissions
SET status = 'Accepted'
WHERE submission_id = 5001
AND score = 100;

-- AFTER

SELECT submission_id, status
FROM staging_submissions
WHERE submission_id = 5001;

-- Safety Note:
-- Query targets one verified submission only.
