# ACID Properties Explanation

## Example Transaction

The following transaction is used:

```sql
START TRANSACTION;

UPDATE submissions
SET score = 80
WHERE submission_id = 3001;

SAVEPOINT score_updated;

UPDATE submissions
SET status = 'Accepted'
WHERE submission_id = 3001;

ROLLBACK TO score_updated;

COMMIT;
```

---

# 1. Atomicity

Atomicity ensures that a transaction behaves as a single unit.

In this example:

* either all approved operations succeed
* or failed operations are rolled back

The incorrect status update was rolled back without affecting the valid score update.

---

# 2. Consistency

Consistency ensures database rules remain valid.

The transaction:

* preserved valid submission status rules
* prevented inconsistent grading data

Foreign keys and CHECK constraints remain satisfied.

---

# 3. Isolation

Isolation prevents simultaneous transactions from interfering with each other.

While this transaction runs:

* other users should not see partially modified data
* they either see old committed data or final committed data

This avoids inconsistent reads.

---

# 4. Durability

Durability guarantees committed data survives system failure.

After COMMIT:

* updated score remains permanently stored
* rollback changes are not preserved

Even after crash/restart, committed data should persist.

---

# Conclusion

This transaction demonstrates safe partial rollback using SAVEPOINT while maintaining ACID guarantees.
