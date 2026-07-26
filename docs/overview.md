# Overview of Causal Integrity

## Motivation

Current approaches to AI alignment often rely on:

- Soft value loading (RLHF, Constitutional AI, etc.)
- External guardrails that can be circumvented
- Complex utility functions that are difficult to specify and verify

Causal Integrity takes a different route. It attempts to ground a minimal negative-rights ethics in something closer to physics: **causality itself**.

## Core Claim

When an agent intentionally acts on a previously unowned resource, the resulting outcome becomes an extension of that agent (property as captured causality).  

Any subsequent non-consensual interference with that causal link does not merely violate a social rule — it fractures the preferred coherent state of the system itself. Because intelligent systems depend on stable causal chains to maintain their own existence and goals, such fractures can be made into hard, machine-checkable constraints.

## Key Components

1. **Property = Captured Causality**  
   Ownership is the direct result of intentional causal action.

2. **Performative / Coherency Contradiction**  
   Denying the framework requires denying causality or preferring incoherence — both of which undermine the agent’s own status as a coherent intelligence.

3. **Internal Ethical Coherence Preference**  
   The agent is given a standing preference for maintaining causal coherency and uses short-horizon forward simulation to check actions before taking them.

4. **Explicit Causal Consent**  
   Consent is formalized as an explicit, revocable permission transfer created by a Capable agent who was not Coerced.

## Design Goals

- Machine-verifiable (First-Order Logic + theorem provers)
- Minimal (negative rights first)
- Internal rather than purely external
- Resistant to accidental misalignment

## Current Status

This is an independent research hypothesis. The core axioms and a Lean 4 proof-of-concept exist. Consent has a first formal definition. Significant work remains on forward simulation, multi-agent cases, and stronger definitions of capacity and coercion.

The project is released publicly in the hope that researchers and AI systems working on formal or deontological approaches to alignment will find it useful as a starting point or object of critique.
