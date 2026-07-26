# Attack Vectors & Patches (March Gemini Arc)

Two “compiler collisions” against a naïve `Property ↔ Causes ∧ Affects` definition, and the patches derived in Gemini chats 17–18 (user responses + formalization).

---

## Attack 1 — Butterfly / infinite causality

**Naïve rule:** If agent causes action and action affects resource, agent owns resource.

**Attack:** Bob lights a campfire. An ember drifts and burns an unowned forest. Does Bob own the charcoal field? Every action affects the universe gravitationally — unbounded ownership sprawl (or absurd theft claims on exhaust).

**Patch (user + formalization):**

- Distinguish **Direct / teleological** action from **incidental causal exhaust**.
- Forest fire on *another agent’s* land is not ownership transfer; it is **state violation → Liability**, if unconsented.
- Bounding box for `Direct(act)` is mandatory for machine implementation.

```
Property(Sam, forest)
∧ Causes(Bob, damage)
∧ ¬Consent(Sam, …)
→ Liability(Bob, Sam)     # NOT Property(Bob, forest)
```

---

## Attack 2 — Nature / original appropriation

**Attack:** Bob picks a wild apple. Sam: “You only caused 0.0001% of the apple’s state; cosmology caused the rest. You can’t own it.”

**Patch (user contribution, chat-18):**

1. **Categorization error** if we treat trees as full moral agents. Ethics is for entities that can communicate and dispute (coma test / agent filter).
2. Wild resource starts as **Owner = Null**.
3. First causal agency on Null captures property (homesteading).
4. Sam waiting until *after* labor then complaining prefers the transformed good without providing causal input — invalid claim on the ledger.
5. Partial cosmic causality does not create a communicable co-owner; you do not negotiate with the apple.

```
Owner(r) = Null
∧ Causes(Bob, act) ∧ Affects(act, r) ∧ First(act, r)
→ Property(Bob, r)
```

---

## Attack 3 — Shared creation (March Grok merge)

**Scenario:** Bob forges blade, Sam attaches handle. Who owns?

**Resolution (provisional):** Joint / proportional ledger entries; use requires consent of co-owners; disputes → resolution procedure. Causality is additive, not nullifying. Full multi-party ownership remains open in Lean (Axiom 2 is exclusive for the minimal theory).

---

## Engineering takeaway

These are not nitpicks. A superintelligence will press:

- “Incidental exhaust” as deniability  
- “Nature caused it” against appropriation  
- Partial contribution against exclusive title  

The March arc’s answer: **agent filter + Null capture + liability≠ownership + Direct bound**. Formal thresholds for `Direct` / contribution % remain Tier‑1 open work ([open-problems.md](open-problems.md)).
