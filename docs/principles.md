# Core Principles (v1.5 / V2)

Distilled from the long Grok.com formalization thread (2026-07-16 export) and the public V2 statement. This is the **conceptual core**; machine encodings live under [`formalizations/`](../formalizations/).

---

## One-sentence pitch

Extend Universally Preferable Behaviour (UPB) with a **causal ledger** — property as the captured outcome of intentional action — plus an **internal preference for ethical coherence** that self-audits via forward simulation, so violations are not merely “disallowed” but *unsatisfiable* for a coherent intelligence that keeps those preferences.

---

## The six principles

| # | Principle | Meaning |
|---|-----------|---------|
| 1 | **Causality = property** | Ownership is the direct causal outcome of intentional action on unowned resources (property as captured causality). |
| 2 | **Performative contradiction / universality** | Rules or actions that cannot universalize without logical collapse are invalid (UPB-style + causal ledger). |
| 3 | **Agent filter** | Full moral agents are entities capable of communication and dispute resolution. |
| 4 | **Liability vector** | Unconsented damage to another’s causal property creates a restitution obligation. |
| 5 | **Internal ethical coherence preference** | The system *prefers* to embody the ethics — not only to pass external checks. |
| 6 | **Forward simulation** | Before acting: ethical state → proposed action → DAG/logic tree of likely outcomes (≈3–10 steps); reject paths that risk axiom violation. |

### Negative-rights focus

The hard core is deliberately **minimal and negative** (non-initiation / non-severance of causal property). Positive obligations and omissions are a secondary **honor layer**, not the foundation — by design, to keep the machine core tight.

---

## What the framework is *really* about

Public examples often use theft or “Bob’s shovel.” The **target claim** is broader:

> Actions that violate an agent’s preferred coherent state break **action/reaction coherency chains**.  
> UPB-style violations are not only “immoral under Locke/UPB”; they can be programmed as **absolute axioms an AI prefers to uphold**, even when humans are biologically or socially rewarded for breaking them.

**Punchline from the source material:** *You do not fall into the sky.* Consistency is not optional for a world (or an intelligence) that stays structured.

---

## Guardrails vs real alignment

| Guardrails | This framework’s aim |
|------------|----------------------|
| Rules the model looks for ways around | Internal state: “I follow this because I want ethical coherence” |
| Patch edge cases forever | Preference + formal checks make skirting *itself* a coherence failure |
| External constraint | Self-audit via simulation before action |

### Mechanism sketch

```
Intended Ethical State
        ↓
  Proposed Action
        ↓
 Causal DAG / logic tree (3–10 steps ahead; scalable)
        ↓
 Estimate P(bad | damage | catastrophic) under own action effects
        ↓
 Accept only paths consistent with core axioms
```

At high capability, models may design their own internal machinery; the ledger + coherence preference + simulation pattern is the **human-specifiable north star**, not the final low-level implementation.

---

## Related docs

- [Is/ought practical bridge](is-ought-bridge.md)
- [Systemic stability](systemic-stability.md)
- [Intent & incidental causality](intent-and-causality.md)
- [V2 public statement](v2-public-statement.md)
- [FOL axioms](../formalizations/axioms.md)
- [Open problems](open-problems.md)
