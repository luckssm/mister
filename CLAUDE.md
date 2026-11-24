# Mister: guide for Claude Code

Mister is an engine-first football manager game and the testbed for an
AI-assisted development framework (the "harness"). Read `docs/vision.md`
before doing anything else.

## Sources of truth

- `docs/vision.md`: what we're building and why
- `docs/inception.md`: scope (IN / OUT / UNRESOLVED), risks, trade-offs
- `docs/roadmap.md`: milestones and order
- `docs/process.md`: how work flows. Follow it.
- `docs/adr/`: architecture decisions. Never contradict an accepted ADR; propose a new one instead.
- `docs/specs/`: approved specs. A spec is approved when its PR is merged.
  Only implement against an approved spec.
- `docs/milestones/`: task lists per milestone
- `docs/experiments/`: framework lessons and spike notes

## Hard rules

- One task = one issue = one branch = one PR. Keep PRs small.
- No implementation without an approved spec linked from the issue. Every
  behavior change ships with tests in the same PR, written test-first; only
  docs-only or config-only changes are exempt.
- `packages/engine` is pure: no I/O, no `Date.now()`, no `Math.random()`.
  All randomness goes through the injected, seeded `Rng`.
- Dependency rule: `packages/engine` never imports from adapters (CLI, UI,
  data loader) or from `packages/harness`.
- The event log is the source of truth. Stats and the súmula are derived
  from events, never tracked separately.
- Do not modify a test in the same PR as the code it tests unless the spec
  changed. If you must, state it explicitly in the PR description and say why.
- Dependencies: ask before adding any. Exact version pins, package version
  published at least 30 days ago (enforced by pnpm `minimumReleaseAge`, see
  ADR-0006), lockfile committed, run an audit.
- Use football domain language in code (`pass`, `press`, `coverage`, `zone`).
  English for all code, comments and docs.
- Spikes live on `spike/*` branches and are never merged. Their note in
  `docs/experiments/` lands by its own small docs PR.
- Never merge a PR. The human merges.
- Run every task by the task workflow in `docs/process.md`: when to stop and ask, and when to decide and flag.

## Conventions

- Commits: [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`, `fix:`, `docs:`, `chore:`, `test:`, `refactor:`, `ci:`).
- Branches: `<issue#>-<slug>`, for example `12-engine-purity-lint`. Spikes:
  `spike/<topic>`.
- PRs are squash-merged; the PR title becomes the commit message, so it
  follows Conventional Commits too.

## PR descriptions

`.github/pull_request_template.md` defines the sections, their format and
which are optional; follow it exactly. `gh pr create` doesn't
apply the template on its own: start the body from that file and pass it
with `--body-file`.

## Issues and specs

New issues use `.github/ISSUE_TEMPLATE/task.md`. New specs start from
`docs/specs/0000-template.md`; ADRs from `docs/adr/0000-template.md`.

## Commands

_Filled during Sprint 0: each task's PR adds the commands it introduces._
