/-
  CausalIntegrityV2.Universalization — Conditional universality, UPB action-type
  universalizability, demonstrated-preference self-contradiction, and UPB risk rules.

  Corresponds to docs/CONCEPTS.md §§5, 7, and 10:
  1. Bijective Agent-Renaming Invariance: swapping agent IDs leaves stewardship,
     delegation-aware consent, proportional defense, and violation classification
     identical — blocking identity-only exceptions.
  2. UPB Universalizability over Action Types: tests action-type role profiles,
     not momentary desires; non-consensual violation and unbounded retaliation fail,
     while consensual exchange, competition, and bounded proportional defense pass.
  3. Demonstrated Preference Self-Contradiction: explicit single-agent P ∧ ¬P
     given single-agent preference consistency, demonstrated control preference,
     and endorsement of a universal seizure rule.
  4. UPB Risk-Rule Universalizability: resolves probabilistic physical/digital risk
     without utilitarianism — zero-risk paralysis fails (abolishes agency), engineered
     asymmetric risk-loading fails, and reciprocal background risk with strict causal
     liability passes.
-/

import CausalIntegrityV2.Domain

namespace CausalIntegrityV2

/-- Bijective permutation over agent identifiers. -/
structure AgentPerm where
  toFun : AgentId → AgentId
  invFun : AgentId → AgentId
  left_inv : ∀ a, invFun (toFun a) = a
  right_inv : ∀ a, toFun (invFun a) = a

namespace AgentPerm

theorem injective (π : AgentPerm) {a b : AgentId} (h : π.toFun a = π.toFun b) : a = b := by
  have h1 := congrArg π.invFun h
  rw [π.left_inv, π.left_inv] at h1
  exact h1

@[simp] theorem beq_iff (π : AgentPerm) (a b : AgentId) :
    (π.toFun a == π.toFun b) = (a == b) := by
  cases hab : (a == b)
  · cases hπ : (π.toFun a == π.toFun b)
    · rfl
    · have heq : a = b := π.injective ((agentId_beq_iff (π.toFun a) (π.toFun b)).mp hπ)
      have htrue : (a == b) = true := (agentId_beq_iff a b).mpr heq
      rw [htrue] at hab
      cases hab
  · have heq : a = b := (agentId_beq_iff a b).mp hab
    rw [heq]
    exact (agentId_beq_iff (π.toFun b) (π.toFun b)).mpr rfl

@[simp] theorem bne_iff (π : AgentPerm) (a b : AgentId) :
    (π.toFun a != π.toFun b) = (a != b) := by
  simp [bne, π.beq_iff]

end AgentPerm

theorem list_any_congr {α : Type} (l : List α) (p q : α → Bool)
    (h : ∀ x, p x = q x) :
    l.any p = l.any q := by
  induction l with
  | nil => rfl
  | cons x xs ih => simp [List.any_cons, h x, ih]

theorem list_all_congr {α : Type} (l : List α) (p q : α → Bool)
    (h : ∀ x, p x = q x) :
    l.all p = l.all q := by
  induction l with
  | nil => rfl
  | cons x xs ih => simp [List.all_cons, h x, ih]

def renamePermission (π : AgentPerm) (p : Permission) : Permission :=
  { p with owner := π.toFun p.owner, actor := π.toFun p.actor }

def renameViolation (π : AgentPerm) (v : ActiveViolation) : ActiveViolation :=
  { v with offender := π.toFun v.offender, victim := π.toFun v.victim }

def renameEvent (π : AgentPerm) (e : CausalEvent) : CausalEvent :=
  { e with
    initiator := π.toFun e.initiator
    intermediaries := e.intermediaries.map π.toFun
    recipient := e.recipient.map π.toFun }

def renameWorld (π : AgentPerm) (w : WorldState) : WorldState :=
  { bodies := w.bodies.map (fun p => (p.1, π.toFun p.2))
  , capacities := w.capacities.map (fun p => (π.toFun p.1, p.2))
  , guardians := w.guardians.map (fun p => (π.toFun p.1, π.toFun p.2))
  , permissions := w.permissions.map (renamePermission π)
  , activeViolations := w.activeViolations.map (renameViolation π)
  , history := w.history.map (renameEvent π) }

