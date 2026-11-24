/-
  CausalIntegrityV2.Universalization — Conditional universality, UPB action-type
  universalizability, and demonstrated-preference self-contradiction.

  Corresponds to docs/CONCEPTS.md §5 and §10:
  1. Bijective Agent-Renaming Invariance: swapping agent IDs leaves domain
     membership, authorization, proportional defense, and violation classification
     identical — blocking identity-only exceptions.
  2. UPB Universalizability over Action Types: tests action-type role profiles,
     not momentary desires; non-consensual violation fails while consensual
     exchange, harmless competition, and bounded proportional defense pass;
     unbounded retaliation fails.
  3. Demonstrated Preference Self-Contradiction: explicit single-agent P ∧ ¬P
     given single-agent preference consistency, demonstrated control preference,
     and endorsement of a universal seizure rule. (An actor who refuses to endorse
     any universal rule is still classified under IsViolation / trust collapse.)
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

def renamePermission (π : AgentPerm) (p : Permission) : Permission :=
  { p with owner := π.toFun p.owner, actor := π.toFun p.actor }

def renameViolation (π : AgentPerm) (v : ActiveViolation) : ActiveViolation :=
  { v with offender := π.toFun v.offender, victim := π.toFun v.victim }

def renameEvent (π : AgentPerm) (e : CausalEvent) : CausalEvent :=
  { e with
    initiator := π.toFun e.initiator
    intermediaries := e.intermediaries.map π.toFun }

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

@[simp] theorem inDomainBool_rename (π : AgentPerm) (w : WorldState)
    (a : AgentId) (r : ResourceId) :
    inDomainBool (renameWorld π w) (π.toFun a) r = inDomainBool w a r := by
  unfold inDomainBool
  rw [isBodyOfBool_rename, isContributorBool_rename]

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
    (owner actor : AgentId) (r : ResourceId) (k : ActionKind) :
    hasValidDirectConsentBool (renameWorld π w) (π.toFun owner) (π.toFun actor) r k =
      hasValidDirectConsentBool w owner actor r k := by
  unfold hasValidDirectConsentBool
  rw [isCapableBool_rename]
  congr 1
  change (w.permissions.map (renamePermission π)).any (permissionMatchesBool (π.toFun owner) (π.toFun actor) r k) = _
  rw [list_any_map]
  apply list_any_congr
  intro p
  simp [permissionMatchesBool, renamePermission, π.beq_iff]

@[simp] theorem hasGuardianConsentBool_rename (π : AgentPerm) (w : WorldState)
    (owner actor : AgentId) (r : ResourceId) (k : ActionKind) :
    hasGuardianConsentBool (renameWorld π w) (π.toFun owner) (π.toFun actor) r k =
      hasGuardianConsentBool w owner actor r k := by
  unfold hasGuardianConsentBool
  rw [isIncapacitatedBool_rename]
  congr 1
  change (w.guardians.map (fun p => (π.toFun p.1, π.toFun p.2))).any _ = _
  rw [list_any_map]
  apply list_any_congr
  intro g
  simp only [π.beq_iff]
  rw [hasValidDirectConsentBool_rename]

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
  rw [isEmergencyStabilizationBool_rename]
  have hInit : (renameEvent π e).initiator = π.toFun e.initiator := rfl
  have hTarget : (renameEvent π e).target = e.target := rfl
  have hKind : (renameEvent π e).kind = e.kind := rfl
  rw [hInit, hTarget, hKind, π.beq_iff,
      hasValidDirectConsentBool_rename, hasGuardianConsentBool_rename]

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

private theorem bodyStakeholders_rename (π : AgentPerm)
    (bodies : List (ResourceId × AgentId)) (r : ResourceId) :
    bodyStakeholders (bodies.map (fun p => (p.1, π.toFun p.2))) r =
      (bodyStakeholders bodies r).map π.toFun := by
  induction bodies with
  | nil => rfl
  | cons p rest ih =>
    rcases p with ⟨r', a⟩
    simp only [List.map_cons, bodyStakeholders]
    cases h : (r' == r) <;> simp [ih]

private theorem eventStakeholders_rename (π : AgentPerm) (e : CausalEvent) (r : ResourceId) :
    eventStakeholders (renameEvent π e) r = (eventStakeholders e r).map π.toFun := by
  unfold eventStakeholders renameEvent
  cases h : (e.target == r) <;> simp

private theorem historyStakeholders_rename (π : AgentPerm)
    (history : List CausalEvent) (r : ResourceId) :
    historyStakeholders (history.map (renameEvent π)) r =
      (historyStakeholders history r).map π.toFun := by
  induction history with
  | nil => rfl
  | cons e rest ih =>
    simp only [List.map_cons, historyStakeholders, List.map_append]
    rw [eventStakeholders_rename, ih]

theorem allStakeholders_rename (π : AgentPerm) (w : WorldState) (r : ResourceId) :
    allStakeholders (renameWorld π w) r = (allStakeholders w r).map π.toFun := by
  unfold allStakeholders renameWorld
  simp only [List.map_append]
  rw [bodyStakeholders_rename, historyStakeholders_rename]

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

/-! ### Part 2: UPB Universalizability over Action Types

  Models the UPB action-type criterion from `docs/CONCEPTS.md` §5:
  UPB tests action-type profiles (whether every affected role can consistently prefer
  the rule), not momentary desires. Overriding another's domain preference fails
  unless bounded as proportional defense against an active violation, and unbounded
  retaliation (general license under trust collapse) always fails.
-/

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

/-! ### Part 3: Demonstrated Preference Self-Contradiction

  Formalizes the exact single-agent contradiction from `docs/CONCEPTS.md` §5 as a
  theorem with explicit local premises (no hidden global axioms):
  - Once an actor's seizing/controlling conduct demonstrates a preference to retain
    control (`Prefers actor (¬ SeizedFrom actor r)`), endorsing a universal rule that
    permits unconsented seizure (`Prefers actor (SeizedFrom actor r)`) yields `P ∧ ¬P`
    within that single agent's own preferences.
  - Note on scope: an "honest wrongdoer" who refuses to endorse any universal rule does
    not trigger `hUniv`, and is instead classified as committing a violation (`IsViolation`)
    subject to bounded trust collapse and proportional defense.
-/

theorem demonstrated_preference_self_contradiction
    (Prefers : AgentId → Prop → Prop)
    (SeizedFrom : AgentId → ResourceId → Prop)
    (actor : AgentId) (r : ResourceId)
    (hCons : ∀ (a : AgentId) (P : Prop), ¬ (Prefers a P ∧ Prefers a (¬ P)))
    (hDemo : Prefers actor (¬ SeizedFrom actor r))
    (hUniv : Prefers actor (SeizedFrom actor r)) :
    False :=
  hCons actor (SeizedFrom actor r) ⟨hUniv, hDemo⟩

end CausalIntegrityV2
