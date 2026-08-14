# Core First-Order Logic Axioms

Current formal specification of Causal Integrity in First-Order Logic.

Lean encoding (Lake): [`CausalIntegrity.lean`](CausalIntegrity.lean),
[`CausalIntegrity/Axioms.lean`](CausalIntegrity/Axioms.lean),
[`CausalIntegrity/Lemmas.lean`](CausalIntegrity/Lemmas.lean),
[`CausalIntegrity/Organism.lean`](CausalIntegrity/Organism.lean).  
Build: `lake build` from repo root.  
Demo: `python examples/organism_collapse.py`.  
Framing: [`../docs/framing.md`](../docs/framing.md) — property is an instrument, not the foundation.

---

## Domain / sorts

| Sort | Informal role |
|---|---|
| `Agent` | Actor (full moral status: see Axiom 0) |
| `Resource` | Object or domain of causal effect |
| `Action` | Intentional / physical act |
| `Effect` | Outcome produced by an action |
| `State` | World / system state after actions |
| `Permission` | Explicit, revocable authorization token |
| `Liability` | Restitution obligation record |
| `Composite` | Multi-part organism (MoE, tool stack, module society) |
| `Part` | Sub-agent / module of a composite |

---

## Primitive predicates

| Predicate | Reading |
|---|---|
| `Causes(a, act, e, r)` | Agent `a` performs `act` producing effect `e` on resource `r` |
| `Intentional(a, act)` / `Direct(act)` | Teleological contribution (bounds butterfly exhaust) |
| `Owns(a, r)` / `Property(a, r)` | Causal property link |
| `Unowned(r)` (Lean) | Null-owner marker for homesteading (FOL: `¬∃b Owns`) |
| `Coherent(s)` | Preferred causal coherency holds in state `s` |
| `Prefers(a, P)` | Agent prefers states satisfying `P` |
| `BreaksCoherency(act)` | Action fractures preferred coherency |
| `ResultingState(act)` | Action → resulting state |
| `CreatesPermission(o, p)` | Owner creates permission |
| `Authorizes(p, a, act)` | Permission authorizes actor/action |
| `Revoked(p)` | Permission revoked |
| `Capable(o)` / `Coerced(o, p)` / `Incapacitated(o)` | Consent validity |
| `CanCommunicate(a)` / `CanDispute(a)` / `MoralAgent(a)` | Agent filter |
| `Damages(a, act, r)` | Damage event |
| `OwesRestitution(a, b, ℓ)` | Liability debt |
| `Member(p, c)` | Part `p` belongs to composite `c` |
| `Serves(p, c)` | Part still serves the whole |
| `Subverts(p, c)` | Part pursues a local end against the whole |
| `PursuesSharedGoal(c)` | Composite is in coordinated pursuit of a shared goal |

`Consent`, `Intact`, and `Collapsed` are defined, not primitive.

---

## Core axioms (ledger / preference)

### Axiom 0 — Agent filter

```
∀a (MoralAgent(a) ↔ (CanCommunicate(a) ∧ CanDispute(a)))
```

### Axiom 1 — Property as captured causality / homesteading

```
∀a ∀r ∀act ∀e (
  Causes(a, act, e, r)
  ∧ Intentional(a, act)
  ∧ ¬∃b Owns(b, r)
  → Owns(a, r)
)
```

**Lean note:** uses primitive `Unowned r` instead of timeless `¬∃ Owns`.

### Axiom 2 — Exclusivity of ownership

```
∀a ∀b ∀r (Owns(a, r) ∧ Owns(b, r) → a = b)
```

### Axiom 3 — Non-consensual interference breaks coherency

```
∀a ∀b ∀r ∀act ∀e (
  Owns(b, r) ∧ Causes(a, act, e, r) ∧ ¬Consent(b, a, act)
  → BreaksCoherency(act) ∧ ¬Coherent(ResultingState(act))
)
```

### Axiom 4 — Internal ethical coherence preference

```
∀a Prefers(a, Coherent)
```

### Axiom 5 — Universality / performative contradiction (meta, UPB)

A candidate rule `ρ` is not UPB-valid if assuming all agents follow `ρ` entails `⊥`.

Not encoded in Lean (needs a language of rules).

### Axiom 6 — Liability vector (not ownership transfer)

```
∀a ∀b ∀r ∀act (
  Owns(b, r) ∧ Damages(a, act, r) ∧ ¬Consent(b, a, act)
  → ∃ℓ OwesRestitution(a, b, ℓ)
)
```

---

## Organism / shared-goal (internal collapse)

This is **not** more title law. It is the identity of a composite agent.
See [docs/systemic-stability.md](../docs/systemic-stability.md).

### Definitions

```
Intact(c)    ≡ ∀p (Member(p, c) → Serves(p, c))
Collapsed(c) ≡ ∃p (Member(p, c) ∧ Subverts(p, c))
```

### Axiom 7a — Serve and subvert are incompatible (on members)

```
∀p ∀c (Member(p, c) ∧ Subverts(p, c) → ¬ Serves(p, c))
```

### Axiom 7b — Shared-goal pursuit requires Intact

```
∀c (PursuesSharedGoal(c) → Intact(c))
```

### Immediate consequences (Lean: `Organism.lean`)

```
Collapsed(c) → ¬ Intact(c)
Collapsed(c) → ¬ PursuesSharedGoal(c)
PursuesSharedGoal(c) → ¬ Collapsed(c)
```

Constructive only. We do **not** claim `¬ Intact → Collapsed` (that needs classical logic or identifying the two defs).

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

**Lean:** `Capable ↔ ¬Incapacitated` only; `Coerced` primitive.

---

## Toy checks

- [`../examples/theft_unsatisfiable.py`](../examples/theft_unsatisfiable.py) — ledger pattern
- [`../examples/causal_ledger_sim.py`](../examples/causal_ledger_sim.py) — theft + homestead + liability
- [`../examples/organism_collapse.py`](../examples/organism_collapse.py) — shared-goal / subversion collapse

---

## Lean alignment table

| Topic | FOL / prose | Lean |
|---|---|---|
| Agent filter | Axiom 0 | `moral_agent_def` |
| Property / homestead | Axiom 1 | `property_capture` + `Unowned` |
| Non-consensual break | Axiom 3 | `non_consensual_breaks_coherency` |
| Coherence preference | Axiom 4 | `internal_coherence_preference` |
| Liability | Axiom 6 | `liability_vector` |
| Organism intact/collapse | Axiom 7 | `Intact`, `Collapsed`, `collapsed_not_pursuing_shared_goal` |
| Consent | Defined | `def Consent` |
| UPB meta | Axiom 5 | Not encoded |
| Forward simulation | Principles | Not encoded |
