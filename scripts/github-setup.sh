#!/usr/bin/env bash
# GitHub setup for Mister (Sprint 0, task 7).
#
# Creates labels, milestones, the project board, the Sprint 0 issues, repo
# merge settings and branch protection on main.
#
# Idempotent: every step checks what already exists first. Re-running it
# creates no duplicate labels, milestones, boards or issues; labels, merge
# settings and branch protection are re-applied to the values below.
#
# Requires: gh (logged in, scopes: repo, project), jq.
# Usage: scripts/github-setup.sh
set -euo pipefail

OWNER="luckssm"
REPO="$OWNER/mister"
PROJECT_TITLE="Mister"
DOC_URL="https://github.com/$REPO/blob/main/docs/milestones/m0-sprint-0.md"

log() { printf '%s\n' "$*" >&2; }

# ---------------------------------------------------------------------------
# Labels (create or update in place)
# ---------------------------------------------------------------------------
label() { gh label create "$1" --repo "$REPO" --color "$2" --description "$3" --force >/dev/null; log "label: $1"; }

label "type:feature" "1d76db" "New behavior"
label "type:bug"     "d73a4a" "Something that doesn't work as specified"
label "type:chore"   "c5def5" "Tooling, config, setup"
label "type:docs"    "0e8a16" "Documentation only"
label "type:spike"   "fbca04" "Throwaway exploration; never merged"
label "area:engine"  "5319e7" "packages/engine"
label "area:harness" "d4c5f9" "packages/harness and framework tooling"
label "area:cli"     "bfdadc" "apps/cli"
label "area:process" "f9d0c4" "Repo, CI, templates, process docs"
label "needs-spec"   "e99695" "Can't start: no approved spec yet"

# GitHub's default labels (delete if present)
existing_labels="$(gh label list --repo "$REPO" --limit 200 --json name --jq '.[].name')"
for default in "accessibility" "bug" "documentation" "duplicate" "enhancement" "good first issue" \
               "help wanted" "invalid" "question" "wontfix"; do
  if grep -qxF "$default" <<<"$existing_labels"; then
    gh label delete "$default" --repo "$REPO" --yes >/dev/null
    log "default label deleted: $default"
  fi
done

# ---------------------------------------------------------------------------
# Milestones (create if missing, matched by exact title)
# ---------------------------------------------------------------------------
existing_milestones="$(gh api "repos/$REPO/milestones?state=all&per_page=100" --jq '.[].title')"
milestone() {
  if grep -qxF "$1" <<<"$existing_milestones"; then
    log "milestone exists: $1"
  else
    gh api "repos/$REPO/milestones" -f title="$1" -f description="$2" >/dev/null
    log "milestone created: $1"
  fi
}

milestone "Sprint 0" "Inception and setup. Plan: docs/milestones/m0-sprint-0.md"
milestone "M1"       "A match happens. Plan: docs/milestones/m1.md"
milestone "M2"       "A match is believable. See docs/roadmap.md"
milestone "M3"       "Tactics matter (first playable). See docs/roadmap.md"

# ---------------------------------------------------------------------------
# Project board (create if missing, link to repo, ensure Status options)
# ---------------------------------------------------------------------------
project_number="$(gh project list --owner "$OWNER" --format json --limit 100 \
  | jq -r --arg t "$PROJECT_TITLE" '.projects[] | select(.title == $t) | .number' | head -n1)"
if [[ -z "$project_number" ]]; then
  project_number="$(gh project create --owner "$OWNER" --title "$PROJECT_TITLE" --format json | jq -r '.number')"
  log "project created: #$project_number"
else
  log "project exists: #$project_number"
fi

project_json="$(gh api graphql -f owner="$OWNER" -F n="$project_number" -f query='
  query($owner: String!, $n: Int!) {
    user(login: $owner) {
      projectV2(number: $n) {
        id
        repositories(first: 20) { nodes { nameWithOwner } }
        field(name: "Status") {
          ... on ProjectV2SingleSelectField { id options { id name color description } }
        }
      }
    }
  }' --jq '.data.user.projectV2')"
