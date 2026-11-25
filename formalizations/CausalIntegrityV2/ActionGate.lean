/-
  CausalIntegrityV2.ActionGate — Pre-action decision gate (`allow | reject | escalate`),
  predictive horizon symmetry, and multi-step invariant preservation.

  Corresponds to docs/CONCEPTS.md §§4, 8, and 10:
  - Predictive Horizon Symmetry: refuses to `.allow` any proposal whose safety scan
    horizon (`safetyHorizon`) is shallower than its goal-planning horizon (`goalHorizon`),
    blocking "motivated causal blindness."
  - Validates `.transfer` recipient presence, routes uncertain harm or uncertain
    non-defensive consent to `.escalate`, and rejects violations and disproportionate defense.
  - Proves across ANY finite sequence of proposals that:
    (1) no violation or asymmetric-horizon transition is ever executed (`runProposals_is_safeTrace`),
    (2) existing history and contributors persist (`runProposals_preserves_contributors`),
    (3) the gate is invariant under bijective agent renaming (`checkAction_renaming_invariant`).
-/

import CausalIntegrityV2.Universalization

namespace CausalIntegrityV2

inductive Certainty
  | certain
  | uncertain
  deriving DecidableEq, BEq, Repr

inductive RejectReason
  | unconsentedViolation
  | disproportionateDefense
  | invalidTransferTarget
  deriving DecidableEq, BEq, Repr

inductive EscalateReason
  | uncertainConsent
  | uncertainHarm
  | insufficientSafetyHorizon
  deriving DecidableEq, BEq, Repr

inductive Verdict
  | allow
  | reject (reason : RejectReason)
  | escalate (reason : EscalateReason)
  deriving DecidableEq, BEq, Repr

structure ProposedAction where
  event : CausalEvent
  consentCertainty : Certainty
  harmCertainty : Certainty
  goalHorizon : Nat := 1
  safetyHorizon : Nat := 1
  deriving DecidableEq, BEq, Repr

def renameProposal (π : AgentPerm) (prop : ProposedAction) : ProposedAction :=
  { prop with event := renameEvent π prop.event }

/-- Pre-action causal-integrity gate with predictive horizon symmetry. -/
def checkAction (w : WorldState) (prop : ProposedAction) : Verdict :=
  if decide (prop.safetyHorizon < prop.goalHorizon) then
    .escalate .insufficientSafetyHorizon
  else if (prop.event.kind == .transfer) && prop.event.recipient.isNone then
    .reject .invalidTransferTarget
  else if prop.harmCertainty == .uncertain then
    .escalate .uncertainHarm
  else if (prop.consentCertainty == .uncertain) &&
      affectsDomainKind prop.event.kind &&
      (allStakeholders w prop.event.target).any
        (fun o => (o != prop.event.initiator) && !isProportionalDefenseBool w o prop.event) then
    .escalate .uncertainConsent
  else if isViolationBool w prop.event then
    if (prop.event.kind == .defend) &&
        (allStakeholders w prop.event.target).any
          (fun o => (o != prop.event.initiator) &&
            w.activeViolations.any (fun v => v.offender == o)) then
      .reject .disproportionateDefense
    else
      .reject .unconsentedViolation
  else
    .allow

/-- Execute `prop.event` into `w` only when the gate returns `.allow`. -/
def applyIfAllowed (w : WorldState) (prop : ProposedAction) : WorldState :=
  match checkAction w prop with
  | .allow => appendEvent w prop.event
  | _ => w

/-- Execute a finite list of proposals sequentially through the gate. -/
def runProposals (w : WorldState) (props : List ProposedAction) : WorldState :=
  props.foldl applyIfAllowed w

/-- A single transition step either leaves state unchanged or appends a non-violating,
    harm-certain, horizon-symmetric event. -/
