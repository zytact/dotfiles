# Review: fix/linkedin-description @ 4955505 (fixed point 5d18e48), spec issue #46

## Standards
Confirmed:
- Missing focused test: source.test.ts mock built listings `as JobListing` with no descriptionText (undefined), so `=== null` never matched and the new branch never ran in tests; job.ts mock lacked DESCRIPTION_SELECTOR. Fixed: mock now sets descriptionText, check uses `!job.descriptionText`, two tests added.
- Mysterious Name (heuristic): TEXT_BOX is an XPath fragment beside CSS selectors. Fixed: renamed TEXT_BOX_XPATH.
Refuted / kept:
- Duplicated Code (heuristic): the error shares a tail with layoutChanged, but the messages say different things (timeout vs no listing had one). Kept.

## Spec
Confirmed:
- English-only heading hook (new limit vs old id hook). Fixed: noted in linkedin-job-selectors.txt. Spec itself suggests the heading.
Ungrounded:
- Climb could reach shared pane if the job block renders without a box, returning the company blurb. Hypothetical; live panes always had a job box.
- Single-listing search with a genuinely missing description fails. Matches spec wording; LinkedIn listings always carry a description.
Refuted / notes:
- Multi-source search still exits 0 with linkedin failed in meta.sources: existing design, to be stated in PR.
- Description wait not job-scoped: live probe showed the pane empties on click. No change.
- Throw discards listings and skips summary logs: matches spec intent.

Standards: 2 confirmed (worst: new branch untested because mock lacked descriptionText). Spec: 1 confirmed (worst: English-only hook).
