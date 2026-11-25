# Abstract: Causal Integrity

**Research question:** Can the causal commitments implicit in purposeful action ground consistent ethical restraints for AI agents?

**Repository:** https://github.com/NetworkYum/causal-integrity
**Status:** Independent research hypothesis. `formalizations/` holds a constructive Lean 4 v2.1 model (`CausalIntegrityV2`: zero custom axioms, zero `sorry`). The full ethical argument is not machine-proven, and real-world deployment remains open. MIT License.
**Primary conceptual reference:** [CONCEPTS.md](CONCEPTS.md).

## Summary

Causal Integrity begins with the dependence of purposeful action on causal regularity. An agent attempting to change the world, including by communicating, relies on actions being able to produce effects. A categorical denial of that relationship undermines the means used to offer the denial. Actual causal contributions must also remain attributable: if Bob punches Sam, Bob's preference cannot erase his contribution to Sam's being struck. In this foundational argument, “ownership” means causal attribution, before questions of exclusive property rights.

The author proposes a further connection to ethics: an agent cannot consistently rely on agency, preference pursuit, and attribution for its own claims while selectively discarding those same relationships when affecting others. Role-universalizability and performative contradiction provide the proposed consistency test. [Section 5 of the conceptual reference](CONCEPTS.md#5-preferences-and-role-universalization) develops three additions to this test: universalization over action types rather than momentary preferences, demonstrated preference (conduct reveals the rule the actor relies on), and trust collapse (rejecting morality as a principle forfeits appeal to its protection). The move from reliance on causality to obligations toward other agents remains the central philosophical claim to develop and test.

The intended application is an AI that wants to embody a coherent ethical framework and evaluates proposed actions against foreseeable prohibited harms, including engineered indirect effects. The immediate scope is negative duties rather than unlimited obligations to prevent harm. Formal verification and causal prediction are intended tools for fulfilling that internal commitment. They are not implemented end-to-end here.

## Reading the evidence

- **Foundation:** purposeful action relies on causal relationships; accurate attribution cannot change merely to suit an actor's interests.
- **Conditional consistency result:** a justification based solely on a shared property cannot support an exception based solely on identity.
- **Central hypothesis:** the requirements of agency supply ethical restraints respecting other agents.
- **Formal artifacts:** `CausalIntegrityV2` (v2.1) machine-checks consequences of constructive definitions and explicit modeling premises: permanent historical attribution separated from transferable stewardship, bodily inalienability, delegation-scoped consent, caretaker/competition boundaries, bijective renaming invariance, predictive horizon symmetry, action-type and risk-rule universalizability checks, an executable `allow | reject | escalate` gate, and 20 concrete scenarios. It does not prove the complete ethical bridge.
- **Additional hypothesis:** internal goal dissonance and self-collapse, discussed separately in [systemic stability](systemic-stability.md).

## Read next

1. [Conceptual reference](CONCEPTS.md): **primary conceptual reference** for the intended argument, including Section 5 (role-universalization over action types, demonstrated preference, and trust collapse).
2. [README](../README.md): the complete introduction and status distinctions.
3. [Framing](framing.md): action, attribution, preferences, and the proposed bridge.
4. [Is/ought bridge](is-ought-bridge.md): conditional reasoning and remaining proof obligations.
5. [Open problems](open-problems.md) and [definition of done](definition-of-done.md).
6. [Formalization status](../formalizations/README.md): constructive Lean 4 v2.1 model. Machine-proven consequences are distinct from modeling premises. The superseded v1 axiomatic sketch is in [archive/formalizations-v1/](../archive/formalizations-v1/).

Superseded earlier-model drafts are in [archive/](../archive/README.md) and are not authoritative. Use the conceptual reference and the introduction above to distinguish the intended foundation from those implementation attempts.

## Intellectual lineage and citation

Related philosophical and technical work includes Kantian universalization, Alan Gewirth's Principle of Generic Consistency (*Reason and Morality*), demonstrated preference (Mises/Rothbard), estoppel proportionality (Kinsella), structural actual causality (Halpern & Pearl), goal-directed systems across scales (Michael Levin and collaborators), and Stefan Molyneux's *Universally Preferable Behaviour* as background study material on universalizable preference and performative contradiction. This is independent research, without implied affiliation or endorsement. See [CITATION.cff](../CITATION.cff).

**Keywords:** AI alignment, machine ethics, causal attribution, agency, performative contradiction, role universalizability, demonstrated preference, negative duties, ethical consistency, formal verification, Lean, causal reasoning.
