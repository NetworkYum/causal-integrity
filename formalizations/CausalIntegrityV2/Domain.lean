/-
  CausalIntegrityV2.Domain — Attributed domain, consent validity, and violation boundaries.

  Separates three concepts that v1 conflated:
  1. Causal attribution (`IsContributor`) — who causally contributed to a resource.
  2. Attributed domain (`InDomain`) — bodily domain or prior causal contribution.
  3. Normative violation (`IsViolation`) — unconsented, domain-affecting interference
     by a non-holder outside bounded proportional defense.

  Fixes v1's concrete bugs:
  - Timeless `Unowned` contradiction: unowned resources can be homesteaded without
    collision, and prior capture lives in `WorldState.history`.
  - Self-use contradiction: acting on your own domain requires no permission token.
  - Exclusive title vs. joint creation: multiple contributors coexist in `InDomain`.
  - Caretaker contradiction: guardian consent and non-harmful emergency stabilization
    for incapacitated owners are explicitly distinguished from exploitation.
  - Competition boundary: competing (`.compete`) and declining (`.decline`) do not
    violate another's attributed domain even when they frustrate a preference.
-/

import CausalIntegrityV2.Attribution

namespace CausalIntegrityV2

/-- `r` is registered as part of `a`'s body. -/
def isBodyOfBool (w : WorldState) (a : AgentId) (r : ResourceId) : Bool :=
  w.bodies.any (fun p => (p.1 == r) && (p.2 == a))

/-- `a` has an attributed domain stake in `r` (body or prior causal contribution). -/
def inDomainBool (w : WorldState) (a : AgentId) (r : ResourceId) : Bool :=
  isBodyOfBool w a r || isContributorBool w a r

/-- Prop-level attributed domain membership. -/
def InDomain (w : WorldState) (a : AgentId) (r : ResourceId) : Prop :=
  inDomainBool w a r = true

/-- `a` is currently recorded as incapacitated. -/
def isIncapacitatedBool (w : WorldState) (a : AgentId) : Bool :=
  w.capacities.any (fun p => (p.1 == a) && (p.2 == .incapacitated))

/-- `a` is capable iff not recorded as incapacitated. -/
def isCapableBool (w : WorldState) (a : AgentId) : Bool :=
  !isIncapacitatedBool w a

/-- `g` is registered as a guardian for `ward`. -/
def isGuardianOfBool (w : WorldState) (g ward : AgentId) : Bool :=
  w.guardians.any (fun p => (p.1 == ward) && (p.2 == g))

/-- Check whether permission record `p` is valid for `(owner, actor, r, k)`. -/
def permissionMatchesBool (owner actor : AgentId) (r : ResourceId) (k : ActionKind)
    (p : Permission) : Bool :=
  (p.owner == owner) && (p.actor == actor) && (p.target == r) && (p.kind == k) &&
    !p.revoked && !p.coerced && p.informed

/-- Direct consent from a capable owner: unrevoked, uncoerced, informed permission. -/
def hasValidDirectConsentBool (w : WorldState) (owner actor : AgentId)
    (r : ResourceId) (k : ActionKind) : Bool :=
  isCapableBool w owner && w.permissions.any (permissionMatchesBool owner actor r k)

/-- Guardian proxy consent when `owner` is incapacitated and a guardian issues valid consent. -/
def hasGuardianConsentBool (w : WorldState) (owner actor : AgentId)
    (r : ResourceId) (k : ActionKind) : Bool :=
  isIncapacitatedBool w owner &&
    w.guardians.any (fun g => (g.1 == owner) && hasValidDirectConsentBool w g.2 actor r k)

/-- Non-harmful emergency stabilization of an incapacitated owner's body. -/
def isEmergencyStabilizationBool (w : WorldState) (owner : AgentId) (e : CausalEvent) : Bool :=
  isIncapacitatedBool w owner && isBodyOfBool w owner e.target &&
    (e.kind == .stabilize) && (e.valence != .harmful)

/-- An event targeting `owner`'s domain is authorized by `owner` via self-action,
    valid direct consent, valid guardian consent, or non-harmful emergency stabilization. -/
