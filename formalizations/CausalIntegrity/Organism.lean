/-
  Causal Integrity — composite organism / shared-goal integrity (Angle 1)

  Operational claim (docs/systemic-stability.md):
    shared goal holds the whole together
      → dissonance / local subversion
      → internally-propagated decoherence
      → self-collapse (no longer one organism)

  This module is independent of the property ledger. Property remains a
  proof *instrument* for external interference; this is the *organism*
  story for internal decoherence.

  Constructive: we prove Collapsed → ¬ Intact and
  Collapsed → ¬ PursuesSharedGoal. The converse (¬ Intact → Collapsed)
  would need classical logic or a different definition; we do not claim it.
-/

import CausalIntegrity.Axioms

namespace CausalIntegrity

/-- A composite agent / multi-part organism (MoE, tool stack, society of modules). -/
axiom Composite : Type

/-- A part / sub-agent / module of some composite. -/
axiom Part : Type

/-- `Member p c` — part `p` belongs to composite `c`. -/
axiom Member : Part → Composite → Prop

/-- `Serves p c` — part still serves the whole's coordinated structure. -/
axiom Serves : Part → Composite → Prop

/-- `Subverts p c` — part pursues a local end against the whole. -/
axiom Subverts : Part → Composite → Prop

/-- The composite is still in coordinated pursuit of a shared goal. -/
axiom PursuesSharedGoal : Composite → Prop

/-- Intact organism: every member still serves the whole. -/
def Intact (c : Composite) : Prop :=
  ∀ (p : Part), Member p c → Serves p c

/-- Collapsed organism: some member subverts (local end against the whole). -/
def Collapsed (c : Composite) : Prop :=
  ∃ (p : Part), Member p c ∧ Subverts p c

/-- On members, serving and subverting are incompatible.
    (A part that subverts is not serving.) -/
axiom subvert_not_serve :
  ∀ (p : Part) (c : Composite),
    Member p c → Subverts p c → ¬ Serves p c

/-- Coordinated shared-goal pursuit requires an intact organism.
    If the identity of the composite *is* coordinated pursuit, loss of
    intactness is loss of that identity (docs/systemic-stability.md). -/
axiom shared_goal_requires_intact :
  ∀ (c : Composite), PursuesSharedGoal c → Intact c

/-- A member that subverts falsifies Intact. -/
theorem subvert_breaks_intact
    (c : Composite) (p : Part)
    (hMem : Member p c)
    (hSub : Subverts p c) :
    ¬ Intact c := by
  intro hInt
  have hServe : Serves p c := hInt p hMem
  exact (subvert_not_serve p c hMem hSub) hServe

/-- Collapse implies the organism is not intact. -/
theorem collapsed_not_intact
    (c : Composite)
    (h : Collapsed c) :
    ¬ Intact c := by
  obtain ⟨p, hMem, hSub⟩ := h
  exact subvert_breaks_intact c p hMem hSub

/-- Collapse implies the organism is no longer pursuing a shared goal. -/
theorem collapsed_not_pursuing_shared_goal
    (c : Composite)
    (h : Collapsed c) :
    ¬ PursuesSharedGoal c := by
  intro hGoal
  have hInt : Intact c := shared_goal_requires_intact c hGoal
  exact collapsed_not_intact c h hInt

/-- Contrapositive form: still pursuing a shared goal ⇒ not collapsed. -/
theorem pursuing_shared_goal_not_collapsed
    (c : Composite)
    (h : PursuesSharedGoal c) :
    ¬ Collapsed c := by
  intro hCol
  exact collapsed_not_pursuing_shared_goal c hCol h

/-- If every member serves, no member can be a known subverter. -/
theorem intact_member_not_subverting
    (c : Composite) (p : Part)
    (hInt : Intact c)
    (hMem : Member p c) :
    ¬ Subverts p c := by
  intro hSub
  exact subvert_breaks_intact c p hMem hSub hInt

end CausalIntegrity
