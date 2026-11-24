## Summary

**Needs from you:** <!-- the number of decisions in "Needs your decision" (e.g. "2 decisions"), or "nothing" -->

**Closes #N** · Spec: <!-- link to the spec in docs/specs/, or "#N's body" for Sprint 0 bootstrap issues -->

<!-- 3–5 lines: what changed and why. -->

## Review focus

<!--
The specific places to actually look. Where to look, not background.
One bullet each: `file:line` (at this PR's head commit), what is there, and
why it needs eyes, labelled with one of:
  **risky** · **judgment call** · **first time running for real** · **uncertain**

Groups: by what the reviewer must do, in this order; drop empty groups.
The tag decides the group (a fixed mapping, not a severity judgment), and
items keep their tag inside it.
  ### Check carefully       risky, uncertain
  ### Needs your decision   judgment call
  ### Worth a glance        first time running for real
Each "Needs your decision" item is a question with your default:
"I chose X; approve, or should I do Y?" Merging without comment accepts
the defaults. Their count goes in the Summary's "Needs from you" line.

Links:
- `file:line` links to that spot in this PR's diff, so it opens in context:
  https://github.com/OWNER/REPO/pull/N/files#diff-<sha256 of the path>R<line>
  (R = line in the new version; L<line> for a removed line.)
- Items labelled **risky** also get a commit permalink on its own line, so
  GitHub embeds the snippet in the description:
  https://github.com/OWNER/REPO/blob/<full head sha>/path#L<x>-L<y>
- When new commits move the lines, regenerate both links.

Example:
### Check carefully
- [`scripts/setup.sh:42`](https://github.com/OWNER/REPO/pull/N/files#diff-<sha256>R42) (protection PUT): **risky.** Replaces the whole config on every run.

  https://github.com/OWNER/REPO/blob/<sha>/scripts/setup.sh#L42-L50

### Needs your decision
- [`docs/process.md:60`](https://github.com/OWNER/REPO/pull/N/files#diff-<sha256>R60) (Acceptance): **judgment call.** I chose to convert old issues when each task starts; approve, or should I convert them all now?
-->

### Check carefully

- 

### Needs your decision

- 

### Worth a glance

- 

## Acceptance criteria

<!--
One line per criterion of the linked spec, cited by number, each mapped to its
evidence: a test name, a run output (in Evidence) or a check.
Example:
- **AC-1:** `engine/rng.test.ts` › "same seed, same sequence"
-->

- **AC-1:** 

## Assumptions I made

<!--
Short bullets. Write "None" rather than removing the section.
An assumption that is also risky goes only in Review focus, not here.
-->

- 

## Things I could not verify

<!-- Short bullets. Write "None" rather than removing the section. -->

- 

## Files changed

<!-- One line per file: what changed and why. -->

- `path`: 

## Tests

<!--
Nothing added or changed: one line, e.g. "None added or changed: docs-only change (exempt)."
Otherwise one bullet per test added, and per test changed with the reason
(changing a test together with the code it tests needs a spec change; say which).
-->

## Reviewer context

<!--
Optional. Include it only when this PR uses a concept, library or technique
that's new to this codebase or non-obvious to an experienced developer
(e.g. seeded RNGs, property-based testing). Otherwise delete the section
entirely: no "None". A concept tied to one specific spot can go into that
Review focus item instead. Only concepts here; things to check go in Review focus.
-->

- 

## Evidence

<!--
Bulky output (script runs, logs, command output), one collapsed block per item,
each with a one-line summary stating the outcome. Delete this section if there is none.

<details><summary>Outcome in one line</summary>

```
output
```
</details>
-->
