# ADR-0003: Functional core with ports and adapters, without full Clean Architecture ceremony

- **Status:** Accepted
- **Date:** 2026-11-11

## Context

The engine must be highly testable, deterministic, and usable by several
consumers (CLI now, UI later, the harness always). AI-written code tends to
add unnecessary abstraction layers.

## Decision

- The engine is a **functional core**: pure functions, no I/O, randomness
  only through an injected seeded RNG.
- CLI, data loader and future UI are **adapters** around it (ports and
  adapters / hexagonal architecture).
- **Dependency rule:** dependencies point inward; the engine imports nothing
  from adapters or the harness.
- We do **not** adopt full Clean Architecture layering (use cases,
  interactors, presenters, gateways) for the engine.

## Alternatives considered

- **Full Clean Architecture:** keeps the dependency rule, but its ceremony is
  overkill for a simulation engine and invites bloat.
- **No explicit boundaries:** fastest start, but couples the engine to I/O
  and makes tests and future UIs harder.

## Consequences

- The engine is trivially testable and deterministic.
- The harness can be extracted to its own project without touching the game.
- Reviewers should reject abstractions that don't serve a concrete need.
