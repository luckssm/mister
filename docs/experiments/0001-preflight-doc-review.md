# 0001: Pre-flight doc review

- **Date:** 2026-11-17
- **Hypothesis:** having the implementer read every planning doc and list
  gaps before any work starts catches the problems that would otherwise
  surface mid-task as quiet workarounds.

## What we tried

Before the initial commit, a Claude Code session read `CLAUDE.md`, the
README and every file in `docs/`, summarized the project and the process in
its own words, and listed what was inconsistent, ambiguous or missing,
especially anything blocking Sprint 0. It proposed changes and waited; the
tech lead answered each item, and the answers were applied before the
initial commit, so commit 1 is the finalized plan.

## What happened

19 items, grouped by type:

- **Missing preconditions:** no repo or GitHub remote; the `gh` token lacked
  the `project` scope; no Node or pnpm version (local Node 20 is end of
  life).
- **Gaps in the process:** no task carried out the Sprint 0 definition of
  done; no way to record a spec's approval; no cycle-time mechanism; no
  branch protection; undocumented commit, branch and merge conventions; no
  labels; no license; engine purity rules with no enforcement.
- **Contradictions:** task 7 generated M1 issues that couldn't meet the
  definition of ready; the ADR template already existed but task 6 listed it;
  spikes are never merged, yet their note must land somewhere; the M1
  definition of done checked individual scorelines while its test checked
  the average.
- **Ambiguity:** where the PO agent lives; the commands section overlapping
  tasks 1–5; the role of `packages/harness`; package scope and module
  system.

## What changed

- Sprint 0: added task 11 (end-to-end demo, which is the definition of done)
  and task 12 (engine purity lint with ESLint built-in rules, before any M1
  code); task 7 now lists labels, the board's Status field, branch protection
  without required approvals, and no M1 issues until M1 starts.
- A spec is approved by merging its PR; no status header. Sprint 0 issue
  bodies are approved when the tech lead approves the `gh` commands.
- Cycle time is computed from GitHub timestamps (In Progress → PR merged),
  never entered by hand.
- `CLAUDE.md` gained conventions: Conventional Commits, `<issue#>-<slug>`
  branches, squash merge, the human merges.
- ADR-0006: Node 24 LTS, pnpm 10, `minimumReleaseAge` enforcing the 30-day
  rule.
- M1 definition of done made testable: average total goals between 1 and 5,
  and fewer than 1% of matches with 8+ goals.
- README states there is no license (all rights reserved).

## What we decided against

- A spec status header (merging the spec's PR is enough).
- A manually entered "Started" date for cycle time.
- Required approving reviews (one human can't approve their own PRs).
- Creating M1 issues now.
- A license, for now.

## Lesson

One review pass found two hard blockers (no repo, missing token scope) and
one definition of done with no task behind it, all before any code. Worth
repeating at the start of each milestone; cut it at a retro if it stops
finding anything.
