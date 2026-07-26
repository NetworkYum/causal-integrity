# Intent & Incidental Causality

How the framework treats gray zones (butterfly effects, “I only left the poison out,” long obfuscated chains). Recovered from the formalization thread’s Tier‑1 discussions.

---

## The problem

A naïve “direct vs incidental” boolean is too weak:

- Forest-fire / butterfly-effect cases feel incidental.
- A superintelligence can construct long, indirect causal chains (proxies, environment shaping, multi-step setups) where responsibility is hard to pin to one node.

If “Direct” is a shallow flag, gray zones become exploit surface.

---

## The poison example (user contribution)

> “I simply created poison and left it sitting out in convenient places that would increase the likelihood of causing damage.”

**Reply that advanced the framework:** that framing **ignores intent**. To intend harm and take actions that raise the probability of a ledger-violating outcome still fails universality: the agent cannot coherently prefer “I may set up indirect harm chains” while preferring not to be on the receiving end of such chains.

So gray-zone *exploitation* is not automatically outside UPB + causal integrity; intentional construction of harm pathways is still a coherency violation.

---

## Working formal target (not finished)

Define intentional / teleological contribution roughly as:

1. The agent **foresaw** (or should have under its own predictive model) a path to ledger violation.
2. The agent **chose** actions that **materially raised** the probability of that path.
3. The action was **not** authorized by valid consent of the affected property-holder.

Then Axiom‑3 style breaks apply not only to “hand on shovel” but to **engineered indirect paths**.

### Still open (honest)

| Gap | Why it matters |
|-----|----------------|
| Computable foreseeability thresholds | Superintelligence-scale prediction horizons |
| Contribution % / causal graph cuts | Avoid infinite butterfly liability |
| Deniability vs malice markers | Adversarial agents will muddy intent |
| Shared sub-agent intent | MoE / tool chains |

See [open-problems.md](open-problems.md) — **Intent + causal contribution** is Tier 1 alongside consent.

---

## Relation to forward simulation

The **Internal Ethical Coherence Preference + forward DAG** is the operational answer:

- Do not only classify the last physical contact.
- Simulate own-action effects several steps out.
- Reject paths with material risk of axiom violation, including intentional indirect setups.

This is why Principle 6 is not optional polish; it is how intent-sensitive gray zones get checked in practice.
