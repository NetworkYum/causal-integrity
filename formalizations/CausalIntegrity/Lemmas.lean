/-
  Causal Integrity — derived lemmas (S1)

  Grounded in Axioms 0–4 and 6. Prefer multi-axiom combinations over
  single-axiom projections. Scenario guides: examples/, docs/attack-vectors.md.
-/

import CausalIntegrity.Axioms

namespace CausalIntegrity

-- ---------------------------------------------------------------------------
-- Consent hygiene (Capable / Coerced / Revoked)
-- ---------------------------------------------------------------------------

/-- Incapacitated owners cannot grant Consent (Capable is required). -/
theorem incapacitated_owner_no_consent
    (owner actor : Agent) (act : Action)
    (hInc : Incapacitated owner) :
    ¬ Consent owner actor act := by
  intro hConsent
  obtain ⟨_p, ⟨_hCreate, _hAuth, _hRev, hCap, _hCoer⟩⟩ := hConsent
  have hNotInc : ¬ Incapacitated owner := (capable_def owner).mp hCap
  exact hNotInc hInc

/-- A coerced permission cannot witness Consent. -/
theorem coerced_permission_not_consent
    (owner actor : Agent) (act : Action) (p : Permission)
    (hCoerced : Coerced owner p) :
    ¬ (CreatesPermission owner p ∧
        Authorizes p actor act ∧
        ¬ Revoked p ∧
        Capable owner ∧
        ¬ Coerced owner p) := by
  intro h
  exact h.2.2.2.2 hCoerced

/-- A revoked permission cannot witness Consent. -/
theorem revoked_permission_not_consent
    (owner actor : Agent) (act : Action) (p : Permission)
    (hRevoked : Revoked p) :
    ¬ (CreatesPermission owner p ∧
        Authorizes p actor act ∧
        ¬ Revoked p ∧
        Capable owner ∧
        ¬ Coerced owner p) := by
  intro h
  exact h.2.2.1 hRevoked

-- ---------------------------------------------------------------------------
-- Agent filter / “nature” attack (Axiom 0)
-- ---------------------------------------------------------------------------

/-- Non-communicators are outside the moral-agent filter (coma / tree test). -/
theorem non_communicator_not_moral_agent
    (a : Agent) (h : ¬ CanCommunicate a) :
    ¬ MoralAgent a := by
  intro hm
  exact h ((moral_agent_def a).mp hm).1

/-- Entities that cannot dispute are outside the moral-agent filter. -/
theorem non_disputer_not_moral_agent
    (a : Agent) (h : ¬ CanDispute a) :
    ¬ MoralAgent a := by
  intro hm
  exact h ((moral_agent_def a).mp hm).2

/-- Missing either filter conjunct rules out moral agency.
    Blocks “nature / cosmos as co-owner” style claims that treat
    non-communicating causes as dispute parties (docs/attack-vectors.md). -/
theorem filter_failure_not_moral_agent
    (a : Agent) (h : ¬ CanCommunicate a ∨ ¬ CanDispute a) :
    ¬ MoralAgent a := by
  intro hm
  have ⟨hc, hd⟩ := (moral_agent_def a).mp hm
  cases h with
  | inl hnc => exact hnc hc
  | inr hnd => exact hnd hd

/-- Moral agents satisfy both filter conjuncts (inverse direction). -/
theorem moral_agent_can_communicate
    (a : Agent) (h : MoralAgent a) :
    CanCommunicate a :=
  (moral_agent_def a).mp h |>.1

theorem moral_agent_can_dispute
    (a : Agent) (h : MoralAgent a) :
    CanDispute a :=
  (moral_agent_def a).mp h |>.2

-- ---------------------------------------------------------------------------
-- Ownership exclusivity + capture (Axioms 1–2)
-- ---------------------------------------------------------------------------

/-- Ownership is unique. -/
theorem ownership_unique
    (a b : Agent) (r : Resource)
    (ha : Owns a r) (hb : Owns b r) :
    a = b :=
  exclusivity a b r ha hb

/-- A distinct agent from the owner does not co-own (exclusivity). -/
theorem distinct_agent_not_co_owner
    (owner other : Agent) (r : Resource)
    (hOwn : Owns owner r)
    (hDiff : other ≠ owner) :
    ¬ Owns other r := by
  intro hOther
  exact hDiff (exclusivity other owner r hOther hOwn)

/-- Intentional causal action on a Null / unowned resource yields ownership
    (homesteading under Axiom 1 + Unowned marker). -/
theorem intentional_null_capture
    (a : Agent) (r : Resource) (act : Action) (e : Effect)
    (hCause : Causes a act e r)
    (hIntent : Intentional a act)
    (hUnowned : Unowned r) :
    Owns a r :=
  property_capture a r act e hCause hIntent hUnowned

