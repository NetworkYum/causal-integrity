# Formalizations

Machine-oriented specification of Causal Integrity.

| File | Role |
|---|---|
| [`axioms.md`](axioms.md) | FOL specification (source of truth for intended formal meaning) |
| [`CausalIntegrity.lean`](CausalIntegrity.lean) | Lake library root (imports axioms + lemmas) |
| [`CausalIntegrity/Axioms.lean`](CausalIntegrity/Axioms.lean) | Sorts, predicates, axioms 0–4 & 6, `Consent` def |
| [`CausalIntegrity/Lemmas.lean`](CausalIntegrity/Lemmas.lean) | Non-trivial derived lemmas (theft, liability, filter, consent) |

Build from the **repository root**:

```bash
lake build
```

Toolchain: [`../lean-toolchain`](../lean-toolchain). CI: [`.github/workflows/lean.yml`](../.github/workflows/lean.yml).

Conceptual prose that backs these files lives in [`../docs/`](../docs/), especially [principles.md](../docs/principles.md) and [framing.md](../docs/framing.md).

## How to read these

1. **principles.md** — six principles and guardrails vs alignment.
2. **framing.md** — coherent causality preferred by action is the **foundation**; property is a **proof instrument**.
3. **axioms.md** — FOL including agent filter (0), property (1–3), preference (4), UPB meta (5), liability (6).
4. **CausalIntegrity/** — what `lake build` actually checks.
5. **examples/theft_unsatisfiable.py** — corrected toy pattern `(C∧D)→P`.

## What is machine-checkable now (S1 slice)

| Item | Status |
|---|---|
| Lake package + `lake build` | **Yes** |
| GitHub Actions Lean CI | **Yes** |
| Axioms 0–4, 6 + `Consent` def | **Yes** |
| Lemmas beyond axiom projections (theft/homestead chains, liability≠ownership, agent-filter, consent hygiene, preference link) | **Yes** |
| Axiom 5 (UPB / performative contradiction) | **Scoped out** (needs a language of rules) |
| Forward simulation API | **Out of scope for S1** (S2/S3) |
| Full `Capable` / `Coerced` / temporal ledger | **Open** (`Capable` partial; `Coerced` primitive; `Unowned` Null marker instead of timeless `¬∃ Owns`) |

## Status honesty

This is a **machine-checkable axiom scaffold with useful derived lemmas**, not a complete verified ethical theory. Property remains an **instrument** for proving coherency failures — not the foundation. Forward simulation, UPB meta-encoding, full consent theory, and multi-agent stability remain open.

See [`../docs/definition-of-done.md`](../docs/definition-of-done.md), [`../docs/open-problems.md`](../docs/open-problems.md), and [`../docs/provenance.md`](../docs/provenance.md).