project_id="$(jq -r '.id' <<<"$project_json")"
status_field_id="$(jq -r '.field.id' <<<"$project_json")"

if jq -e --arg r "$REPO" '.repositories.nodes[] | select(.nameWithOwner == $r)' <<<"$project_json" >/dev/null; then
  log "project already linked to $REPO"
else
  gh project link "$project_number" --owner "$OWNER" --repo "$REPO" >/dev/null
  log "project linked to $REPO"
fi

# The repo is public and the board is part of the process story.
if [[ "$(gh project view "$project_number" --owner "$OWNER" --format json | jq -r '.public')" == "true" ]]; then
  log "project already public"
else
  gh project edit "$project_number" --owner "$OWNER" --visibility PUBLIC >/dev/null
  log "project made public"
fi

# New boards come with Status = Todo / In Progress / Done. Add "In Review",
# keeping the existing option ids so items already on the board keep their status.
if jq -e '.field.options[] | select(.name == "In Review")' <<<"$project_json" >/dev/null; then
  log "status options already include In Review"
else
  options="$(jq -c '
    .field.options as $o
    | def keep($n): ($o[] | select(.name == $n) | {id, name, color, description});
      [ keep("Todo"), keep("In Progress"),
        {name: "In Review", color: "PURPLE", description: "PR open, waiting for the human"},
        keep("Done") ]' <<<"$project_json")"
  gh api graphql --input - >/dev/null <<EOF
{"query": "mutation(\$f: ID!, \$o: [ProjectV2SingleSelectFieldOptionInput!]) { updateProjectV2Field(input: {fieldId: \$f, singleSelectOptions: \$o}) { projectV2Field { ... on ProjectV2SingleSelectField { id } } } }",
 "variables": {"f": "$status_field_id", "o": $options}}
EOF
  log "status options: Todo / In Progress / In Review / Done"
  project_json="$(gh api graphql -f owner="$OWNER" -F n="$project_number" -f query='
    query($owner: String!, $n: Int!) { user(login: $owner) { projectV2(number: $n) {
      field(name: "Status") { ... on ProjectV2SingleSelectField { options { id name } } } } } }' \
    --jq '.data.user.projectV2')"
fi
status_option() { jq -r --arg n "$1" '.field.options[] | select(.name == $n) | .id' <<<"$project_json"; }

# ---------------------------------------------------------------------------
# Sprint 0 issues (create if missing, matched by exact title)
# Created in task order on a repo with no issues or PRs yet, so issue #N is
# task N. Each body is that task's approved spec (Sprint 0 bootstrap rule).
#
# These bodies are SEED versions, used only when an issue is created. Once an
# issue exists, the GitHub issue is the canonical spec and this script is not
# kept in sync with later edits to it.
# ---------------------------------------------------------------------------
existing_issues="$(gh issue list --repo "$REPO" --state all --limit 500 --json title,url)"

# issue TITLE LABELS(comma-separated) STATUS  <<< body
issue() {
  local title="$1" labels="$2" status="$3" body url item_id
  body="$(cat)"
  url="$(jq -r --arg t "$title" '.[] | select(.title == $t) | .url' <<<"$existing_issues" | head -n1)"
  if [[ -n "$url" ]]; then
    log "issue exists: $title ($url)"
    return
  fi
  local label_args=()
  IFS=',' read -ra ls <<<"$labels"
  for l in "${ls[@]}"; do label_args+=(--label "$l"); done
  url="$(gh issue create --repo "$REPO" --title "$title" --milestone "Sprint 0" "${label_args[@]}" \
    --body "$body"$'\n\n'"---"$'\n'"Spec: this issue (Sprint 0 bootstrap rule, see [m0-sprint-0.md]($DOC_URL)).")"
  item_id="$(gh project item-add "$project_number" --owner "$OWNER" --url "$url" --format json | jq -r '.id')"
  gh project item-edit --project-id "$project_id" --id "$item_id" \
    --field-id "$status_field_id" --single-select-option-id "$(status_option "$status")" >/dev/null
  log "issue created: $title ($url) [$status]"
}

