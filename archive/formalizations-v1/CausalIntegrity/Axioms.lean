/-
  Causal Integrity — core sorts, predicates, and axioms (Lean 4)

  Framing: coherent causality preferred by action is the foundation;
  property-as-captured-causality is a proof instrument (see docs/framing.md).

  Source of truth for intended FOL meaning: formalizations/axioms.md

  Explicitly out of scope in this module (S1):
  - Axiom 5 (UPB / performative contradiction) — needs a language of rules
  - Forward simulation / short-horizon coherency API — S2/S3
-/

namespace CausalIntegrity

-- Basic sorts
axiom Agent : Type
axiom Resource : Type
axiom Action : Type
axiom Effect : Type
axiom State : Type
axiom Permission : Type
axiom Liability : Type

-- Predicates
axiom Causes : Agent → Action → Effect → Resource → Prop
axiom Intentional : Agent → Action → Prop
axiom Owns : Agent → Resource → Prop
/-- Null-owner marker for homesteading (Owner = Null).
    Kept primitive (not `¬∃ Owns`) so Axiom 1 is usable without a temporal
    state index; a full ledger with time remains open (S2). -/
axiom Unowned : Resource → Prop
axiom Coherent : State → Prop
axiom Prefers : Agent → (State → Prop) → Prop
axiom BreaksCoherency : Action → Prop
axiom ResultingState : Action → State

-- Agent filter
axiom CanCommunicate : Agent → Prop
axiom CanDispute : Agent → Prop
axiom MoralAgent : Agent → Prop

-- Consent-related predicates
axiom CreatesPermission : Agent → Permission → Prop
axiom Authorizes : Permission → Agent → Action → Prop
axiom Revoked : Permission → Prop
axiom Capable : Agent → Prop
axiom Coerced : Agent → Permission → Prop
axiom Incapacitated : Agent → Prop

-- Liability
axiom Damages : Agent → Action → Resource → Prop
axiom OwesRestitution : Agent → Agent → Liability → Prop

/-- Expanded Consent definition (matches formalizations/axioms.md). -/
def Consent (owner actor : Agent) (act : Action) : Prop :=
  ∃ (p : Permission),
    CreatesPermission owner p ∧
    Authorizes p actor act ∧
    ¬ Revoked p ∧
    Capable owner ∧
    ¬ Coerced owner p

/-- Axiom 0: Agent filter — moral agents communicate and can dispute. -/
axiom moral_agent_def :
  ∀ (a : Agent),
    MoralAgent a ↔ (CanCommunicate a ∧ CanDispute a)

/-- Capable (partial): currently only ¬ Incapacitated.
    Full cognitive-capacity clauses remain open (S2). -/
axiom capable_def :
  ∀ (o : Agent),
    Capable o ↔ (¬ Incapacitated o)

-- Coerced is intentionally primitive.
-- Intended meaning (not yet formal):
--   force, threat of significant harm, or extreme power asymmetry that
--   substantially undermines voluntary agency when producing permission p.
-- See formalizations/axioms.md.

/-- Axiom 1: Property as Captured Causality (proof instrument)
    An intentional causal action on a Null / unowned resource creates ownership.
    FOL in axioms.md writes `¬∃b Owns(b,r)`; Lean uses primitive `Unowned`
    to avoid timeless collapse (see module header / formalizations/README.md). -/
axiom property_capture :
  ∀ (a : Agent) (r : Resource) (act : Action) (e : Effect),
    Causes a act e r →
    Intentional a act →
    Unowned r →
    Owns a r

/-- Axiom 2: Exclusivity of Ownership -/
axiom exclusivity :
  ∀ (a b : Agent) (r : Resource),
    Owns a r → Owns b r → a = b

/-- Axiom 3: Non-consensual interference breaks coherency
    Violating another agent’s causal property without consent fractures
    preferred coherent states. Intentional/teleological contribution is meant
    to cover engineered indirect paths (see docs/intent-and-causality.md). -/
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

-- Axiom 5 (UPB / performative contradiction): NOT ENCODED.
-- A candidate rule ρ is not UPB-valid if assuming all agents follow ρ entails ⊥.
-- Requires a language of rules; deliberately scoped out of the S1 Lake core.
-- See formalizations/axioms.md and docs/upb-core-proofs.md.

/-- Axiom 6: Liability vector (not ownership transfer)
    Unconsented damage creates a restitution obligation. -/
axiom liability_vector :
  ∀ (a b : Agent) (r : Resource) (act : Action),
    Owns b r →
    Damages a act r →
    ¬ Consent b a act →
    ∃ (ℓ : Liability), OwesRestitution a b ℓ

-- Forward simulation / short-horizon coherency check: NOT ENCODED (S2/S3).
-- Intended later as a decision procedure over causal DAGs; see
-- docs/definition-of-done.md and docs/principles.md.

end CausalIntegrity
