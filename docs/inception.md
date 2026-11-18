# Inception deck

Based on Jonathan Rasmusson's Inception Deck (*The Agile Samurai*). Run on
2026-11-11, with Lucas as client and tech lead.

## 1. Why are we here?

To build a football manager game that is simple, consequential and legible.
See `vision.md`.

## 2. Elevator pitch

See `vision.md`.

## 3. Product box

See `vision.md`. The three ranked promises double as the prioritization
rule: a task should serve one of them.

## 4. The NOT list

"First playable" means the end of milestone 3.

### IN (first playable)

- One match between two teams on the zoned possession-chain engine
- Actions: pass, dribble, tackle/interception, cross, shot (with xG)
- Player attributes, formations, a small capped set of team tactics
- In-match fatigue
- Event log as source of truth; stats derived from it
- The súmula: readable match report explaining the result
- Fictional teams and players loaded from data files
- Deterministic, seeded simulation
- CLI as the only interface
- Realism and tactical claims as tests
- Framework: harness, process, PO agent, risk report

### OUT (for now), in planned implementation order after first playable

1. Graphical UI (no 2D animated pitch)
2. Leagues, seasons, calendars
3. Transfers, negotiations, contracts, finances
4. Morale, weather, referee bias: each only once the súmula can explain it
5. Training, youth academy, staff

### OUT (even later)

- Real club or player names in the public repo (real data stays local or private)
- Individual player instructions (team-level tactics only)
- Multiplayer, mobile, monetization

### UNRESOLVED (current leans)

- In-match decisions: halftime changes in first playable; any moment later
- Substitutions: halftime first; any moment later
- Set pieces: IN, simplified
- Fouls/cards: fouls only as a source of free kicks; cards later
- Injuries: OUT until seasons exist
- Tactical lever cap: around 4–6, decided when tactics are designed
- Zone count: parametric, decided by experiment
- Language: code and docs in English; game text TBD
- UI platform: decided after first playable

## 5. Meet the neighbors

- **Data files:** teams and players live outside the engine; an editor may come later
- **The framework (harness):** observes the game; the game never depends on it
- **Future UI:** consumes the engine's public API
- **Public GitHub:** anything committed is public; no real data, no secrets
- **Claude Code and agents:** work from the docs, so the docs must be good
- **IP and licensing:** solved by fictional public data; real data only private

## 6. Show the solution

- Pure engine package (domain, actions, resumable match loop, súmula and stats)
- Adapters around it: CLI, data loader, future UI
- Harness package observes from outside
- Docs at repo root

See ADRs 0001–0005 (architecture) and 0006 (toolchain).

## 7. What keeps us up at night

| Risk | Mitigation |
| --- | --- |
| Limited development time | Every milestone ships as a self-contained, usable increment |
| Process overhead outweighing its value, or drifting back to unstructured prompt-and-patch development | Spikes give exploration a sanctioned lane (never merged); every process step must earn its place and is reviewed at retros |
| Over-complexity (game) | NOT list, tactics cap, legibility rule, PO agent |
| Over-engineering (unnecessary abstractions in generated code) | Review agents, human-owned contracts, ADR-0003 |
| Framework work crowding out game work | No harness feature without a logged incident; Sprint 0 harness is deliberately minimal |
| Engine doesn't feel believable, or calibration takes disproportionate time | Realism claims as ranges from day one; timebox calibration |
| False confidence from AI-written tests | Mutation testing; human owns the claims |

## 8. Size it

First playable is 3 milestones after Sprint 0. No timeboxes (Kanban); cycle
time is recorded per task and milestone.

## 9. What's going to give

From most protected (top) to sacrificed first (bottom):

1. Engine correctness
2. Verification
3. Process (minimum version)
4. Scope
5. Speed
6. Polish

Rule: ship less, but properly. Spikes are the only sanctioned exception to
the process, and spike code is never merged.

## 10. What's it going to take

- **Lucas:** client plus tech lead/architect; occasional implementer
- **PO agent:** vision, backlog, specs, scope guard, demo acceptance
- **Implementer:** Claude Code sessions, one task per PR
- **Reviewer agents:** spec-reviewer first; others added when an incident earns them
- **Tools:** GitHub (Issues, Projects, Milestones, Actions), Node 24 LTS,
  pnpm 10, TypeScript, ESLint (engine purity rules), Vitest, fast-check,
  Vitest bench, Stryker (M2), Claude Code
- **Docs:** vision, specs and ADRs kept current so agents and reviewers can work from them
- **Claude usage** is a real resource; measure it (Sprint 0 spike)