issue "S0-01: Workspace" "type:chore,area:process" "Todo" <<'EOF'
pnpm workspace with placeholder packages, toolchain pinned as in ADR-0006.

## Acceptance criteria
- [ ] Root `package.json` is private, with `packageManager: "pnpm@<exact>"` and an exact `engines.node`; `.nvmrc` holds the same exact Node 24 version. Both versions were published at least 30 days before the PR (ADR-0006).
- [ ] `pnpm-workspace.yaml` covers `packages/*` and `apps/*` and sets `minimumReleaseAge: 43200`.
- [ ] Placeholder packages `packages/engine`, `packages/harness`, `apps/cli`, each with a `package.json` and nothing beyond a placeholder entry point.
- [ ] `pnpm install` succeeds from a clean clone; `pnpm-lock.yaml` is committed.
- [ ] `minimumReleaseAge` shown to work: the PR includes the command and output of pnpm refusing a version younger than 30 days.
- [ ] `pnpm audit` run; result in the PR.
- [ ] `.gitignore` covers `node_modules` and build/test output.
- [ ] Package scope and module system proposed under **Assumptions I made**.
- [ ] Commands this task introduces are added to the `CLAUDE.md` commands section.

## Reviewer context
pnpm workspaces; `packageManager` field; pnpm `minimumReleaseAge`.
EOF

issue "S0-02: TypeScript strict config" "type:chore,area:process" "Todo" <<'EOF'
One strict TypeScript config shared by every package.

## Acceptance criteria
- [ ] `typescript` added with an exact pin, after asking (dependency policy).
- [ ] A shared base config with `strict: true` (plus any extra strictness flags, each justified in the PR); every package extends it.
- [ ] `pnpm typecheck` type-checks all packages without emitting and passes.
- [ ] The PR shows `pnpm typecheck` failing on a deliberate type error (not committed).
- [ ] `CLAUDE.md` commands section updated.

## Reviewer context
tsconfig `extends`; project references, if used, and why.
EOF

issue "S0-03: Vitest" "type:chore,area:process" "Todo" <<'EOF'
Vitest configured across the workspace, one trivial test per package.

## Acceptance criteria
- [ ] `vitest` added with an exact pin, after asking.
- [ ] `pnpm test` runs the tests of every package from the root.
- [ ] One trivial passing test in each of `packages/engine`, `packages/harness`, `apps/cli`.
- [ ] The PR shows `pnpm test` exiting non-zero on a deliberately failing test (not committed).
- [ ] `CLAUDE.md` commands section updated.

## Reviewer context
Vitest workspace/projects configuration.
EOF

issue "S0-04: CI" "type:chore,area:process" "Todo" <<'EOF'
GitHub Actions running typecheck and tests on every PR, then required on `main`.

## Acceptance criteria
- [ ] Workflow runs on `pull_request` and on `push` to `main`.
- [ ] Node version comes from `.nvmrc`, pnpm version from `packageManager`.
- [ ] Steps: `pnpm install --frozen-lockfile`, `pnpm typecheck`, `pnpm test`.
- [ ] Every action is pinned to a full commit SHA with the version in a comment (ADR-0006).
- [ ] The workflow runs green on this task's own PR.
- [ ] `scripts/github-setup.sh` updated to require the CI check on `main` (resolves the TODO left by task 7); after merge, the script is re-run with the tech lead's approval.

## Reviewer context
GitHub Actions; required status checks in branch protection.
EOF

issue "S0-05: Benchmark harness" "type:chore,area:process" "Todo" <<'EOF'
Vitest bench running in CI, reporting only.

