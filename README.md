# CodeJudge Database Transactions and Safe DML – Part 4

## Objective

This project demonstrates safe database modification operations and transaction reliability concepts using the CodeJudge database.

The work focuses on:

* safe UPDATE operations
* safe DELETE operations
* transaction control
* rollback and savepoints
* ACID property reasoning
* database reliability practices

---

# Safety Strategy

The original imported database is never directly modified.

All UPDATE and DELETE operations are performed on:

* staging_students
* staging_submissions
* staging_enrollments
* staging_attendance
* staging_requests

or inside controlled transactions.

This prevents accidental corruption of production data.

---

# Repository Files

| File                | Purpose                                |
| ------------------- | -------------------------------------- |
| safe_updates.sql    | Safe UPDATE examples                   |
| safe_deletes.sql    | Safe DELETE examples                   |
| transactions.sql    | Transaction scenarios                  |
| acid_explanation.md | ACID explanation using own transaction |
| incident_note.md    | Reliability incident documentation     |

---

# Topics Covered

## Safe DML

* validation before modification
* targeted WHERE clauses
* staged correction workflow

## Transactions

* BEGIN TRANSACTION
* COMMIT
* ROLLBACK
* SAVEPOINT

## Reliability

* recovery planning
* accidental update protection
* auditability
* rollback strategy
