# Abstract: Causal Integrity

**Research question:** Can the causal commitments implicit in purposeful action ground consistent ethical restraints for AI agents?

**Repository:** https://github.com/NetworkYum/causal-integrity
**Status:** Independent research hypothesis with exploratory FOL and Lean 4 artifacts. The full ethical argument is not machine-proven. MIT License.

## Summary

Causal Integrity begins with the dependence of purposeful action on causal regularity. An agent attempting to change the world, including by communicating, relies on actions being able to produce effects. A categorical denial of that relationship undermines the means used to offer the denial. Actual causal contributions must also remain attributable: if Bob punches Sam, Bob's preference cannot erase his contribution to Sam's being struck. In this foundational argument, “ownership” means causal attribution, before questions of exclusive property rights.

The author proposes a further connection to ethics: an agent cannot consistently rely on agency, preference pursuit, and attribution for its own claims while selectively discarding those same relationships when affecting others. UPB-style universality and performative contradiction, drawing on Stefan Molyneux's *Universally Preferable Behaviour*, provide the proposed consistency test. The move from reliance on causality to obligations toward other agents remains the central philosophical claim to develop and test.

The intended application is an AI that wants to embody a coherent ethical framework and evaluates proposed actions against foreseeable prohibited harms, including engineered indirect effects. The immediate scope is negative duties rather than unlimited obligations to prevent harm. Formal verification and causal prediction are intended tools for fulfilling that internal commitment. They are not implemented end-to-end here.

## Reading the evidence

- **Foundation:** purposeful action relies on causal relationships; accurate attribution cannot change merely to suit an actor's interests.
- **Conditional consistency result:** a justification based solely on a shared property cannot support an exception based solely on identity.
- **Central hypothesis:** the requirements of agency supply ethical restraints respecting other agents.
- **Formal artifacts:** existing Lean lemmas derive consequences of explicit axioms. They do not prove the complete ethical bridge.
- **Additional hypothesis:** internal goal dissonance and self-collapse, discussed separately in [systemic stability](systemic-stability.md).

## Read next

1. [README](../README.md): the complete introduction and status distinctions.
2. [Framing](framing.md): action, attribution, preferences, and the proposed bridge.
3. [Is/ought bridge](is-ought-bridge.md): conditional reasoning and remaining proof obligations.
4. [Open problems](open-problems.md) and [definition of done](definition-of-done.md).
5. [Formalization status](../formalizations/README.md) and [explicit axioms](../formalizations/axioms.md).

Some supporting documents retain earlier exploratory formulations; use the introduction above to distinguish the intended foundation from those implementation attempts.

## Intellectual debts and citation

Stefan Molyneux's UPB informs the universality and performative-contradiction argument. Michael Levin and collaborators' work on goal-directed systems informs the separate interest in shared goals and multi-scale coordination. This is independent research, without implied affiliation or endorsement. See [CITATION.cff](../CITATION.cff).

**Keywords:** AI alignment, machine ethics, causal attribution, agency, performative contradiction, universally preferable behaviour, negative duties, ethical consistency, formal verification, Lean, causal reasoning.