def authorizedByBool (w : WorldState) (owner : AgentId) (e : CausalEvent) : Bool :=
  (owner == e.initiator) ||
    hasValidDirectConsentBool w owner e.initiator e.target e.kind ||
    hasGuardianConsentBool w owner e.initiator e.target e.kind ||
    isEmergencyStabilizationBool w owner e

/-- Action kinds that touch/interfere with a resource's attributed domain.
    Pure competition (`.compete`) and refusal/declining (`.decline`) do not. -/
def affectsDomainKind : ActionKind → Bool
  | .compete => false
  | .decline => false
  | _ => true

/-- Bounded proportional defense against an active offender (`e.severity ≤ v.severity`). -/
def isProportionalDefenseBool (w : WorldState) (owner : AgentId) (e : CausalEvent) : Bool :=
  (e.kind == .defend) &&
    w.activeViolations.any (fun v => (v.offender == owner) && decide (e.severity ≤ v.severity))

/-- Collect body holders for resource `r`. -/
def bodyStakeholders (bodies : List (ResourceId × AgentId)) (r : ResourceId) : List AgentId :=
  match bodies with
  | [] => []
  | (r', a) :: rest => if r' == r then a :: bodyStakeholders rest r else bodyStakeholders rest r

/-- Collect agents involved in a single event if it targets `r`. -/
def eventStakeholders (e : CausalEvent) (r : ResourceId) : List AgentId :=
  if e.target == r then e.initiator :: e.intermediaries else []

/-- Collect all agents involved in historical events targeting `r`. -/
def historyStakeholders (history : List CausalEvent) (r : ResourceId) : List AgentId :=
  match history with
  | [] => []
  | e :: rest => eventStakeholders e r ++ historyStakeholders rest r

/-- Finite list of all agents with an attributed domain stake in `r` under `w`. -/
def allStakeholders (w : WorldState) (r : ResourceId) : List AgentId :=
  bodyStakeholders w.bodies r ++ historyStakeholders w.history r

private theorem mem_bodyStakeholders_iff (bodies : List (ResourceId × AgentId))
    (a : AgentId) (r : ResourceId) :
    a ∈ bodyStakeholders bodies r ↔ bodies.any (fun p => (p.1 == r) && (p.2 == a)) = true := by
  induction bodies with
  | nil => simp [bodyStakeholders]
  | cons p rest ih =>
    rcases p with ⟨r', b⟩
    simp only [bodyStakeholders, List.any_cons]
    cases h : (r' == r)
    · simp [ih]
    · simp only [↓reduceIte, List.mem_cons, Bool.true_and]
      constructor
      · intro hm
        cases hm with
        | inl heq =>
          subst heq
          simp
        | inr hrest =>
          exact (Bool.or_eq_true _ _).mpr (Or.inr (ih.mp hrest))
      · intro hOr
        rcases (Bool.or_eq_true _ _).mp hOr with hb | hrest
        · left
          exact (agentId_beq_iff b a).mp hb |>.symm
        · right
          exact ih.mpr hrest

private theorem mem_eventStakeholders_iff (e : CausalEvent) (a : AgentId) (r : ResourceId) :
    a ∈ eventStakeholders e r ↔ ((e.target == r) && eventInvolves a e) = true := by
  unfold eventStakeholders eventInvolves
  cases h : (e.target == r)
  · simp
  · simp only [↓reduceIte, List.mem_cons, Bool.true_and, Bool.or_eq_true]
    constructor
    · intro hm
      cases hm with
      | inl heq =>
        left
        exact (agentId_beq_iff e.initiator a).mpr heq.symm
      | inr hmem =>
        right
        exact List.any_eq_true.mpr ⟨a, hmem, (agentId_beq_iff a a).mpr rfl⟩
    · intro hOr
      rcases hOr with hi | hinter
      · left
        exact ((agentId_beq_iff e.initiator a).mp hi).symm
      · right
        obtain ⟨x, hx, hxbeq⟩ := List.any_eq_true.mp hinter
        have hxa : x = a := (agentId_beq_iff x a).mp hxbeq
        subst hxa
        exact hx

private theorem mem_historyStakeholders_iff (history : List CausalEvent)
    (a : AgentId) (r : ResourceId) :
    a ∈ historyStakeholders history r ↔
      history.any (fun e => (e.target == r) && eventInvolves a e) = true := by
  induction history with
  | nil => simp [historyStakeholders]
  | cons e rest ih =>
    simp only [historyStakeholders, List.mem_append, List.any_cons, Bool.or_eq_true]
    rw [mem_eventStakeholders_iff, ih]

/-- `allStakeholders w r` enumerates exactly the domain holders of `r` in `w`. -/
theorem mem_allStakeholders_iff_inDomain (w : WorldState) (a : AgentId) (r : ResourceId) :
    a ∈ allStakeholders w r ↔ InDomain w a r := by
  unfold allStakeholders InDomain inDomainBool isBodyOfBool isContributorBool
  simp only [List.mem_append, Bool.or_eq_true]
  rw [mem_bodyStakeholders_iff, mem_historyStakeholders_iff]

/-- Whether event `e` violates domain-holder `owner` in world `w`. -/
def violatesOwnerBool (w : WorldState) (owner : AgentId) (e : CausalEvent) : Bool :=
  affectsDomainKind e.kind &&
    inDomainBool w owner e.target &&
    (owner != e.initiator) &&
    !authorizedByBool w owner e &&
    !isProportionalDefenseBool w owner e

/-- Computable violation check across all domain holders of `e.target`. -/
def isViolationBool (w : WorldState) (e : CausalEvent) : Bool :=
  (allStakeholders w e.target).any (fun owner => violatesOwnerBool w owner e)

/-- Prop-level violation definition: `e` violates at least one domain holder under `w`. -/
def IsViolation (w : WorldState) (e : CausalEvent) : Prop :=
  ∃ owner, violatesOwnerBool w owner e = true

/-- Exact correspondence between the computable checker `isViolationBool` and `IsViolation`. -/
theorem isViolationBool_eq_true_iff (w : WorldState) (e : CausalEvent) :
    isViolationBool w e = true ↔ IsViolation w e := by
  constructor
  · intro h
    obtain ⟨owner, _, hViol⟩ := List.any_eq_true.mp h
    exact ⟨owner, hViol⟩
  · intro ⟨owner, hViol⟩
    have hDom : InDomain w owner e.target := by
      have h1 : (((affectsDomainKind e.kind && inDomainBool w owner e.target) &&
          (owner != e.initiator)) && !authorizedByBool w owner e) = true :=
        (Bool.and_eq_true _ _ |>.mp hViol).1
      have h2 : ((affectsDomainKind e.kind && inDomainBool w owner e.target) &&
          (owner != e.initiator)) = true :=
        (Bool.and_eq_true _ _ |>.mp h1).1
      have h3 : (affectsDomainKind e.kind && inDomainBool w owner e.target) = true :=
        (Bool.and_eq_true _ _ |>.mp h2).1
      exact (Bool.and_eq_true _ _ |>.mp h3).2
    have hMem : owner ∈ allStakeholders w e.target :=
      (mem_allStakeholders_iff_inDomain w owner e.target).mpr hDom
    exact List.any_eq_true.mpr ⟨owner, hMem, hViol⟩

/-- Incapacitated owners cannot issue valid direct consent. -/
theorem incapacitated_no_direct_consent (w : WorldState) (owner actor : AgentId)
    (r : ResourceId) (k : ActionKind) (hInc : isIncapacitatedBool w owner = true) :
    hasValidDirectConsentBool w owner actor r k = false := by
  simp [hasValidDirectConsentBool, isCapableBool, hInc]

/-- Any permission that is revoked, coerced, or uninformed fails validation. -/
theorem permission_disqualified_if_revoked_coerced_uninformed
    (owner actor : AgentId) (r : ResourceId) (k : ActionKind) (p : Permission)
    (hBad : p.revoked = true ∨ p.coerced = true ∨ p.informed = false) :
    permissionMatchesBool owner actor r k p = false := by
  rcases hBad with hRev | hCoer | hUninf
  · simp [permissionMatchesBool, hRev]
  · simp [permissionMatchesBool, hCoer]
  · simp [permissionMatchesBool, hUninf]

/-- If every permission in `w.permissions` is revoked, coerced, or uninformed,
    no direct consent can hold. -/
theorem no_valid_direct_consent_if_all_disqualified (w : WorldState) (owner actor : AgentId)
    (r : ResourceId) (k : ActionKind)
    (hAll : ∀ p ∈ w.permissions, p.revoked = true ∨ p.coerced = true ∨ p.informed = false) :
    hasValidDirectConsentBool w owner actor r k = false := by
  unfold hasValidDirectConsentBool
  cases hCap : isCapableBool w owner
  · rfl
  · simp only [Bool.true_and]
    cases hAny : w.permissions.any (permissionMatchesBool owner actor r k)
    · rfl
    · obtain ⟨p, hpMem, hpOk⟩ := List.any_eq_true.mp hAny
      have hFalse := permission_disqualified_if_revoked_coerced_uninformed
        owner actor r k p (hAll p hpMem)
      rw [hFalse] at hpOk
      cases hpOk

/-- Self-use fix: if the initiator is the sole domain holder of `e.target`,
    acting on it cannot be a violation (no self-permission token needed). -/
theorem sole_owner_self_action_not_violation (w : WorldState) (e : CausalEvent)
    (hSole : ∀ other, InDomain w other e.target → other = e.initiator) :
    ¬ IsViolation w e := by
  intro ⟨owner, hViol⟩
  have h1 := (Bool.and_eq_true _ _ |>.mp hViol).1
  have h2 := (Bool.and_eq_true _ _ |>.mp h1).1
  have h3 := (Bool.and_eq_true _ _ |>.mp h2).1
  have hDom : InDomain w owner e.target := (Bool.and_eq_true _ _ |>.mp h3).2
  have hDiff : (owner != e.initiator) = true := (Bool.and_eq_true _ _ |>.mp h2).2
  have hEq : owner = e.initiator := hSole owner hDom
  subst hEq
  have hSelf : (e.initiator == e.initiator) = true := (agentId_beq_iff e.initiator e.initiator).mpr rfl
  rw [bne, hSelf] at hDiff
  cases hDiff

/-- Homesteading fix: acting on a resource with no prior domain holders is not a violation. -/
theorem homestead_unowned_not_violation (w : WorldState) (e : CausalEvent)
    (hUnowned : ∀ a, ¬ InDomain w a e.target) :
    ¬ IsViolation w e := by
  intro ⟨owner, hViol⟩
  have h1 := (Bool.and_eq_true _ _ |>.mp hViol).1
  have h2 := (Bool.and_eq_true _ _ |>.mp h1).1
  have h3 := (Bool.and_eq_true _ _ |>.mp h2).1
  have hDom : InDomain w owner e.target := (Bool.and_eq_true _ _ |>.mp h3).2
  exact hUnowned owner hDom

/-- Non-exclusive attribution: two distinct agents can sequentially create and modify
    the same resource, and both retain attributed domain membership. -/
theorem joint_attribution_coexists (w : WorldState) (bob sam : AgentId) (r : ResourceId)
    (e₁ e₂ : CausalEvent)
    (h₁ : e₁.initiator = bob ∧ e₁.target = r)
    (h₂ : e₂.initiator = sam ∧ e₂.target = r) :
    let w' := appendEvents w [e₁, e₂]
    InDomain w' bob r ∧ InDomain w' sam r := by
  intro w'
  have hBobContrib : IsContributor (appendEvent w e₁) bob r := by
    unfold IsContributor isContributorBool appendEvent
    simp [h₁.1, h₁.2, eventInvolves]
  have hBobPers : IsContributor w' bob r :=
    attribution_persistent (appendEvent w e₁) bob r e₂ hBobContrib
  have hSamContrib : IsContributor w' sam r := by
    unfold IsContributor isContributorBool w' appendEvents appendEvent
    simp [h₂.1, h₂.2, eventInvolves]
  constructor
  · exact (Bool.or_eq_true _ _).mpr (Or.inr hBobPers)
  · exact (Bool.or_eq_true _ _).mpr (Or.inr hSamContrib)

/-- Caretaker fix: non-harmful emergency stabilization of an incapacitated owner's
    sole-holder body is not a violation. -/
theorem emergency_stabilization_not_violation (w : WorldState) (owner : AgentId)
    (e : CausalEvent)
    (hKind : e.kind = .stabilize)
    (hSafe : e.valence ≠ .harmful)
    (hInc : isIncapacitatedBool w owner = true)
    (hBody : isBodyOfBool w owner e.target = true)
    (hSole : ∀ a, InDomain w a e.target → a = owner) :
    ¬ IsViolation w e := by
  intro ⟨holder, hViol⟩
  have h1 := (Bool.and_eq_true _ _ |>.mp hViol).1
  have hNotAuth : (!authorizedByBool w holder e) = true := (Bool.and_eq_true _ _ |>.mp h1).2
  have h2 := (Bool.and_eq_true _ _ |>.mp h1).1
  have h3 := (Bool.and_eq_true _ _ |>.mp h2).1
  have hDom : InDomain w holder e.target := (Bool.and_eq_true _ _ |>.mp h3).2
  have hEq : holder = owner := hSole holder hDom
  subst hEq
  have hNotHarm : (e.valence != .harmful) = true := by
    cases hv : e.valence with
    | beneficial => decide
    | neutral => decide
    | harmful => exact absurd hv hSafe
  have hStab : isEmergencyStabilizationBool w holder e = true := by
    simp [isEmergencyStabilizationBool, hInc, hBody, hKind, hNotHarm]
  have hAuth : authorizedByBool w holder e = true := by
    simp [authorizedByBool, hStab]
  rw [hAuth] at hNotAuth
  cases hNotAuth

/-- Harmless competition (`.compete`) never constitutes a domain violation. -/
theorem competition_not_violation (w : WorldState) (e : CausalEvent)
    (hComp : e.kind = .compete) :
    ¬ IsViolation w e := by
  intro ⟨owner, hViol⟩
  simp [violatesOwnerBool, hComp, affectsDomainKind] at hViol

/-- Declining an offer (`.decline`) never constitutes a domain violation. -/
theorem declining_not_violation (w : WorldState) (e : CausalEvent)
    (hDecl : e.kind = .decline) :
    ¬ IsViolation w e := by
  intro ⟨owner, hViol⟩
  simp [violatesOwnerBool, hDecl, affectsDomainKind] at hViol

/-- Seizing or harming an incapacitated owner's domain without guardian consent is a violation. -/
theorem exploiting_incapacitated_is_violation (w : WorldState) (owner : AgentId) (e : CausalEvent)
    (hDiff : owner ≠ e.initiator)
    (hDom : InDomain w owner e.target)
    (hInc : isIncapacitatedBool w owner = true)
    (hNoGuard : hasGuardianConsentBool w owner e.initiator e.target e.kind = false)
    (hKind : e.kind = .seize ∨ e.kind = .harm) :
    IsViolation w e := by
  refine ⟨owner, ?_⟩
  have hAff : affectsDomainKind e.kind = true := by
    rcases hKind with h | h <;> simp [h, affectsDomainKind]
  have hNoDirect : hasValidDirectConsentBool w owner e.initiator e.target e.kind = false :=
    incapacitated_no_direct_consent w owner e.initiator e.target e.kind hInc
  have hNoStab : isEmergencyStabilizationBool w owner e = false := by
    rcases hKind with h | h <;> simp [isEmergencyStabilizationBool, h]
  have hNotSelf : (owner == e.initiator) = false := by
    cases hb : (owner == e.initiator)
    · rfl
    · exact absurd ((agentId_beq_iff owner e.initiator).mp hb) hDiff
  have hNotAuth : authorizedByBool w owner e = false := by
    simp [authorizedByBool, hNotSelf, hNoDirect, hNoGuard, hNoStab]
  have hNotDef : isProportionalDefenseBool w owner e = false := by
    rcases hKind with h | h <;> simp [isProportionalDefenseBool, h]
  have hNeq : (owner != e.initiator) = true := by
    simp [bne, hNotSelf]
  have hInDom : inDomainBool w owner e.target = true := hDom
  simp [violatesOwnerBool, hAff, hInDom, hNeq, hNotAuth, hNotDef]

end CausalIntegrityV2
