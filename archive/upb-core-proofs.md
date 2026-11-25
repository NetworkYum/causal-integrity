# UPB Core Proofs — Critique Map (March Codifying Thread)

From the March 2026 “Codifying Ethics for AI Alignment” Grok thread: validation of Molyneux’s five UPB proof styles for **AI-foundation use**, not as finished theology.

Goal stated by the user: strip politics, keep **valid contradiction-removal** as the machine-usable core.

---

## Proof styles assessed

| # | Proof style | Form | Soundness (for AI core) | AI use |
|---|-------------|------|-------------------------|--------|
| 1 | **Logical / performative** — denial of UPB prefers truth/correction | High | Medium–High if scoped to *argument* / consistency-seeking agents | Primary: contradiction detector |
| 2 | **Biological** — survival requires UPB-like preferences | High form | Low–Medium (is/ought blur) | Weak as sole base |
| 3 | **Empirical** — humans believe morals exist | Medium | Medium (belief ≠ UPB) | Training signal, not axiom |
| 4 | **Choices** — convergence implies preference ranking | Medium | Low (descriptive) | Heuristic only |
| 5 | **Evolutionary** — success selects UPB | Medium | Low (naturalistic fallacy) | Avoid as proof of ought |

**Reinforcement chosen in-thread:** keep **performative + universality** as the hard core; treat empirical as support; demote bio/evo as sole foundations.

---

## Critiques hammered (summary)

| Critique | Typical form | Thread response |
|----------|--------------|-----------------|
| Is/ought | Can’t derive ought from is | Causal integrity + hypothetical “if you value coherence/debate…” for AI; later decoherence/selection arguments |
| Circularity | “UPB must be valid” begs question | Prefer *performative*: denial while arguing still uses consistency machinery |
| Equivocation on “preference” | Instinct vs moral choice | Scope to rational/communicating agents + machine consistency |
| Woodford-style (debate) | Hypothetical ≠ categorical; foundation assumes validity | For AI, encode as **objective function / verifier**, not persuasion of humans |

---

## Theft-style universalization (public FOL sketch)

From March example blocks (cleaned):

```
Axiom (simplified):  P(a,r) ↔ C(a,r) ∧ Direct(a,r)

Universal theft test:
  Theft(a1,a2,r) → (P(a2,r) ∧ ¬P(a1,r))

Universalized theft:
  ∀a: Theft(a,a,r) → (P(a,r) ∧ ¬P(a,r)) → ⊥
```

Runnable (corrected) pattern: [`../examples/theft_unsatisfiable.py`](../examples/theft_unsatisfiable.py)  
Richer multi-check: [`../examples/causal_ledger_sim.py`](../examples/causal_ledger_sim.py)

---

## How this feeds Causal Integrity

UPB alone = universality without paradox.  
**Causal Integrity** = UPB + property-as-captured-causality + coherence preference + (later) forward sim.

The March work established: *which* UPB proofs are worth encoding. The Gemini arc established: *how* property plugs into physics-level causality. July packaging put a thin slice on GitHub; this doc restores the critique map.
