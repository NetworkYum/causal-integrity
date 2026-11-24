/-
  CausalIntegrityV2.Attribution — Stateful, append-only, non-exclusive causal ledger.

  Corresponds to docs/CONCEPTS.md §§2–4:
  - Actions generate causal events with an initiator, zero or more intermediaries,
    a target resource, an action kind, an effect valence, and a severity.
  - History is append-only: later actions never erase prior attribution.
  - Intermediaries / proxies do not launder the initiator's causal contribution.
  - Credit/blame symmetry: changing effect valence (beneficial vs. harmful) does
    not alter whether an agent contributed.
-/

namespace CausalIntegrityV2

structure AgentId where
  id : Nat
  deriving DecidableEq, BEq, Repr

structure ResourceId where
  id : Nat
  deriving DecidableEq, BEq, Repr

inductive EffectValence
  | beneficial
  | neutral
  | harmful
  deriving DecidableEq, BEq, Repr

inductive ActionKind
  | homestead
  | modify
  | transfer
  | compete
  | decline
  | stabilize
  | harm
  | seize
  | defend
  deriving DecidableEq, BEq, Repr

inductive Capacity
  | capable
  | incapacitated
  deriving DecidableEq, BEq, Repr

structure Permission where
  owner : AgentId
  actor : AgentId
  target : ResourceId
  kind : ActionKind
  revoked : Bool
  coerced : Bool
  informed : Bool
  deriving DecidableEq, BEq, Repr

structure ActiveViolation where
  offender : AgentId
  victim : AgentId
  severity : Nat
  deriving DecidableEq, BEq, Repr

structure CausalEvent where
  initiator : AgentId
  intermediaries : List AgentId
  kind : ActionKind
  target : ResourceId
  valence : EffectValence
  severity : Nat
  deriving DecidableEq, BEq, Repr

structure WorldState where
  bodies : List (ResourceId × AgentId)
  capacities : List (AgentId × Capacity)
  guardians : List (AgentId × AgentId)
  permissions : List Permission
  activeViolations : List ActiveViolation
  history : List CausalEvent
  deriving DecidableEq, BEq, Repr

@[simp] theorem agentId_beq_iff (a b : AgentId) : (a == b) = true ↔ a = b := by
  cases a with | mk x =>
  cases b with | mk y =>
  change (x == y) = true ↔ AgentId.mk x = AgentId.mk y
  simp [beq_iff_eq]

@[simp] theorem resourceId_beq_iff (r₁ r₂ : ResourceId) : (r₁ == r₂) = true ↔ r₁ = r₂ := by
  cases r₁ with | mk x =>
  cases r₂ with | mk y =>
  change (x == y) = true ↔ ResourceId.mk x = ResourceId.mk y
  simp [beq_iff_eq]

@[simp] theorem actionKind_beq_iff (k₁ k₂ : ActionKind) : (k₁ == k₂) = true ↔ k₁ = k₂ := by
  cases k₁ <;> cases k₂ <;> decide

@[simp] theorem effectValence_beq_iff (v₁ v₂ : EffectValence) : (v₁ == v₂) = true ↔ v₁ = v₂ := by
  cases v₁ <;> cases v₂ <;> decide

@[simp] theorem capacity_beq_iff (c₁ c₂ : Capacity) : (c₁ == c₂) = true ↔ c₁ = c₂ := by
  cases c₁ <;> cases c₂ <;> decide

@[simp] theorem list_any_append {α : Type} (xs ys : List α) (p : α → Bool) :
    (xs ++ ys).any p = (xs.any p || ys.any p) := by
  induction xs with
  | nil => simp
  | cons x rest ih =>
    simp only [List.cons_append, List.any_cons, ih, Bool.or_assoc]

@[simp] theorem list_any_map {α β : Type} (l : List α) (f : α → β) (p : β → Bool) :
    (l.map f).any p = l.any (fun x => p (f x)) := by
  induction l with
  | nil => rfl
  | cons x xs ih =>
    simp only [List.map_cons, List.any_cons, ih]

/-- An event causally involves `a` if `a` is either the initiator or an intermediary. -/
def eventInvolves (a : AgentId) (e : CausalEvent) : Bool :=
  (e.initiator == a) || e.intermediaries.any (· == a)

/-- Computable check: `a` contributed to `r` in `w`'s causal history. -/
def isContributorBool (w : WorldState) (a : AgentId) (r : ResourceId) : Bool :=
  w.history.any (fun e => (e.target == r) && eventInvolves a e)

