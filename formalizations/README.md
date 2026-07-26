# Formalizations

This folder holds the machine-oriented specification of Causal Integrity.

| File | Role |
|---|---|
| [`axioms.md`](axioms.md) | Human-readable First-Order Logic specification (source of truth for prose + FOL) |
| [`CausalIntegrity.lean`](CausalIntegrity.lean) | Lean 4 encoding: sorts, predicates, core axioms, consent `def`, starter lemmas |

## How to read these

1. Start with **axioms.md** for the intended meanings of predicates and the five core claims (including the UPB meta-axiom).
2. Open **CausalIntegrity.lean** for the executable skeleton.  
   - Core ownership / coherency axioms are encoded as Lean `axiom`s.  
   - `Consent` is a `def` matching the FOL expansion.  
   - `Coerced` remains a **primitive** until a stronger theory lands.  
   - Starter lemmas show that Axiom 3 has immediate, checkable consequences.

## Status honesty

This is **not** yet a complete verified ethical theory. It is an axiom scaffold plus a few derived lemmas. Next structural steps:

- Lake package so `lake build` typechecks CI
- Stronger `Capable` / `Coerced`
- Non-trivial theorems connecting preference, prediction, and action choice
- Forward-simulation / causal DAG layer

See [`../docs/open-problems.md`](../docs/open-problems.md).
