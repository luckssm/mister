# Harness candidates

Harness features we might build, each tied to the incident that suggested
it, or to the risk it guards against when there's no incident yet. Nothing here is built until it's picked at a retro and goes through the
normal flow ("no harness feature without a logged incident", `inception.md`).

| Candidate | Incident | Logged |
| --- | --- | --- |
| CI check that the PR body has the template's required headings (Summary, Review focus, Acceptance criteria, Assumptions I made, Things I could not verify, Files changed, Tests, Reviewer context) | While adding the templates (#6, PR #14): `gh pr create` doesn't apply `.github/pull_request_template.md`, so a PR opened from the CLI can skip sections and nothing catches it. Today the only guard is the instruction in `CLAUDE.md`. | 2026-11-24 |
| Script that regenerates a PR's Review focus links (diff anchors and commit permalinks) from its head commit | No incident yet: the hand-built links on PR #14 landed correctly. The risk is forgetting to regenerate them after a push, leaving links that point at the wrong lines. Build only if that happens. | 2026-11-24 |