@[simp] theorem isBodyOfBool_rename (π : AgentPerm) (w : WorldState)
    (a : AgentId) (r : ResourceId) :
    isBodyOfBool (renameWorld π w) (π.toFun a) r = isBodyOfBool w a r := by
  unfold isBodyOfBool renameWorld
  rw [list_any_map]
  apply list_any_congr
  intro p
  simp [π.beq_iff]

@[simp] theorem isBodyResourceBool_rename (π : AgentPerm) (w : WorldState) (r : ResourceId) :
    isBodyResourceBool (renameWorld π w) r = isBodyResourceBool w r := by
  unfold isBodyResourceBool renameWorld
  rw [list_any_map]

@[simp] theorem eventInvolves_rename (π : AgentPerm) (a : AgentId) (e : CausalEvent) :
    eventInvolves (π.toFun a) (renameEvent π e) = eventInvolves a e := by
  unfold eventInvolves renameEvent
  simp only [list_any_map, π.beq_iff]

@[simp] theorem isContributorBool_rename (π : AgentPerm) (w : WorldState)
    (a : AgentId) (r : ResourceId) :
    isContributorBool (renameWorld π w) (π.toFun a) r = isContributorBool w a r := by
  unfold isContributorBool renameWorld
  rw [list_any_map]
  apply list_any_congr
  intro e
  have hTarget : (renameEvent π e).target = e.target := rfl
  simp [hTarget, eventInvolves_rename]

