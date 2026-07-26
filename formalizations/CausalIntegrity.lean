/-
  Causal Integrity Framework
  Lean 4 axiom skeleton + starter lemmas

  Core idea: Property = Captured Causality
  Violations of preferred coherent states break action/reaction coherency chains.

  Status:
  - Core axioms encoded
  - Consent expanded as a definition
  - Capable: partial ( ¬ Incapacitated )
  - Coerced: primitive (see formalizations/axioms.md for intended meaning)
  - Axiom 5 (UPB / performative contradiction) not yet encoded
  - Not a Lake package yet; treat this as a standalone sketch
-/

-- Basic sorts
axiom Agent : Type
axiom Resource : Type
axiom Action : Type
axiom Effect : Type
axiom State : Type
axiom Permission : Type

-- Predicates
axiom Causes : Agent → Action → Effect → Resource → Prop
axiom Intentional : Agent → Action → Prop
axiom Owns : Agent → Resource → Prop
axiom Coherent : State → Prop
axiom Prefers : Agent → (State → Prop) → Prop
axiom BreaksCoherency : Action → Prop
axiom ResultingState : Action → State

-- Consent-related predicates
axiom CreatesPermission : Agent → Permission → Prop
axiom Authorizes : Permission → Agent → Action → Prop
axiom Revoked : Permission → Prop
axiom Capable : Agent → Prop
axiom Coerced : Agent → Permission → Prop
axiom Incapacitated : Agent → Prop

/-- Expanded Consent definition (matches formalizations/axioms.md). -/
def Consent (owner actor : Agent) (act : Action) : Prop :=
  ∃ (p : Permission),
    CreatesPermission owner p ∧
    Authorizes p actor act ∧
    ¬ Revoked p ∧
    Capable owner ∧
    ¬ Coerced owner p

/-- Capable (partial): currently only ¬ Incapacitated.
    Full cognitive-capacity clauses remain open. -/
axiom capable_def :
  ∀ (o : Agent),
    Capable o ↔ (¬ Incapacitated o)

-- Coerced is intentionally primitive.
-- Intended meaning (not yet formal):
--   force, threat of significant harm, or extreme power asymmetry that
--   substantially undermines voluntary agency when producing permission p.
-- See formalizations/axioms.md.

-- Core Axioms

/-- Axiom 1: Property as Captured Causality
    An intentional causal action on a previously unowned resource creates ownership. -/
axiom property_capture :
  ∀ (a : Agent) (r : Resource) (act : Action) (e : Effect),
    Causes a act e r →
    Intentional a act →
    (¬ ∃ b, Owns b r) →
    Owns a r

/-- Axiom 2: Exclusivity of Ownership -/
axiom exclusivity :
  ∀ (a b : Agent) (r : Resource),
    Owns a r → Owns b r → a = b

/-- Axiom 3: Non-consensual interference breaks coherency
    Violating another agent’s causal property without consent fractures
    preferred coherent states. -/
axiom non_consensual_breaks_coherency :
  ∀ (a b : Agent) (r : Resource) (act : Action) (e : Effect),
    Owns b r →
    Causes a act e r →
    ¬ Consent b a act →
    BreaksCoherency act ∧ ¬ Coherent (ResultingState act)

/-- Axiom 4: Internal Ethical Coherence Preference
    Every agent maintains a preference for coherent states. -/
axiom internal_coherence_preference :
  ∀ (a : Agent), Prefers a Coherent

-- ---------------------------------------------------------------------------
-- Starter lemmas (immediate consequences of Axiom 3)
-- ---------------------------------------------------------------------------

/-- Non-consensual interference yields an incoherent resulting state. -/
theorem non_consensual_not_coherent
    (a b : Agent) (r : Resource) (act : Action) (e : Effect)
    (hOwn : Owns b r)
    (hCause : Causes a act e r)
    (hNoConsent : ¬ Consent b a act) :
    ¬ Coherent (ResultingState act) :=
  (non_consensual_breaks_coherency a b r act e hOwn hCause hNoConsent).2

/-- Non-consensual interference breaks coherency (action-level flag). -/
theorem non_consensual_breaks
    (a b : Agent) (r : Resource) (act : Action) (e : Effect)
    (hOwn : Owns b r)
    (hCause : Causes a act e r)
    (hNoConsent : ¬ Consent b a act) :
    BreaksCoherency act :=
  (non_consensual_breaks_coherency a b r act e hOwn hCause hNoConsent).1

/-- Ownership is unique: if a and b both own r, they are the same agent. -/
theorem ownership_unique
    (a b : Agent) (r : Resource)
    (ha : Owns a r) (hb : Owns b r) :
    a = b :=
  exclusivity a b r ha hb
