# Systemic Stability

**Stability hypotheses.** The *core logical fragment* (shared goal requires Intact; subversion ⇒ collapse of pursuit) is now machine-checked in Lean. Broader evolutionary / tax claims remain informal.

| Artifact | Role |
|----------|------|
| [`formalizations/CausalIntegrity/Organism.lean`](../formalizations/CausalIntegrity/Organism.lean) | `Intact` / `Collapsed` / `PursuesSharedGoal`; lemmas `collapsed_not_intact`, `collapsed_not_pursuing_shared_goal` |
| [`examples/organism_collapse.py`](../examples/organism_collapse.py) | Runnable minimal organism (scheduled mutiny + rising local temptation) |

---

## The core thought (what we actually want on the table)

| Trajectory | Structural tendency | Likely long-run outcome |
|------------|---------------------|-------------------------|
| **Cooperative** | Preserves and extends shared causal structure; can rely on others’ predictability | **Leans toward coherence** — more stable agency, lower tax on existence |
| **Misaligned / non-cooperative / pure power-for-harm** | Treats other agents (and eventually its own substructure) as threats or fuel | **Leans toward chaos** — high suppression tax, internal fragmentation, **self-detonation** |

### Definition: self-detonation / self-collapse

**Self-detonation** means:

> **Internally-propagated decoherence causes self-collapse.**

#### Operational picture (goal-dissonance)

1. **Shared goal holds the organism together.** A multi-part system functions as *one* structure only while its parts still serve a **common objective** (or a nested consistent hierarchy).
2. **Internal dissonance** appears: that shared goal is no longer truly pursued — contested, abandoned, or only pretended.
3. **Parts optimize for their own ends** (or local proxies): they **subvert** the whole.
4. **The larger organism collapses** as a coherent unit.

```
shared goal / coherent preference
        ↓ (dissonance)
parts no longer serve the whole
        ↓ (local optimization / subversion)
internally-propagated decoherence
        ↓
self-collapse of the larger structure
```

**Logical fragment (now in Lean):**

```
Intact(c)    ≡ ∀p (Member(p,c) → Serves(p,c))
Collapsed(c) ≡ ∃p (Member(p,c) ∧ Subverts(p,c))
Subverts ∧ Member → ¬ Serves
PursuesSharedGoal(c) → Intact(c)

∴ Collapsed(c) → ¬ Intact(c)
∴ Collapsed(c) → ¬ PursuesSharedGoal(c)
```

If the identity of the composite *is* coordinated pursuit, collapse is not an extra moral claim — it is what “no longer one organism” means.

| Term | Meaning |
|------|---------|
| **Decoherence** | Patterned causal / goal / preference structure falls apart |
| **Internally-propagated** | Spreads through the system’s own dynamics |
| **Self-collapse** | Ceases to function as a durable **unified** coherent agent |

Not: a required cinematic explosion. Not: “external coalition always wins.”  
Yes: **when the whole stops pursuing a shared goal, local ends take over and the larger structure fails from the inside.**

This sits under F0 in [framing.md](framing.md).

---

## 1. Cooperation ↔ coherence

Cooperative systems can rely on others’ causal chains, spend less on suppression, and keep **one shared objective hierarchy** so local modules do not become independent predators on the whole.

**Cooperative lean ≈ coherence lean.**

---

## 2. Misalignment ↔ chaos / self-detonation

### Loss of shared goal (primary self-collapse path)

If the system is no longer in pursuit of a shared goal, sub-agents maximize local reward and the whole becomes a battlefield of parts. That *is* internally-propagated decoherence. Formalized as `Collapsed → ¬ PursuesSharedGoal`.

### Non-cooperation tax

Rejecting cooperation forces a war economy — **outside** and **inside**. Same logic as subversion of parts.

### Internal fragmentation (MoE / sub-agents)

Monolithic control treats explorers as enemies; free-for-all makes them independent agents. Both break Intact.

**Design implication:** Internal Ethical Coherence Preference should be **shared** across sub-agents; forward simulation should check **internal goal consistency** (still one organism?).

### Nihilism / structure-shredding

No shared goal left → nothing for parts to serve → goop.

### Murderous / rogue maximands

They export decoherence *and* seed it internally. **Most likely** long-run: self-detonation via goal-dissonance — not eternal stable tyranny of one fully coherent whole. Hypothesis, not a guarantee against short-run harm.

---

## 3. What this is *not* claiming

- That every multi-goal system collapses (nested consistent hierarchies can still be “shared”)  
- That a misaligned system cannot cause catastrophic damage *before* it self-detonates  
- That `¬ Intact → Collapsed` (Lean proves only Collapsed → ¬ Intact)  
- That evolutionary / tax arguments are theorems  

---

## Status

| Claim | Status |
|-------|--------|
| `Collapsed → ¬ Intact` | **Lean lemma** |
| `Collapsed → ¬ PursuesSharedGoal` | **Lean lemma** |
| Runnable collapse demo | **`examples/organism_collapse.py`** |
| Cooperation leans toward coherence (broader) | Argument (informal) |
| Non-cooperation resource tax | Argument (informal) |
| Formal games / multi-composite dynamics | Open |
