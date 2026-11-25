# Open Problems & Roadmap

Prioritized remaining work. Incorporates earlier formalization and coherence/forward-simulation arcs.

---

## Tier 1 — Critical foundations

### 1. Consent strengthening

- Stronger `Capable` / `Coerced` (beyond partial / primitive)
- Collective / multi-party consent
- Informed consent
- Consent as verifiable ledger state transition (Gemini: “cryptographic handshake”)

### 2. Intent + Direct bound (attack surface)

- Computable `Direct` / teleological vs exhaust (butterfly attack)
- Contribution thresholds for appropriation without infinite cosmos-claim
- See [attack-vectors.md](attack-vectors.md), [intent-and-causality.md](intent-and-causality.md)

### 3. Forward simulation layer

- Short-horizon causal DAGs
- Risk of coherency break within *n* steps
- Shared coherence preference across MoE / sub-agents

---

## Tier 2 — Practical robustness

### 4. Positive obligations / honor layer

- Capability + foreseeability when inaction becomes liability (coma test only covers capacity edge)

### 5. Scalability & approximation

- Strict check for high-stakes; sampling for low-stakes without reopening loopholes

### 6. Dispute resolution

- Third-party / protocol for liability magnitude and joint ownership (shared creation attack)

---

## Tier 3 — Advanced / tooling

### 7. Multi-agent coordination

- Soften exclusivity (Axiom 2) for joint title
- Formalize systemic stability arguments

### 8. Verification depth

- [x] Lake package + CI for Lean (`lake build`, `.github/workflows/lean.yml`)
- Encode full meta-level role-universalizability over rich rule languages (beyond the discrete profiles in `CausalIntegrityV2`)
- Temporal / state-indexed ownership ledger (replace `Unowned` marker)
- Promote [foundations-gemini.md](../archive/foundations-gemini.md) sketches to machine-checked theorems

### 9. Scholarship

- Related work: Kantian universalization, Gewirth/Beyleveld, Locke, Kinsella (estoppel), Halpern-Pearl actual causality, formal deontology, and historical universalization critiques
- Note Woodford-style critiques of hypothetical vs. categorical universality and how the AI-scoped version answers them ([../archive/upb-core-proofs.md](../archive/upb-core-proofs.md))
