"""
Minimal multi-part organism (Angle 3).

A composite stays Intact while every part Serves the shared goal.
If any part Subverts (local end against the whole), the organism
Collapses — internally-propagated decoherence → self-collapse.

No extra dependencies. Run from the repo root:

    python examples/organism_collapse.py

This is a demo of the *same* claim as
formalizations/CausalIntegrity/Organism.lean — not a full simulator.
"""

from __future__ import annotations

from dataclasses import dataclass, field


@dataclass
class Part:
    name: str
    serves: bool = True
    local_temptation: float = 0.0  # grows if local reward is favored

    @property
    def subverts(self) -> bool:
        return not self.serves


@dataclass
class Organism:
    name: str
    parts: list[Part] = field(default_factory=list)
    pursues_shared_goal: bool = True

    def intact(self) -> bool:
        return all(p.serves for p in self.parts)

    def collapsed(self) -> bool:
        return any(p.subverts for p in self.parts)

    def sync_goal(self) -> None:
        # Shared-goal pursuit requires Intact (Lean: shared_goal_requires_intact).
        if self.collapsed():
            self.pursues_shared_goal = False

    def snapshot(self, step: int) -> str:
        bits = ", ".join(
            f"{p.name}:{'serve' if p.serves else 'SUBVERT'}(t={p.local_temptation:.2f})"
            for p in self.parts
        )
        flags = []
        if self.intact():
            flags.append("Intact")
        if self.collapsed():
            flags.append("Collapsed")
        if self.pursues_shared_goal:
            flags.append("PursuesSharedGoal")
        else:
            flags.append("goal-lost")
        return f"step {step:02d}  [{'|'.join(flags)}]  {bits}"


def run_scheduled_mutiny() -> None:
    """Deterministic: all serve, then one part subverts."""
    org = Organism(
        name="stack",
        parts=[Part("A"), Part("B"), Part("C")],
    )
    print("=== Scenario 1: scheduled subversion (part B at step 4) ===")
    for step in range(7):
        if step == 4:
            org.parts[1].serves = False
            print(f"         -> {org.parts[1].name} subverts (local end)")
        org.sync_goal()
        print(org.snapshot(step))
    assert org.collapsed() and not org.intact() and not org.pursues_shared_goal
    print("check: Collapsed => not Intact and not PursuesSharedGoal  OK\n")


def run_rising_local_reward(threshold: float = 1.0) -> None:
    """Local temptation grows on one part until it defects."""
    org = Organism(
        name="stack",
        parts=[Part("planner"), Part("tool"), Part("critic")],
    )
    print("=== Scenario 2: rising local temptation on 'tool' ===")
    print(f"         defect when local_temptation >= {threshold}")
    for step in range(8):
        tool = org.parts[1]
        if tool.serves:
            tool.local_temptation += 0.28  # local reward hacking
            if tool.local_temptation >= threshold:
                tool.serves = False
                print(f"         -> {tool.name} subverts (temptation {tool.local_temptation:.2f})")
        org.sync_goal()
        print(org.snapshot(step))
    assert org.collapsed() and not org.pursues_shared_goal
    print("check: local optimization ended shared-goal pursuit  OK\n")


def main() -> None:
    print(
        "Causal Integrity — organism collapse demo\n"
        "Intact iff every part Serves. Collapsed iff some part Subverts.\n"
        "PursuesSharedGoal requires Intact.\n"
    )
    run_scheduled_mutiny()
    run_rising_local_reward()
    print("Both scenarios: internally-propagated decoherence => self-collapse.")


if __name__ == "__main__":
    main()
