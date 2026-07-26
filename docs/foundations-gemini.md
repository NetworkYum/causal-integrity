# Foundations from the Gemini Formalization Arc (March 2026)

This document reconstructs the **base axioms** developed in the Google Gemini conversation (chats 13–18, 2026-03-06 export) that first locked **property as captured causality**, then patched attack vectors. Cleaned of MathJax garble; faithful to the intended logic.

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

## Base axioms (causality layer)

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

### Property as causality (core theorem / definition)

An agent has a causal property link to a resource iff they caused a **direct** action that affected it.

```
∀ a ∈ A, ∀ r ∈ R:
  Property(a, r) ↔ ∃ act ∈ Act:
    Causes(a, act) ∧ Affects(act, r) ∧ Direct(act)
```

`Direct(act)` is the bounding box: **teleological / intentional** contribution, not universal causal exhaust (see [attack-vectors.md](attack-vectors.md)).

### Homesteading (null capture)

First agency on an unowned resource creates property.

```
Owner(r) = Null
∧ Causes(a, act) ∧ Affects(act, r) ∧ First(act, r)
→ Property(a, r)
```

### Liability (not ownership transfer)

Unconsented intersection with another’s property generates restitution debt — **not** automatic ownership of the damaged resource.

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

## Proof sketch: theft as performative contradiction

**Scenario:** Sam takes Bob’s shovel while denying that property/causal links bind.

1. To move the shovel Sam must act: `Causes(Sam, act_take)`.
2. Denying property-as-causality universally asserts something like  
   `¬∃ links of the form Causes(agent, act) → Property(...)`  
   or, in the strong form used in chat-16, that causal-agent links to effects are invalid.
3. Sam cannot both rely on `Causes(Sam, act_take)` and deny that agents are causally linked to the effects of their actions without contradiction.

**Punchline (user contribution, chat-15):**  
Rejecting property in this framework requires rejecting **causality / coherency** lower in the stack — not merely a social convention.

Honest note: the strongest “syntax error” claim assumes the denial is universalized against *all* causal-agent links. A thinner denial (“only Bob’s claim fails”) needs Axiom 3-style coherency + consent, not only Agency. Both layers appear in the later Lean/FOL package.

---

## Mapping to current repo formalization

| Gemini / March | Current repo |
|----------------|--------------|
| Agency + Effect | Implicit in `Causes` |
| Property ↔ causal + Direct | Axiom 1 + `Intentional` |
| Homesteading / Null | Axiom 1 (`¬∃b Owns b r`) |
| Liability vector | Axiom 6 |
| Agent filter (communicate / dispute) | Axiom 0 |
| UPB universality | Axiom 5 (meta) |
| Consent transfer | `def Consent` |
| Direct vs exhaust | [intent-and-causality.md](intent-and-causality.md), still open math |

---

## What this arc contributed that the July package under-emphasized

1. **Explicit Agency / Effect axioms** before property.
2. **Attack-driven patches** (butterfly, nature) with user-originated agent filter + liability-vs-ownership.
3. **DAG / ledger language** for neural theorem provers.
4. **Coma test / agent filter** as information-theoretic: ethics for entities that can dispute.

See also: [attack-vectors.md](attack-vectors.md), [upb-core-proofs.md](upb-core-proofs.md), [provenance.md](provenance.md).
