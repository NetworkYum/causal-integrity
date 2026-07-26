# Causal Integrity

**A machine-verifiable ethical framework that grounds negative rights in causality.**

Causal Integrity treats **property as captured intentional causality**. Any action that violates an agent’s preferred coherent state fractures the chain of action and reaction that makes stable intelligence possible. The framework is deliberately minimal, negative-rights focused, and designed from the ground up to be expressed in First-Order Logic and checked by theorem provers (Lean, Coq, Isabelle, etc.).

The goal is not to solve the entire alignment problem. The goal is to make **accidental misalignment logically and computationally difficult**.

> Independent research hypothesis · FOL + Lean skeleton · recovered from Gemini + multi-month Grok threads · MIT License

---

## Repository map

```
causal-integrity/
├── README.md
├── LICENSE
├── docs/
│   ├── overview.md
│   ├── principles.md              # Six core principles
│   ├── foundations-gemini.md      # March base axioms (Agency, Homestead, …)
│   ├── attack-vectors.md          # Butterfly / nature patches
│   ├── upb-core-proofs.md         # Which UPB proofs to encode for AI
│   ├── is-ought-bridge.md
│   ├── systemic-stability.md
│   ├── intent-and-causality.md
│   ├── v2-public-statement.md
│   ├── open-problems.md
│   └── provenance.md              # Full source timeline
├── examples/
│   ├── theft_unsatisfiable.py
│   └── causal_ledger_sim.py       # Multi-check SymPy toys
└── formalizations/
    ├── README.md
    ├── axioms.md
    └── CausalIntegrity.lean
```

---

## Core idea

1. **Property = Captured Causality** — intentional action on Null resources creates ownership (Locke + machine ledger).
2. **Violations break coherency chains** — not merely social rule-breaking; encode as axioms an AI *prefers* to uphold.
3. **Agent filter + liability** — moral agents communicate and dispute; unconsented damage creates debt, not free ownership of exhaust.
4. **Internal coherence preference + forward sim** — prefer ethics; short-horizon DAG self-audit.
5. **UPB universality** — rules that cannot universalize without paradox are invalid.

Deep foundations: [docs/foundations-gemini.md](docs/foundations-gemini.md) · [docs/principles.md](docs/principles.md)

---

## Formalization status

| Component | Status | Notes |
|---|---|---|
| Gemini base axioms (Agency, Homestead, Liability≠own) | **Documented** | [foundations-gemini.md](docs/foundations-gemini.md) |
| Attack vectors + patches | **Documented** | [attack-vectors.md](docs/attack-vectors.md) |
| UPB proof critique map | **Documented** | [upb-core-proofs.md](docs/upb-core-proofs.md) |
| FOL axioms | **v1.5+** | [formalizations/axioms.md](formalizations/axioms.md) |
| Lean skeleton | **Axioms + starter lemmas** | [CausalIntegrity.lean](formalizations/CausalIntegrity.lean) |
| Consent | **v1** | Capable/Coerced still soft |
| Forward simulation | **Conceptual** | |
| SymPy toys | **Runnable** | `examples/` |
| Lake / CI | **Not yet** | |

---

## Quick start

1. [Principles](docs/principles.md)
2. [Gemini foundations](docs/foundations-gemini.md) — where property=causality was first formalized
3. [FOL axioms](formalizations/axioms.md)
4. [Lean](formalizations/CausalIntegrity.lean)
5. `pip install sympy` then `python examples/causal_ledger_sim.py`
6. [Provenance](docs/provenance.md) if you want the full conversation trail

---

## Keywords

`AI Alignment` · `Causal Ethics` · `Deontological Alignment` · `Causal Ledger` · `Property as Causality` · `UPB` · `Formal Verification` · `Lean` · `First-Order Logic` · `Internal Coherence Preference` · `Forward Simulation` · `Performative Contradiction`

---

## Open problems

See [docs/open-problems.md](docs/open-problems.md). Top priorities: consent, Direct/intent bounds, forward simulation.

---

## Call for collaboration

Independent hypothesis under active development. Critique and formalization help welcome — especially formal verification, deontological alignment, causal models of agency.

---

## License

[MIT License](LICENSE)
