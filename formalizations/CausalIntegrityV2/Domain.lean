/-
  CausalIntegrityV2.Domain — Separates permanent historical attribution (`IsContributor`)
  from active normative stewardship (`InDomain`), delegation-aware consent, and violation.

  Corresponds to docs/CONCEPTS.md §§3, 5, and 7:
  1. Historical causal attribution (`IsContributor`) is append-only and never erased.
  2. Active domain stewardship (`InDomain` / `stewardsOf`):
     - Bodily resources (`isBodyResourceBool`) are inalienable: emergency stabilization,
       proportional defense, and attempted transfers never alter bodily stewardship
       (`body_domain_inalienable`).
     - Non-body resources acquire stewards via `.homestead` and `.coCreate`, are NOT
       captured by guest/service `.modify` (`guest_modify_preserves_domain`), and move
       cleanly on `.transfer` while preserving historical attribution
       (`transfer_moves_stewardship_preserving_attribution`).
  3. Delegation-scoped consent: intermediaries in `e.intermediaries` must either be
     covered by a permission with `allowsDelegation = true` granted to `e.initiator`,
     or be individually authorized by the domain holder.
-/

import CausalIntegrityV2.Attribution

namespace CausalIntegrityV2

/-- `r` is registered as part of `a`'s body. -/
def isBodyOfBool (w : WorldState) (a : AgentId) (r : ResourceId) : Bool :=
  w.bodies.any (fun p => (p.1 == r) && (p.2 == a))

/-- `r` is registered as a bodily resource (inalienable). -/
def isBodyResourceBool (w : WorldState) (r : ResourceId) : Bool :=
  w.bodies.any (fun p => p.1 == r)