## Acceptance criteria
- [ ] `pnpm bench` runs Vitest bench; one trivial benchmark in `packages/engine`.
- [ ] CI runs the benchmark and its results are visible in the job log or summary.
- [ ] The benchmark never fails CI on its numbers (no budget yet).
- [ ] `CLAUDE.md` commands section updated.

## Reviewer context
Vitest bench; why benchmark numbers on shared CI runners are noisy.
EOF

issue "S0-06: Templates" "type:docs,area:process" "Todo" <<'EOF'
Issue, PR and spec templates; confirm the ADR template.

## Acceptance criteria
- [ ] Issue template with: linked spec, acceptance criteria, reviewer context, milestone.
- [ ] PR template with every field `CLAUDE.md` requires (linked issue and spec, what changed, assumptions, things not verified, tests added/changed with reason, reviewer context).
- [ ] Spec template in `docs/specs/` with testable acceptance criteria and a place for the brief.
- [ ] `docs/adr/0000-template.md` confirmed or adjusted; the PR says which.
- [ ] The PR template follows the PR description format agreed in #13: a 3–5 line summary; the `CLAUDE.md` fields as short bullets, with **Assumptions I made** and **Things I could not verify** kept prominent; bulky evidence (script runs, logs, command output) in collapsed `<details>` blocks, one per item, each with a one-line `<summary>`.
- [ ] `CLAUDE.md`'s PR description section points to the PR template, so the format is defined only in the template.

## Reviewer context
GitHub issue/PR templates (`.github/`).
EOF

issue "S0-07: GitHub setup" "type:chore,area:process" "In Progress" <<'EOF'
Labels, milestones, project board, Sprint 0 issues, merge settings and branch protection, created by `scripts/github-setup.sh`.

## Acceptance criteria
- [ ] Labels: `type:` feature / bug / chore / docs / spike; `area:` engine / harness / cli / process; `needs-spec`. GitHub's default labels are deleted.
- [ ] Milestones: Sprint 0, M1, M2, M3.
- [ ] Project board linked to the repo, public, with Status: Todo / In Progress / In Review / Done.
- [ ] One issue per Sprint 0 task, with acceptance criteria, on the board, in the Sprint 0 milestone. No M1 issues.
- [ ] Repo allows squash merge only, with the PR title as the commit title.
- [ ] Branch protection on `main`: PR required, no approving review required, applies to admins too. Requiring the CI check is a marked TODO for task 4.
- [ ] The script is idempotent: the PR shows a second run creating nothing.

## Reviewer context
GitHub Projects (v2) and its GraphQL API; classic branch protection.
EOF

issue "S0-08: PO agent v0" "type:feature,area:process" "Todo" <<'EOF'
A product-owner agent that drafts specs and reviews demos. Never writes code.

## Acceptance criteria
- [ ] `.claude/agents/po.md` exists and points to `docs/vision.md` and `docs/inception.md` rather than copying them.
- [ ] Given a brief, it drafts a spec using the spec template (task 6). The PR includes one example run.
- [ ] Given a deliverable and a definition of done, it reviews one against the other. The PR includes one example run.
- [ ] Its instructions say it never writes code and pushes back on scope outside the current milestone.
- [ ] Given a milestone's tasks, proposes an execution order with dependencies; once the tech lead approves it, sets the dependencies and the board order.

## Reviewer context
Claude Code subagents (`.claude/agents/`).

Depends on: S0-06.
EOF

issue "S0-09: Spike: Claude usage measurement" "type:spike,area:process" "Todo" <<'EOF'
Find out what Claude usage can be measured per session or task, and how to attach it to a PR.

## Acceptance criteria
- [ ] Exploration on `spike/claude-usage`; that branch is never merged.
- [ ] A note in `docs/experiments/` lands by its own small docs PR: what can be measured (tokens, cost, time, ...), how, how reliable, how it could be attached to a PR, and a recommendation.
- [ ] Any follow-up work is proposed as new issues, not done in the spike.

