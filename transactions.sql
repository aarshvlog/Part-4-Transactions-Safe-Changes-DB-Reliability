-- =====================================================
-- TRANSACTION SCENARIOS
-- =====================================================

---

## -- Scenario 1: Student submission transaction

START TRANSACTION;

INSERT INTO submissions (
submission_id,
student_id,
problem_id,
score,
status
)
VALUES (
90001,
101,
12,
100,
'Accepted'
);

INSERT INTO test_results (
result_id,
submission_id,
testcase_id,
result_status
)
VALUES (
70001,
90001,
501,
'Passed'
);

COMMIT;

-- Expected Result:
-- Both submission and test result are permanently saved.

---

## -- Scenario 2: Enrollment rollback example

START TRANSACTION;

INSERT INTO enrollments (
enrollment_id,
student_id,
course_id
)
VALUES (
80001,
99999,
12
);

-- Validation fails because student does not exist

ROLLBACK;

-- Expected Result:
-- Enrollment is completely discarded.

---

## -- Scenario 3: SAVEPOINT example

START TRANSACTION;

UPDATE submissions
SET score = 80
WHERE submission_id = 3001;

SAVEPOINT score_updated;

UPDATE submissions
SET status = 'Accepted'
WHERE submission_id = 3001;

-- Later discovered status should not change

ROLLBACK TO score_updated;

COMMIT;

-- Expected Result:
-- Score update remains.
-- Status update is reversed.

---

## -- Scenario 4: Regrade request resolution

START TRANSACTION;

UPDATE regrade_requests
SET status = 'Resolved',
resolved_at = CURRENT_TIMESTAMP
WHERE request_id = 901;

UPDATE submissions
SET score = 95
WHERE submission_id = 4001;

COMMIT;

-- Expected Result:
-- Regrade request and submission score update together.
