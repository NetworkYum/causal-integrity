# CausalIntegrityV2 (Lean 4)

A clean, standalone Lean 4 formalization of **Causal Integrity** built on Lean 4 core (`leanprover/lean4:v4.33.0`) with zero external dependencies, zero custom `axiom` declarations, and zero `sorry`.

This v2 model replaces the superseded exploratory axiomatic sketch in [`../archive/formalizations-v1/`](../archive/formalizations-v1/) and aligns directly with the conceptual specification in [`../docs/CONCEPTS.md`](../docs/CONCEPTS.md).

The library root is [`CausalIntegrityV2.lean`](CausalIntegrityV2.lean).

## Build & Verify

From the repository root:

```bash
lake build
```

Toolchain: [`../lean-toolchain`](../lean-toolchain). CI: [`.github/workflows/lean.yml`](../.github/workflows/lean.yml).

## Module Overview

| Module | What it formalizes | Key machine-checked results |
|---|---|---|
| [`Attribution.lean`](CausalIntegrityV2/Attribution.lean) | Stateful, append-only, non-exclusive causal history (`CausalEvent`, `WorldState`, `IsContributor`, `InitiatedContribution`) | `attribution_persistent`, `attribution_persistent_multi`, `intermediary_does_not_launder`, `credit_blame_symmetry` |
| [`Domain.lean`](CausalIntegrityV2/Domain.lean) | Separates causal attribution from attributed domain (`InDomain`), consent validity (`isCapableBool`, guardian proxy, emergency stabilization, unrevoked/uncoerced/informed checks), and `IsViolation` | `sole_owner_self_action_not_violation`, `homestead_unowned_not_violation`, `joint_attribution_coexists`, `emergency_stabilization_not_violation`, `competition_not_violation`, `declining_not_violation`, `exploiting_incapacitated_is_violation` |
| [`Universalization.lean`](CausalIntegrityV2/Universalization.lean) | Bijective agent-renaming invariance (`AgentPerm`), UPB action-type universalizability (`ActionTypeProfile`, `UniversallyPreferable`), and single-agent demonstrated-preference self-contradiction | `isViolationBool_rename`, `violation_type_fails_upb`, `consensual_exchange_passes_upb`, `competition_passes_upb`, `proportional_defense_passes_upb`, `unlimited_retaliation_fails_upb`, `demonstrated_preference_self_contradiction` |
| [`ActionGate.lean`](CausalIntegrityV2/ActionGate.lean) | Executable pre-action gate (`allow \| reject \| escalate`) and multi-step execution traces (`runProposals`, `SafeStep`, `SafeTrace`) | `checkAction_allow_safe`, `runProposals_is_safeTrace`, `runProposals_preserves_history`, `runProposals_preserves_contributors`, `checkAction_renaming_invariant` |
| [`Scenarios.lean`](CausalIntegrityV2/Scenarios.lean) | Concrete finite models covering allowed, rejected, escalated, and renaming checks plus an intentionally broken intermediary-ignoring checker | 15 numbered scenario blocks (including `broken_checker_allows_laundered_harm` counterexample) |

## How v1 Bugs Are Resolved

1. **Two-homesteader contradiction (fixed):** Capture appends an event to `WorldState.history` rather than asserting a timeless `Unowned` predicate alongside `Exclusivity`.
2. **Owner self-consent bug (fixed):** Self-actions on one's own sole domain are authorized directly (`sole_owner_self_action_not_violation`).
3. **Caretaker / coma-patient bug (fixed):** Incapacitated principals still cannot issue direct consent (`incapacitated_no_direct_consent`), while guardian proxy consent and non-harmful emergency bodily stabilization are explicitly permitted (`emergency_stabilization_not_violation`).
4. **Joint creation vs. exclusivity (fixed):** Multiple contributors coexist in `IsContributor` and `InDomain` (`joint_attribution_coexists`).
5. **Consistency & non-vacuity (verified):** Instead of global `axiom`s, everything is defined constructively over `WorldState` and exercised on concrete finite instances with allowed, rejected, and escalated actions.

## Epistemic Scope (What Is Proven vs. Modeling Premises)

- **Machine-proven here:** Every theorem compiles in Lean 4 from constructive definitions and local hypotheses alone, proving consistency, attribution persistence, intermediary non-laundering, credit/blame valence invariance, bijective agent-renaming invariance, and multi-step `SafeTrace` preservation for the `checkAction` gate.
- **Explicit modeling premises:**
  - `ActionTypeProfile` / `UniversallyPreferable` encodes the UPB action-type criterion (overriding another's domain preference is non-universalizable outside bounded proportional defense; unbounded retaliation fails).
  - `demonstrated_preference_self_contradiction` takes single-agent preference consistency, demonstrated control preference, and universal-rule endorsement as explicit theorem hypotheses; an actor who refuses to endorse any universal rule is handled through `IsViolation` classification and bounded trust collapse rather than forced contradiction.
  - Real-world causal discovery, foreseeability over continuous environments, and internalizing values inside neural agents remain open deployment challenges outside this discrete symbolic model.
