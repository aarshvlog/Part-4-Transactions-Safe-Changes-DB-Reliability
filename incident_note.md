# Reliability Incident Note

## Incident Summary

A developer accidentally executed the following query on the production CodeJudge database:

```sql
UPDATE submissions
SET status = 'Accepted';
```

The query was executed without a WHERE clause.

---

# What Went Wrong

The missing WHERE condition caused every submission record in the database to be updated.

Submissions with:

* Wrong Answer
* Runtime Error
* Compilation Error
* Time Limit Exceeded

were all incorrectly marked as Accepted.

---

# Data Potentially Affected

Affected tables:

* submissions
* leaderboard calculations
* contest rankings
* plagiarism review workflows
* student performance analytics

The corruption could affect thousands of rows.

---

# Detection Method

The issue could be detected through:

* sudden spike in Accepted submissions
* leaderboard inconsistencies
* audit logs
* transaction logs
* comparison with test_results table

Example validation query:

```sql
SELECT submission_id
FROM submissions s
JOIN test_results tr
ON s.submission_id = tr.submission_id
WHERE s.status = 'Accepted'
AND tr.result_status = 'Failed';
```

---

# Recovery Strategy

## Immediate Action

* stop further writes
* identify transaction timestamp

## Recovery Options

* ROLLBACK if transaction still open
* restore from backup
* replay transaction logs
* recover from staging snapshots

---

# Preventive Measures

## 1. Always Use Transactions

```sql
START TRANSACTION;
```

before mass updates.

---

## 2. Validate with SELECT First

Run:

```sql
SELECT *
FROM submissions
WHERE condition;
```

before UPDATE or DELETE.

---

## 3. Restrict Production Permissions

Junior developers should not have unrestricted UPDATE access.

---

## 4. Require WHERE Clause Reviews

Peer review required for large DML operations.

---

## 5. Use Staging Tables

All bulk corrections should first be tested on staging copies.

---

# Conclusion

This incident highlights why transaction safety, backups, and careful validation are critical in database administration.
