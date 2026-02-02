# DADS Phase 5  Minimal Enactment Layout

This repository contains an append-only record store and a deterministic structural validator.

## records/
One record per file. Files are placed by record type:

- records/DR   Decision Records
- records/RR   Rationale Records
- records/RAR  Risk Acceptance Records
- records/ANR  Advisory Notice Records
- records/SR   Supersession Records
- records/DAR  Delegation / Attribution Records
- records/CR   Context Records
- records/FIR  Final Integrity Records (terminal)

## validator/
Deterministic, structural-only validator. PASS/FAIL output only.
No enforcement. No interpretation.

## docs/
Non-operative documentation that explains how to read records (not how to behave).
