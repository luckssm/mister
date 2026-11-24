# Harness candidates

Harness features we might build, each tied to the incident that suggested
it. Nothing here is built until it's picked at a retro and goes through the
normal flow ("no harness feature without a logged incident", `inception.md`).

| Candidate | Incident | Logged |
| --- | --- | --- |
| CI check that the PR body has the template's required headings (Summary, Review focus, Acceptance criteria, Assumptions I made, Things I could not verify, Files changed, Tests, Reviewer context) | While adding the templates (#6, PR #14): `gh pr create` doesn't apply `.github/pull_request_template.md`, so a PR opened from the CLI can skip sections and nothing catches it. Today the only guard is the instruction in `CLAUDE.md`. | 2026-11-24 |
