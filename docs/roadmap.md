# Roadmap

Now / Next / Later. Milestones are ordered, not dated; cycle time is
recorded once work is done. Each milestone has a game track and a framework
track, and ends with a demo accepted against its definition of done.

## Now

### Sprint 0: Inception and setup

- Game: inception (done, see `inception.md`)
- Framework: repo, workspace, toolchain (ADR-0006), CI, templates, PO agent v0,
  tests, a benchmark and an engine purity lint in CI
- Demo: a trivial change goes through the full process end to end
- Tasks: `milestones/m0-sprint-0.md`

### Milestone 1: "A match happens"

- Game: contracts, pass + shot + minimal match loop, event log, basic stats, CLI
- Framework: invariant tests, first benchmark, first smoke realism test
- Demo: `pnpm sim --home A --away B --seed 42` prints a full match log,
  score and basic stats; the same seed gives the same match
- Tasks: `milestones/m1.md`

## Next

### Milestone 2: "A match is believable"

- Game: dribble, tackle, cross, set pieces (simplified), fatigue, calibrated
  xG, realism claims
- Framework: risk report v0 on PRs, mutation testing, performance budgets,
  spec-reviewer agent
- Demo: 10k simulated matches with stats in realistic ranges

### Milestone 3: "Tactics matter"

- Game: tactical levers (capped), halftime changes and substitutions,
  tactical claims, the súmula as readable prose, highlights from the log
- Framework: improvements earned by what slipped through in M1 and M2
- Demo: same teams, different tactics, measurably different matches, explained

The end of milestone 3 is first playable.

## Later (ordered)

1. Graphical UI
2. Leagues, seasons, calendars
3. Transfers, negotiations, contracts, finances
4. Morale, weather, referee bias (each only once the súmula can explain it)
5. Training, youth academy, staff
