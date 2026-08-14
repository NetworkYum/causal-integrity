# Formalizations

Machine-oriented specification of Causal Integrity.

| File | Role |
|---|---|
| [`axioms.md`](axioms.md) | FOL specification (source of truth for intended formal meaning) |
| [`CausalIntegrity.lean`](CausalIntegrity.lean) | Lake library root |
| [`CausalIntegrity/Axioms.lean`](CausalIntegrity/Axioms.lean) | Sorts, predicates, axioms 0–4 & 6, `Consent` def |
| [`CausalIntegrity/Lemmas.lean`](CausalIntegrity/Lemmas.lean) | Ledger lemmas (theft, liability, filter, consent) |
| [`CausalIntegrity/Organism.lean`](CausalIntegrity/Organism.lean) | Shared-goal / Intact / Collapsed (internal self-collapse) |

Build from the **repository root**:

```bash
lake build
```

Runnable organism demo (no Lean required):

```bash
python examples/organism_collapse.py
```

Toolchain: [`../lean-toolchain`](../lean-toolchain). CI: [`.github/workflows/lean.yml`](../.github/workflows/lean.yml).

## Two stories, two artifacts

| Story | What it checks | Artifact |
|-------|----------------|----------|
| **Instrument** (external) | Non-consensual interference / ledger | Axioms + Lemmas + SymPy toys |
| **Organism** (internal) | Shared goal fails → part subverts → collapse | `Organism.lean` + `organism_collapse.py` |

Property remains a **proof instrument**. Shared-goal integrity is the **identity** of a composite agent ([docs/systemic-stability.md](../docs/systemic-stability.md)).

## What is machine-checkable now

| Item | Status |
|---|---|
| Lake package + `lake build` + CI | **Yes** |
| Axioms 0–4, 6 + `Consent` def | **Yes** |
| Ledger lemmas | **Yes** |
| Organism: `Collapsed → ¬ Intact` and `Collapsed → ¬ PursuesSharedGoal` | **Yes** (constructive) |
| Axiom 5 (UPB) | **Scoped out** |
| Forward simulation API | **Open** (S2/S3) |
| `¬ Intact → Collapsed` | **Not claimed** (would need classical logic or a different def) |

See [`../docs/definition-of-done.md`](../docs/definition-of-done.md) and [`../docs/open-problems.md`](../docs/open-problems.md).
