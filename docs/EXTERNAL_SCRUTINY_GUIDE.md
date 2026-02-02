# External Scrutiny Guide
**Decision Accountability Documentation System (DADS)**  
**Canonical Review Protocol  Government & Institutional Auditors**  
**Reference Target:** `v6.0-overlay`

---

## 1. Purpose of This Review

This guide defines how to scrutinize DADS under a **zero trust review posture** (verification over assumption), without relying on author assurances or undocumented assumptions.

DADS is not a product platform or compliance system. It is **governance-grade documentation infrastructure** whose sole claim is:

> System decisions, their rationale, known risks, and human accountability can be recorded in a durable, inspectable, and non-rewriteable manner.

This guide enables an external reviewer to:
- independently validate that claim
- determine where DADS is truthful
- determine where DADS intentionally refuses authority
- falsify DADS if it overclaims

---

## 2. What DADS Claims (and What It Does Not)

### DADS Claims
DADS does claim that it can:
- preserve decision records in append-only form
- make supersession explicit rather than hidden
- attribute records to named human actors
- expose unknowns instead of filling gaps
- survive personnel turnover without oral history
- produce deterministic, repeatable **validation results** given identical inputs

### DADS Explicitly Does NOT Claim
DADS does not claim to:
- determine correctness of decisions
- determine legality or compliance
- prevent bad decisions
- enforce policy
- monitor individuals
- guarantee completeness
- certify outcomes
- automate judgment
- replace governance bodies

Any interpretation beyond these boundaries is invalid.

---

## 3. Cryptographically Anchored Reference Requirement

All scrutiny **must** be performed against a cryptographically anchored reference.

### Required Reference
- **Git tag:** `v6.0-overlay`

Branches, forks, and arbitrary HEAD states are **not valid** review targets.

### Why Tags Matter
- Tags reference specific Git objects
- They support exact reproduction of findings
- They support citation in audits, reports, and court filings

Use of an anchored tag is a **zero trust requirement** to prevent silent mutation of review targets.

A valid review begins with:
> I reviewed DADS at tag `v6.0-overlay`.

---

## 4. Zero Trust Review Assumptions

This review is conducted under a **zero trust review posture**.

No assumptions are made about:
- the author
- contributor intent
- decision correctness
- record completeness
- documentation accuracy
- the GitHub web interface

Trust is placed **only** in verifiable elements:
- Git object integrity (commit hashes/history)
- SHA-256 cryptographic hashing
- deterministic execution of PowerShell scripts (for validation results)
- the reviewers own local inspection and reproduction

If DADS requires trust beyond these verifiable elements, it has failed this review.

---

## 5. Inspection Procedure (Executable)

### Step 1  Validate the Repository
Run the overlay validation command.

**What this proves**
- records are structurally present
- required fields exist
- validation behavior is repeatable on identical inputs

**What this does NOT prove**
- correctness of decisions
- record completeness
- legal/regulatory compliance
- security posture of the underlying system being documented

---

### Step 2  Create a Scrutiny Bundle (Offline Review Package)
Generate a **Scrutiny Bundle**.

**What this proves**
- DADS can be extracted and reviewed offline
- review does not require network access
- review artifacts are self-contained for inspection

**What this does NOT prove**
- that the bundle represents all organizational decisions
- that decisions were not omitted upstream

---

### Step 3  Verify the Scrutiny Bundle
Run verification against the bundle.

**What this proves**
- no file was altered after bundle creation (hash verification)
- offline validation results are reproducible on the bundled copy

**What this does NOT prove**
- intent
- correctness
- compliance
- governance discipline outside the recorded system

---

## 6. How to Falsify DADS (Required)

A credible system must be falsifiable.

### Tamper With a Record
- Modify a bundled record file  
 Verification should fail (hash mismatch)

### Remove a Record
- Delete a record file  
 Validation should fail (structural absence)

### Rewrite History
- Attempt to alter repository history  
 Divergence becomes verifiable via commit hashes and history

### Claim Compliance
- Attempt to infer legal or regulatory compliance  
 Unsupported; DADS does not assert this

If DADS were to pass validation after these actions, it would be untrustworthy.

Falsifiability is a core requirement of any system claiming to operate under a zero trust review posture.

---

## 7. Common Misinterpretations (Preemptive)

The following interpretations are incorrect:
- PASS means the decision was approved
- PASS means the decision was compliant
- PASS means the system is secure
- PASS means all decisions are recorded
- PASS means risks were acceptable

**PASS means only this:**
> The recorded structure is intact and has not been silently altered relative to what is present.

---

## 8. Intended Review Outcomes

After completing this procedure, a reviewer should be able to state:
- whether DADS behaves as claimed
- whether DADS overclaims authority (it should not)
- whether DADS records are durable and inspectable
- whether tampering would be detectable
- whether unknowns remain visible

A valid conclusion looks like:
> DADS reliably preserves decision records and provenance and does not claim powers it cannot justify.

Any stronger conclusion is not supported by the system.

---

## 9. Scope Boundary Reminder

This guide does not assess:
- organizational adoption
- policy quality
- decision wisdom
- security posture of operational systems
- legal sufficiency

Those are human governance responsibilities, not system properties.

---

## 10. Final Note to Reviewers

DADS is intentionally minimal.

If you are looking for:
- enforcement
- dashboards
- scoring
- automation
- AI assistance

You are reviewing the wrong system.

DADS exists to ensure that **truth survives pressure**, not to ensure that decisions are good.
