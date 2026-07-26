# Foundations from the Gemini Formalization Arc (March 2026)

> **Framing note:** This file records how **property-as-captured-causality** was first written in FOL. In the overall project, that construction is a **proof instrument**, not the deepest foundation. The foundation is that **coherent causality is preferred by action** (dissolve the chains → goop). See [framing.md](framing.md).

This document reconstructs the **base axioms** developed in the Google Gemini conversation (chats 13–18, 2026-03-06 export). Cleaned of MathJax garble; faithful to the intended logic.

Source files (local):

- `gemini_google-gemini_2026-03-06T00-32-48-0500.md`
- Merged into Grok’s “Unified UPB-Causality Framework” (March codifying thread, msg 12)

---

## Domains

| Symbol | Meaning |
|--------|---------|
| `A` | Agents (actors) |
| `Act` | Physical / intentional actions |
| `R` | Resources (matter, effects, ledger objects) |

---

## Base axioms (causality layer — instrument for checking coherency)

### Axiom of Agency

Every action is caused by an agent.

```
∀ act ∈ Act, ∃ a ∈ A: Causes(a, act)
```

### Axiom of Material Effect

Actions exert change on resources.

```
∀ act ∈ Act, ∃ r ∈ R: Affects(act, r)
```

### Property as causality (ledger form of captured links)

An agent has a causal property link to a resource iff they caused a **direct** action that affected it.

```
∀ a ∈ A, ∀ r ∈ R:
  Property(a, r) ↔ ∃ act ∈ Act:
    Causes(a, act) ∧ Affects(act, r) ∧ Direct(act)
```

`Direct(act)` bounds teleological contribution vs incidental exhaust (see [attack-vectors.md](attack-vectors.md)).

**Why define this at all?** So a prover can detect when an action **uses** causality while **denying** coherent attachment of effects to agents — the worked case for “coherence preferred by action.”

### Homesteading (null capture)

```
Owner(r) = Null
∧ Causes(a, act) ∧ Affects(act, r) ∧ First(act, r)
→ Property(a, r)
```

### Liability (not ownership transfer)

```
Property(b, r)
∧ Causes(a, damage_to_r)
∧ ¬Consent(b, a, damage)
→ Liability(a, b)
```

### Universality (UPB core)

```
∀ rules: Valid(rule) ↔
  (∀ agents: Applicable(rule, agents)) ∧ ¬Contradiction(rule)
```

---

## Proof sketch: theft as performative contradiction (instrument demo)

**Scenario:** Sam takes Bob’s shovel while denying that property/causal links bind.

1. To move the shovel Sam must act: `Causes(Sam, act_take)`.
2. A universal denial that agents are causally linked to effects of their actions collides with (1).
3. **Deeper reading:** the contradiction is not “Sam violated real estate law”; it is that **coherent action cannot both use and erase causal attachment** without collapse.

Honest note: thinner denials need the later coherency/consent layer (Axiom 3-style), not only Agency.

---

## Mapping to current repo formalization

| Gemini / March | Current repo |
|----------------|--------------|
| Agency + Effect | Implicit in `Causes` |
| Property ↔ causal + Direct | Axiom 1 + `Intentional` (**instrument**) |
| Homesteading / Null | Axiom 1 |
| Liability vector | Axiom 6 |
| Agent filter | Axiom 0 |
| UPB universality | Axiom 5 (meta) |
| Coherence preference (July) | Axiom 4 + [framing.md](framing.md) (**foundation**) |

---

## What this arc contributed

1. Explicit Agency / Effect before ownership talk.  
2. Attack-driven patches (butterfly, nature).  
3. DAG / ledger language for provers.  
4. Agent filter (communicate / dispute).

What it **under-labeled** (fixed in [framing.md](framing.md)): property was always in service of **coherency of action**, not the final subject matter of the ethics.
