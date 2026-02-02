# Record Model (Phase 0 Contract)

This document defines the canonical record types used by DADS.

All records are designed to be:
- human-readable
- machine-parseable (later)
- structurally explicit (no silent assumptions)
- attributable and reviewable under scrutiny

DADS records preserve facts and declared context only. They do not certify correctness or compliance.

---

## Global Record Requirements (All Types)

Every DADS record MUST include:

- Record-Type
- Record-ID
- Created-At (timezone-explicit)
- Created-By (human principal)
- System-Scope (what system/domain this pertains to)

Every record MAY include:
- References (links to external evidence such as tickets, commits, documents)
- Notes (factual clarifications; no retroactive rationalization)

---

## 1) Decision Record

Purpose:
- Preserve a material decision about architecture, security, operations, data, risk, or governance.

Required fields:
- Owner (human principal)
- Approver (human principal or explicit "none" with explanation)
- Decision-Title
- Decision-Statement
- Context
- Options-Considered
- Rationale (human-entered)
- Known-Risks-Accepted (human-entered)
- Unknowns (explicitly stated, may be "none")
- Related-Obligation-IDs (may be empty; absence is recordable)

Optional fields:
- Supersedes-Record-ID
- Effective-At
- Expiration-At (if decision has a review horizon)

---

## 2) Supersession Record

Purpose:
- Preserve append-only evolution without rewriting history.

Required fields:
- Supersedes-Record-ID
- Superseding-Record-ID
- Reason-For-Supersession (human-entered; factual)

Notes:
- Supersession never deletes the prior record.
- The prior record remains true "as of then."

---

## 3) Obligation Declaration Record

Purpose:
- Declare that a legal, regulatory, contractual, or policy obligation applies to a system scope.

Required fields:
- Declared-By (governance authority principal)
- Obligation-Name
- Obligation-Type (legal | regulatory | contract | policy)
- Applies-To-System-Scope
- References (authoritative source pointers if available)

Notes:
- DADS does not interpret law. Applicability is a human declaration.

---

## 4) Derived Notice Record (Obligation Intersection)

Purpose:
- Preserve that a notice condition existed when a decision intersected a declared obligation domain.

Required fields:
- Derived-From-Decision-ID
- Declared-Obligation-IDs
- Intersection-Domain
- Notice-Statement (factual, non-authoritative)
- Non-Authoritative-Disclaimer
- Acknowledgment-Required (yes/no)
- Acknowledged-By (if required)
- Acknowledged-At (if required)

Notes:
- Derived notices do not determine legality or compliance.
- Derived notices do not imply intent or negligence.
- They preserve evidence of awareness conditions, not enforcement.

---

## 5) Risk Acceptance Record

Purpose:
- Preserve explicit acceptance of a known risk with ownership and (optionally) expiration.

Required fields:
- Owner (human principal)
- Approver (human principal or explicit "none" with explanation)
- Risk-Statement
- Scope
- Justification (human-entered)
- Expiration-At (or explicit "none" with explanation)

Notes:
- Risk acceptance is not moral judgment; it is accountability preservation.

---

## Explicit Rule: Silence-As-Record

If a required field is intentionally left empty, the record MUST explicitly state:
- that it is empty
- why it is empty (e.g., "unknown at time of decision")

DADS does not allow silent omissions.