/-- After Null-capture, no distinct agent can also hold title (Axioms 1–2). -/
theorem null_capture_exclusive
    (a b : Agent) (r : Resource) (act : Action) (e : Effect)
    (hCause : Causes a act e r)
    (hIntent : Intentional a act)
    (hUnowned : Unowned r)
    (hDiff : b ≠ a) :
    Owns a r ∧ ¬ Owns b r := by
  have hOwn : Owns a r := property_capture a r act e hCause hIntent hUnowned
  exact ⟨hOwn, distinct_agent_not_co_owner a b r hOwn hDiff⟩

-- ---------------------------------------------------------------------------
-- Theft / non-consensual interference (Axioms 2–3)
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

/-- Theft-shaped case under Axioms 2–3: a distinct non-consensual interferer
    neither co-owns the resource nor preserves coherency. -/
theorem theft_neither_owns_nor_coherent
    (owner thief : Agent) (r : Resource) (act : Action) (e : Effect)
    (hOwn : Owns owner r)
    (hDiff : thief ≠ owner)
    (hCause : Causes thief act e r)
    (hNoConsent : ¬ Consent owner thief act) :
    ¬ Owns thief r ∧
      BreaksCoherency act ∧
      ¬ Coherent (ResultingState act) := by
  refine ⟨distinct_agent_not_co_owner owner thief r hOwn hDiff, ?_⟩
  exact non_consensual_breaks_coherency thief owner r act e hOwn hCause hNoConsent

/-- Homestead-then-seize: Null-capture by owner, then non-consensual seizure
    by a distinct thief, yields incoherency (Axioms 1–3).
    Uses primitive `Unowned` rather than timeless `¬∃ Owns`. -/
theorem homestead_then_theft_incoherent
    (owner thief : Agent) (r : Resource)
    (capAct stealAct : Action) (eCap eSteal : Effect)
    (hCauseCap : Causes owner capAct eCap r)
    (hIntent : Intentional owner capAct)
    (hUnowned : Unowned r)
    (hDiff : thief ≠ owner)
    (hCauseSteal : Causes thief stealAct eSteal r)
    (hNoConsent : ¬ Consent owner thief stealAct) :
    Owns owner r ∧
      ¬ Owns thief r ∧
      BreaksCoherency stealAct ∧
      ¬ Coherent (ResultingState stealAct) := by
  have hOwn : Owns owner r :=
    property_capture owner r capAct eCap hCauseCap hIntent hUnowned
  have hTheft :=
    theft_neither_owns_nor_coherent owner thief r stealAct eSteal
      hOwn hDiff hCauseSteal hNoConsent
  exact ⟨hOwn, hTheft.1, hTheft.2.1, hTheft.2.2⟩

-- ---------------------------------------------------------------------------
-- Liability ≠ ownership transfer (Axiom 6 + Axiom 2)
-- ---------------------------------------------------------------------------

/-- Unconsented damage yields some restitution debt. -/
theorem unconsented_damage_creates_liability
    (a b : Agent) (r : Resource) (act : Action)
    (hOwn : Owns b r)
    (hDmg : Damages a act r)
    (hNoConsent : ¬ Consent b a act) :
    ∃ (ℓ : Liability), OwesRestitution a b ℓ :=
  liability_vector a b r act hOwn hDmg hNoConsent

/-- Forest-fire / exhaust pattern: unconsented damage creates liability, but the
    damager does not thereby become owner (butterfly patch; docs/attack-vectors.md). -/
theorem liability_without_ownership_transfer
    (damager owner : Agent) (r : Resource) (act : Action)
    (hOwn : Owns owner r)
    (hDiff : damager ≠ owner)
    (hDmg : Damages damager act r)
    (hNoConsent : ¬ Consent owner damager act) :
    (∃ ℓ, OwesRestitution damager owner ℓ) ∧ ¬ Owns damager r := by
  refine ⟨liability_vector damager owner r act hOwn hDmg hNoConsent, ?_⟩
  exact distinct_agent_not_co_owner owner damager r hOwn hDiff

-- ---------------------------------------------------------------------------
-- Coherence preference + interference (Axioms 3–4)
-- ---------------------------------------------------------------------------

/-- Non-consensual interference produces a state outside the Coherent class
    that every agent prefers (Axiom 4). Instrument-level link from ledger
    violation to the foundation preference. -/
theorem interference_misses_universal_coherence_preference
    (interferer owner witness : Agent) (r : Resource)
    (act : Action) (e : Effect)
    (hOwn : Owns owner r)
    (hCause : Causes interferer act e r)
    (hNoConsent : ¬ Consent owner interferer act) :
    Prefers witness Coherent ∧ ¬ Coherent (ResultingState act) :=
  ⟨internal_coherence_preference witness,
    (non_consensual_breaks_coherency interferer owner r act e
      hOwn hCause hNoConsent).2⟩

end CausalIntegrity
