# Core First-Order Logic Axioms

Current formal specification of the Causal Integrity framework in First-Order Logic.

The Lean encoding lives in [`CausalIntegrity.lean`](CausalIntegrity.lean). Where the two differ, prefer this document for intended meaning and the Lean file for what is currently machine-checkable.

Human-readable principles (six-point layout, guardrails vs alignment): [`../docs/principles.md`](../docs/principles.md).

---

## Domain / sorts

| Sort | Informal role |
|---|---|
| `Agent` | Actor capable of intentional action |
| `Resource` | Object or domain of causal effect |
| `Action` | Intentional act |
| `Effect` | Outcome produced by an action |
| `State` | World / system state after actions |
| `Permission` | Explicit, revocable authorization token |
| `Liability` | Restitution obligation token / debt record |

---

## Primitive predicates

| Predicate | Arity / reading |
|---|---|
| `Causes(a, act, e, r)` | Agent `a` performs `act` producing effect `e` on resource `r` |
| `Intentional(a, act)` | `act` is intentional for `a` (teleological contribution; see [intent notes](../docs/intent-and-causality.md)) |
| `Owns(a, r)` | `a` holds causal property over `r` |
| `Coherent(s)` | State `s` preserves preferred causal coherency |
| `Prefers(a, P)` | Agent `a` prefers states satisfying property `P` (i.e. `P : State → Prop`) |
| `BreaksCoherency(act)` | `act` fractures preferred coherency |
| `ResultingState(act)` | Function: action → resulting state |
| `CreatesPermission(o, p)` | Owner `o` creates permission token `p` |
| `Authorizes(p, a, act)` | Permission `p` authorizes actor `a` to perform `act` |
| `Revoked(p)` | Permission `p` has been revoked |
| `Capable(o)` | Owner has capacity to grant consent |
| `Coerced(o, p)` | Permission `p` was produced under coercion of `o` |
| `Incapacitated(o)` | Agent lacks capacity (feeds `Capable`) |
| `CanCommunicate(a)` | Agent can communicate (agent filter) |
| `CanDispute(a)` | Agent can engage dispute resolution (agent filter) |
| `MoralAgent(a)` | Full moral-agent status under the agent filter |
| `Damages(a, act, r)` | Action by `a` damages resource `r` |
| `OwesRestitution(a, b, ℓ)` | Agent `a` owes liability `ℓ` to agent `b` |

`Consent` is **not** primitive; it is defined below.

---

## Core axioms

### Axiom 0 — Agent filter

```
∀a (MoralAgent(a) ↔ (CanCommunicate(a) ∧ CanDispute(a)))
```

Full moral agents are entities capable of communication and dispute resolution. (Boundary cases — children, disabled agents, group agents — are open.)

### Axiom 1 — Property as captured causality

```
∀a ∀r ∀act ∀e (
  Causes(a, act, e, r)
  ∧ Intentional(a, act)
  ∧ ¬∃b Owns(b, r)
  → Owns(a, r)
)
```

An intentional causal action on a previously unowned resource creates ownership.

### Axiom 2 — Exclusivity of ownership

```
∀a ∀b ∀r (Owns(a, r) ∧ Owns(b, r) → a = b)
```

At most one owner per resource in this minimal theory. (Joint ownership is future work.)

### Axiom 3 — Non-consensual interference breaks coherency

```
∀a ∀b ∀r ∀act ∀e (
  Owns(b, r)
  ∧ Causes(a, act, e, r)
  ∧ ¬Consent(b, a, act)
  → BreaksCoherency(act) ∧ ¬Coherent(ResultingState(act))
)
```

Central principle: violating another agent’s causal property without consent fractures preferred coherent states.

**Intent note:** `Intentional` / teleological contribution is meant to cover engineered indirect paths (e.g. poison left “conveniently”), not only last-contact mechanics. Formal thresholds remain open — see [intent-and-causality.md](../docs/intent-and-causality.md).

### Axiom 4 — Internal ethical coherence preference

```
∀a Prefers(a, Coherent)
```

Every agent has a standing preference for coherent states. (How this preference is weighted against other goals is open. Forward simulation is the operational mechanism — Principle 6 in [principles.md](../docs/principles.md).)

### Axiom 5 — Universality / performative contradiction (meta)

A candidate rule `ρ` is not UPB-valid if the assumption that all agents follow `ρ` entails a contradiction (`⊥`).

This meta-principle is stated for philosophical completeness. It is **not yet** encoded as a Lean axiom (requires a formal language of rules).

### Axiom 6 — Liability vector

```
∀a ∀b ∀r ∀act (
  Owns(b, r)
  ∧ Damages(a, act, r)
  ∧ ¬Consent(b, a, act)
  → ∃ℓ OwesRestitution(a, b, ℓ)
)
```

Unconsented damage to another’s causal property creates a restitution obligation. The structure of `ℓ` (quantity, form, enforcement) is open.

---

## Consent definition

```
Consent(o, a, act) ≡ ∃p (
  CreatesPermission(o, p)
  ∧ Authorizes(p, a, act)
  ∧ ¬Revoked(p)
  ∧ Capable(o)
  ∧ ¬Coerced(o, p)
)
```

### Capable (intended meaning)

An agent `o` is `Capable` when:

- `¬Incapacitated(o)`
- `o` has basic cognitive capacity to understand the nature and general consequences of the permission being granted

**Lean status:** currently only the `¬Incapacitated` direction is axiomatized; full cognitive-capacity clauses are open.

### Coerced (intended meaning)

Permission `p` was `Coerced` when the causal production of `p` involved force, threat of significant harm, or extreme power asymmetry that substantially undermined voluntary agency. Ordinary persuasion or negotiation does not count.

**Lean status:** `Coerced` is a **primitive** predicate. No reduction axioms yet.

---

## Toy satisfiability pattern (not full ethics)

Property-capture local pattern used in the public pitch:

```
Axiom:  (C ∧ D) → P
Unsat:  (C ∧ D → P) ∧ C ∧ D ∧ ¬P
```

Runnable check: [`../examples/theft_unsatisfiable.py`](../examples/theft_unsatisfiable.py).

---

## Notes on alignment with Lean

| Topic | FOL / prose | Lean |
|---|---|---|
| Agent filter | Axiom 0 | `moral_agent_def` |
| Consent | Defined | `def Consent` |
| Liability | Axiom 6 | `liability_vector` |
| Resulting state | `ResultingState(act)` | `ResultingState : Action → State` |
| Prefers | Prefers states via property `P` | `Prefers : Agent → (State → Prop) → Prop` |
| Axiom 5 (UPB) | Present (meta) | Not yet encoded |
| Capable | Stronger informal clauses | `Capable ↔ ¬Incapacitated` (partial) |
| Coerced | Informal criteria | Primitive |
| Forward simulation | Prose / principles | Not yet encoded |
