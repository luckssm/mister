# ADR-0006: Toolchain: Node 24 LTS, pnpm 10, release-age enforced

- **Status:** Accepted
- **Date:** 2026-11-17

## Context

The docs named pnpm and TypeScript but no runtime or package manager
versions. Local and CI environments must match, or "works on my machine"
undermines deterministic tests and benchmarks. Node 20 reached end of life
in April 2026. The dependency policy (exact pins, published at least 30 days
ago, lockfile, audit) relied on whoever adds a dependency checking dates by
hand.

## Decision

- **Runtime:** Node 24 (Active LTS), pinned to an exact version in `.nvmrc`
  and `engines.node`. CI reads `.nvmrc`.
- **Package manager:** pnpm 10, pinned to an exact version in the root
  `packageManager` field. CI uses the same version.
- **Release age:** `minimumReleaseAge: 43200` (minutes, so 30 days) in
  `pnpm-workspace.yaml`, so pnpm refuses to resolve versions published less
  than 30 days ago. Verified in the pnpm 10.34.7 source: the value is read in
  minutes and an immature version fails resolution with "does not meet the
  minimumReleaseAge constraint". Task 1 confirms the behavior in practice
  before we rely on it.
- **Same rule for the toolchain:** the exact Node and pnpm versions are also
  at least 30 days old when pinned. Exception: a security release may be
  adopted sooner; the PR says so and why.
- **GitHub Actions are dependencies too:** pinned to a full commit SHA, with
  the version in a comment.
- Exact pins are chosen in Sprint 0 task 1, not here, so this ADR doesn't go
  stale with every patch release.

## Alternatives considered

- **Node 22 LTS:** still supported, but in maintenance and ends sooner; no
  reason to start a new project on it.
- **Corepack to manage pnpm:** convenient, but corepack is no longer bundled
  from Node 25, so we'd be building on something on its way out.
- **Checking release dates by hand:** easy to forget, and an AI implementer
  can't be trusted to do it every time; a pnpm setting fails loudly.

## Consequences

- Local, CI and future contributors run the same versions.
- A dependency newer than 30 days can't be installed by accident; a real
  need for one goes into `minimumReleaseAgeExclude` with a reason in the PR.
- Upgrading Node or pnpm is an explicit PR that touches the pins.
- When Node 24 leaves LTS, a new ADR supersedes this one.
