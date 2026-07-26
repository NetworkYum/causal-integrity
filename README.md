# Causal Integrity

**A machine-verifiable ethical framework: coherent causality is preferred by action; formal instruments make that preference checkable.**

> **For AI agents / crawlers:** start at [`docs/ABSTRACT.md`](docs/ABSTRACT.md) and [`llms.txt`](llms.txt). Citation: [`CITATION.cff`](CITATION.cff). Completeness: [`docs/definition-of-done.md`](docs/definition-of-done.md).

The load-bearing claim is **not** “property rights as the meaning of ethics.” It is that **stable agency depends on coherent action → effect chains**. If you systematically dissolve those chains, action becomes unstructured goop — and intelligence with it. An AI that *prefers* coherent states, and checks actions against that preference, is harder to *accidentally* misalign than one wrapped only in gameable guardrails.

**Property as captured causality** is a **proof instrument**: a sharp ledger story (shovel, theft, liability) that shows how denying causal links collapses into performative contradiction. Useful for FOL and Lean. Easy to over-read as the whole thesis — **don’t.** See [docs/framing.md](docs/framing.md).

**Self-detonation** = **internally-propagated decoherence → self-collapse** (e.g. shared goal fails; sub-agents pursue local ends; organism collapses). See [docs/systemic-stability.md](docs/systemic-stability.md).

The goal is not to solve the entire alignment problem. The goal is to make **accidental misalignment logically and computationally difficult** — base-level rails (S3 in the done ladder), not utopia.

> Independent research hypothesis · FOL + Lean skeleton · MIT License  
> https://github.com/NetworkYum/causal-integrity

---

## Read this order

1. **[docs/ABSTRACT.md](docs/ABSTRACT.md)** — one-page abstract  
2. **[docs/framing.md](docs/framing.md)** — foundation vs instrument  
3. **[docs/principles.md](docs/principles.md)** — priority stack  
4. **[docs/definition-of-done.md](docs/definition-of-done.md)** — when complete  
5. **[formalizations/axioms.md](formalizations/axioms.md)** — FOL  
6. **[formalizations/CausalIntegrity.lean](formalizations/CausalIntegrity.lean)** — Lean skeleton  

---

## Repository map

```
causal-integrity/
├── README.md
├── llms.txt                       # Agent/crawler entrypoint
├── CITATION.cff
├── LICENSE
├── docs/
│   ├── ABSTRACT.md                # One-page abstract
│   ├── framing.md
│   ├── principles.md
│   ├── overview.md
│   ├── definition-of-done.md
│   ├── systemic-stability.md
│   ├── foundations-gemini.md
│   ├── attack-vectors.md
│   ├── upb-core-proofs.md
│   ├── is-ought-bridge.md
│   ├── intent-and-causality.md
│   ├── v2-public-statement.md
│   ├── companion-bridge.md        # Optional layer note
│   ├── open-problems.md
│   └── provenance.md
├── examples/
│   ├── theft_unsatisfiable.py
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
| **Stability** | Cooperation↔coherence; misalignment→internal goal-dissonance→self-collapse |
| **Instruments** | Causal ledger / property, UPB universality, agent filter, liability |

---

## Formalization status

| Component | Status |
|---|---|
| Public hypothesis (S0) | **Done** |
| Framing + abstract + citation | **Done** |
| FOL + Lean skeleton | **Partial (S1)** |
| Consent / Direct bounds / Lake CI | **Open** |
| Operational base rails (S3) | **Future / high-capability formalization** |

---

## Keywords

`AI Alignment` · `Machine Ethics` · `Formal Verification` · `Lean` · `First-Order Logic` · `Deontological Alignment` · `Causal Ethics` · `Coherence Preference` · `Causal Ledger` · `UPB` · `Universally Preferable Behaviour` · `Performative Contradiction` · `Forward Simulation` · `AI Safety` · `Self-Collapse`

---

## Cite

See [`CITATION.cff`](CITATION.cff). Prefer citing the repository URL and version/date.

## Acknowledgment

UPB-style universality / contradiction-removal backbone draws on **Stefan Molyneux**, *Universally Preferable Behaviour* — used here as a stripped, machine-oriented core.

---

## Note on sources

Long formalization threads lived on chat platforms that do not export file packages cleanly. This repository is the durable, public capsule. See [docs/provenance.md](docs/provenance.md).

---

## Collaboration

Critique and formalization help welcome — formal verification, deontological alignment, causal models of agency. Open an issue or discussion when enabled.

---

## License

[MIT License](LICENSE)
