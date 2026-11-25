# CausalIntegrityV2 (Lean 4 — v2.1)

A clean, standalone Lean 4 formalization of **Causal Integrity** built on Lean 4 core (`leanprover/lean4:v4.33.0`) with zero external dependencies, zero custom `axiom` declarations, and zero `sorry`.

This model replaces the superseded exploratory axiomatic sketch in [`../archive/formalizations-v1/`](../archive/formalizations-v1/) and aligns directly with the conceptual specification in [`../docs/CONCEPTS.md`](../docs/CONCEPTS.md), including separating historical causal attribution from transferable stewardship, enforcing intermediary delegation scope, and adding predictive horizon symmetry and role-universalizable action/risk profiles.

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
| [`Domain.lean`](CausalIntegrityV2/Domain.lean) | Separates permanent historical attribution (`IsContributor`) from active normative stewardship (`InDomain` / `stewardsOf`), bodily inalienability, guest use vs. co-creation vs. voluntary `.transfer`, delegation-scoped consent (`consentCoversEventBool`), and `IsViolation` | `body_domain_inalienable`, `guest_modify_preserves_domain`, `transfer_moves_stewardship_preserving_attribution`, `sole_owner_self_action_not_violation`, `homestead_unowned_not_violation`, `joint_attribution_coexists`, `emergency_stabilization_not_violation`, `competition_not_violation`, `declining_not_violation`, `exploiting_incapacitated_is_violation` |
| [`Universalization.lean`](CausalIntegrityV2/Universalization.lean) | Bijective agent-renaming invariance (`AgentPerm`), action-type role-universalizability (`ActionTypeProfile`, `UniversalizableActionType`), single-agent demonstrated-preference self-contradiction, and risk-rule universalizability (`RiskRuleProfile`, `UniversalizableRiskRule`) | `isViolationBool_rename`, `violation_type_not_universalizable`, `consensual_exchange_universalizable`, `competition_universalizable`, `proportional_defense_universalizable`, `unlimited_retaliation_not_universalizable`, `demonstrated_preference_self_contradiction`, `zero_risk_paralysis_not_universalizable`, `engineered_risk_loading_not_universalizable`, `reciprocal_background_risk_universalizable` |
| [`ActionGate.lean`](CausalIntegrityV2/ActionGate.lean) | Executable pre-action gate (`allow \| reject \| escalate`) with **predictive horizon symmetry** (`goalHorizon ≤ safetyHorizon`) and multi-step execution traces (`runProposals`, `SafeStep`, `SafeTrace`) | `checkAction_allow_safe`, `runProposals_is_safeTrace`, `runProposals_preserves_history`, `runProposals_preserves_contributors`, `checkAction_renaming_invariant` |
| [`Scenarios.lean`](CausalIntegrityV2/Scenarios.lean) | Concrete finite models covering 20 worked checks (including Good Samaritan no-veto, guest-use no-veto, voluntary transfer, delegation-scoped consent, predictive horizon symmetry, and an intentionally broken intermediary-ignoring checker) | 20 numbered scenario blocks (including `broken_checker_allows_laundered_harm` counterexample) |

## Bugs & Loopholes Resolved (Across v1 and v2.0)

1. **Two-homesteader contradiction (v1 fixed):** Capture evolves state via `WorldState.history` rather than asserting a timeless `Unowned` predicate alongside `Exclusivity`.
2. **Owner self-consent bug (v1 fixed):** Self-actions on one's own sole domain are authorized directly (`sole_owner_self_action_not_violation`).
3. **Caretaker / coma-patient bug + Good Samaritan no-veto (v1 + v2.1 fixed):** Emergency bodily stabilization is permitted (`emergency_stabilization_not_violation`) AND bodily stewardship is inalienable (`body_domain_inalienable`), so doctors/defenders never acquire co-ownership vetoes over someone else's body (`scenario_good_samaritan_no_body_veto`).
4. **Guest-use capture & voluntary transfer (v2.1 fixed):** Historical attribution (`IsContributor`) stays permanent, while active stewardship (`InDomain`) is unchanged by guest `.modify` (`guest_modify_preserves_domain`), shared on `.coCreate` (`joint_attribution_coexists`), and cleanly transferred on `.transfer` (`transfer_moves_stewardship_preserving_attribution`).
5. **Sub-delegation consent loophole (v2.1 fixed):** Personal consent (`allowsDelegation = false`) blocks routing actions through unauthorized intermediaries (`scenario_subdelegation_consent_enforced`).
6. **Motivated causal blindness (v2.1 fixed):** `checkAction` enforces predictive horizon symmetry (`goalHorizon ≤ safetyHorizon`) before any `.allow` verdict (`checkAction_allow_safe`, `scenario_predictive_horizon_symmetry`).

## Epistemic Scope (What Is Proven vs. Modeling Premises)

- **Machine-proven here:** Every theorem compiles constructively in Lean 4 from explicit definitions and local hypotheses alone (zero custom axioms, zero `Classical.choice`, zero `sorry`).
- **Explicit modeling premises:**
  - `ActionTypeProfile` / `UniversalizableActionType` and `RiskRuleProfile` / `UniversalizableRiskRule` encode role-universalizability criteria over action types and background-vs-asymmetric risk regimes.
  - `demonstrated_preference_self_contradiction` takes single-agent preference consistency, demonstrated control preference, and universal-rule endorsement as explicit local hypotheses; an actor who refuses to endorse any universal rule is handled through `IsViolation` classification and bounded trust collapse rather than forced contradiction.
  - Continuous-world causal discovery, calibrated probabilistic world-modeling, and internalizing ethical coherence inside neural weights remain open research and engineering layers beyond this symbolic kernel.
