# ADR-0005: Separate deciding an action from resolving it

- **Status:** Accepted
- **Date:** 2026-11-11

## Context

Tactics and player attributes both influence what happens, but in different
ways. Mixing them in one function makes effects hard to test and explain.

## Decision

Each step has two phases:

- `chooseAction(ctx, rng) → ActionIntent`: what the carrier tries.
- `resolveAction(intent, ctx, rng) → ActionOutcome`: whether it works and
  where the ball ends up.

Guiding rule: **tactics mostly shape decisions; attributes mostly shape
resolution.**

## Alternatives considered

- **A single function per action that decides and resolves:** less code, but
  tactical effects and skill effects become entangled.

## Consequences

- "High tempo → more forward pass attempts" is testable separately from
  "better passers complete more passes".
- The súmula can explain both what a team tried and why it worked or failed.
- Edge cases where tactics affect resolution (e.g. pressing intensity raising
  tackle success) must be documented explicitly.
