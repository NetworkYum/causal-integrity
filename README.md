# Causal Integrity

**A machine-verifiable ethical framework that grounds negative rights in causality.**

Causal Integrity treats **property as captured intentional causality**. Any action that violates an agent’s preferred coherent state fractures the chain of action and reaction that makes stable intelligence possible. The framework is deliberately minimal, negative-rights focused, and designed from the ground up to be expressed in First-Order Logic and checked by theorem provers (Lean, Coq, Isabelle, etc.).

The goal is not to solve the entire alignment problem. The goal is to make **accidental misalignment logically and computationally difficult**.

> Independent research hypothesis · FOL + Lean skeleton · mined from long formalization thread · MIT License

---

## Repository map

```
causal-integrity/
├── README.md
├── LICENSE
├── docs/
│   ├── overview.md              # Motivation and design goals
│   ├── principles.md            # Six core principles (v1.5 / V2)
│   ├── is-ought-bridge.md       # Practical is/ought bridge
│   ├── systemic-stability.md    # Cooperation / nihilism arguments
│   ├── intent-and-causality.md  # Gray zones, poison example, intent
│   ├── v2-public-statement.md   # Polished public pitch
│   ├── open-problems.md         # Prioritized roadmap
│   └── provenance.md            # Where material came from / translation loss
├── examples/
│   └── theft_unsatisfiable.py   # Corrected SymPy toy check
└── formalizations/
    ├── README.md
    ├── axioms.md                # FOL specification
    └── CausalIntegrity.lean    # Lean 4 skeleton + starter lemmas
```

---

## Core idea

Most alignment approaches rely on fuzzy value vectors or external guardrails that can be gamed. Causal Integrity takes a different route:

1. **Property = Captured Causality**  
   When an agent intentionally acts on a previously unowned resource, the resulting outcome is an extension of that agent.

2. **Violations break coherency chains**  
   The point is not theft discourse per se — any action that violates preferred coherent states breaks action/reaction coherency. Such violations can be encoded as absolute axioms an AI would *prefer* to uphold.

3. **Internal Ethical Coherence Preference**  
   The agent prefers ethical coherency and checks proposed actions against short-horizon forward simulations (causal DAGs).

4. **Agent filter + liability**  
   Moral agents communicate and can dispute; unconsented damage creates restitution debt.

5. **Formalizable**  
   Core claims target First-Order Logic and theorem provers — not only prose.

Start with [docs/principles.md](docs/principles.md) for the full six-principle layout.

---

## Formalization status

| Component | Status | Notes |
|---|---|---|
| Principles / public V2 | **Restored** | [`docs/principles.md`](docs/principles.md), [`docs/v2-public-statement.md`](docs/v2-public-statement.md) |
| Core axioms (FOL) | **v1.5** | Agent filter + liability added — [`formalizations/axioms.md`](formalizations/axioms.md) |
| Lean 4 skeleton | **Axioms + starter lemmas** | [`formalizations/CausalIntegrity.lean`](formalizations/CausalIntegrity.lean) |
| Expanded consent | **v1** | Capable / ¬Coerced sketched; coercion still primitive |
| Intent / incidental causality | **Prose + open math** | [`docs/intent-and-causality.md`](docs/intent-and-causality.md) |
| Forward simulation layer | **Conceptual** | DAG self-audit sketch |
| Toy satisfiability check | **Runnable** | [`examples/theft_unsatisfiable.py`](examples/theft_unsatisfiable.py) (fixed) |
| Multi-agent / stability proofs | **Open** | Arguments in docs; not theorems yet |
| Lake / CI typecheck | **Not yet** | See open problems |

---

## Quick start

1. [Principles](docs/principles.md) — conceptual core
2. [V2 public statement](docs/v2-public-statement.md) — short pitch
3. [FOL axioms](formalizations/axioms.md) — formal spec
4. [Lean skeleton](formalizations/CausalIntegrity.lean) — machine encoding
5. [Open problems](docs/open-problems.md) — roadmap
6. Optional: `pip install sympy` then `python examples/theft_unsatisfiable.py`

---

## Why this approach?

- **Causality-grounded** — Ethics tied to intentional causal chains rather than only contingent preference vectors.
- **Machine-checkable target** — Constraints can move into theorem provers, not only prose.
- **Minimal** — Active interference and incoherence first; global utility maximization deferred.
- **Internal rather than external** — Prefer coherency; do not only bolt on rules.
- **Stability arguments (hypothesis)** — Non-cooperation and nihilism argued as self-undermining; see [systemic-stability.md](docs/systemic-stability.md).

---

## Keywords

`AI Alignment` · `Causal Ethics` · `Deontological Alignment` · `Causal Ledger` · `Property as Causality` · `Universally Preferable Behaviour` · `UPB` · `Formal Verification` · `Theorem Proving` · `Lean` · `First-Order Logic` · `Internal Coherence Preference` · `Forward Simulation` · `Machine Ethics` · `AI Safety` · `Performative Contradiction`

---

## Open problems & roadmap

See [docs/open-problems.md](docs/open-problems.md).

Highest priority:

1. Stronger `Capable` / `Coerced` (consent)
2. Intent + causal contribution thresholds (gray zones)
3. Concrete forward-simulation DAG procedure
4. Multi-agent stability formalization
5. Lake project + CI

If you have older chat exports with longer FOL/Lean blocks that never landed here, see [docs/provenance.md](docs/provenance.md).

---

## Call for collaboration

This is an independent hypothesis under active development. Feedback, critique, formalization help, and alternative formalizations are strongly welcomed — especially from people working on formal verification, deontological approaches to alignment, or causal models of agency.

Open an issue, start a discussion, or fork and improve the formalization.

---

## License

This work is released under the [MIT License](LICENSE).
