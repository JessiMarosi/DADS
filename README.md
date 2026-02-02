# Decision Accountability Documentation System (DADS)

**Status:** Frozen at Phase 6 (scrutiny-ready)

**Reference tag:** `v6.0-overlay`

---

## What DADS Is

The **Decision Accountability Documentation System (DADS)** is governance-grade documentation infrastructure designed to preserve **institutional truth**.

DADS exists to make system decisions, rationale, known risks, and human accountability **durable across time, personnel change, audits, litigation, and scrutiny**  without enforcing behavior, rewriting history, or automating judgment.

DADS answers, credibly and immutably:
- Why does this system exist the way it does?
- Who made or approved this decision?
- What risks were knowingly accepted, and by whom?
- What was known at the time the decision was made?

---

## What DADS Is Not

DADS does **not**:
- Prevent cyberattacks
- Enforce compliance
- Certify correctness or legality
- Monitor people or productivity
- Generate or fabricate rationale
- Rewrite or delete history
- Act as a black-box authority
- Use AI for interpretation, judgment, or record generation

**Critical boundary:** DADS does not certify correctness  only accountability and truthfulness of record.

---

## Core Governance Rule

**Append-Only Truth Rule**
- Records are never edited to change meaning
- Corrections require new records with explicit supersession
- Original records remain visible permanently

---

## How to Scrutinize DADS (Zero Trust Review)

DADS includes a program overlay that supports:
- validate
- bundle (offline scrutiny package)
- verify (hash + re-validation)

See:
- `docs/EXTERNAL_SCRUTINY_GUIDE.md` (canonical review protocol)
- `overlay/dads.ps1` (executable overlay)

---

## Phase Model (Authoritative)

- **Phase 0  Foundation** (Complete, Locked)
- **Phase 1  Validation Rules** (Complete, Locked)
- **Phase 1.5  Minimal Validator** (Complete, Locked)
- **Phase 2  Architecture & Lifecycle** (Complete, Locked)
- **Phase 2.1  Threat Model** (Complete, Locked)
- **Phase 2.2  Failure Modes & Misuse Analysis** (Complete, Locked)
- **Phase 3  Scope/Taxonomy/Validator Proposals** (Locked)
- **Phase 4  Enactment Planning** (Complete)
- **Phase 5  Minimal Enactment (MVE)** (Complete)
- **Phase 6  Program Overlay** (Complete; tag `v6.0-overlay`)

Phases beyond 6 are not started as build work.

---

## One-Sentence Essence

**DADS preserves institutional truth by making system decisions, rationale, and human accountability durable across time, people, and scrutiny.**
