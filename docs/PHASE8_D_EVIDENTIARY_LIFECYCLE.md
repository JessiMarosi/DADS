# Phase 8-D  Evidentiary Lifecycle Beyond GitHub
**Decision Accountability Documentation System (DADS)**  
**Status:** Draft (Planning Only)

## 1. Goal
Define how DADS evidence survives:
- audits
- investigations
- litigation
- FOIA
- air-gapped review
- long-term retention

## 2. Evidence Objects

**Primary:** DADS Scrutiny Bundle  
Contains records, validator, overlay, docs, hashes, metadata.

**Secondary:** Git tags/commits  
Provide reproducibility anchors, not dependency.

## 3. Lifecycle Stages
A. Record creation  
B. Internal review  
C. Bundling  
D. Transfer & custody  
E. Adversarial scrutiny  
F. Long-term retention  
G. Legal production  

At each stage, verification is **integrity-only**.

## 4. Offline / Air-Gapped Review
Bundles are self-contained and verifiable without network access.

Limitation:
> Completeness cannot be proven  only integrity.

## 5. Court Posture
DADS can prove:
- records existed in this form
- hashes match
- structure is valid

DADS cannot prove:
- truthfulness
- legality
- compliance
- intent

## 6. Failure Containment
Acceptable:
- tooling obsolescence
- repo disappearance

Unacceptable:
- interpretive validators
- certified bundles
- official registries

## 7. Conclusion
The scrutiny bundle is the durable evidence unit.  
GitHub is a convenience, not a dependency.
