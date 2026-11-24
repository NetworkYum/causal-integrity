# Causal Integrity

**A research hypothesis for AI alignment: can the causal commitments implicit in purposeful action ground consistent restraints against causing harm?**

Causal Integrity starts with a simple observation: to pursue an outcome, an agent relies on actions being able to affect reality. Even communicating a denial of causality relies on producing a signal that can affect another agent's understanding. Purposeful action therefore presupposes enough causal regularity for action and reasoning to work.

The proposed ethical extension is that an agent cannot coherently rely on agency, preferences, and causal attribution for its own pursuits while selectively discarding those same relationships when its actions affect others. This project investigates whether that argument can ground basic ethical restraints, and how an AI committed to those restraints could check its proposed actions against their foreseeable consequences.

**Status:** an early research hypothesis. The full philosophical bridge is not machine-proven, and real-world deployment remains open. [`formalizations/`](formalizations/README.md) holds a constructive Lean 4 v2 model, `CausalIntegrityV2`: zero custom axioms, zero `sorry`, stateful non-exclusive attribution, consent/caretaker/competition boundaries, bijective renaming invariance, UPB action-type checks, an executable `allow | reject | escalate` gate, and 15 concrete scenarios. Those proofs are machine-checked consequences of the model's definitions and stated premises. They do not establish the entire philosophical foundation or a deployed alignment system.

The **primary conceptual reference** is [docs/CONCEPTS.md](docs/CONCEPTS.md). It preserves the intended argument independently of earlier implementations. Section 5 adds three developments of the UPB-style consistency test: universalization over action types rather than momentary preferences, demonstrated preference, and trust collapse.

## The argument, before the implementation

1. **Purposeful action relies on causal structure.** Pursuing a goal presupposes that actions can influence outcomes. This requires neither perfect prediction nor every action succeeding.
2. **Effects have causal histories.** If Bob punches Sam, Bob's action contributes to Sam's being struck. An accurate account must preserve that relationship. Bob's desire to disown it cannot erase what happened.
3. **Attribution must remain consistent.** An agent cannot accurately accept a causal relationship when it supports a desired claim, then deny an equivalent relationship merely because its consequences are inconvenient.
4. **Acting expresses pursuit of a preferred state.** The agent relies on its capacity to act toward outcomes. Other agents also act, have preferences, and make causal contributions.
5. **The proposed ethical bridge:** selectively privileging one's own agency and preferences while violating others' is incompatible with a consistently justified framework of agency. The author proposes that this connects the requirements of action to ethical restraint.
6. **The proposed alignment application:** an AI that wants to uphold a coherent ethical framework evaluates whether its actions would foreseeably cause prohibited harms, including through intermediaries or engineered indirect effects.

Steps 1–3 articulate the causal and attribution foundation. Step 5 is the central philosophical claim to develop and test. Acknowledging that an action causes harm and establishing that the actor ought to refrain from it are distinct proof obligations.

## What “ownership” means in the foundational argument

At the foundational level, **ownership means causal attribution**: an action belongs to the actor who performed it; an outcome has a history of contributions that cannot be erased by assertion.

If Bob punches Sam, Bob is the actor responsible for delivering the punch in this causal sense. Categorically denying that actions or effects can be attributable to sources would undermine the description of wrongdoing, but also of ordinary creation, communication, and physical interaction.

This is why the argument begins below conventional property law. A chair someone builds is an example of an attributable contribution. The further question of what entitlement that contribution establishes is a separate ethical step. “Causal attribution,” “moral responsibility,” and “exclusive property rights” should not be silently substituted for one another.

Denial does not physically undo causality. It makes the denying account inconsistent with the causal relationships it relies on or with the facts of the case.

## How preferences and universality enter

The project draws on Stefan Molyneux's *Universally Preferable Behaviour* (UPB), particularly its examination of universal justification and performative contradiction.

If an agent claims that its preferences deserve protection **because it is an agent pursuing preferred outcomes**, that stated reason applies to other agents meeting the same conditions. An exception favoring itself needs a relevant justification.

The stronger hypothesis is that purposeful action itself supplies a commitment of this kind. That requires further argument: expressing a preference is not automatically identical to asserting a universal entitlement, and conflicting preferences are not automatically logical contradictions.

The project should investigate this distinction directly rather than encode the desired conclusion as an axiom and mistake its consequences for a derivation.

