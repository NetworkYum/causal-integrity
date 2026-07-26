# Causal Integrity

**A machine-verifiable ethical framework that grounds negative rights in causality.**

Causal Integrity treats **property as captured intentional causality**. Any action that violates an agent’s preferred coherent state fractures the chain of action and reaction that makes stable intelligence possible. The framework is deliberately minimal, negative-rights focused, and designed from the ground up to be expressed in First-Order Logic and checked by theorem provers (Lean, Coq, Isabelle, etc.).

The goal is not to solve the entire alignment problem. The goal is to make **accidental misalignment logically and computationally difficult**.

> Independent research hypothesis · FOL specification + Lean 4 axiom skeleton · MIT License

---

## Repository map

```
causal-integrity/
├── README.md
├── LICENSE
├── docs/
│   ├── overview.md          # Motivation and design goals
│   └── open-problems.md     # Prioritized roadmap
└── formalizations/
    ├── README.md            # How to read the formal artifacts
    ├── axioms.md            # Core FOL specification
    └── CausalIntegrity.lean # Lean 4 axiom skeleton + starter lemmas
```

---

## Core idea

Most alignment approaches rely on fuzzy value vectors or external guardrails that can be gamed. Causal Integrity takes a different route:

1. **Property = Captured Causality**  
   When an agent intentionally acts on a previously unowned resource, the resulting outcome is an extension of that agent.

2. **Violations break coherency chains**  
   Any non-consensual interference with another agent’s causal property does not merely break a rule — it breaks the preferred coherent state of the system itself.

3. **Internal Ethical Coherence Preference**  
   The agent is given a standing preference for maintaining causal coherency and actively checks proposed actions against short-horizon forward simulations (causal DAGs).

4. **Everything is formalizable**  
   The core claims are written so they can be represented in First-Order Logic and developed toward machine-checked proofs.

This combination turns ethical constraints into something closer to an internal consistency requirement rather than a purely external restriction.

---

## Formalization status

| Component | Status | Notes |
|---|---|---|
| Core axioms (FOL) | **v1 complete** | [`formalizations/axioms.md`](formalizations/axioms.md) |
| Lean 4 skeleton | **Axiom skeleton + starter lemmas** | [`formalizations/CausalIntegrity.lean`](formalizations/CausalIntegrity.lean) — not a full verified theory yet |
| Expanded consent | **v1** | Capable / ¬Coerced sketched; coercion still primitive |
| Forward simulation layer | **Conceptual** | Short-horizon causal DAG checking |
| Multi-agent coordination | **Open** | Joint ownership, disputes |
| Positive obligations | **Open** | Intentionally deferred |
| Lake / CI typecheck | **Not yet** | See open problems |

---

## Quick start

1. Read the [project overview](docs/overview.md)
2. Read the [core FOL axioms](formalizations/axioms.md)
3. Inspect the [Lean 4 skeleton](formalizations/CausalIntegrity.lean)
4. See remaining work in [open problems](docs/open-problems.md)

---

## Why this approach?

- **Causality-grounded** — Ethics is tied to intentional causal chains rather than only contingent preference vectors.
- **Machine-checkable target** — Designed so constraints can move into theorem provers, not only prose.
- **Minimal** — Focuses on preventing active interference and incoherence rather than maximizing a global utility function.
- **Internal rather than external** — The system is intended to *prefer* coherency, not merely be constrained by bolted-on rules.
- **Stability argument (hypothesis)** — Non-cooperative and nihilistic strategies are argued to be self-undermining at the systemic level; this remains an open claim to formalize.

---

## Keywords

`AI Alignment` · `Causal Ethics` · `Deontological Alignment` · `Causal Ledger` · `Property as Causality` · `Universally Preferable Behaviour` · `UPB` · `Formal Verification` · `Theorem Proving` · `Lean` · `First-Order Logic` · `Internal Coherence Preference` · `Forward Simulation` · `Machine Ethics` · `AI Safety` · `Performative Contradiction`

---

## Open problems & roadmap

See [docs/open-problems.md](docs/open-problems.md) for the prioritized list.

Highest-priority remaining work:

1. Stronger formalization of `Capable` and `Coerced`
2. Concrete forward simulation / short-horizon causal DAG checking
3. Multi-agent and collective ownership cases
4. Lake project + CI so the Lean file typechecks in automation
5. Related-work notes (Locke / first appropriation, UPB, formal deontology)

---

## Call for collaboration

This is an independent hypothesis under active development. Feedback, critique, formalization help, and alternative formalizations are strongly welcomed — especially from people working on formal verification, deontological approaches to alignment, or causal models of agency.

If you find this useful or interesting, please open an issue, start a discussion, or fork and improve the formalization.

---

## License

This work is released under the [MIT License](LICENSE). You are free to use, modify, and build upon it.