## Reviewer context
Spikes (`docs/process.md`).
EOF

issue "S0-10: CLAUDE.md commands section" "type:docs,area:process" "Todo" <<'EOF'
Check that the `CLAUDE.md` commands section is complete and correct.

## Acceptance criteria
- [ ] Every root script (install, typecheck, test, bench, lint, ...) is listed with a one-line description.
- [ ] Each listed command was run from a clean clone and works; the PR says so.
- [ ] No command is listed that doesn't exist.

## Reviewer context
None beyond `CLAUDE.md`.

Depends on: S0-01 to S0-05, S0-12.
EOF

issue "S0-11: Demo: placeholder function end to end" "type:feature,area:engine" "Todo" <<'EOF'
The Sprint 0 definition-of-done run: a trivial change through the whole process. Runs last.

## Acceptance criteria
- [ ] This issue's body is rewritten to the issue template (task 6) before work starts.
- [ ] A spec for a placeholder function in `packages/engine`, written with the spec template, lands in its own PR and is merged (that is its approval).
- [ ] The implementation PR uses the PR template; the test is committed before the implementation (visible in the commit history).
- [ ] CI is green, including lint (task 12).
- [ ] Merged by the tech lead.
- [ ] Cycle time (In Progress → merged) is computed from GitHub timestamps and reported.
- [ ] The PO agent reviews the result against the Sprint 0 definition of done.

## Reviewer context
The whole flow in `docs/process.md`.

Depends on: every other Sprint 0 task.
EOF

issue "S0-12: Engine purity lint" "type:chore,area:engine" "Todo" <<'EOF'
ESLint in CI so `packages/engine` can't use non-determinism, I/O or adapter imports. Must land before any M1 code.

## Acceptance criteria
- [ ] ESLint (and the TypeScript parser it needs) added with exact pins, after asking.
- [ ] Rules for `packages/engine` only, using ESLint built-ins: `no-restricted-properties` (`Math.random`, `Date.now`), `no-restricted-globals` (e.g. `Date`, `fetch`, `process`, timers), `no-restricted-imports` (Node built-ins, `apps/*`, the harness package).
- [ ] A test lints fixture snippets and asserts each forbidden pattern is reported, and that the same code outside `packages/engine` is not.
- [ ] `pnpm lint` runs locally and in CI.
- [ ] `CLAUDE.md` commands section updated.

## Reviewer context
ESLint flat config; `no-restricted-*` rules.

Depends on: S0-02, S0-04.
EOF

# ---------------------------------------------------------------------------
# Repo merge settings: squash only, PR title as commit title, branch
# commit messages (and their Co-Authored-By trailers) as the body.
# ---------------------------------------------------------------------------
gh repo edit "$REPO" --enable-squash-merge --enable-merge-commit=false \
  --enable-rebase-merge=false --delete-branch-on-merge >/dev/null
gh api -X PATCH "repos/$REPO" -f squash_merge_commit_title=PR_TITLE \
  -f squash_merge_commit_message=COMMIT_MESSAGES >/dev/null
log "merge settings: squash only, PR title as commit title"

# ---------------------------------------------------------------------------
# Branch protection on main (PUT replaces the whole config, so re-running
# converges to exactly this).
#
# TODO(S0-04): require the CI check. GitHub accepts a check name that has
# never run, but then every PR waits forever for it, so it can only be
# required once the CI workflow exists. Task 4 replaces
#   "required_status_checks": null
# with
#   "required_status_checks": {"strict": true, "checks": [{"context": "<CI job name>"}]}
# ---------------------------------------------------------------------------
gh api -X PUT "repos/$REPO/branches/main/protection" --input - >/dev/null <<'EOF'
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 0,
    "dismiss_stale_reviews": false,
    "require_code_owner_reviews": false
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
log "branch protection on main: PR required, 0 approvals, admins included (CI check: TODO S0-04)"

log "done. Board: https://github.com/users/$OWNER/projects/$project_number"
