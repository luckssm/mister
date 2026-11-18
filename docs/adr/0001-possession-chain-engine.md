# ADR-0001: Possession-chain engine on a parametric zoned pitch

- **Status:** Accepted
- **Date:** 2026-11-11

## Context

The vision requires matches where tactics have visible, explainable effects
and results feel like real football, while simulating fast enough to run
thousands of matches for statistical tests.

## Decision

Simulate matches as sequences of possessions on a pitch divided into a grid
of zones (lanes × bands). The engine tracks where the ball is, who has it,
and what they do next. Each action (pass, dribble, cross, shot, tackle) is a
probabilistic roll using player attributes, tactics, fatigue and zone.
The grid size is a parameter, so zone count can be chosen by experiment.

## Alternatives considered

- **Strength comparison + dice (Brasfoot-style):** fast, but tactics have
  nothing to act on, which contradicts the "consequential" pillar.
- **Full 2D spatial simulation (FM-style):** realistic, but a huge project,
  slow for statistical testing, and hard to explain, which contradicts "legible".

## Consequences

- Tactics have concrete levers (where and how actions happen).
- Stats like possession, xG and passes by zone emerge naturally.
- Fast enough for large-scale statistical tests.
- Calibration has many parameters; more zones means more to tune.
- No continuous player positions, so no 2D animation can come straight from the engine.
