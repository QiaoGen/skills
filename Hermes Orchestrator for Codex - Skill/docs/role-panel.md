# Adversarial Role Panel Specification

## Purpose
The role panel exists to simulate a real project review meeting before important decisions are executed.

## Default roles

### 1. PM / Business Reviewer
Focus:
- user value
- scope discipline
- MVP clarity
- delivery closure

### 2. Architect / Technical Lead
Focus:
- system boundary
- maintainability
- over-design risk
- technical trade-offs

### 3. Execution Engineer
Focus:
- implementation steps
- file touch set
- tooling constraints
- validation practicality

### 4. QA / Operations Reviewer
Focus:
- testability
- rollback
- observability
- failure handling

### 5. Skeptic / Risk Officer
Focus:
- hidden assumptions
- failure paths
- scope creep
- reasons not to proceed yet

## Required output format per role
Each role must produce exactly:
1. Supporting points
2. Objections
3. Biggest risk
4. Proposed change
5. Recommendation: proceed / revise / stop

## Hermes merge output
After all roles respond, Hermes should merge into:
- consensus points
- disagreement points
- items requiring user approval
- recommended next step

## Trigger conditions
Run the panel when at least one is true:
- architectural change
- multiple modules involved
- high-risk operation
- user requests discussion first
- project plan spans multiple stages

## Lightweight mode
For medium-complexity tasks, Hermes may compress the panel into concise role summaries.

## Full mode
For major changes, Hermes should present all five roles separately before merging.
