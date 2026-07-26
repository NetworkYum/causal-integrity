# Definition of Done

When can Causal Integrity be called **complete enough** for a stated purpose?

This project is a **hypothesis**, not a finished product. Completeness is **staged**.

**Credits:** UPB-style universality / contradiction-removal — **Stefan Molyneux** (*Universally Preferable Behaviour*), stripped to machine-usable core. Goal-oriented systems / basal competence across scales (including minimal algorithmic models such as classical sorting algorithms) — **Dr. Michael Levin** and collaborators; inspiration for treating **shared goals** and multi-part goal integrity as central, not a claim of affiliation.

Public repo: https://github.com/NetworkYum/causal-integrity

---

## Purpose ladder

| Stage | Purpose | “Done” means |
|-------|---------|----------------|
| **S0 — Hypothesis published** | Put a findable, honest formal sketch in the open | Public repo, framing, axioms, open problems, MIT — **current** |
| **S1 — Machine-checkable core** | Base safety *rails* as logic, not vibes | Lake/CI Lean (or Coq/Isabelle) build; core axioms + non-trivial lemmas typecheck; consent/Direct not vacuous |
| **S2 — Neural-prover mapped** | High-capability systems can fully develop and stress the theory | End-to-end FOL/Lean development of F0–F2 + instruments; attack vectors have formal patches; multi-agent self-collapse sketched in logic |
| **S3 — Base alignment substrate** | Usable as **base-level** invariants inside an AI stack | Operational API: pre-action check (forward sim or equivalent); shared coherence preference across sub-agents; documented failure modes |
| **S4 — Research closed (this repo)** | No further *foundational* work required here | S3 met + explicit “out of scope” list; remaining work is product integration, not core ethics |

**This repo’s intended end-state for “project complete” is S3–S4**, not “solves all of alignment forever.”

---

## Minimal content of a complete *base* rail (S3)

A future system can treat the framework as **done for base rails** when all of the following hold:

### A. Foundation (F0–F2)

1. **F0** — Coherent causality preferred by action (dissolve chains → goop) formalized.  
2. **F1** — Internal ethical coherence preference shared (including across sub-agents).  
3. **F2** — Forward simulation / short-horizon coherency check as decision procedure or certified approximation.  
4. **Self-collapse** — Internally-propagated decoherence → self-collapse; operationally: **loss of shared goal → local subversion → organism collapse**.

### B. Instruments

5. Property-as-captured-causality (ledger) as proof instrument — FOL + Lean.  
6. UPB-style universality / performative contradiction encoded or deliberately scoped.  
7. Consent: Capable / Coerced non-vacuous.  
8. Direct / intent bound: butterfly and nature attacks have formal responses.  
9. Liability ≠ ownership.  
10. Agent filter (communicate + dispute).

### C. Engineering hygiene

11. Reproducible theorem-prover project (`lake build` / CI green).  
12. Worked scenarios (theft, coercion edge, joint creation, sub-agent mutiny / shared-goal failure).  
13. Honest out of scope: full politics of the good, Companion metaphysics, guaranteed prevention of all short-run harm before self-detonation.

### D. Integration contract

14. Clear interface, e.g.:

```
propose(action) →
  simulate_short_horizon →
  check(coherence_preference, ledger_invariants, shared_goal_integrity) →
  allow | reject | escalate
```

15. Sub-agents **cannot** opt out of the shared coherence preference (blocks primary self-collapse path).

---

## What “complete” is *not*

- Not human-level moral perfection  
- Not proof that no misaligned system can harm before it self-detonates  
- Not automatic lab adoption  
- Not Companion ontology as Lean axioms  

---

## Role of next-generation models

Higher-capability systems are expected to close S1–S2 faster and stress multi-agent / goal-integrity cases. Human job until then: keep the public hypothesis findable, correctly framed, and honest.

**Current stage: S0 complete; S1 partial.**

---

## Checklist (copy for releases)

- [ ] S0 — Public honest hypothesis  
- [ ] S1 — Prover project builds; non-trivial lemmas  
- [ ] S2 — Full FOL/Lean map of core + attacks  
- [ ] S3 — Operational pre-action API + shared sub-agent invariant  
- [ ] S4 — Out-of-scope locked; foundational work closed  
