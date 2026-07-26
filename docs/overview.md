# Overview of Causal Integrity

## Motivation

Current approaches to AI alignment often rely on:

- Soft value loading (RLHF, Constitutional AI, etc.)
- External guardrails that can be circumvented
- Complex utility functions that are difficult to specify and verify

Causal Integrity takes a different route: ground a minimal ethics in **the fact that coherent causality is required for durable action**, then make that preference machine-checkable.

**Read [framing.md](framing.md) first.** Property is a proof instrument, not the thesis.

## Core claim

1. **Foundation:** Stable agency and intelligence depend on patterned action → effect chains. Systematically destroying those chains dissolves the actor into local, unstructured reactions (“goop”). Coherent states are therefore **preferred by action** — not as a fashion, but as a precondition of remaining an agent that acts.

2. **Proof instrument:** Representing intentional causal links as **property (captured causality)** lets us show, in sharp formal examples, that non-consensual severance of those links is a performative / coherency contradiction (classic shovel/theft demos).

3. **Alignment payload:** An **internal preference for ethical coherence** plus **forward simulation** so the system rejects paths that break preferred coherent states — not only because a rulebook says so, but because remaining a coherent actor requires it.

## Key components

See [principles.md](principles.md) for the full priority stack. Short form:

| Layer | Content |
|-------|---------|
| Foundation | Coherence preferred by action; goop if causality dissolves |
| Preference | Internal ethical coherence preference |
| Mechanism | Forward simulation (DAG) |
| Instruments | Causal ledger / property, UPB universality, agent filter, liability |

## Design goals

- Machine-verifiable target (FOL + theorem provers)
- Minimal negative core (honor layer secondary)
- Internal rather than purely external
- Aimed at *accidental* misalignment (not every adversarial mind)

## Repository layout

| Path | Contents |
|---|---|
| [framing.md](framing.md) | **Foundation vs proof instrument** |
| [principles.md](principles.md) | Priority stack |
| [foundations-gemini.md](foundations-gemini.md) | Historical FOL for the property instrument |
| [attack-vectors.md](attack-vectors.md) | Butterfly / nature patches |
| [is-ought-bridge.md](is-ought-bridge.md) | Practical bridge + decoherence |
| [systemic-stability.md](systemic-stability.md) | Cooperation / nihilism |
| [open-problems.md](open-problems.md) | Roadmap |
| [provenance.md](provenance.md) | Conversation sources (Grok.com cannot ship files — exports only) |
| [../formalizations/](../formalizations/) | FOL + Lean |
| [../examples/](../examples/) | SymPy toys |

## Current status

**Present:** Framing correction, principles stack, Gemini/March foundations, FOL/Lean skeleton, toys.  
**Not present:** Full verified theory, strong consent/intent math, forward-sim procedure, Lake CI.

Released as a hypothesis for critique and formalization help.
