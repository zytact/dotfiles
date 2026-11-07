# Review of 4955505 (fix linkedin description)

Method: read `git diff 5d18e483e9431ab81983659fe6220c6c08a7b120...49555057bace88323f645ebb2addafefa820c5fd` (4 files). `vp check` and `vp run test` pass at HEAD 4e74f42, which is two follow-up commits past the reviewed diff. I had no live LinkedIn session, so the selector changes were checked by reading the XPath, not against a page.

## Standards

### Hard violations

- Comments out of sync (`AGENTS.md`: "Keep comments up to date! When making changes, it's important to keep things in sync."). `search.ts` keeps:
  ```ts
  // The description loads last, so it is the sign the pane is complete.
  await page.waitForSelector(DESCRIPTION_SELECTOR, ...)
  ```
  The diff makes the selector job-independent (`job.ts`), so the previous job's text box also satisfies it. After a click the wait can return immediately on that stale box, and `extractJobDetailsFromView` then reads the old description while the new (job-keyed) title link already exists. The comment is false and the readiness gate no longer proves this job's pane is complete. Tie the wait to the job (heading plus id) or change the signal and the comment.
- Test double left behind. `source.ts` now imports `DESCRIPTION_SELECTOR` from `./job.ts`, but `source.test.ts` still mocks `./job.ts` as `{ extractJobDetailsFromView }`. No test reaches the new throw, so the suite passes; if one did, the message would interpolate `undefined` (or Vitest's missing-export error). The mock must export the hook.

### Judgement calls

- Mysterious Name: `const TEXT_BOX = '*[@data-testid="expandable-text-box"]'` is an XPath step, not a text box, and it is interpolated into two different XPaths. `TEXT_BOX_XPATH` says what the value is.
- Stale docs: `.agents/skills/verify-is-dl/features/search-and-triage.md` and its `.claude` copy still say a missing description "keeps the job with a null `descriptionText`" and never mention the new source failure or the English-only heading. Both copies were edited in a follow-up commit (4e74f42), not this one.
- The diff adds a new failure path but no test for it; the focused tests landed in follow-up 5693c22. A reviewer reading only this commit cannot see the guard exercised.
- No em dash, `any`, or YAGNI violation in the diff.

## Spec

Spec source: issue #46, "Fix" section.

- "Make a search fail when none of its LinkedIn listings has a description, with a non-zero exit and an error naming the selector." Partial. The `CliError` is thrown inside `scrape`, but `runSources` treats one failed source as normal and only throws when every source failed. `JOB_SOURCES` defaults to `['linkedin','unstop','ycombinator']`, so a default search logs `WARNING: linkedin failed`, records `meta.sources[]` as `failed`, and still exits 0. Only `--source linkedin` gets the promised non-zero exit. The issue's complaint, "Right now they get success with half-empty data", still holds for the default command. The selector is named correctly, and the code is 1 for the LinkedIn-only case.
- "Update the description hook (pick the expandable-text-box under the 'About the job' h2, since About the company has one too)". Partial. `//h2[...]/ancestor::*[.//box][1]//box` picks the first box anywhere inside the nearest ancestor that contains a box; it never checks the box sits under (or after) the heading. That is correct only while each "About" section is its own wrapper. If the heading's nearest box-bearing ancestor spans both sections, the result depends on document order.
- "`topCardXPath` also uses that id ... That check is now always true, so it needs updating too." Implemented, but the replacement is broader than the old check: it excludes any ancestor containing any text box, and `[1]` still picks one ancestor with no fallback. If the title's nearest `figure` ancestor contains a text box (premium insights, a second box in the top card), `topCard` matches nothing and company, location and `jobType` silently go null while descriptions still parse, so the new guard cannot catch it. The old filter named the description block; the new one should too.
- "and `apps/api/linkedin-job-selectors.txt`". Satisfied, and the text matches the code. It omits that the heading is English, which the follow-up adds.
- Edge: the guard requires `jobs.length`, so a run that extracts zero listings (every click fails) still exits 0 even though "none of its LinkedIn listings has a description" is literally true. `MAX_CONSECUTIVE_FAILURES` and the job-list timeout cover most of that path, so this is minor.
- Behavior added beyond the spec: none. The breadth of the `topCardXPath` change is an implementation choice noted above.
