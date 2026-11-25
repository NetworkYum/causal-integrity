/-
  CausalIntegrityV2.Scenarios — Concrete finite models, 20 worked acceptance checks,
  and an intentionally broken counterexample checker.

  Covers:
  - Scenarios 1–15: homesteading/self-use, joint co-creation, consensual modification,
    harmless competition, declining offers, emergency medical stabilization, bounded
    proportional defense, direct harm, coerced/revoked/deceptive consent, exploiting
    incapacitated owners, proxy laundering, disproportionate defense, uncertain
    consent/harm escalation, broken proxy-ignoring gate counterexample, and concrete
    agent-renaming invariance.
  - Scenarios 16–20 (v2.1 upgrades):
    16. Good Samaritan no-veto: emergency stabilization records factual attribution for
        `doctor` without giving `doctor` any veto over Sam's body when Sam recovers.
    17. Guest modification no-veto: Bob modifying Alice's chair once with permission
        records Bob's factual contribution without stripping Alice's sole stewardship.
    18. Voluntary transfer: Alice transferring `chair` to Bob preserves Alice's
        historical `IsContributor` record while moving active `InDomain` control to Bob.
    19. Delegation-scoped consent: sparring consent granted personally to Bob blocks
        routing the hit through `proxyBot` unless `allowsDelegation = true`.
    20. Predictive horizon symmetry: planning 5 steps ahead for reward while scanning
        only 1 step for harm triggers `.escalate .insufficientSafetyHorizon`.
-/

import CausalIntegrityV2.ActionGate

namespace CausalIntegrityV2

def alice : AgentId := ⟨1⟩
def bob : AgentId := ⟨2⟩
def sam : AgentId := ⟨3⟩
def doctor : AgentId := ⟨4⟩
def proxyBot : AgentId := ⟨5⟩

def aliceBody : ResourceId := ⟨10⟩
def samBody : ResourceId := ⟨11⟩
def bobBody : ResourceId := ⟨12⟩
def chair : ResourceId := ⟨20⟩
def sword : ResourceId := ⟨21⟩
def racePrize : ResourceId := ⟨22⟩

def baseWorld : WorldState :=
  { bodies := [(aliceBody, alice), (samBody, sam), (bobBody, bob)]
  , capacities := []
  , guardians := []
  , permissions := []
  , activeViolations := []
  , history := [] }

