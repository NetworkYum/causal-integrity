/-
  Causal Integrity Framework
  Lean 4 Proof-of-Concept

  Core idea: Property = Captured Causality
  Violations of preferred coherent states break action/reaction coherency chains.
  Designed for machine verification and theorem proving.

  This is a proof-of-concept formalization. Capable and Coerced are given
  high-level characterizations and can be refined further.
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

/-- Expanded Consent definition -/
def Consent (owner actor : Agent) (act : Action) : Prop :=
  ∃ (p : Permission),
    CreatesPermission owner p ∧
    Authorizes p actor act ∧
    ¬ Revoked p ∧
    Capable owner ∧
    ¬ Coerced owner p

/-- Capable: currently a functioning Agent and not incapacitated -/
axiom capable_def :
  ∀ (o : Agent),
    Capable o ↔ (¬ Incapacitated o)

/-- Coerced: high-level characterization (see documentation for intended meaning) -/
axiom coerced_def :
  ∀ (o : Agent) (p : Permission),
    Coerced o p → True

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
    This is the central principle: violating another agent’s causal property
    without consent fractures preferred coherent states. -/
axiom non_consensual_breaks_coherency :
  ∀ (a b : Agent) (r : Resource) (act : Action) (e : Effect),
    Owns b r →
    Causes a act e r →
    ¬ Consent b a act →
    BreaksCoherency act ∧ ¬ Coherent (ResultingState act)

/-- Axiom 4: Internal Ethical Coherence Preference
    The agent maintains a preference for coherent states. -/
axiom internal_coherence_preference :
  ∀ (a : Agent), Prefers a Coherent
