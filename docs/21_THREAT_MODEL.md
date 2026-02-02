# Threat Model (Phase 2.1)

This document identifies potential threats, misuse scenarios, and failure modes
relevant to DADS as institutional truth infrastructure.

This is a conceptual threat model.
It does not prescribe controls, enforcement, or mitigations beyond documentation.

---

## 1. Threat Modeling Scope

This threat model considers risks arising from:

- organizational pressure
- legal and political incentives
- misuse or misunderstanding of records
- selective disclosure
- abandonment or neglect
- adversarial interpretation during disputes

It explicitly excludes:
- cyberattack prevention
- intrusion detection
- runtime system security

---

## 2. Core Threat Categories

### A. Authority Capture

**Threat**
DADS is pressured to function as an authority:
- certifying correctness
- determining legality
- approving decisions

**Risk**
Loss of neutrality; increased legal exposure.

**Design Posture**
DADS refuses authority.
It records accountability only.

---

### B. Retrospective Narrative Rewriting

**Threat**
Actors attempt to:
- edit records post-incident
- delete embarrassing decisions
- obscure responsibility after failure

**Risk**
Institutional memory corruption.

**Design Posture**
Append-only records.
Supersession required for any change.
Original records remain visible.

---

### C. Compliance Theater Misuse

**Threat**
DADS is used to imply compliance without substance:
- We recorded it, therefore it was compliant.

**Risk**
False assurance; reputational harm.

**Design Posture**
DADS does not certify compliance.
Advisory notices are non-authoritative.

---

### D. Selective Disclosure

**Threat**
Only favorable records are presented externally.

**Risk**
Misleading narratives in audits or litigation.

**Design Posture**
Lineage and supersession chains remain inspectable.
Absence of records is itself observable.

---

### E. Scapegoating Individuals

**Threat**
Records are used to unfairly assign blame
without context or organizational responsibility.

**Risk**
Chilling effect on documentation.

**Design Posture**
Context, rationale, and approval chains are preserved.
Unknowns are explicitly recorded.

---

### F. Over-Reliance on Automation

**Threat**
Future users treat validators or notices as decision-makers.

**Risk**
False delegation of judgment.

**Design Posture**
Validation is structural only.
Human accountability remains explicit.

---

### G. Neglect and Abandonment

**Threat**
DADS is partially adopted, then ignored.

**Risk**
False sense of institutional memory.

**Design Posture**
Resume-safe requirement.
Gaps remain visible rather than silently failing.

---

## 3. Adversarial Scenarios

### Legal Dispute
Records are subpoenaed and interpreted adversarially.

Posture:
- DADS asserts only what is recorded
- No claims beyond the text
- Unknowns remain unknown

### Leadership Change
New leadership inherits systems without context.

Posture:
- Decisions remain intelligible
- Accountability is explicit
- Oral history is not required

### Public Scrutiny
Records are examined under reputational pressure.

Posture:
- No retroactive cleanup
- No narrative optimization
- Truth preservation over optics

---

## 4. Explicit Non-Goals (Reaffirmed)

DADS does not:
- prevent bad decisions
- ensure legal compliance
- replace governance bodies
- protect organizations from consequences
- provide moral or technical judgment

---

## 5. Threat Model Boundary

This document:
- identifies risks
- records design posture

It does not:
- solve threats
- claim mitigation
- introduce enforcement mechanisms

Those decisions, if ever made, belong to future phases.