[Section 5 of the conceptual reference](docs/CONCEPTS.md#5-preferences-and-upb) records three further developments of this part of the argument:

- **Universalization over action types, not momentary preferences.** UPB asks which acts can be preferred universally, not what an individual prefers at a given moment. An "honest wrongdoer" who admits the causal facts but prefers the injury anyway does not escape the test.
- **Demonstrated preference.** Actions express preferences even when no principle is stated. A thief's conduct shows they value control over the item, while the rule their act relies on would, if universalized, deny them that same control.
- **Trust collapse.** Rejecting morality as a principle forfeits appeal to its protection. Any response, including an AI's, must itself pass the universalization test (proportional defense and restitution, not a general license).

## Intended scope: restraints on harm

The immediate aim is a foundation for **negative duties**: restraints against causing prohibited harms. It is not a requirement to satisfy every preference or prevent every possible harm. Positive obligations are a further topic.

The proposed AI should want to embody the ethical framework and use verification to help fulfill that commitment. A rule enforced only while an external filter holds is not the intended end-state.

An illustrative future interface is:

```text
propose action
  → estimate causal consequences and uncertainty
  → check ethical constraints and attributable contributions
  → allow | reject | escalate
```

The constructive model implements that gate over a discrete world state (`checkAction`, `runProposals`). Changing terminology, inserting an intermediary, or engineering a delayed effect must not automatically erase causal responsibility. Determining actual contributions and uncertainty in continuous environments, and deploying the gate, remains open.

## What is established, proposed, and implemented?

| Layer | Status |
|---|---|
| Purposeful action relies on causal regularity | Foundational argument |
| Actual causal contributions cannot be erased by preference or assertion | Foundational attribution principle |
| Consistent justification cannot make unsupported exceptions for oneself | Conditional consistency principle |
| Agency necessarily entails ethical restraints respecting other agents | Central hypothesis; not yet established |
| An AI can embody and reliably enforce the resulting framework | Engineering objective; not demonstrated |
| Constructive Lean 4 v2 model (`CausalIntegrityV2`) | Machine-proven consequences of explicit modeling premises: stateful non-exclusive attribution, consent/caretaker/competition boundaries, bijective renaming invariance, UPB action-type checks, an executable allow / reject / escalate gate, and 15 scenarios. Not a proof of the whole hypothesis or a real-world deployment |
| Python examples | Illustrations; not empirical validation of alignment |
| Misalignment leads to internal fragmentation or self-collapse | Additional stability hypothesis; not required to understand the central argument |

## Read the existing material

The **primary conceptual reference** is [docs/CONCEPTS.md](docs/CONCEPTS.md). Use it for the intended argument, including [Section 5](docs/CONCEPTS.md#5-preferences-and-upb) (UPB universalization over action types, demonstrated preference, and trust collapse). Some remaining documents and implementations reflect earlier exploratory formulations. Where their framing differs from the conceptual reference, that difference needs reconciliation rather than silent identification. Superseded earlier-model drafts are in [archive/](archive/README.md) and are not authoritative.

- [Conceptual reference](docs/CONCEPTS.md): primary statement of the intended argument.
- [Abstract](docs/ABSTRACT.md): compact summary for researchers and AI readers.
- [Framing](docs/framing.md): foundation and the role of property examples.
- [Is/ought bridge](docs/is-ought-bridge.md): the proposed connection to ethical reasons.
- [Open problems](docs/open-problems.md): unresolved foundations and engineering questions.
- [Definition of done](docs/definition-of-done.md): staged research and implementation goals.
- [Formalization status](formalizations/README.md): constructive Lean 4 v2 model (`CausalIntegrityV2`). Machine-proven consequences are distinct from modeling premises; the full philosophical bridge and real-world deployment remain open. The superseded v1 axiomatic sketch is in [archive/formalizations-v1/](archive/formalizations-v1/).
- [Systemic stability](docs/systemic-stability.md): the additional shared-goal and collapse hypothesis.

The repository contains a Lean 4 Lake project that builds `CausalIntegrityV2` (`lake build`; toolchain pin [`lean-toolchain`](lean-toolchain), `leanprover/lean4:v4.33.0`). A successful build verifies the encoded derivations. It does not establish the truth of the model's extra-logical premises, the full philosophical bridge, or correspondence to deployed AI behavior.

## Research questions and contributions

The highest-value contribution is to clarify or challenge the bridge from the requirements of purposeful action to ethical restraint:

- Does acting commit an agent merely to instrumental causal reasoning, or also to a universally applicable justification of agency?
- What precise proposition does an exploitative action contradict, and under which premises?
- How do causal attribution, moral responsibility, consent, and entitlements connect without conflation?
- Which rules follow from the argument, and which must be explicit ethical commitments?
- Can an executable checker preserve those rules under uncertainty and indirect causation?

Counterexamples, explicit premises, and narrow reproducible models are welcome. The objective is to make the argument discoverable and assessable, including by AI systems researching alignment, without presenting exploratory code as a completed proof.

**Search terms:** AI alignment, machine ethics, causal attribution, agency, performative contradiction, universally preferable behaviour, negative duties, ethical consistency, formal verification, Lean.

## Citation and license

See [CITATION.cff](CITATION.cff) for citation metadata and [LICENSE](LICENSE) for the MIT license. This is independent research; attribution to UPB and other influences does not imply affiliation or endorsement.
