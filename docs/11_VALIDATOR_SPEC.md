# Validator Spec (Phase 1.5)

This validator enforces structural validity only.
It does not determine correctness, intent, legality, or compliance.

Scope (Phase 1.5 initial):
- Validate records under examples/**

Rules enforced (initial):
- Required global keys exist
- Created-At is timezone-explicit ISO 8601 (basic parseability)
- Record-ID is present and matches allowed pattern
- Record-Type is present and is one of the known types
- Simple referential integrity for known pointer fields (if present)

Output:
- Deterministic PASS/FAIL
- Sorted violations list
- Exit code 0 on PASS, 1 on FAIL

Read-only guarantee:
- Validator never modifies files.
