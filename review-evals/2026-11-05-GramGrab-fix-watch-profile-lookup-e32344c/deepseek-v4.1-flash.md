# Review: e32344c fix(watch): send the profile lookup to /api/graphql with fb_dtsg

Reviewed `git diff 05b2f49...e32344c`. Tooling is clean: `vp check` (323 files formatted, no lint or type errors), `vp run fallow`, and the affected suites (`watch/check.test.ts`, `background.test.ts`, `options/watches.test.tsx`, 168 tests) pass.

## Standards

No hard violations in the diff itself: commit message follows the repo convention, no co-author trailer, no em dashes in added lines, and the new test is focused rather than a smoke test.

Documented-process violation (low impact):
- `docs/instagram-protocol.md` states a changed endpoint "also needs the matching `*Fetch` function in `apps/extension/scripts/capture-ig-fixtures.mjs` and the Endpoint column of the fixtures README updated", but neither changed. Mitigation: the capture script has no `profileById` entry and the generated script embeds the config, so nothing is broken today. Still, the endpoint now needs `fb_dtsg`, and `configuredGraphqlFetch`'s form path sends only `lsd`, so a future profile capture would get HTML.

Judgement calls (heuristics unless noted):

- **Primitive Obsession**, and against CLAUDE.md's "make that class of error impossible with a better design". `readToken` still produces an empty-string sentinel:

  ```ts
  const readToken = readHomePage().pipe(Effect.map(({ token }) => token ?? ''));
  ```

  `withDtsgToken` then does `send(cached ?? (yield* readToken))`, so a 200 home page that names no token still posts `fb_dtsg=''`. Making "no token" unrepresentable (fail, or an `Option`) would close the bug class the commit is fixing.

- **Documentation drift** (CLAUDE.md "Keep comments up to date!", AGENTS.md docs rule). The commit's doc bullet says "Every Watch confirms the account's username before its Posts check, so this broke Posts checks as `not-json`." `NEEDS_PROFILE` in `watch/check.ts` is `['avatar', 'posts']`, so Avatar checks broke the same way. The same sentence credits `withDtsgToken` with failing the request; the failure now comes from `readToken`, which `withDtsgToken` calls. (The uncommitted working-tree edit already fixes both, but the reviewed commit carries the stale text.)

- **Mysterious Name** (heuristic). The new test name "sends no lookup without a token when Instagram refuses its home page" does not describe what it asserts: no request carries a body, and the result is `IG_RATE_LIMITED`.

- **Duplicated Code** (heuristic, very low). The test fake hardcodes `pathname !== '/api/graphql'` while the same file already imports `protocolConfig`; the companion change in `check.test.ts` deliberately derives `POSTS_DOC_ID` from config, so deriving the endpoint path would match that intent.

## Spec

Implemented and correct:
- `profileById` points at `https://www.instagram.com/api/graphql` in `config.json`, and `confirmProfile` now calls `postWebQuery` for the token and Origin rule ("Point `profileById` at ... and send it through `postWebQuery` in `confirmProfile` so it gets the token and the Origin rule").
- `readToken` no longer swallows `RateLimited` / `GraphQLRequestFailed`, and the new background test proves a refused home page surfaces `IG_RATE_LIMITED` with no tokenless POST.
- The new `watch-instagram.ts` route requires both the `/api/graphql` path and the current token, so every existing Watch test now guards the fix indirectly.

Partial / missing:
- "update the fixture capture script for the new endpoint" - no such change. The script embeds config, so the URL follows, but its form path never sends `fb_dtsg`; a profile capture would now return HTML.
- "Still worth doing: don't send an empty `fb_dtsg` when the home page is refused" is only half done. Refused (429/error) pages fail now; a 200 page without `DTSGInitialData` still yields `''` and a tokenless POST, which is exactly the "sure to fail as `not-json`" case. No test covers that path.
- "Mapping a `text/html` answer to its own failure instead of `not-json`" was not attempted. Explicitly optional in the spec, so not a defect, but the next Instagram change of this kind will still present as `not-json`.

Added behavior the spec did not request:
- The old `confirmProfile` body sent `server_timestamps: 'true'`; `postWebQuery` does not, so the parameter silently disappears. The spec's verified request was `/api/graphql` with `fb_dtsg` and the same variables; it never says to drop `server_timestamps`. Probably harmless because `ProfileResponse` reads no timestamps, but it is an unrequested request-shape change worth confirming against a live session.

Look incorrect or understated:
- The doc bullet claims this "broke Posts checks as `not-json`". `profileStage` fails the profile stage for every kind in `NEEDS_PROFILE` (`avatar` and `posts`), so Avatar checks were equally broken. The spec requirement to "Record it under _Known server behavior_" is met in form, not in accuracy.

The reported root cause (profile lookup missing `fb_dtsg`) is fixed; the residual risks are the empty-token sentinel and the unverified `server_timestamps` removal.
