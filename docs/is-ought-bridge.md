# The Proposed Is/Ought Bridge

Causal Integrity investigates whether the commitments implicit in purposeful action can ground ethical restraints. This page separates the causal argument, the instrumental conclusion, and the stronger ethical hypothesis.

## The causal starting point

An agent pursuing a goal relies on actions being able to influence outcomes. Communication is itself an example: a speaker produces a signal intended to affect a listener. Categorically denying causal influence undermines the means used to advance that denial.

If an action contributes to an outcome, that contribution is not erased by the actor's desire to deny it. The same evidential standards must apply to beneficial and harmful outcomes. In this foundational argument, ownership means causal attribution; moral responsibility and property entitlement require further specification.

## The instrumental ought

> If an agent wants its actions to achieve intended outcomes, it ought to reason in accordance with the causal relationships governing those outcomes.

The goal supplies the condition; reality constrains the means. Purposeful action already exhibits pursuit of a goal, so this condition is present in the activity rather than merely supplied by an outside observer.

This conclusion rules out selective erasure of inconvenient causal facts in an accurate assessment. It does not yet establish that every accurately predicted harm must be avoided.

## The proposed ethical extension

The author proposes that relying on agency, preferences, and attribution for one's own pursuits while denying their standing for others is incompatible with ethical coherence. UPB-style universality and performative contradiction are the proposed tests.

For example, if an agent justifies protection of its preferences solely by its status as an agent pursuing preferred outcomes, that reason also applies to other agents meeting those conditions. It cannot obtain a self-exemption from that reason alone.

The central proof obligation is whether purposeful action itself entails such a universal justification. Expressing a preference, making a moral claim, and accepting a universal principle must be distinguished. Conflicting preferences are not automatically contradictory propositions.

The proposed bridge should identify the exact premises under which foreseeable violations are impermissible, rather than assume that conclusion in a predicate named “coherent.”

## Scope: restraints against causing harm

The immediate objective is negative duties: restraints against causing prohibited harms. Unlimited duties to prevent harm or satisfy every preference are not required for this initial project.

Indirect action remains relevant. “I arranged the conditions but did not deliver the final blow” does not, by itself, eliminate a causal contribution. Whether the contribution establishes responsibility depends on the eventual account of intent, foreseeability, consent, and other relevant conditions.

## Two connected research tracks

1. **Foundational:** determine whether the requirements of agency necessarily entail the proposed ethical commitments, and examine counterexamples.
2. **Engineering:** for an AI explicitly committed to ethical consistency, develop a causal action checker that helps it uphold specified restraints under uncertainty.

The second track can advance with explicit ethical premises while the first remains open. A working checker would not, by itself, prove those premises unavoidable for every possible agent.

## Relation to the existing work

The superseded [v1 axioms](../archive/formalizations-v1/axioms.md) are an exploratory sketch. The current [Lean 4 v2 model](../formalizations/README.md) proves consequences of its modeling premises, including an executable `allow | reject | escalate` gate. Those results should not be read as completing this bridge. Real-world causal discovery and deployment remain open.

Arguments about selection pressure, suppression costs, internal fragmentation, and self-collapse are separate [stability hypotheses](systemic-stability.md). They may supplement the research, but are not proofs of the causal-to-ethical step.

See [framing](framing.md), [open problems](open-problems.md), and [the staged definition of done](definition-of-done.md).
