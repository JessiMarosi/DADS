# Phase 0 Alignment Ledger (Authoritative)

This ledger defines the required Phase 0 artifacts for DADS.
If any item in this ledger is missing, renamed, or materially contradicted, Phase 0 is out of alignment.

---

## A. Required Files (Must Exist Exactly)

Top-level:
- README.md
- .gitattributes
- .editorconfig

Docs:
- docs/00_CANONICAL_DEFINITION.md
- docs/01_CONSTITUTION.md
- docs/02_STABILIZED_INVARIANTS.md
- docs/03_EVIDENTIARY_GUARANTEES.md
- docs/04_RECORD_MODEL.md

Templates:
- templates/decision_record.md
- templates/supersession_record.md
- templates/obligation_declaration.md
- templates/derived_notice_record.md
- templates/risk_acceptance_record.md

Examples:
- examples/00_minimal/obligation_decl_0001.md
- examples/00_minimal/decision_0001.md
- examples/00_minimal/notice_0001.md

---

## B. Phase 0 Meaning (Non-Optional)

Phase 0 is complete when:
- Identity is locked (canonical definition + README).
- Constitution is locked (non-negotiables + boundaries).
- Execution discipline is locked (WHY/WHERE/HOW/EXPECT/IF FAILS).
- Evidentiary posture is locked (court posture and responsibility boundary).
- Record model is defined (types + required fields).
- Templates exist (no freestyle record creation).
- A minimal example chain exists (obligation -> decision -> notice).

No implementation commitments are made in Phase 0.

---

## C. Alignment Rules

1) No silent edits:
   - If content must change, it must be committed as an explicit change with a clear commit message.

2) No filename drift:
   - Phase 0 filenames are part of the contract.

3) Constitution and invariants outrank all other documents:
   - If a later doc conflicts, later doc must be corrected or superseded.

4) No compliance claims:
   - DADS does not determine legality/compliance/correctness; it preserves accountability and truthfulness of record.

5) Resume-safe requirement:
   - The repo must remain sufficient for a qualified successor to resume stewardship without oral history.

---

## D. Verification (Manual)

To verify alignment:
- Confirm all required files exist.
- Confirm no document contradicts the constitution, invariants, or evidentiary guarantees.
- Confirm example chain matches record model semantics.

This ledger is authoritative for Phase 0.
