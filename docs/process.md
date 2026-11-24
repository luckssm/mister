# Process

The goal is the **minimum process that makes AI-built code trustworthy**,
not maximum process. Any ritual or check that hasn't caught a problem or
saved time in a few cycles gets cut at a retro.

## Roles

- **Client (Lucas):** owns the vision, priorities and acceptance of deliveries.
- **Tech lead (Lucas):** owns contracts, ADRs, claims (what "correct" means),
  and reviews what the harness flags.
- **PO agent:** holds the vision and backlog, drafts specs, guards scope,
  reviews demos against acceptance criteria. Never writes code. Pushes back
  when scope sneaks into a milestone.
- **Implementer:** a Claude Code session, one task per PR.
- **Reviewer agents:** narrow lenses (spec, tests, deps/security), added as
  they're earned.

## Flow

1. **Brief:** what's wanted, in product language.
2. **Spec** in `docs/specs/`: acceptance criteria written so they can become
   tests. Drafted with Claude, in its own PR. The tech lead approves it by
   merging that PR; there is no status header. No code before an approved
   spec.
3. **Issues:** one per task, linked to the spec and to a milestone.
4. **PR per task:** branch, implementation, CI (tests, benchmarks; later
   mutation score and risk report), human reviews what's flagged, squash
   merge. Only the human merges. Branch protection on `main` requires a PR
   and green CI but no approving review, since there is one human.
5. **Milestone demo:** the PO agent checks the deliverable against the
   definition of done.
6. **Retro:** what slipped, what to cut, what to add. Framework lessons go to
   `docs/experiments/`.

## Flow model

Kanban: continuous flow, no timeboxes. Milestones live in GitHub Milestones,
tasks on a GitHub Project board. The docs in `docs/milestones/` hold each
milestone's plan and definition of done; GitHub holds execution status.
Status is never tracked in both. Cycle time runs from the issue moving to
In Progress on the board to its PR being merged. It is computed from GitHub
timestamps, never entered by hand, for every task and milestone.

## Definition of ready (a task can start when)

- It links an approved spec
- Its acceptance criteria are testable
- It's small enough for one PR
- Its reviewer context is identified

## Definition of done (a task is done when)

- Acceptance criteria are covered by tests, written before the implementation
- CI is green
- The PR description is complete (see `.github/pull_request_template.md`)
- Flagged hunks have been reviewed by the human
- Docs and ADRs are updated if a decision changed

## Acceptance

Issue acceptance criteria are numbered (`AC-1`, …) and never ticked. The
issue stays the spec; the PR's Acceptance criteria section maps each
criterion to its evidence; merging the PR is the acceptance.

## Repo settings

GitHub settings (labels, milestones, the project board, merge settings,
branch protection) change only through `scripts/github-setup.sh`, in a PR,
never by hand: a re-run of the script reverts manual changes.

## Spikes

Throwaway exploration to answer a question ("does a 5×6 grid feel
better?"). Branch `spike/<topic>`. Free-form, unstructured coding is
allowed. Never merged. The output is a short note in `docs/experiments/`
with what was learned, landed by its own small docs PR; then the real work
goes through the normal flow.

## Architecture decisions

Any decision that's hard to reverse or worth explaining gets an ADR in
`docs/adr/` (Nygard format). Accepted ADRs only change by being superseded
by a new ADR.

## Reviewer context

Every PR lists the concepts a reviewer needs to understand it (for example
property-based testing or seeded RNGs), so review never depends on
knowledge that isn't written down.

## Framework metrics

- Cycle time per task and milestone
- What the harness flagged vs what actually had bugs
- Mutation score (from M2)
- Claude usage per task (mechanism decided in a Sprint 0 spike)
