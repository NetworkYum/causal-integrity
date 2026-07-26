# Open Problems & Roadmap

Prioritized remaining work for Causal Integrity. Status labels match the [README](../README.md) formalization table.

---

## Priority 1 — Consent strengthening

- Stronger formal definitions of `Capable` and `Coerced` (beyond partial / primitive)
- Handling of collective / multi-party consent
- Possible “informed consent” condition
- Alignment of informal criteria in `axioms.md` with Lean reductions

## Priority 2 — Forward simulation layer

- Formal definition of short-horizon causal DAGs
- Decision procedure for risk of breaking coherency within *n* steps
- Safe approximation methods for high-capability regimes
- Reference implementation (even a tiny toy) bridging prose → executable check

## Priority 3 — Multi-agent cases

- Joint ownership (Axiom 2 currently enforces exclusivity)
- Coordination and dispute resolution
- Game-theoretic stability of the coherence preference

## Priority 4 — Tooling & verification depth

- Lake package + `lake build` for `CausalIntegrity.lean`
- CI typecheck on push
- Non-trivial theorems connecting `Prefers`, prediction, and action selection
- Encode or deliberately scope out Axiom 5 (UPB / performative contradiction)

## Priority 5 — Positive obligations

- Secondary layer for when inaction becomes a liability
- Keep this deferred until negative-rights core is more solid

## Priority 6 — Scholarship & framing

- Related-work notes: Lockean first appropriation, UPB, formal deontology, causal decision theory, preference-learning approaches
- Worked scenarios (theft, revoked permission, coercion edge cases) in prose and Lean examples
- Clarify which claims are theorems vs philosophical hypotheses
