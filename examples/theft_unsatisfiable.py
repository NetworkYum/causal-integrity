\"\"\"
Toy satisfiability check for Causal Integrity's property-capture axiom.

Illustrative only — not a full ethics formalization.

Intended reading of symbols:
  C  — agent causes an effect on a resource
  D  — the action is direct / intentional (teleological contribution)
  P  — the agent holds property (captured causality) over that outcome

Axiom (simplified):  (C ∧ D) → P
  Intentional causal action on the relevant resource yields property capture
  (in the unowned-first-appropriation case this is Axiom 1; here we only show
  the local unsatisfiability pattern used in the public V2 pitch).

A "theft-shaped" attempt that asserts cause + intent but denies the captured
link is unsatisfiable *when Direct/Intentional is included*.

IMPORTANT: An earlier public sketch used only (axiom ∧ C ∧ ¬P). That formula
*is* satisfiable by setting D false. This file uses the corrected pattern.
\"\"\"

from __future__ import annotations

try:
    from sympy import And, Implies, Not, satisfiable, symbols
except ImportError as exc:  # pragma: no cover
    raise SystemExit(
        "Install sympy to run this example:  pip install sympy"
    ) from expc


def main() -> None:
    P, C, D = symbols("P C D")  # Property, Causes, Direct/Intentional

    axiom = Implies(And(C, D), P)

    # Incorrect older sketch (satisfiable — D can be false):
    incomplete = And(axiom, C, Not(P))
    # Corrected toy (unsatisfiable):
    theft_shaped = And(axiom, C, D, Not(P))

    print("Incomplete pattern satisfiable?", bool(satisfiable(incomplete)))
    print("Theft-shaped pattern satisfiable?", bool(satisfiable(theft_shaped)))
    print(
        "Theft-shaped is logically impossible under axiom:",
        not bool(satisfiable(theft_shaped)),
    )


if __name__ == "__main__":
    main()
