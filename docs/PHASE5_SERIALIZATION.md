# DADS Phase 5  Record Serialization Format

## Format
- Records are stored as JSON files.
- One record per file.
- File extension: .json
- Encoding: UTF-8

## Placement
records/<TYPE>/<record_id>.json

## Constraints (Structural, Not Interpretive)
- Every record MUST include: record_id, record_type, created_utc, actors
- Records MUST be immutable in meaning; corrections occur via supersession records.

## Notes
- JSON field order is not semantically meaningful.
- Validator treats required fields as presence checks only.
