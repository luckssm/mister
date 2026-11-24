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
- Any reviewer context it needs is identified

## Definition of done (a task is done when)

- Acceptance criteria are covered by tests, written before the implementation
- CI is green
- The PR description is complete (see `.github/pull_request_template.md`)
- Flagged hunks have been reviewed by the human
- Docs and ADRs are updated if a decision changed

## Task workflow

How the implementer runs a task from start to merge.

**Principle: ask on one-way doors, decide and flag on two-way doors.** A
one-way door is a choice that's hard to reverse or changes what gets built;
a two-way door is cheap to change later.

**Channels:** blocking questions go in the session, and work waits for the
answer. Judgment calls go in the PR under "Needs your decision", each with
the implementer's default, so merging without comment accepts the defaults.

1. **Before starting:** read the issue and its spec and check the
   definition of ready. If the spec is unclear, or the task is too big for
   one PR, ask before writing any code: all questions in one message, each
   with a suggested answer. A split is proposed, never done unilaterally.
2. **Start:** convert the issue's acceptance criteria to the numbered
   format if needed, move the issue to In Progress, and create the branch
   `<issue#>-<slug>` from an up-to-date `main`.
3. **During the work, stop and ask when:**
   - a dependency would be added;
   - the spec is wrong or contradicts itself;
   - the work would contradict an accepted ADR;
   - the scope grows beyond the issue;
   - an action is hard to reverse or affects something outside the repo
     (GitHub settings, anything public);
   - making a test pass would require changing the test or the spec (never
     weaken a test to get green);
   - the same approach has failed twice: stop and report what was tried and
     why it didn't work.

   Anything else: decide, and flag it in the PR.
4. **End:** open the PR from the template, move the issue to In Review, and
   stop.
5. **Review and merge:** the human comments; fixes go on the same PR, with
   the Review focus links regenerated. The human merges; repo settings
   delete the remote branch, and the implementer only syncs `main` and
   deletes the local branch.

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

When a PR uses a concept, library or technique that's new to this codebase
or non-obvious to an experienced developer (for example property-based
testing or seeded RNGs), its description names it, so review never depends
on knowledge that isn't written down. Otherwise the section is omitted. A
concept tied to one spot goes into that Review focus item instead.

## Framework metrics

- Cycle time per task and milestone
- What the harness flagged vs what actually had bugs
- Mutation score (from M2)
- Claude usage per task (mechanism decided in a Sprint 0 spike)