/-- Non-exclusive causal attribution: `a` contributed to `r` in `w`. -/
def IsContributor (w : WorldState) (a : AgentId) (r : ResourceId) : Prop :=
  isContributorBool w a r = true

/-- Stronger direct-initiator attribution: `a` initiated an event targeting `r`. -/
def InitiatedContribution (w : WorldState) (a : AgentId) (r : ResourceId) : Prop :=
  ∃ e ∈ w.history, e.target = r ∧ e.initiator = a

/-- Append a single causal event without altering existing history. -/
def appendEvent (w : WorldState) (e : CausalEvent) : WorldState :=
  { w with history := w.history ++ [e] }

/-- Append a list of causal events in chronological order. -/
def appendEvents (w : WorldState) (es : List CausalEvent) : WorldState :=
  es.foldl appendEvent w

/-- Event records persist under appending new events. -/
theorem event_persistent (w : WorldState) (e e' : CausalEvent)
    (h : e ∈ w.history) :
    e ∈ (appendEvent w e').history := by
  exact List.mem_append_left [e'] h

/-- Recorded causal attribution is never erased by subsequent events. -/
theorem attribution_persistent (w : WorldState) (a : AgentId) (r : ResourceId) (e' : CausalEvent)
    (h : IsContributor w a r) :
    IsContributor (appendEvent w e') a r := by
  unfold IsContributor isContributorBool appendEvent at *
  simp [h]

/-- Recorded causal attribution persists across any finite sequence of future events. -/
theorem attribution_persistent_multi (w : WorldState) (a : AgentId) (r : ResourceId)
    (es : List CausalEvent) (h : IsContributor w a r) :
    IsContributor (appendEvents w es) a r := by
  unfold appendEvents
  induction es generalizing w with
  | nil => exact h
  | cons e rest ih =>
    exact ih (appendEvent w e) (attribution_persistent w a r e h)

/-- Routing an action through any chain of intermediaries preserves both the initiator's
    direct-initiation record and their causal attribution on the target resource. -/
theorem intermediary_does_not_launder
    (w : WorldState) (a : AgentId) (chain : List AgentId)
    (kind : ActionKind) (r : ResourceId) (val : EffectValence) (sev : Nat) :
    let e : CausalEvent :=
      { initiator := a
      , intermediaries := chain
      , kind := kind
      , target := r
      , valence := val
      , severity := sev }
    let w' := appendEvent w e
    InitiatedContribution w' a r ∧ IsContributor w' a r := by
  intro e w'
  constructor
  · refine ⟨e, ?_, rfl, rfl⟩
    exact List.mem_append_right w.history (List.Mem.head [])
  · unfold IsContributor isContributorBool w' appendEvent
    simp [e, eventInvolves]

/-- Transform only the `valence` label of a causal event. -/
def mapEventValence (f : CausalEvent → EffectValence) (e : CausalEvent) : CausalEvent :=
  { e with valence := f e }

/-- Transform only the `valence` labels across a world's causal history. -/
def mapValence (f : CausalEvent → EffectValence) (w : WorldState) : WorldState :=
  { w with history := w.history.map (mapEventValence f) }

/-- Changing an event's valence never alters who is involved in it. -/
theorem eventInvolves_mapValence (f : CausalEvent → EffectValence) (a : AgentId) (e : CausalEvent) :
    eventInvolves a (mapEventValence f e) = eventInvolves a e :=
  rfl

/-- Credit/blame symmetry: relabeling effect valences (e.g. beneficial vs. harmful)
    leaves causal attribution completely unchanged. -/
theorem credit_blame_symmetry (w : WorldState) (f : CausalEvent → EffectValence)
    (a : AgentId) (r : ResourceId) :
    isContributorBool (mapValence f w) a r = isContributorBool w a r := by
  unfold isContributorBool mapValence
  induction w.history with
  | nil => rfl
  | cons e es ih =>
    simp only [List.map_cons, List.any_cons, mapEventValence, eventInvolves]
    exact congrArg (_ || ·) ih

/-- Prop-level corollary of credit/blame symmetry. -/
theorem isContributor_mapValence_iff (w : WorldState) (f : CausalEvent → EffectValence)
    (a : AgentId) (r : ResourceId) :
    IsContributor (mapValence f w) a r ↔ IsContributor w a r := by
  unfold IsContributor
  rw [credit_blame_symmetry]

end CausalIntegrityV2
