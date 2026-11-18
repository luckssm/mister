# Sprint 0: Setup

The initial commit contains only the inception docs. That's a bootstrap
exception, since the process can't govern its own creation. Every task below
goes through the full flow: issue, branch, small PR. Until the spec template
exists (task 6), each Sprint 0 issue carries its own acceptance criteria and
serves as its spec. Those issue bodies count as approved specs once the tech
lead approves the `gh` commands that create them.

Task 7 runs first, so the other tasks have issues to attach to. Task 11 runs
last, since it exercises everything else.

## Tasks

1. **Workspace:** pnpm workspaces with `packages/engine`, `packages/harness`,
   `apps/cli` placeholders. Node and pnpm pinned as in ADR-0006. Exact pins,
   dependency policy applied.
2. **TypeScript:** strict config shared across packages.
3. **Testing:** Vitest configured, one trivial test per package.
4. **CI:** GitHub Actions running typecheck and tests on every PR. Once it
   runs, make the CI check required by branch protection on `main`.
5. **Benchmark harness:** Vitest bench running in CI (reporting only, no budget yet).
6. **Templates:** issue template (with spec link and reviewer context), PR
   template (fields from `CLAUDE.md`), spec template. The ADR template
   already exists (`docs/adr/0000-template.md`); confirm it fits.
7. **GitHub setup:** created by Claude Code with the `gh` CLI, commands
   approved by the tech lead before they run:
   - Labels: `type:` feature / chore / docs / spike; `area:` engine /
     harness / cli / process; `needs-spec`.
   - Milestones: Sprint 0, M1, M2, M3.
   - Project board with a Status field (Todo / In Progress / In Review / Done).
   - One issue per Sprint 0 task, with acceptance criteria. M1 issues are
     created when M1 starts; until then `m1.md` holds the plan.
   - Branch protection on `main`: changes only through a PR, no approving
     review required (there is one human). The CI check becomes required in
     task 4.
8. **PO agent v0:** `.claude/agents/po.md`, which points to `vision.md` and
   `inception.md` instead of copying them; can draft a spec from a brief and
   review a demo against a definition of done.
9. **Spike: Claude usage measurement:** find out what can be measured per
   session or task and how to attach it to a PR. Output: a note in
   `docs/experiments/`, landed by its own small docs PR (the spike branch is
   never merged).
10. **`CLAUDE.md` commands section:** each task's PR adds the commands it
    introduces; this task checks the section is complete and correct.
11. **Demo: placeholder function end to end:** a real spec in `docs/specs/`
    (using the spec template), its issue, a placeholder function in
    `packages/engine` with its test written first, PR, CI green, merged.
    This is the definition-of-done run.
12. **Engine purity lint:** ESLint in CI using the built-in
    `no-restricted-globals` / `no-restricted-properties` /
    `no-restricted-imports` rules, so `packages/engine` fails CI on
    `Date.now()`, `Math.random()`, I/O modules, or imports from adapters or
    `packages/harness`. Must land before any M1 code.

## Definition of done

Task 11 is done: a trivial change goes through the full process (issue,
spec, PR, CI green, merged), templates are used, and cycle time can be
computed from GitHub timestamps.
