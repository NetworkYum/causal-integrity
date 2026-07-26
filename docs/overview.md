# Overview of Causal Integrity

## Motivation

Current approaches to AI alignment often rely on:

- Soft value loading (RLHF, Constitutional AI, etc.)
- External guardrails that can be circumvented
- Complex utility functions that are difficult to specify and verify

Causal Integrity takes a different route. It attempts to ground a minimal negative-rights ethics in **causality and coherence** — a UPB extension with a causal ledger and an internal preference for ethical coherency.

## Core claim

When an agent intentionally acts on a previously unowned resource, the resulting outcome becomes an extension of that agent (**property as captured causality**).

Any subsequent non-consensual interference with that causal link does not merely violate a social rule — it fractures the preferred coherent state of the system itself. Because intelligent systems depend on stable causal chains to maintain their own existence and goals, such fractures are candidates for hard, machine-checkable constraints.

**Not mainly a theft theory:** the point is that violations of preferred coherent states break action/reaction coherency chains, and those constraints can be encoded as axioms an AI *prefers* to follow.

## Key components

See [principles.md](principles.md) for the full six-point table. Short form:

1. Property = captured causality
2. Performative contradiction / universality (UPB)
3. Agent filter (communicate + dispute)
4. Liability vector (unconsented damage → restitution)
5. Internal ethical coherence preference
6. Forward simulation (short-horizon DAG self-audit)

## Design goals

- Machine-verifiable target (First-Order Logic + theorem provers)
- Minimal (negative rights first; honor layer secondary)
- Internal rather than purely external
- Resistant to *accidental* misalignment (not a full solution to every adversarial mind)

## Repository layout

| Path | Contents |
|---|---|
| [principles.md](principles.md) | Conceptual core |
| [is-ought-bridge.md](is-ought-bridge.md) | Practical is/ought bridge |
| [systemic-stability.md](systemic-stability.md) | Cooperation / nihilism arguments |
| [intent-and-causality.md](intent-and-causality.md) | Gray zones and intent |
| [v2-public-statement.md](v2-public-statement.md) | Polished public pitch |
| [open-problems.md](open-problems.md) | Roadmap |
| [provenance.md](provenance.md) | Source exports and translation loss |
| [../formalizations/axioms.md](../formalizations/axioms.md) | FOL |
| [../formalizations/CausalIntegrity.lean](../formalizations/CausalIntegrity.lean) | Lean |
| [../examples/theft_unsatisfiable.py](../examples/theft_unsatisfiable.py) | Toy check |

## Current status

**Present today:**

- Principles and V2 public statement restored from the long thread
- FOL v1.5 (agent filter + liability + consent expansion)
- Lean axiom skeleton with starter lemmas
- Corrected satisfiability toy
- Honest open-problem list

**Not present yet:**

- Full machine-checked ethical theory
- Strong Capable / Coerced / intent thresholds
- Forward-simulation decision procedure
- Multi-agent stability theorems
- Lake package / CI

The project is released so researchers and systems working on formal or deontological alignment can use it as a starting point or object of critique.