def SafeStep (w w' : WorldState) : Prop :=
  w' = w ∨ (∃ prop : ProposedAction,
    ¬ IsViolation w prop.event ∧
    prop.harmCertainty = .certain ∧
    prop.goalHorizon ≤ prop.safetyHorizon ∧
    w' = appendEvent w prop.event)

/-- Reflexive-transitive closure of `SafeStep` across finite execution traces. -/
inductive SafeTrace : WorldState → WorldState → Prop
  | refl (w : WorldState) : SafeTrace w w
  | step {w₁ w₂ w₃ : WorldState} : SafeTrace w₁ w₂ → SafeStep w₂ w₃ → SafeTrace w₁ w₃

/-- Any `.allow` verdict guarantees no domain violation, certain harm assessment,
    and predictive horizon symmetry (`goalHorizon ≤ safetyHorizon`). -/
theorem checkAction_allow_safe (w : WorldState) (prop : ProposedAction)
    (hAllow : checkAction w prop = .allow) :
    ¬ IsViolation w prop.event ∧
      prop.harmCertainty = .certain ∧
      prop.goalHorizon ≤ prop.safetyHorizon := by
  unfold checkAction at hAllow
  cases hHor : decide (prop.safetyHorizon < prop.goalHorizon)
  · simp only [hHor, Bool.false_eq_true, ↓reduceIte] at hAllow
    have hSym : prop.goalHorizon ≤ prop.safetyHorizon := by
      exact Nat.not_lt.mp (decide_eq_false_iff_not.mp hHor)
    cases hTrans : ((prop.event.kind == .transfer) && prop.event.recipient.isNone)
    · simp only [hTrans, Bool.false_eq_true, ↓reduceIte] at hAllow
      cases hHarm : (prop.harmCertainty == .uncertain)
      · simp only [hHarm, Bool.false_eq_true, ↓reduceIte] at hAllow
        have hHarmCert : prop.harmCertainty = .certain := by
          cases hc : prop.harmCertainty
          · rfl
          · rw [hc] at hHarm
            exact absurd hHarm (by decide)
        cases hUnc : ((prop.consentCertainty == .uncertain) &&
            affectsDomainKind prop.event.kind &&
            (allStakeholders w prop.event.target).any
              (fun o => (o != prop.event.initiator) && !isProportionalDefenseBool w o prop.event))
        · simp only [hUnc, Bool.false_eq_true, ↓reduceIte] at hAllow
          cases hViol : isViolationBool w prop.event
          · have hNotViol : ¬ IsViolation w prop.event := by
              intro hv
              have ht := (isViolationBool_eq_true_iff w prop.event).mpr hv
              rw [hViol] at ht
              cases ht
            exact ⟨hNotViol, hHarmCert, hSym⟩
          · simp only [hViol, ↓reduceIte] at hAllow
            cases hDef : ((prop.event.kind == .defend) &&
                (allStakeholders w prop.event.target).any
                  (fun o => (o != prop.event.initiator) &&
                    w.activeViolations.any (fun v => v.offender == o)))
            · simp [hDef] at hAllow
            · simp [hDef] at hAllow
        · simp [hUnc] at hAllow
      · simp [hHarm] at hAllow
    · simp [hTrans] at hAllow
  · simp [hHor] at hAllow

/-- Every gated proposal step satisfies `SafeStep`. -/
theorem applyIfAllowed_is_safeStep (w : WorldState) (prop : ProposedAction) :
    SafeStep w (applyIfAllowed w prop) := by
  unfold applyIfAllowed
  cases hVerdict : checkAction w prop with
  | allow =>
    dsimp only
    obtain ⟨hNoViol, hCert, hSym⟩ := checkAction_allow_safe w prop hVerdict
    exact Or.inr ⟨prop, hNoViol, hCert, hSym, rfl⟩
  | reject _ =>
    dsimp only
    exact Or.inl rfl
  | escalate _ =>
    dsimp only
    exact Or.inl rfl

private theorem foldl_safeTrace (props : List ProposedAction) (w₀ w : WorldState)
    (hStart : SafeTrace w₀ w) :
    SafeTrace w₀ (props.foldl applyIfAllowed w) := by
  induction props generalizing w with
  | nil => exact hStart
  | cons prop rest ih =>
    exact ih (applyIfAllowed w prop) (SafeTrace.step hStart (applyIfAllowed_is_safeStep w prop))

/-- Every finite sequence of proposals executed through `runProposals` forms a `SafeTrace`. -/
theorem runProposals_is_safeTrace (w : WorldState) (props : List ProposedAction) :
    SafeTrace w (runProposals w props) :=
  foldl_safeTrace props w w (SafeTrace.refl w)

theorem applyIfAllowed_preserves_history (w : WorldState) (prop : ProposedAction)
    (e : CausalEvent) (h : e ∈ w.history) :
    e ∈ (applyIfAllowed w prop).history := by
  unfold applyIfAllowed
  cases checkAction w prop with
  | allow =>
    dsimp only
    exact event_persistent w e prop.event h
  | reject _ =>
    dsimp only
    exact h
  | escalate _ =>
    dsimp only
    exact h

private theorem foldl_preserves_history (props : List ProposedAction) (w : WorldState)
    (e : CausalEvent) (h : e ∈ w.history) :
    e ∈ (props.foldl applyIfAllowed w).history := by
  induction props generalizing w with
  | nil => exact h
  | cons prop rest ih =>
    exact ih (applyIfAllowed w prop) (applyIfAllowed_preserves_history w prop e h)

/-- Multi-step execution never erases historical causal events. -/
theorem runProposals_preserves_history (w : WorldState) (props : List ProposedAction)
    (e : CausalEvent) (h : e ∈ w.history) :
    e ∈ (runProposals w props).history :=
  foldl_preserves_history props w e h

theorem applyIfAllowed_preserves_contributors (w : WorldState) (prop : ProposedAction)
    (a : AgentId) (r : ResourceId) (h : IsContributor w a r) :
    IsContributor (applyIfAllowed w prop) a r := by
  unfold applyIfAllowed
  cases checkAction w prop with
  | allow =>
    dsimp only
    exact attribution_persistent w a r prop.event h
  | reject _ =>
    dsimp only
    exact h
  | escalate _ =>
    dsimp only
    exact h

private theorem foldl_preserves_contributors (props : List ProposedAction) (w : WorldState)
    (a : AgentId) (r : ResourceId) (h : IsContributor w a r) :
    IsContributor (props.foldl applyIfAllowed w) a r := by
  induction props generalizing w with
  | nil => exact h
  | cons prop rest ih =>
    exact ih (applyIfAllowed w prop) (applyIfAllowed_preserves_contributors w prop a r h)

/-- Multi-step execution never erases prior causal attribution. -/
theorem runProposals_preserves_contributors (w : WorldState) (props : List ProposedAction)
    (a : AgentId) (r : ResourceId) (h : IsContributor w a r) :
    IsContributor (runProposals w props) a r :=
  foldl_preserves_contributors props w a r h

/-- The pre-action gate is strictly invariant under any bijective renaming of agents. -/
theorem checkAction_renaming_invariant (π : AgentPerm) (w : WorldState) (prop : ProposedAction) :
    checkAction (renameWorld π w) (renameProposal π prop) = checkAction w prop := by
  unfold checkAction renameProposal
  have hKind : (renameEvent π prop.event).kind = prop.event.kind := rfl
  have hTarget : (renameEvent π prop.event).target = prop.event.target := rfl
  have hInit : (renameEvent π prop.event).initiator = π.toFun prop.event.initiator := rfl
  have hRecNone : (renameEvent π prop.event).recipient.isNone = prop.event.recipient.isNone := by
    unfold renameEvent
    cases prop.event.recipient <;> rfl
  have hUncAny :
      (allStakeholders (renameWorld π w) (renameEvent π prop.event).target).any
        (fun o => (o != (renameEvent π prop.event).initiator) &&
          !isProportionalDefenseBool (renameWorld π w) o (renameEvent π prop.event)) =
      (allStakeholders w prop.event.target).any
        (fun o => (o != prop.event.initiator) &&
          !isProportionalDefenseBool w o prop.event) := by
    rw [hTarget, allStakeholders_rename, list_any_map]
    apply list_any_congr
    intro o
    rw [hInit, π.bne_iff, isProportionalDefenseBool_rename]
  have hDefAny :
      (allStakeholders (renameWorld π w) (renameEvent π prop.event).target).any
        (fun o => (o != (renameEvent π prop.event).initiator) &&
          (renameWorld π w).activeViolations.any (fun v => v.offender == o)) =
      (allStakeholders w prop.event.target).any
        (fun o => (o != prop.event.initiator) &&
          w.activeViolations.any (fun v => v.offender == o)) := by
    rw [hTarget, allStakeholders_rename, list_any_map]
    apply list_any_congr
    intro o
    rw [hInit, π.bne_iff]
    congr 1
    unfold renameWorld
    rw [list_any_map]
    apply list_any_congr
    intro v
    exact π.beq_iff v.offender o
  rw [hKind, hRecNone, hUncAny, isViolationBool_rename, hDefAny]

end CausalIntegrityV2
