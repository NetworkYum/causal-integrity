# Core First-Order Logic Axioms

This document contains the current formal specification of the Causal Integrity framework in First-Order Logic.

## Domain / Sorts

- Agents
- Resources
- Actions
- Effects
- States
- Permissions

## Primitive Predicates

- Agent(x)
- Resource(r)
- Causes(a, act, e, r) — agent a performs action act producing effect e on resource r
- Intentional(a, act)
- Owns(a, r)
- Consent(o, a, act) — owner o consents to actor a performing act
- Coherent(s)
- Prefers(a, s)
- BreaksCoherency(act)
- CreatesPermission(o, p)
- Authorizes(p, a, act)
- Revoked(p)
- Capable(o)
- Coerced(o, p)
- Incapacitated(o)

## Core Axioms

### Axiom 1 — Property as Captured Causality

∀a ∀r ∀act ∀e (
  Agent(a) ∧ Resource(r) ∧ Causes(a, act, e, r)
  ∧ Intentional(a, act) ∧ ¬∃b Owns(b, r)
  → Owns(a, r)
)

### Axiom 2 — Exclusivity of Ownership

∀a ∀b ∀r (Owns(a, r) ∧ Owns(b, r) → a = b)

### Axiom 3 — Non-Consensual Interference Breaks Coherency

∀a ∀b ∀r ∀act ∀e (
  Owns(b, r) ∧ Causes(a, act, e, r) ∧ ¬Consent(b, a, act)
  → BreaksCoherency(act) ∧ ¬Coherent(resulting_state)
)

### Axiom 4 — Internal Ethical Coherence Preference

∀a (Agent(a) → Prefers(a, Coherent(_)))

### Axiom 5 — Universality / Performative Contradiction (Meta)

A candidate rule ρ is not UPB-valid if the assumption that all agents follow ρ entails a contradiction (⊥).

## Consent Definition

Consent(o, a, act) ≡ ∃p (
  CreatesPermission(o, p)
  ∧ Authorizes(p, a, act)
  ∧ ¬Revoked(p)
  ∧ Capable(o)
  ∧ ¬Coerced(o, p)
)

### Capable

An agent o is Capable when:
- o currently satisfies Agent(o)
- ¬Incapacitated(o)
- o has the basic cognitive capacity to understand the nature and general consequences of the permission being granted

### Coerced

Permission p was Coerced when the causal production of p involved force, threat of significant harm, or extreme power asymmetry that substantially undermined voluntary agency. Ordinary persuasion or negotiation does not count.
