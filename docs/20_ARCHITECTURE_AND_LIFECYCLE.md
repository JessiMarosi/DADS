# Architecture & Lifecycle (Phase 2)

This document describes how DADS operates conceptually within an organization.
It is descriptive, not prescriptive.
No implementation, enforcement, or automation is implied.

---

## 1. Operating Model Overview

DADS functions as institutional memory infrastructure, not an operational system.

It:
- records decisions and acknowledgments
- preserves rationale and accountability
- surfaces advisory notices when declared obligations intersect decisions
- remains read-only once records are committed

DADS does not:
- block actions
- approve changes
- determine correctness or legality
- intervene in operations

---

## 2. Separation of Roles (Conceptual)

### Authors
Create decision, risk, and supersession records with human-entered rationale.

### Approvers
Explicitly approve decisions or risk acceptance; accountability is recorded, not inferred.

### Governance Authority
Declares obligations and maps obligation sets to system scopes.

### Reviewers / Auditors
Read-only inspection of records, lineage, and notices.

---

## 3. Record Ingestion Lifecycle

1) Human creates a record using an approved template.
2) Record is committed to the repository (append-only posture).
3) Once committed, record is immutable.
4) Corrections require new records with supersession/clarification.
5) History is never rewritten.

---

## 4. Derived Notices (Advisory Overlay)

Derived notices are an overlay, not a gate.

Principle:
DADS records that a warning condition existed and that a human proceeded.

DADS does not:
- stop the decision
- coach the decision-maker
- determine compliance

---

## 5. Validation vs Enforcement Boundary

Validation is structural and deterministic.
Enforcement is human and external to DADS.

---

## 6. Storage & Survivability Model (Conceptual)

DADS records must be append-only, durable, readable without proprietary tooling,
and resilient to leadership or vendor change.

Technology choices are intentionally deferred.

---

## 7. Court & Audit Posture

DADS supports forensic reconstruction and scrutiny via timestamps, authorship,
acknowledgment, preserved unknowns, and non-rewritten history.

DADS does not assert correctness, legality, or intent beyond what is recorded.

---

## 8. Resume-Safe Requirement (Reaffirmed)

DADS records must be sufficient for a qualified successor to resume stewardship
without oral history.

---

## 9. Phase 2 Boundary

This phase defines roles, lifecycle, and boundaries.
It does not define UI, APIs, databases, or deployment architecture.
