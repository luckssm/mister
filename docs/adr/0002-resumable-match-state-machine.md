# ADR-0002: The match engine is a resumable state machine

- **Status:** Accepted
- **Date:** 2026-11-11

## Context

The first playable allows changes at halftime; later the manager should be
able to make decisions (tactics, substitutions) at any moment of a match.

## Decision

The match is advanced step by step: the engine takes a match state and
returns the next state plus emitted events. Running a full match is just
stepping until the final whistle. Pausing at any step, applying changes, and
resuming is a first-class operation.

## Alternatives considered

- **One opaque `simulateMatch` function running 90 minutes:** simpler at
  first, but in-match decisions would require a painful retrofit.

## Consequences

- Halftime and live decisions use the same mechanism.
- Matches can be inspected mid-way (debugging, tests, future UI).
- State must be explicit and serializable; no hidden state in closures.
