# ADR-0004: The event log is the source of truth

- **Status:** Accepted
- **Date:** 2026-11-11

## Context

The game must explain results (the súmula), show stats, support highlights,
and be debuggable and testable. Tracking stats separately from what happened
risks inconsistencies.

## Decision

The engine emits an ordered log of match events (passes, dribbles, shots,
turnovers, goals...). All stats, the súmula and highlights are **derived**
from the log (projections, as in event sourcing). Nothing is tracked twice.

## Alternatives considered

- **Counters updated during simulation:** simpler at first, but stats can
  drift from what happened and explanations need a separate data source.

## Consequences

- Invariants become easy to test (score equals goal events).
- One log serves three purposes: debugging, tests, and the product (súmula,
  highlights).
- The event schema is a key contract; changing it affects every projection.
- Logs for many matches may be large; we may need compact representations later.
