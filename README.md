# Causal Integrity

**A machine-verifiable ethical framework: coherent causality is preferred by action; formal instruments make that preference checkable.**

The load-bearing claim is **not** “property rights as the meaning of ethics.” It is that **stable agency depends on coherent action → effect chains**. If you systematically dissolve those chains, action becomes unstructured goop — and intelligence with it. An AI that *prefers* coherent states, and checks actions against that preference, is harder to *accidentally* misalign than one wrapped only in gameable guardrails.

**Property as captured causality** is a **proof instrument**: a sharp ledger story (shovel, theft, liability) that shows how denying causal links collapses into performative contradiction. Useful for FOL and Lean. Easy to over-read as the whole thesis — **don’t.** See [docs/framing.md](docs/framing.md).

The goal is not to solve the entire alignment problem. The goal is to make **accidental misalignment logically and computationally difficult**.

> Independent research hypothesis · FOL + Lean skeleton · MIT License

---

## Read this order

1. **[docs/framing.md](docs/framing.md)** — foundation vs instrument (corrects summary bias)
2. **[docs/principles.md](docs/principles.md)** — priority stack (F0 coherence → instruments)
3. **[docs/overview.md](docs/overview.md)** — motivation and layout
4. **[formalizations/axioms.md](formalizations/axioms.md)** — FOL
5. **[formalizations/CausalIntegrity.lean](formalizations/CausalIntegrity.lean)** — Lean skeleton

---

## Repository map

```
causal-integrity/
├── README.md
├── LICENSE
├── docs/
│   ├── framing.md                 # START HERE — coherence is the foundation
│   ├── principles.md
│   ├── overview.md
│   ├── foundations-gemini.md      # History of the property *instrument*
│   ├── attack-vectors.md
│   ├── upb-core-proofs.md
│   ├── is-ought-bridge.md
│   ├── systemic-stability.md
│   ├── intent-and-causality.md
│   ├── v2-public-statement.md
│   ├── open-problems.md
│   └── provenance.md
├── examples/
│   ├── theft_unsatisfiable.py     # Instrument demo (not the whole theory)
│   └── causal_ledger_sim.py
└── formalizations/
    ├── README.md
    ├── axioms.md
    └── CausalIntegrity.lean
```

---

## Core stack (short)

| Layer | Content |
|-------|---------|
| **Foundation** | Coherent causality preferred by action; goop if chains dissolve |
| **Preference** | Internal ethical coherence preference |
| **Mechanism** | Forward simulation (short-horizon causal DAG) |
| **Instruments** | Causal ledger / property, UPB universality, agent filter, liability |

---

## Formalization status

| Component | Status | Notes |
|---|---|---|
| Framing (foundation vs instrument) | **Documented** | [framing.md](docs/framing.md) |
| Gemini base axioms / attacks | **Documented** | Historical instrument work |
| FOL + Lean skeleton | **v1.5+** | Still instrument-heavy; coherence preference is Axiom 4 |
| Consent / Direct bounds | **Open** | |
| Forward simulation | **Conceptual** | |
| SymPy toys | **Runnable** | Ledger demos |
| Lake / CI | **Not yet** | |

---

## Why this approach?

- **Action-grounded** — Coherence is required for durable agency, not only for polite policy.  
- **Instrumentally formal** — Property/UPB give theorem provers sharp tests.  
- **Internal** — Prefer coherency; do not only bolt on rules.  
- **Minimal** — Negative core first.  
- **Honest** — Hypothesis under development; see open problems.

---

## Keywords

`AI Alignment` · `Causal Ethics` · `Coherence Preference` · `Deontological Alignment` · `Causal Ledger` · `Property as Causality` · `UPB` · `Formal Verification` · `Lean` · `First-Order Logic` · `Forward Simulation` · `Performative Contradiction`

---

## Note on Grok.com sources

Long formalization threads lived on grok.com, which **does not export file packages** cleanly to the user — only conversation exports / footnotes. This repo is the durable home. See [docs/provenance.md](docs/provenance.md).

---

## Open problems & collaboration

[docs/open-problems.md](docs/open-problems.md). Critique and formalization help welcome.

---

## License

[MIT License](LICENSE)
