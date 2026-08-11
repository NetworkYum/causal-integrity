# Core First-Order Logic Axioms

Current formal specification of Causal Integrity in First-Order Logic.

Lean encoding (Lake): [`CausalIntegrity.lean`](CausalIntegrity.lean),
[`CausalIntegrity/Axioms.lean`](CausalIntegrity/Axioms.lean),
[`CausalIntegrity/Lemmas.lean`](CausalIntegrity/Lemmas.lean).  
Build: `lake build` from repo root.  
Historical Gemini base layer (cleaned): [`../docs/foundations-gemini.md`](../docs/foundations-gemini.md).  
Principles: [`../docs/principles.md`](../docs/principles.md).  
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
| `First(act, r)` | First appropriation marker (homesteading) |

`Consent` is defined, not primitive.

---

## Core axioms

### Axiom 0 — Agent filter (Gemini chat-18)

```
∀a (MoralAgent(a) ↔ (CanCommunicate(a) ∧ CanDispute(a)))
```

Ethics targets entities that can communicate and resolve disputes (coma test / not trees).

### Axiom 1a — Agency (Gemini base)

```
∀act ∃a Causes_agent(a, act)
```

*(In Lean this is packaged into the `Causes` relation.)*

### Axiom 1 — Property as captured causality / homesteading

```
∀a ∀r ∀act ∀e (
  Causes(a, act, e, r)
  ∧ Intentional(a, act)
  ∧ ¬∃b Owns(b, r)
  → Owns(a, r)
)
```

Intentional causal action on previously unowned (Null) resource creates ownership.  
This is the machine form of Gemini’s Null + First capture rule.

**Lean note:** the Lake encoding uses a primitive `Unowned r` Null marker in place of
timeless `¬∃b Owns(b,r)`, which would make Axiom 1 immediately inconsistent without a
temporal state index. Intended meaning is the same; a timed ledger remains open.

### Axiom 2 — Exclusivity of ownership

```
∀a ∀b ∀r (Owns(a, r) ∧ Owns(b, r) → a = b)
```

Minimal theory: exclusive title. Joint ownership is open (shared-creation attack).

### Axiom 3 — Non-consensual interference breaks coherency

```
∀a ∀b ∀r ∀act ∀e (
  Owns(b, r)
  ∧ Causes(a, act, e, r)
  ∧ ¬Consent(b, a, act)
  → BreaksCoherency(act) ∧ ¬Coherent(ResultingState(act))
)
```

Central July emphasis: violations break preferred action/reaction coherency chains — not “theft discourse” alone.

### Axiom 4 — Internal ethical coherence preference

```
∀a Prefers(a, Coherent)
```

### Axiom 5 — Universality / performative contradiction (meta, UPB)

A candidate rule `ρ` is not UPB-valid if assuming all agents follow `ρ` entails `⊥`.

Not yet encoded in Lean (needs a language of rules).

### Axiom 6 — Liability vector (not ownership transfer)

```
∀a ∀b ∀r ∀act (
  Owns(b, r)
  ∧ Damages(a, act, r)
  ∧ ¬Consent(b, a, act)
  → ∃ℓ OwesRestitution(a, b, ℓ)
)
```

Forest-fire / exhaust damage → debt, **not** `Owns(a, r)`.

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

### Capable (intended)

- `¬Incapacitated(o)`
- Basic capacity to understand nature and general consequences of the grant

**Lean:** currently `Capable ↔ ¬Incapacitated` only.

### Coerced (intended)

Force, threat of significant harm, or extreme power asymmetry undermining voluntary agency. Ordinary persuasion does not count.

**Lean:** primitive.

---

## Toy checks

- [`../examples/theft_unsatisfiable.py`](../examples/theft_unsatisfiable.py) — corrected `(C∧D)→P` pattern
- [`../examples/causal_ledger_sim.py`](../examples/causal_ledger_sim.py) — theft + homestead + liability toys

---

## Lean alignment table

| Topic | FOL / prose | Lean |
|---|---|---|
| Agent filter | Axiom 0 | `moral_agent_def` |
| Property / homestead | Axiom 1 | `property_capture` + `Unowned` |
| Exclusivity | Axiom 2 | `exclusivity` |
| Non-consensual break | Axiom 3 | `non_consensual_breaks_coherency` |
| Coherence preference | Axiom 4 | `internal_coherence_preference` |
| Liability | Axiom 6 | `liability_vector` |
| Consent | Defined | `def Consent` |
| UPB meta | Axiom 5 | Not encoded (S1 scoped out) |
| Direct bound | Intentional + docs | Predicate only |
| Forward simulation | Principles | Not encoded (S2/S3) |
| Derived lemmas | examples / attacks | `CausalIntegrity/Lemmas.lean` |
