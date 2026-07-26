# Open Problems & Roadmap

Prioritized remaining work for Causal Integrity. Aligns with the Tier structure from the long formalization thread, updated after the mining pass.

---

## Tier 1 — Critical foundations

### 1. Consent strengthening

- Stronger formal definitions of `Capable` and `Coerced` (beyond partial / primitive)
- Collective / multi-party consent
- Possible “informed consent” condition
- Consent as a **verifiable state transition** in the causal ledger

### 2. Intent + causal contribution

- Computable foreseeability and contribution thresholds
- Cover engineered indirect paths (poison / proxy / long chains) without infinite butterfly liability
- See [intent-and-causality.md](intent-and-causality.md)

### 3. Forward simulation layer

- Formal short-horizon causal DAGs
- Decision procedure for risk of breaking coherency within *n* steps
- Shared coherence preference across MoE / sub-agents
- Safe approximation methods for high-capability regimes

---

## Tier 2 — Practical robustness

### 4. Positive obligations / honor layer

- Capability + foreseeability test for when inaction becomes liability
- Keep secondary to negative-rights core

### 5. Scalability & approximation

- Strict axiom check for high-stakes actions
- Probabilistic sampling + verification for low-stakes
- Ensure approximations do not reopen loopholes

---

## Tier 3 — Advanced / long-term

### 6. Multi-agent coordination

- Joint ownership (Axiom 2 currently enforces exclusivity)
- Prisoner’s dilemmas, aligned agent societies
- Formalize [systemic-stability.md](systemic-stability.md) arguments as theorems or simulations

### 7. Tooling & verification depth

- Lake package + `lake build` for `CausalIntegrity.lean`
- CI typecheck on push
- Non-trivial theorems connecting `Prefers`, prediction, and action selection
- Encode or deliberately scope out Axiom 5 (UPB / performative contradiction)

### 8. Scholarship & framing

- Related-work notes: Locke, UPB, formal deontology, causal decision theory
- Worked scenarios in prose and Lean
- Recover any pre-export FOL/Lean blocks still offline — see [provenance.md](provenance.md)
