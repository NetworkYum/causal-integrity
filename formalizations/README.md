# Formalizations

Machine-oriented specification of Causal Integrity.

| File | Role |
|---|---|
| [`axioms.md`](axioms.md) | FOL specification (source of truth for intended formal meaning) |
| [`CausalIntegrity.lean`](CausalIntegrity.lean) | Lean 4 encoding: sorts, predicates, axioms, consent `def`, starter lemmas |

Conceptual prose that backs these files lives in [`../docs/`](../docs/), especially [principles.md](../docs/principles.md).

## How to read these

1. **principles.md** — six principles and guardrails vs alignment.
2. **axioms.md** — FOL including agent filter (0), property (1–3), preference (4), UPB meta (5), liability (6).
3. **CausalIntegrity.lean** — what is currently sketched in Lean.
4. **examples/theft_unsatisfiable.py** — corrected toy pattern `(C∧D)→P`.

## Status honesty

This is an **axiom scaffold plus a few derived lemmas**, not a complete verified ethical theory. Forward simulation, full consent theory, and multi-agent stability are still open.

See [`../docs/open-problems.md`](../docs/open-problems.md) and [`../docs/provenance.md`](../docs/provenance.md).
