# Validation Rules (Phase 1)

These rules define what it means for DADS records to be structurally valid.
They do not evaluate correctness of decisions or legal compliance.

---

## A. File & Encoding Rules

1) All record files MUST be UTF-8 text.
2) Line endings MUST be LF (repo policy).
3) Records MUST be stored under an approved directory (examples/, records/, etc.).

---

## B. Global Record Rules (All Types)

Each record MUST include the following keys with non-empty values unless explicitly permitted:
- Record-Type
- Record-ID
- Created-At (timezone-explicit ISO 8601)
- Created-By
- System-Scope

Silence-as-record rule:
- If a required field is intentionally unknown, it MUST be explicitly stated as 'unknown' with a reason.

---

## C. Timestamp Rules

1) Created-At MUST include timezone offset (e.g., -05:00 or Z).
2) Created-At MUST be parseable ISO 8601.
3) A record MUST NOT claim a Created-At earlier than its repository first introduction without an explicit explanation record (future: attestation).

---

## D. Record-ID Rules

1) Record-ID MUST be unique within the repository record corpus.
2) Record-ID MUST match a deterministic naming convention (Phase 1 proposal):
   - lowercase
   - letters, digits, underscore only
   - no spaces
   - examples: decision_0001, obligation_decl_0001

---

## E. Type-Specific Required Fields

### Decision Record (Record-Type: decision)
Required:
- Owner
- Approver (or 'none' with explanation)
- Decision-Title
- Decision-Statement
- Context
- Options-Considered
- Rationale
- Known-Risks-Accepted
- Unknowns
- Related-Obligation-IDs (may be empty; emptiness is recordable)

### Supersession Record (Record-Type: supersession)
Required:
- Supersedes-Record-ID
- Superseding-Record-ID
- Reason-For-Supersession

### Obligation Declaration (Record-Type: obligation_declaration)
Required:
- Declared-By
- Obligation-Name
- Obligation-Type
- Applies-To-System-Scope

### Derived Notice (Record-Type: derived_notice)
Required:
- Derived-From-Decision-ID
- Declared-Obligation-IDs
- Intersection-Domain
- Notice-Statement
- Non-Authoritative-Disclaimer
- Acknowledgment-Required
If Acknowledgment-Required is yes:
- Acknowledged-By
- Acknowledged-At

### Risk Acceptance (Record-Type: risk_acceptance)
Required:
- Owner
- Approver (or 'none' with explanation)
- Risk-Statement
- Scope
- Justification
- Expiration-At (or 'none' with explanation)

---

## F. Referential Integrity Rules

1) Any referenced Record-ID MUST exist in the record corpus.
   Examples:
   - Derived-From-Decision-ID must point to a Decision Record.
   - Declared-Obligation-IDs must point to Obligation Declaration records.
   - Supersedes-Record-ID must point to an earlier record.

2) Supersession MUST NOT create cycles.

---

## G. Append-Only Truth Rules (Conceptual, Enforced Later)

1) A record must never be edited in a way that changes meaning without a supersession record.
2) Corrections are captured as new records that supersede or clarify, never by rewriting history.

---

## H. Validation Output Expectations (Future)

A validator SHOULD produce:
- PASS/FAIL
- list of rule violations by file
- deterministic output for CI suitability