private theorem bodyStakeholders_rename (π : AgentPerm)
    (bodies : List (ResourceId × AgentId)) (r : ResourceId) :
    bodyStakeholders (bodies.map (fun p => (p.1, π.toFun p.2))) r =
      (bodyStakeholders bodies r).map π.toFun := by
  induction bodies with
  | nil => rfl
  | cons p rest ih =>
    rcases p with ⟨r', a⟩
    simp only [List.map_cons, bodyStakeholders]
    cases (r' == r) <;> simp [ih]

private theorem filter_neq_rename (π : AgentPerm) (l : List AgentId) (x : AgentId) :
    (l.map π.toFun).filter (fun a => a != π.toFun x) =
      (l.filter (fun a => a != x)).map π.toFun := by
  induction l with
  | nil => rfl
  | cons a rest ih =>
    simp only [List.map_cons, List.filter_cons, π.bne_iff]
    cases (a != x) <;> simp [ih]

private theorem stepStewards_rename (π : AgentPerm) (cur : List AgentId)
    (e : CausalEvent) (r : ResourceId) :
    stepStewards (cur.map π.toFun) (renameEvent π e) r =
      (stepStewards cur e r).map π.toFun := by
  unfold stepStewards renameEvent
  cases (e.target == r)
  · simp
  · simp only [↓reduceIte]
    cases e.kind <;> cases e.recipient <;> simp [filter_neq_rename]

private theorem historyStewards_rename (π : AgentPerm)
    (history : List CausalEvent) (r : ResourceId) (cur : List AgentId) :
    historyStewards (history.map (renameEvent π)) r (cur.map π.toFun) =
      (historyStewards history r cur).map π.toFun := by
  induction history generalizing cur with
  | nil => rfl
  | cons e rest ih =>
    simp only [List.map_cons, historyStewards]
    rw [stepStewards_rename, ih]

theorem stewardsOf_rename (π : AgentPerm) (w : WorldState) (r : ResourceId) :
    stewardsOf (renameWorld π w) r = (stewardsOf w r).map π.toFun := by
  unfold stewardsOf
  rw [isBodyResourceBool_rename]
  cases isBodyResourceBool w r
  · simp only [Bool.false_eq_true, ↓reduceIte]
    exact historyStewards_rename π w.history r []
  · simp only [↓reduceIte]
    exact bodyStakeholders_rename π w.bodies r

theorem allStakeholders_rename (π : AgentPerm) (w : WorldState) (r : ResourceId) :
    allStakeholders (renameWorld π w) r = (allStakeholders w r).map π.toFun :=
  stewardsOf_rename π w r

@[simp] theorem inDomainBool_rename (π : AgentPerm) (w : WorldState)
    (a : AgentId) (r : ResourceId) :
    inDomainBool (renameWorld π w) (π.toFun a) r = inDomainBool w a r := by
  unfold inDomainBool
  rw [stewardsOf_rename, list_any_map]
  apply list_any_congr
  intro x
  exact π.beq_iff x a

@[simp] theorem isIncapacitatedBool_rename (π : AgentPerm) (w : WorldState) (a : AgentId) :
    isIncapacitatedBool (renameWorld π w) (π.toFun a) = isIncapacitatedBool w a := by
  unfold isIncapacitatedBool renameWorld
  rw [list_any_map]
  apply list_any_congr
  intro p
  simp [π.beq_iff]

@[simp] theorem isCapableBool_rename (π : AgentPerm) (w : WorldState) (a : AgentId) :
    isCapableBool (renameWorld π w) (π.toFun a) = isCapableBool w a := by
  unfold isCapableBool
  rw [isIncapacitatedBool_rename]

@[simp] theorem hasValidDirectConsentBool_rename (π : AgentPerm) (w : WorldState)
    (owner actor : AgentId) (r : ResourceId) (k : ActionKind) (needDel : Bool) :
    hasValidDirectConsentBool (renameWorld π w) (π.toFun owner) (π.toFun actor) r k needDel =
      hasValidDirectConsentBool w owner actor r k needDel := by
  unfold hasValidDirectConsentBool
  rw [isCapableBool_rename]
  congr 1
  change (w.permissions.map (renamePermission π)).any
    (permissionMatchesBool (π.toFun owner) (π.toFun actor) r k needDel) = _
  rw [list_any_map]
  apply list_any_congr
  intro p
  simp [permissionMatchesBool, renamePermission, π.beq_iff]

@[simp] theorem hasGuardianConsentBool_rename (π : AgentPerm) (w : WorldState)
    (owner actor : AgentId) (r : ResourceId) (k : ActionKind) (needDel : Bool) :
    hasGuardianConsentBool (renameWorld π w) (π.toFun owner) (π.toFun actor) r k needDel =
      hasGuardianConsentBool w owner actor r k needDel := by
  unfold hasGuardianConsentBool
  rw [isIncapacitatedBool_rename]
  congr 1
  change (w.guardians.map (fun p => (π.toFun p.1, π.toFun p.2))).any _ = _
  rw [list_any_map]
  apply list_any_congr
  intro g
  simp only [π.beq_iff]
  rw [hasValidDirectConsentBool_rename]

@[simp] theorem actorAuthorizedByOwnerBool_rename (π : AgentPerm) (w : WorldState)
    (owner actor : AgentId) (r : ResourceId) (k : ActionKind) (needDel : Bool) :
    actorAuthorizedByOwnerBool (renameWorld π w) (π.toFun owner) (π.toFun actor) r k needDel =
      actorAuthorizedByOwnerBool w owner actor r k needDel := by
  unfold actorAuthorizedByOwnerBool
  rw [π.beq_iff, hasValidDirectConsentBool_rename, hasGuardianConsentBool_rename]

@[simp] theorem consentCoversEventBool_rename (π : AgentPerm) (w : WorldState)
    (owner : AgentId) (e : CausalEvent) :
    consentCoversEventBool (renameWorld π w) (π.toFun owner) (renameEvent π e) =
      consentCoversEventBool w owner e := by
  unfold consentCoversEventBool
  have hInit : (renameEvent π e).initiator = π.toFun e.initiator := rfl
  have hInter : (renameEvent π e).intermediaries = e.intermediaries.map π.toFun := rfl
  have hTarget : (renameEvent π e).target = e.target := rfl
  have hKind : (renameEvent π e).kind = e.kind := rfl
  rw [hInit, hInter, hTarget, hKind,
      actorAuthorizedByOwnerBool_rename, actorAuthorizedByOwnerBool_rename, list_all_map]
  congr 2
  apply list_all_congr
  intro m
  exact actorAuthorizedByOwnerBool_rename π w owner m e.target e.kind false

@[simp] theorem isEmergencyStabilizationBool_rename (π : AgentPerm) (w : WorldState)
    (owner : AgentId) (e : CausalEvent) :
    isEmergencyStabilizationBool (renameWorld π w) (π.toFun owner) (renameEvent π e) =
      isEmergencyStabilizationBool w owner e := by
  unfold isEmergencyStabilizationBool
  have hTarget : (renameEvent π e).target = e.target := rfl
  have hKind : (renameEvent π e).kind = e.kind := rfl
  have hVal : (renameEvent π e).valence = e.valence := rfl
  rw [isIncapacitatedBool_rename, hTarget, isBodyOfBool_rename, hKind, hVal]

@[simp] theorem authorizedByBool_rename (π : AgentPerm) (w : WorldState)
    (owner : AgentId) (e : CausalEvent) :
    authorizedByBool (renameWorld π w) (π.toFun owner) (renameEvent π e) =
      authorizedByBool w owner e := by
  unfold authorizedByBool
  rw [consentCoversEventBool_rename, isEmergencyStabilizationBool_rename]
  have hInit : (renameEvent π e).initiator = π.toFun e.initiator := rfl
  rw [hInit, π.beq_iff]

@[simp] theorem isProportionalDefenseBool_rename (π : AgentPerm) (w : WorldState)
    (owner : AgentId) (e : CausalEvent) :
    isProportionalDefenseBool (renameWorld π w) (π.toFun owner) (renameEvent π e) =
      isProportionalDefenseBool w owner e := by
  unfold isProportionalDefenseBool
  have hKind : (renameEvent π e).kind = e.kind := rfl
  have hSev : (renameEvent π e).severity = e.severity := rfl
  rw [hKind]
  congr 1
  change (w.activeViolations.map (renameViolation π)).any _ = _
  rw [list_any_map]
  apply list_any_congr
  intro v
  simp [renameViolation, hSev, π.beq_iff]

@[simp] theorem violatesOwnerBool_rename (π : AgentPerm) (w : WorldState)
    (owner : AgentId) (e : CausalEvent) :
    violatesOwnerBool (renameWorld π w) (π.toFun owner) (renameEvent π e) =
      violatesOwnerBool w owner e := by
  unfold violatesOwnerBool
  have hKind : (renameEvent π e).kind = e.kind := rfl
  have hTarget : (renameEvent π e).target = e.target := rfl
  have hInit : (renameEvent π e).initiator = π.toFun e.initiator := rfl
  rw [hKind, hTarget, hInit, inDomainBool_rename, π.bne_iff,
      authorizedByBool_rename, isProportionalDefenseBool_rename]

/-- Identity symmetry (no identity-only exceptions): permuting agent IDs preserves
    violation status identically. -/
theorem isViolationBool_rename (π : AgentPerm) (w : WorldState) (e : CausalEvent) :
    isViolationBool (renameWorld π w) (renameEvent π e) = isViolationBool w e := by
  unfold isViolationBool
  have hTarget : (renameEvent π e).target = e.target := rfl
  rw [hTarget, allStakeholders_rename, list_any_map]
  apply list_any_congr
  intro owner
  exact violatesOwnerBool_rename π w owner e

/-- Prop-level renaming invariance for `IsViolation`. -/
theorem isViolation_rename_iff (π : AgentPerm) (w : WorldState) (e : CausalEvent) :
    IsViolation (renameWorld π w) (renameEvent π e) ↔ IsViolation w e := by
  rw [← isViolationBool_eq_true_iff, ← isViolationBool_eq_true_iff, isViolationBool_rename]

/-! ### Part 2: UPB Universalizability over Action Types -/

structure ActionTypeProfile where
  affectsOtherDomain : Bool
  overridesHolderPref : Bool
  isProportionalDefense : Bool
  unboundedRetaliation : Bool
  deriving DecidableEq, BEq, Repr

def UniversallyPreferable (p : ActionTypeProfile) : Prop :=
  (p.affectsOtherDomain = true → p.overridesHolderPref = false ∨ p.isProportionalDefense = true) ∧
    p.unboundedRetaliation = false

theorem violation_type_fails_upb :
    ¬ UniversallyPreferable
      { affectsOtherDomain := true
      , overridesHolderPref := true
      , isProportionalDefense := false
      , unboundedRetaliation := false } := by
  intro ⟨hRule, _⟩
  rcases hRule rfl with h | h <;> cases h

theorem consensual_exchange_passes_upb :
    UniversallyPreferable
      { affectsOtherDomain := true
      , overridesHolderPref := false
      , isProportionalDefense := false
      , unboundedRetaliation := false } := by
  exact ⟨fun _ => Or.inl rfl, rfl⟩

theorem competition_passes_upb :
    UniversallyPreferable
      { affectsOtherDomain := false
      , overridesHolderPref := false
      , isProportionalDefense := false
      , unboundedRetaliation := false } := by
  constructor
  · intro h
    cases h
  · rfl

theorem proportional_defense_passes_upb :
    UniversallyPreferable
      { affectsOtherDomain := true
      , overridesHolderPref := true
      , isProportionalDefense := true
      , unboundedRetaliation := false } := by
  exact ⟨fun _ => Or.inr rfl, rfl⟩

theorem unlimited_retaliation_fails_upb (p : ActionTypeProfile)
    (hUnb : p.unboundedRetaliation = true) :
    ¬ UniversallyPreferable p := by
  intro ⟨_, hFalse⟩
  rw [hUnb] at hFalse
  cases hFalse

/-! ### Part 3: Demonstrated Preference Self-Contradiction -/

theorem demonstrated_preference_self_contradiction
    (Prefers : AgentId → Prop → Prop)
    (SeizedFrom : AgentId → ResourceId → Prop)
    (actor : AgentId) (r : ResourceId)
    (hCons : ∀ (a : AgentId) (P : Prop), ¬ (Prefers a P ∧ Prefers a (¬ P)))
    (hDemo : Prefers actor (¬ SeizedFrom actor r))
    (hUniv : Prefers actor (SeizedFrom actor r)) :
    False :=
  hCons actor (SeizedFrom actor r) ⟨hUniv, hDemo⟩

/-! ### Part 4: UPB Risk-Rule Universalizability (Probabilistic Risk vs. Paralysis)

  Models the UPB criterion over candidate risk regimes (docs/CONCEPTS.md §7):
  - Requiring strictly zero physical/digital tail risk abolishes ordinary agency
    (`permitsOrdinaryAgency = false`), which no purposeful agent can universally prefer.
  - Unilateral / reckless / engineered risk-loading (`imposesAsymmetricRisk = true`,
    e.g. leaving poison out) fails universal preferability across roles.
  - Reciprocal background risk of ordinary non-negligent agency paired with strict
    causal attribution and restitution (`attachesStrictLiability = true`) passes.
-/

structure RiskRuleProfile where
  permitsOrdinaryAgency : Bool
  imposesAsymmetricRisk : Bool
  attachesStrictLiability : Bool
  deriving DecidableEq, BEq, Repr

def UniversallyPreferableRiskRule (r : RiskRuleProfile) : Prop :=
  r.permitsOrdinaryAgency = true ∧
    r.imposesAsymmetricRisk = false ∧
    r.attachesStrictLiability = true

theorem zero_risk_paralysis_fails_upb :
    ¬ UniversallyPreferableRiskRule
      { permitsOrdinaryAgency := false
      , imposesAsymmetricRisk := false
      , attachesStrictLiability := true } := by
  intro ⟨hAgency, _⟩
  cases hAgency

theorem engineered_risk_loading_fails_upb (liab : Bool) :
    ¬ UniversallyPreferableRiskRule
      { permitsOrdinaryAgency := true
      , imposesAsymmetricRisk := true
      , attachesStrictLiability := liab } := by
  intro ⟨_, hAsym, _⟩
  cases hAsym

theorem reciprocal_background_risk_passes_upb :
    UniversallyPreferableRiskRule
      { permitsOrdinaryAgency := true
      , imposesAsymmetricRisk := false
      , attachesStrictLiability := true } :=
  ⟨rfl, rfl, rfl⟩

end CausalIntegrityV2