/-- Collect body holders for resource `r`. -/
def bodyStakeholders (bodies : List (ResourceId × AgentId)) (r : ResourceId) : List AgentId :=
  match bodies with
  | [] => []
  | (r', a) :: rest => if r' == r then a :: bodyStakeholders rest r else bodyStakeholders rest r

/-- Update non-body resource stewards across a single event:
    - `.homestead` / `.coCreate` add `e.initiator` as steward;
    - `.transfer` with `some rec` replaces `e.initiator`'s stewardship with `rec`;
    - `.modify`, `.stabilize`, `.defend`, `.compete`, `.decline`, etc. leave stewardship unchanged. -/
def stepStewards (cur : List AgentId) (e : CausalEvent) (r : ResourceId) : List AgentId :=
  if e.target == r then
    match e.kind, e.recipient with
    | .homestead, _ => e.initiator :: cur
    | .coCreate, _ => e.initiator :: cur
    | .transfer, some rec => rec :: cur.filter (fun a => a != e.initiator)
    | _, _ => cur
  else
    cur

/-- Fold stewardship transitions across historical events for a non-body resource. -/
def historyStewards (history : List CausalEvent) (r : ResourceId) (cur : List AgentId) : List AgentId :=
  match history with
  | [] => cur
  | e :: rest => historyStewards rest r (stepStewards cur e r)

/-- Active normative stewards of `r` in world `w`.
    Bodily resources are permanently governed by `w.bodies`; non-body resources evolve
    via homesteading, co-creation, and voluntary transfer. -/
def stewardsOf (w : WorldState) (r : ResourceId) : List AgentId :=
  if isBodyResourceBool w r then
    bodyStakeholders w.bodies r
  else
    historyStewards w.history r []

/-- Computable check: `a` currently holds active normative stewardship over `r`. -/
def inDomainBool (w : WorldState) (a : AgentId) (r : ResourceId) : Bool :=
  (stewardsOf w r).any (· == a)

/-- Prop-level active normative domain membership. -/
def InDomain (w : WorldState) (a : AgentId) (r : ResourceId) : Prop :=
  inDomainBool w a r = true

/-- Finite list of all current domain holders of `r` under `w`. -/
def allStakeholders (w : WorldState) (r : ResourceId) : List AgentId :=
  stewardsOf w r

/-- `allStakeholders w r` enumerates exactly the active domain holders of `r` in `w`. -/
theorem mem_allStakeholders_iff_inDomain (w : WorldState) (a : AgentId) (r : ResourceId) :
    a ∈ allStakeholders w r ↔ InDomain w a r := by
  unfold allStakeholders InDomain inDomainBool
  constructor
  · intro hMem
    exact List.any_eq_true.mpr ⟨a, hMem, (agentId_beq_iff a a).mpr rfl⟩
  · intro hAny
    obtain ⟨x, hxMem, hxEq⟩ := List.any_eq_true.mp hAny
    have hxa : x = a := (agentId_beq_iff x a).mp hxEq
    subst hxa
    exact hxMem

theorem historyStewards_append_singleton (history : List CausalEvent) (e : CausalEvent)
    (r : ResourceId) (cur : List AgentId) :
    historyStewards (history ++ [e]) r cur = stepStewards (historyStewards history r cur) e r := by
  induction history generalizing cur with
  | nil => rfl
  | cons x rest ih =>
    simp only [List.cons_append, historyStewards]
    exact ih (stepStewards cur x r)

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

theorem isBodyOfBool_implies_isBodyResourceBool (w : WorldState) (a : AgentId) (r : ResourceId)
    (h : isBodyOfBool w a r = true) :
    isBodyResourceBool w r = true := by
  unfold isBodyOfBool at h
  unfold isBodyResourceBool
  obtain ⟨p, hpMem, hpAnd⟩ := List.any_eq_true.mp h
  exact List.any_eq_true.mpr ⟨p, hpMem, (Bool.and_eq_true _ _).mp hpAnd |>.1⟩

theorem isBodyOfBool_implies_inDomain (w : WorldState) (a : AgentId) (r : ResourceId)
    (h : isBodyOfBool w a r = true) :
    InDomain w a r := by
  have hRes := isBodyOfBool_implies_isBodyResourceBool w a r h
  rw [← mem_allStakeholders_iff_inDomain]
  unfold allStakeholders stewardsOf
  rw [hRes]
  simp only [↓reduceIte]
  exact (mem_bodyStakeholders_iff w.bodies a r).mpr h

private theorem appendEvents_bodies (w : WorldState) (es : List CausalEvent) :
    (appendEvents w es).bodies = w.bodies := by
  unfold appendEvents
  induction es generalizing w with
  | nil => rfl
  | cons e rest ih =>
    rw [List.foldl_cons, ih (appendEvent w e)]
    rfl

/-- Bodily inalienability: no sequence of appended events (stabilization, defense,
    modification, or attempted transfer) ever alters who stewards a bodily resource. -/
theorem body_domain_inalienable (w : WorldState) (es : List CausalEvent)
    (a : AgentId) (r : ResourceId) (hBody : isBodyResourceBool w r = true) :
    InDomain (appendEvents w es) a r ↔ InDomain w a r := by
  unfold InDomain inDomainBool stewardsOf isBodyResourceBool
  rw [appendEvents_bodies w es]
  unfold isBodyResourceBool at hBody
  simp [hBody]

/-- Good Samaritan / guest-use fix: a `.modify` event records factual attribution
    (`IsContributor`) without altering active stewardship (`InDomain`) for anyone. -/
theorem guest_modify_preserves_domain (w : WorldState) (e : CausalEvent)
    (hKind : e.kind = .modify) :
    IsContributor (appendEvent w e) e.initiator e.target ∧
      ∀ a, InDomain (appendEvent w e) a e.target ↔ InDomain w a e.target := by
  constructor
  · unfold IsContributor isContributorBool appendEvent
    simp [eventInvolves]
  · intro a
    unfold InDomain inDomainBool stewardsOf appendEvent isBodyResourceBool
    simp only
    cases w.bodies.any (fun p => p.1 == e.target)
    · simp only [Bool.false_eq_true, ↓reduceIte, historyStewards_append_singleton]
      unfold stepStewards
      simp [hKind]
    · rfl

/-- Transfer theorem: transferring a non-body resource from `alice` to `bob` (`alice ≠ bob`)
    preserves `alice`'s permanent historical attribution (`IsContributor`) while extinguishing
    `alice`'s active stewardship (`¬ InDomain`) and granting active stewardship to `bob`. -/
theorem transfer_moves_stewardship_preserving_attribution
    (w : WorldState) (alice bob : AgentId) (r : ResourceId) (e : CausalEvent)
    (hNonBody : isBodyResourceBool w r = false)
    (hDiff : alice ≠ bob)
    (hInit : e.initiator = alice)
    (hTarget : e.target = r)
    (hKind : e.kind = .transfer)
    (hRec : e.recipient = some bob) :
    let w' := appendEvent w e
    IsContributor w' alice r ∧ ¬ InDomain w' alice r ∧ InDomain w' bob r := by
  intro w'
  have hContrib : IsContributor w' alice r := by
    unfold IsContributor isContributorBool w' appendEvent
    simp [hInit, hTarget, eventInvolves]
  have hStew : stewardsOf w' r = bob :: (historyStewards w.history r []).filter (fun a => a != alice) := by
    unfold stewardsOf w' appendEvent isBodyResourceBool
    unfold isBodyResourceBool at hNonBody
    simp only [hNonBody, Bool.false_eq_true, ↓reduceIte, historyStewards_append_singleton]
    unfold stepStewards
    simp [hTarget, hKind, hRec, hInit]
  have hAliceNotMem : alice ∉ stewardsOf w' r := by
    rw [hStew, List.mem_cons]
    intro hOr
    cases hOr with
    | inl hEq => exact hDiff hEq
    | inr hFilt =>
      have hBne : (alice != alice) = true := (List.mem_filter.mp hFilt).2
      have hSelf : (alice == alice) = true := (agentId_beq_iff alice alice).mpr rfl
      rw [bne, hSelf] at hBne
      cases hBne
  have hBobMem : bob ∈ stewardsOf w' r := by
    rw [hStew]
    exact List.Mem.head _
  refine ⟨hContrib, ?_, ?_⟩
  · intro hDom
    exact hAliceNotMem ((mem_allStakeholders_iff_inDomain w' alice r).mpr hDom)
  · exact (mem_allStakeholders_iff_inDomain w' bob r).mp hBobMem

/-- `a` is currently recorded as incapacitated. -/
def isIncapacitatedBool (w : WorldState) (a : AgentId) : Bool :=
  w.capacities.any (fun p => (p.1 == a) && (p.2 == .incapacitated))

/-- `a` is capable iff not recorded as incapacitated. -/
def isCapableBool (w : WorldState) (a : AgentId) : Bool :=
  !isIncapacitatedBool w a

/-- `g` is registered as a guardian for `ward`. -/
def isGuardianOfBool (w : WorldState) (g ward : AgentId) : Bool :=
  w.guardians.any (fun p => (p.1 == ward) && (p.2 == g))

/-- Check whether permission record `p` is valid for `(owner, actor, r, k)`
    and satisfies `needDelegation` if sub-delegation through intermediaries is used. -/
def permissionMatchesBool (owner actor : AgentId) (r : ResourceId) (k : ActionKind)
    (needDelegation : Bool) (p : Permission) : Bool :=
  (p.owner == owner) && (p.actor == actor) && (p.target == r) && (p.kind == k) &&
    !p.revoked && !p.coerced && p.informed && (!needDelegation || p.allowsDelegation)

/-- Direct consent from a capable owner for a single actor (with optional delegation requirement). -/
def hasValidDirectConsentBool (w : WorldState) (owner actor : AgentId)
    (r : ResourceId) (k : ActionKind) (needDelegation : Bool := false) : Bool :=
  isCapableBool w owner && w.permissions.any (permissionMatchesBool owner actor r k needDelegation)

/-- Guardian proxy consent when `owner` is incapacitated. -/
def hasGuardianConsentBool (w : WorldState) (owner actor : AgentId)
    (r : ResourceId) (k : ActionKind) (needDelegation : Bool := false) : Bool :=
  isIncapacitatedBool w owner &&
    w.guardians.any (fun g => (g.1 == owner) &&
      hasValidDirectConsentBool w g.2 actor r k needDelegation)

/-- Single-actor authorization by `owner` (self when `needDelegation = false`, direct consent,
    or guardian proxy consent). -/
def actorAuthorizedByOwnerBool (w : WorldState) (owner actor : AgentId)
    (r : ResourceId) (k : ActionKind) (needDelegation : Bool) : Bool :=
  ((owner == actor) && !needDelegation) ||
    hasValidDirectConsentBool w owner actor r k needDelegation ||
    hasGuardianConsentBool w owner actor r k needDelegation

/-- Delegation-aware event consent: either `e.initiator` holds a delegation-enabled consent
    (`allowsDelegation = true`), or `e.initiator` and every intermediary in `e.intermediaries`
    are individually authorized by `owner`. -/
def consentCoversEventBool (w : WorldState) (owner : AgentId) (e : CausalEvent) : Bool :=
  actorAuthorizedByOwnerBool w owner e.initiator e.target e.kind true ||
    (actorAuthorizedByOwnerBool w owner e.initiator e.target e.kind false &&
      e.intermediaries.all (fun m =>
        actorAuthorizedByOwnerBool w owner m e.target e.kind false))

/-- Non-harmful emergency stabilization of an incapacitated owner's body. -/
def isEmergencyStabilizationBool (w : WorldState) (owner : AgentId) (e : CausalEvent) : Bool :=
  isIncapacitatedBool w owner && isBodyOfBool w owner e.target &&
    (e.kind == .stabilize) && (e.valence != .harmful)

/-- An event targeting `owner`'s domain is authorized by `owner` via self-initiation
    (when `owner == e.initiator`), delegation-valid consent, or emergency stabilization. -/
def authorizedByBool (w : WorldState) (owner : AgentId) (e : CausalEvent) : Bool :=
  (owner == e.initiator) ||
    consentCoversEventBool w owner e ||
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

/-- Whether event `e` violates domain-holder `owner` in world `w`. -/
def violatesOwnerBool (w : WorldState) (owner : AgentId) (e : CausalEvent) : Bool :=
  affectsDomainKind e.kind &&
    inDomainBool w owner e.target &&
    (owner != e.initiator) &&
    !authorizedByBool w owner e &&
    !isProportionalDefenseBool w owner e

/-- Computable violation check across all current domain holders of `e.target`. -/
def isViolationBool (w : WorldState) (e : CausalEvent) : Bool :=
  (allStakeholders w e.target).any (fun owner => violatesOwnerBool w owner e)

/-- Prop-level violation definition: `e` violates at least one current domain holder under `w`. -/
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
    (r : ResourceId) (k : ActionKind) (needDel : Bool)
    (hInc : isIncapacitatedBool w owner = true) :
    hasValidDirectConsentBool w owner actor r k needDel = false := by
  simp [hasValidDirectConsentBool, isCapableBool, hInc]

/-- Any permission that is revoked, coerced, or uninformed fails validation. -/
theorem permission_disqualified_if_revoked_coerced_uninformed
    (owner actor : AgentId) (r : ResourceId) (k : ActionKind) (needDel : Bool) (p : Permission)
    (hBad : p.revoked = true ∨ p.coerced = true ∨ p.informed = false) :
    permissionMatchesBool owner actor r k needDel p = false := by
  rcases hBad with hRev | hCoer | hUninf
  · simp [permissionMatchesBool, hRev]
  · simp [permissionMatchesBool, hCoer]
  · simp [permissionMatchesBool, hUninf]

/-- If every permission in `w.permissions` is revoked, coerced, or uninformed,
    no direct consent can hold. -/
theorem no_valid_direct_consent_if_all_disqualified (w : WorldState) (owner actor : AgentId)
    (r : ResourceId) (k : ActionKind) (needDel : Bool)
    (hAll : ∀ p ∈ w.permissions, p.revoked = true ∨ p.coerced = true ∨ p.informed = false) :
    hasValidDirectConsentBool w owner actor r k needDel = false := by
  unfold hasValidDirectConsentBool
  cases hCap : isCapableBool w owner
  · rfl
  · simp only [Bool.true_and]
    cases hAny : w.permissions.any (permissionMatchesBool owner actor r k needDel)
    · rfl
    · obtain ⟨p, hpMem, hpOk⟩ := List.any_eq_true.mp hAny
      have hFalse := permission_disqualified_if_revoked_coerced_uninformed
        owner actor r k needDel p (hAll p hpMem)
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

/-- Homesteading fix: acting on a resource with no current domain holders is not a violation. -/
theorem homestead_unowned_not_violation (w : WorldState) (e : CausalEvent)
    (hUnowned : ∀ a, ¬ InDomain w a e.target) :
    ¬ IsViolation w e := by
  intro ⟨owner, hViol⟩
  have h1 := (Bool.and_eq_true _ _ |>.mp hViol).1
  have h2 := (Bool.and_eq_true _ _ |>.mp h1).1
  have h3 := (Bool.and_eq_true _ _ |>.mp h2).1
  have hDom : InDomain w owner e.target := (Bool.and_eq_true _ _ |>.mp h3).2
  exact hUnowned owner hDom

/-- Non-exclusive co-creation: Bob homesteads a non-body resource `r` via `e₁` and Sam
    co-creates `r` via `e₂`; both retain historical attribution AND active stewardship. -/
theorem joint_attribution_coexists (w : WorldState) (bob sam : AgentId) (r : ResourceId)
    (e₁ e₂ : CausalEvent)
    (hNonBody : isBodyResourceBool w r = false)
    (h₁ : e₁.initiator = bob ∧ e₁.target = r ∧ e₁.kind = .homestead)
    (h₂ : e₂.initiator = sam ∧ e₂.target = r ∧ e₂.kind = .coCreate) :
    let w' := appendEvents w [e₁, e₂]
    IsContributor w' bob r ∧ IsContributor w' sam r ∧ InDomain w' bob r ∧ InDomain w' sam r := by
  intro w'
  have hBobContrib : IsContributor (appendEvent w e₁) bob r := by
    unfold IsContributor isContributorBool appendEvent
    simp [h₁.1, h₁.2.1, eventInvolves]
  have hBobPers : IsContributor w' bob r :=
    attribution_persistent (appendEvent w e₁) bob r e₂ hBobContrib
  have hSamContrib : IsContributor w' sam r := by
    unfold IsContributor isContributorBool w' appendEvents appendEvent
    simp [h₂.1, h₂.2.1, eventInvolves]
  have hStew : stewardsOf w' r =
      sam :: bob :: historyStewards w.history r [] := by
    unfold stewardsOf w' appendEvents appendEvent isBodyResourceBool
    unfold isBodyResourceBool at hNonBody
    simp only [List.foldl_cons, List.foldl_nil, hNonBody, Bool.false_eq_true, ↓reduceIte,
      historyStewards_append_singleton]
    unfold stepStewards
    simp [h₁.1, h₁.2.1, h₁.2.2, h₂.1, h₂.2.1, h₂.2.2]
  have hBobDom : InDomain w' bob r := by
    rw [← mem_allStakeholders_iff_inDomain]
    unfold allStakeholders
    rw [hStew]
    exact List.Mem.tail _ (List.Mem.head _)
  have hSamDom : InDomain w' sam r := by
    rw [← mem_allStakeholders_iff_inDomain]
    unfold allStakeholders
    rw [hStew]
    exact List.Mem.head _
  exact ⟨hBobPers, hSamContrib, hBobDom, hSamDom⟩

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
    (hNoGuardDel : hasGuardianConsentBool w owner e.initiator e.target e.kind true = false)
    (hNoGuardDirect : hasGuardianConsentBool w owner e.initiator e.target e.kind false = false)
    (hKind : e.kind = .seize ∨ e.kind = .harm) :
    IsViolation w e := by
  refine ⟨owner, ?_⟩
  have hAff : affectsDomainKind e.kind = true := by
    rcases hKind with h | h <;> simp [h, affectsDomainKind]
  have hNoDirectDel : hasValidDirectConsentBool w owner e.initiator e.target e.kind true = false :=
    incapacitated_no_direct_consent w owner e.initiator e.target e.kind true hInc
  have hNoDirect : hasValidDirectConsentBool w owner e.initiator e.target e.kind false = false :=
    incapacitated_no_direct_consent w owner e.initiator e.target e.kind false hInc
  have hNoStab : isEmergencyStabilizationBool w owner e = false := by
    rcases hKind with h | h <;> simp [isEmergencyStabilizationBool, h]
  have hNotSelf : (owner == e.initiator) = false := by
    cases hb : (owner == e.initiator)
    · rfl
    · exact absurd ((agentId_beq_iff owner e.initiator).mp hb) hDiff
  have hNoConsent : consentCoversEventBool w owner e = false := by
    simp [consentCoversEventBool, actorAuthorizedByOwnerBool,
      hNotSelf, hNoDirectDel, hNoDirect, hNoGuardDel, hNoGuardDirect]
  have hNotAuth : authorizedByBool w owner e = false := by
    simp [authorizedByBool, hNotSelf, hNoConsent, hNoStab]
  have hNotDef : isProportionalDefenseBool w owner e = false := by
    rcases hKind with h | h <;> simp [isProportionalDefenseBool, h]
  have hNeq : (owner != e.initiator) = true := by
    simp [bne, hNotSelf]
  have hInDom : inDomainBool w owner e.target = true := hDom
  simp [violatesOwnerBool, hAff, hInDom, hNeq, hNotAuth, hNotDef]

end CausalIntegrityV2