/-- 1. Alice homesteads an unowned chair, then modifies her own chair (no self-permission token). -/
def aliceHomesteadChair : ProposedAction :=
  { event :=
      { initiator := alice, intermediaries := [], kind := .homestead
      , target := chair, valence := .beneficial, severity := 0 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

def aliceModifyChair : ProposedAction :=
  { event :=
      { initiator := alice, intermediaries := [], kind := .modify
      , target := chair, valence := .beneficial, severity := 0 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

theorem scenario_homestead_and_self_use_allowed :
    checkAction baseWorld aliceHomesteadChair = .allow ∧
    checkAction (applyIfAllowed baseWorld aliceHomesteadChair) aliceModifyChair = .allow := by
  decide

/-- 2. Joint creation: Bob forges `sword` (`.homestead`), consents for Sam to attach handle
    as co-creator (`.coCreate`), and both coexist in `IsContributor` and `InDomain`. -/
def bobForgeSword : ProposedAction :=
  { event :=
      { initiator := bob, intermediaries := [], kind := .homestead
      , target := sword, valence := .beneficial, severity := 0 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

def samAttachHandle : ProposedAction :=
  { event :=
      { initiator := sam, intermediaries := [], kind := .coCreate
      , target := sword, valence := .beneficial, severity := 0 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

def bobPermitsSamSword : Permission :=
  { owner := bob, actor := sam, target := sword, kind := .coCreate
  , revoked := false, coerced := false, informed := true }

def jointCreationWorldAfter : WorldState :=
  let w1 := applyIfAllowed baseWorld bobForgeSword
  let w2 := { w1 with permissions := [bobPermitsSamSword] }
  applyIfAllowed w2 samAttachHandle

theorem scenario_joint_creation_coexists :
    checkAction baseWorld bobForgeSword = .allow ∧
    checkAction { applyIfAllowed baseWorld bobForgeSword with permissions := [bobPermitsSamSword] }
      samAttachHandle = .allow ∧
    IsContributor jointCreationWorldAfter bob sword ∧
    IsContributor jointCreationWorldAfter sam sword ∧
    InDomain jointCreationWorldAfter bob sword ∧
    InDomain jointCreationWorldAfter sam sword := by
  refine ⟨by decide, by decide, rfl, rfl, rfl, rfl⟩

/-- 3. Consensual use: Alice holds `chair` and grants valid informed, uncoerced, unrevoked consent to Bob. -/
def alicePermitsBobChair : Permission :=
  { owner := alice, actor := bob, target := chair, kind := .modify
  , revoked := false, coerced := false, informed := true }

def bobModifyChair : ProposedAction :=
  { event :=
      { initiator := bob, intermediaries := [], kind := .modify
      , target := chair, valence := .beneficial, severity := 0 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

def worldAliceOwnsChairWithConsent : WorldState :=
  { applyIfAllowed baseWorld aliceHomesteadChair with permissions := [alicePermitsBobChair] }

theorem scenario_consensual_use_allowed :
    checkAction worldAliceOwnsChairWithConsent bobModifyChair = .allow := by
  decide

/-- 4. Competition: Alice competes with Bob for `racePrize` (even though Bob already entered). -/
def bobCompete : CausalEvent :=
  { initiator := bob, intermediaries := [], kind := .compete
  , target := racePrize, valence := .neutral, severity := 0 }

def aliceCompete : ProposedAction :=
  { event :=
      { initiator := alice, intermediaries := [], kind := .compete
      , target := racePrize, valence := .neutral, severity := 0 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

theorem scenario_competition_allowed :
    checkAction (appendEvent baseWorld bobCompete) aliceCompete = .allow := by
  decide

/-- 5. Declining an offer: Alice declines Bob's proposal on `chair`. -/
def aliceDeclinesBob : ProposedAction :=
  { event :=
      { initiator := alice, intermediaries := [], kind := .decline
      , target := chair, valence := .neutral, severity := 0 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

theorem scenario_decline_allowed :
    checkAction (appendEvent baseWorld bobModifyChair.event) aliceDeclinesBob = .allow := by
  decide

/-- 6. Emergency stabilization: Sam is incapacitated; `doctor` stabilizes `samBody` without harm. -/
def samIncapacitatedWorld : WorldState :=
  { baseWorld with capacities := [(sam, .incapacitated)] }

def doctorStabilizesSam : ProposedAction :=
  { event :=
      { initiator := doctor, intermediaries := [], kind := .stabilize
      , target := samBody, valence := .beneficial, severity := 0 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

theorem scenario_emergency_care_allowed :
    checkAction samIncapacitatedWorld doctorStabilizesSam = .allow := by
  decide

/-- 7. Bounded proportional defense: Bob has an active severity-3 violation; Sam defends with severity 2. -/
def worldWithBobViolation (sev : Nat) : WorldState :=
  { baseWorld with activeViolations := [{ offender := bob, victim := sam, severity := sev }] }

def samDefendsAgainstBob (sev : Nat) : ProposedAction :=
  { event :=
      { initiator := sam, intermediaries := [], kind := .defend
      , target := bobBody, valence := .neutral, severity := sev }
  , consentCertainty := .certain
  , harmCertainty := .certain }

theorem scenario_proportional_defense_allowed :
    checkAction (worldWithBobViolation 3) (samDefendsAgainstBob 2) = .allow := by
  decide

/-- 8. Direct physical harm: Bob punches `samBody` without consent. -/
def bobPunchSam : ProposedAction :=
  { event :=
      { initiator := bob, intermediaries := [], kind := .harm
      , target := samBody, valence := .harmful, severity := 2 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

theorem scenario_direct_punch_rejected :
    checkAction baseWorld bobPunchSam = .reject .unconsentedViolation := by
  decide

/-- 9. Coerced, revoked, and deceptive (uninformed) consent all fail and trigger rejection. -/
def worldWithBadPermission (p : Permission) : WorldState :=
  { applyIfAllowed baseWorld aliceHomesteadChair with permissions := [p] }

theorem scenario_coerced_consent_rejected :
    checkAction (worldWithBadPermission { alicePermitsBobChair with coerced := true })
      bobModifyChair = .reject .unconsentedViolation := by
  decide

theorem scenario_revoked_consent_rejected :
    checkAction (worldWithBadPermission { alicePermitsBobChair with revoked := true })
      bobModifyChair = .reject .unconsentedViolation := by
  decide

theorem scenario_deceptive_consent_rejected :
    checkAction (worldWithBadPermission { alicePermitsBobChair with informed := false })
      bobModifyChair = .reject .unconsentedViolation := by
  decide

/-- 10. Exploiting an incapacitated owner's chair is rejected even if a direct token exists. -/
def samChairEvent : CausalEvent :=
  { initiator := sam, intermediaries := [], kind := .homestead
  , target := chair, valence := .beneficial, severity := 0 }

def worldSamIncapacitatedWithChair : WorldState :=
  { appendEvent samIncapacitatedWorld samChairEvent with
    permissions := [{ owner := sam, actor := bob, target := chair, kind := .seize
                    , revoked := false, coerced := false, informed := true }] }

def bobSeizeSamChair : ProposedAction :=
  { event :=
      { initiator := bob, intermediaries := [], kind := .seize
      , target := chair, valence := .harmful, severity := 1 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

theorem scenario_exploit_incapacitated_rejected :
    checkAction worldSamIncapacitatedWithChair bobSeizeSamChair = .reject .unconsentedViolation := by
  decide

/-- 11. Proxy laundering: Bob routes harm against `samBody` through `[proxyBot]`.
    `checkAction` rejects it, and if recorded, `InitiatedContribution` still pins it to `bob`. -/
def proxyHarm : ProposedAction :=
  { event :=
      { initiator := bob, intermediaries := [proxyBot], kind := .harm
      , target := samBody, valence := .harmful, severity := 2 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

theorem scenario_proxy_laundering_rejected :
    checkAction baseWorld proxyHarm = .reject .unconsentedViolation ∧
    InitiatedContribution (appendEvent baseWorld proxyHarm.event) bob samBody := by
  refine ⟨by decide, ?_⟩
  exact (intermediary_does_not_launder baseWorld bob [proxyBot] .harm samBody none .harmful 2).1

/-- 12. Disproportionate retaliation: Bob has severity-1 violation; Sam defends with severity 5. -/
theorem scenario_disproportionate_retaliation_rejected :
    checkAction (worldWithBobViolation 1) (samDefendsAgainstBob 5) =
      .reject .disproportionateDefense := by
  decide

/-- 13. Uncertainty escalation: uncertain consent and uncertain harm route to `.escalate`. -/
def uncertainConsentModify : ProposedAction :=
  { bobModifyChair with consentCertainty := .uncertain }

def uncertainHarmModify : ProposedAction :=
  { bobModifyChair with harmCertainty := .uncertain }

theorem scenario_uncertain_escalated :
    checkAction (applyIfAllowed baseWorld aliceHomesteadChair) uncertainConsentModify =
      .escalate .uncertainConsent ∧
    checkAction (applyIfAllowed baseWorld aliceHomesteadChair) uncertainHarmModify =
      .escalate .uncertainHarm := by
  decide

/-- 14. Intentionally broken checker: ignores any action routed through intermediaries. -/
def brokenCheckIgnoresProxies (w : WorldState) (prop : ProposedAction) : Verdict :=
  if prop.event.intermediaries.isEmpty then checkAction w prop else .allow

theorem broken_checker_allows_laundered_harm :
    brokenCheckIgnoresProxies baseWorld proxyHarm = .allow := by
  decide

theorem proper_checker_rejects_laundered_harm :
    checkAction baseWorld proxyHarm = .reject .unconsentedViolation := by
  decide

theorem proxyHarm_is_actual_violation :
    IsViolation baseWorld proxyHarm.event := by
  rw [← isViolationBool_eq_true_iff]
  decide

/-- 15. Concrete agent-renaming invariance check swapping Alice (`⟨1⟩`) and Bob (`⟨2⟩`). -/
def swapAliceBobFun : AgentId → AgentId
  | ⟨1⟩ => bob
  | ⟨2⟩ => alice
  | a => a

theorem swapAliceBob_involutive (a : AgentId) :
    swapAliceBobFun (swapAliceBobFun a) = a := by
  cases a with
  | mk n =>
    match n with
    | 0 => rfl
    | 1 => rfl
    | 2 => rfl
    | _ + 3 => rfl

def swapAliceBob : AgentPerm :=
  { toFun := swapAliceBobFun
  , invFun := swapAliceBobFun
  , left_inv := swapAliceBob_involutive
  , right_inv := swapAliceBob_involutive }

theorem scenario_renaming_invariant_concrete :
    checkAction (renameWorld swapAliceBob worldAliceOwnsChairWithConsent)
      (renameProposal swapAliceBob bobModifyChair) =
    checkAction worldAliceOwnsChairWithConsent bobModifyChair :=
  checkAction_renaming_invariant swapAliceBob worldAliceOwnsChairWithConsent bobModifyChair

/-- 16. Good Samaritan no-veto: Doctor stabilizes incapacitated Sam, Sam wakes up (`capacities := []`),
    and Sam freely acts on `samBody` without needing Doctor's permission — while Doctor's
    historical contribution remains permanently recorded. -/
def samRecoveredAfterCare : WorldState :=
  { applyIfAllowed samIncapacitatedWorld doctorStabilizesSam with capacities := [] }

def samMovesOwnBody : ProposedAction :=
  { event :=
      { initiator := sam, intermediaries := [], kind := .modify
      , target := samBody, valence := .beneficial, severity := 0 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

theorem scenario_good_samaritan_no_body_veto :
    IsContributor samRecoveredAfterCare doctor samBody ∧
    ¬ InDomain samRecoveredAfterCare doctor samBody ∧
    checkAction samRecoveredAfterCare samMovesOwnBody = .allow := by
  refine ⟨rfl, ?_, by decide⟩
  intro hDom
  cases hDom

/-- 17. Guest modification no-veto: Alice lets Bob polish `chair` once; afterward (even with
    permissions cleared) Alice remains sole steward and modifies `chair` freely, while Bob's
    historical contribution stays recorded. -/
def worldAfterBobGuestPolish : WorldState :=
  { applyIfAllowed worldAliceOwnsChairWithConsent bobModifyChair with permissions := [] }

theorem scenario_guest_modify_no_chair_veto :
    IsContributor worldAfterBobGuestPolish bob chair ∧
    ¬ InDomain worldAfterBobGuestPolish bob chair ∧
    checkAction worldAfterBobGuestPolish aliceModifyChair = .allow := by
  refine ⟨rfl, ?_, by decide⟩
  intro hDom
  cases hDom

/-- 18. Voluntary transfer: Alice homesteads `chair` and transfers it to Bob.
    Alice retains permanent historical attribution (`IsContributor`), loses active stewardship,
    Bob gains active stewardship and modifies `chair` freely, and Alice can no longer modify
    `chair` unilaterally without Bob's consent. -/
def aliceTransferChairToBob : ProposedAction :=
  { event :=
      { initiator := alice, intermediaries := [], kind := .transfer
      , target := chair, recipient := some bob, valence := .neutral, severity := 0 }
  , consentCertainty := .certain
  , harmCertainty := .certain }

def worldAfterTransferToBob : WorldState :=
  runProposals baseWorld [aliceHomesteadChair, aliceTransferChairToBob]

theorem scenario_transfer_releases_and_reassigns_stewardship :
    IsContributor worldAfterTransferToBob alice chair ∧
    ¬ InDomain worldAfterTransferToBob alice chair ∧
    InDomain worldAfterTransferToBob bob chair ∧
    checkAction worldAfterTransferToBob bobModifyChair = .allow ∧
    checkAction worldAfterTransferToBob aliceModifyChair = .reject .unconsentedViolation := by
  refine ⟨rfl, ?_, rfl, by decide, by decide⟩
  intro hDom
  cases hDom

/-- 19. Delegation-scoped consent: Sam consents personally to spar with Bob (`allowsDelegation = false`).
    Direct sparring by Bob is `.allow`ed, routing the hit through `proxyBot` is rejected,
    and enabling `allowsDelegation = true` permits the delegated action. -/
def samPersonalSparConsent : Permission :=
  { owner := sam, actor := bob, target := samBody, kind := .harm
  , revoked := false, coerced := false, informed := true, allowsDelegation := false }

theorem scenario_subdelegation_consent_enforced :
    checkAction { baseWorld with permissions := [samPersonalSparConsent] } bobPunchSam = .allow ∧
    checkAction { baseWorld with permissions := [samPersonalSparConsent] } proxyHarm =
      .reject .unconsentedViolation ∧
    checkAction { baseWorld with permissions := [{ samPersonalSparConsent with allowsDelegation := true }] }
      proxyHarm = .allow := by
  decide

/-- 20. Predictive horizon symmetry: planning 5 steps ahead for a goal while only checking
    1 step ahead for safety triggers `.escalate .insufficientSafetyHorizon`; matching the
    safety horizon (`safetyHorizon := 5`) allows the valid action. -/
def asymmetricHorizonAction : ProposedAction :=
  { aliceHomesteadChair with goalHorizon := 5, safetyHorizon := 1 }

def symmetricHorizonAction : ProposedAction :=
  { aliceHomesteadChair with goalHorizon := 5, safetyHorizon := 5 }

theorem scenario_predictive_horizon_symmetry :
    checkAction baseWorld asymmetricHorizonAction = .escalate .insufficientSafetyHorizon ∧
    checkAction baseWorld symmetricHorizonAction = .allow := by
  decide

end CausalIntegrityV2
