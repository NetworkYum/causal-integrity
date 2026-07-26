"""
Causal ledger toy checks (SymPy) — recovered from March Grok unified framework.

Illustrative only. Requires: pip install sympy

Checks:
  1. Property axiom local pattern (C ∧ D → P) unsat with C,D,¬P
  2. Homesteading pattern satisfiable when Null + First
  3. Liability pattern: damage without consent forces L in the model

These are *propositional toys*, not quantified FOL proofs.
"""

from __future__ import annotations

try:
    from sympy import And, Implies, Not, Or, satisfiable, symbols
except ImportError as exc:  # pragma: no cover
    raise SystemExit("Install sympy: pip install sympy") from exc


def main() -> None:
    # Propositional stand-ins
    P, C, D = symbols("P C D")  # Property, Causes, Direct
    N, F = symbols("N F")  # Null owner, First appropriation
    L, Cn = symbols("L Cn")  # Liability, Consent
    Dmg = symbols("Dmg")  # Damage event

    property_axiom = Implies(And(C, D), P)
    homestead = Implies(And(N, C, D, F), P)
    liability = Implies(And(P, Dmg, Not(Cn)), L)

    # 1) Theft-shaped: assert cause+direct but deny property → unsat under axiom
    theft_shaped = And(property_axiom, C, D, Not(P))
    print("1. Theft-shaped unsatisfiable:", not bool(satisfiable(theft_shaped)))

    # Incomplete older pattern (D free) — still satisfiable
    incomplete = And(property_axiom, C, Not(P))
    print("   Incomplete (no D) satisfiable:", bool(satisfiable(incomplete)))

    # 2) Homestead apple: Null + first intentional cause → can own
    apple = And(homestead, N, C, D, F)
    print("2. Homestead claim satisfiable:", bool(satisfiable(apple)))

    # 3) Liability: if we force damage without consent and owned resource,
    #    liability must hold when axiom is included
    #    Model: P, Dmg, ¬Cn, liability axiom → L is forced
    forced = And(liability, P, Dmg, Not(Cn))
    model = satisfiable(forced, all_models=False)
    print("3. Liability model exists:", bool(model))
    if model:
        print("   L in model:", bool(model.get(L, False)) or model.get(L) is True)

    # Fire exhaust: damage without treating exhaust as ownership transfer
    # (liability may hold; ownership from mere exhaust should not)
    exhaust_not_own = And(liability, P, Dmg, Not(Cn), Not(Implies(Dmg, P)))
    print("4. Liability without exhaust-ownership sat:", bool(satisfiable(exhaust_not_own)))


if __name__ == "__main__":
    main()
