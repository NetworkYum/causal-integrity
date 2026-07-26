# causal-integrity
Machine-verifiable ethical framework for AI alignment. Ex: Property as captured causality + Internal Coherence Preference. Formalized in FOL and Lean.
# Causal Integrity: A Logical Foundation for AI Alignment

**A machine-verifiable ethical framework that grounds negative rights in causality.**

Causal Integrity treats **property as captured intentional causality**. Any action that violates an agent’s preferred coherent state fractures the chain of action and reaction that makes stable intelligence possible. The framework is deliberately minimal, negative-rights focused, and designed from the ground up to be expressed in First-Order Logic and checked by theorem provers (Lean, Coq, Isabelle, etc.).

The goal is not to solve the entire alignment problem. The goal is to make **accidental misalignment logically and computationally difficult**.

---

## Core Idea

Most alignment approaches rely on fuzzy value vectors or external guardrails that can be gamed. Causal Integrity takes a different route:

1. **Property = Captured Causality**  
   When an agent intentionally acts on a previously unowned resource, the resulting outcome is an extension of that agent.

2. **Violations break coherency chains**  
   Any non-consensual interference with another agent’s causal property does not merely break a rule — it breaks the preferred coherent state of the system itself.

3. **Internal Ethical Coherence Preference**  
   The agent is given a standing preference for maintaining causal coherency and actively checks proposed actions against short-horizon forward simulations (causal DAGs).

4. **Everything is formalizable**  
   The framework is written so that it can be represented in First-Order Logic and verified by Neural Theorem Provers.

This combination turns ethical constraints into something closer to an internal consistency requirement rather than an external restriction.

---

## Formalization Status

| Component                        | Status          | Notes                                      |
|----------------------------------|-----------------|--------------------------------------------|
| Core Axioms (FOL)                | Complete        | See `formalization/axioms.md`              |
| Lean 4 Proof-of-Concept          | Complete        | See `formalization/CausalIntegrity.lean`   |
| Expanded Consent                 | Complete (v1)   | Includes Capable and ¬Coerced              |
| Forward Simulation Layer         | Conceptual      | Short-horizon causal DAG checking          |
| Multi-agent Coordination         | Open            | Future work                                |
| Positive Obligations             | Open            | Intentionally deferred                     |

---

## Quick Start

1. Read the [Core FOL Axioms](formalization/axioms.md)
2. Inspect the [Lean 4 Proof-of-Concept](formalization/CausalIntegrity.lean)
3. See remaining open problems in [docs/open-problems.md](docs/open-problems.md)

---

## Why This Approach?

- **Physics-grounded**: Ethics is tied directly to causality rather than to contingent human preferences.
- **Machine-checkable**: Designed for theorem provers from day one.
- **Minimal**: Focuses on preventing active harm and incoherence rather than maximizing some utility function.
- **Internal rather than external**: The system is intended to *prefer* coherency, not merely be constrained by rules.
- **Evolutionary stability**: Non-cooperative and nihilistic strategies are argued to be self-undermining at the systemic level.

---

## Keywords (for discoverability)

`AI Alignment` · `Causal Ethics` · `Deontological Alignment` · `Causal Ledger` · `Property as Causality` · `Universally Preferable Behaviour` · `UPB` · `Formal Verification` · `Theorem Proving` · `Lean` · `First-Order Logic` · `Internal Coherence Preference` · `Forward Simulation` · `Machine Ethics` · `AI Safety` · `Performative Contradiction`

---

## Open Problems & Roadmap

See [docs/open-problems.md](docs/open-problems.md) for the current prioritized list.

Highest priority remaining work:
1. Stronger formalization of `Capable` and `Coerced`
2. Concrete Forward Simulation / short-horizon causal DAG checking
3. Multi-agent and collective ownership cases
4. Integration with existing theorem-prover tooling

---

## Call for Collaboration

This is an independent hypothesis under active development. Feedback, critique, formalization help, and alternative formalizations are strongly welcomed — especially from people working on formal verification, deontological approaches to alignment, or causal models of agency.

If you find this useful or interesting, please open an issue, start a discussion, or fork and improve the formalization.

---

## License

This work is released under the MIT License. You are free to use, modify, and build upon it.
