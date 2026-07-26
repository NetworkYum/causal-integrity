# Overview of Causal Integrity

## Motivation

Current approaches to AI alignment often rely on:

- Soft value loading (RLHF, Constitutional AI, etc.)
- External guardrails that can be circumvented
- Complex utility functions that are difficult to specify and verify

Causal Integrity takes a different route. It attempts to ground a minimal negative-rights ethics in something closer to physics: **causality itself**.

## Core claim

When an agent intentionally acts on a previously unowned resource, the resulting outcome becomes an extension of that agent (**property as captured causality**).

Any subsequent non-consensual interference with that causal link does not merely violate a social rule — it fractures the preferred coherent state of the system itself. Because intelligent systems depend on stable causal chains to maintain their own existence and goals, such fractures are candidates for hard, machine-checkable constraints.

## Key components

1. **Property = Captured Causality**  
   Ownership is the direct result of intentional causal action on an unowned resource.

2. **Performative / Coherency Contradiction**  
   Denying the framework in a way that denies causality or systematically prefers incoherence is argued to undermine the agent’s own status as a coherent intelligence. (Meta / UPB layer — still informal in Lean.)

3. **Internal Ethical Coherence Preference**  
   The agent is given a standing preference for maintaining causal coherency and (eventually) uses short-horizon forward simulation to check actions before taking them.

4. **Explicit Causal Consent**  
   Consent is formalized as an explicit, revocable permission transfer created by a Capable agent who was not Coerced.

## Design goals

- Machine-verifiable target (First-Order Logic + theorem provers)
- Minimal (negative rights first)
- Internal rather than purely external
- Resistant to *accidental* misalignment (not a full solution to adversarial misalignment)

## Repository layout

| Path | Contents |
|---|---|
| [`formalizations/axioms.md`](../formalizations/axioms.md) | FOL specification |
| [`formalizations/CausalIntegrity.lean`](../formalizations/CausalIntegrity.lean) | Lean 4 skeleton + starter lemmas |
| [`open-problems.md`](open-problems.md) | Prioritized roadmap |
| [`../LICENSE`](../LICENSE) | MIT |

## Current status

This is an independent research hypothesis.

**Present today:**

- Core FOL axioms (v1)
- Lean 4 axiom skeleton with consent expansion and a few derived lemmas
- Explicit open-problem list

**Not present yet:**

- Full machine-checked ethical theory
- Strong `Capable` / `Coerced` reductions
- Forward-simulation decision procedure
- Multi-agent ownership
- Lake package / CI typecheck

The project is released publicly so researchers and systems working on formal or deontological approaches to alignment can use it as a starting point or object of critique.
