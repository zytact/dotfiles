# Review of ebec303 vs 5a34187 (issue #370)

Finder: Opus, medium. Verified by the parent.

## Standards

Confirmed
- Fragile rebuild in `restoreInboxEntries`: `collect: { at: discovery.collect.at }` drops any field later added to `CollectRecord`. Verified against `watch/contracts.ts:218`. Fixed in b249447 with `Struct.omit(discovery.collect, 'removedAt')`, the idiom `watch/store.ts` already uses.

Kept, with reasons (judgement calls)
- Duplicated two-pass in `restoreInboxEntries`. It mirrors `inboxRemove` (set of ids, then map) on purpose. Kept.
- `undoRemove` repeats parts of `execute`. `execute` only sends `WATCH_COMMAND`, and restore is not a wire command. Only handling `CommandFailure` matches `combined()`. Kept.
- `removing` only grows. Only this page's Undo can restore an entry, so a stale id hides nothing. Bounded by removals per page session. Kept.
- The `removals` promise chain. Undo is clickable while a removal is in flight (`busy` disables Remove, not Undo), so the chain is needed. Kept.
- The inline response type `{ failure?: WatchFailure }`. The neighbours inline similar shapes (`FailureOnlyResponse` uses OperationFailure). Minor, kept.
- Comment wording on the service function. Minor, kept.
- No direct service-level test of the `owned` guard. `owned()` is shared with remove. Kept.

Refuted: none.

## Spec

Confirmed
- Undo can bring back entries it never removed. `combined()` counts `unknownEntryIds` as removed, and `restoreInboxEntries` clears any `removedAt`, so a stale page's Undo un-did a removal made elsewhere. Fixed in b249447. `combined` now reports `tombstoned` (only `removedEntryIds`), and Undo keeps only those. The test "offers no Undo for an entry already removed elsewhere" fails without the fix and passes with it.

Ungrounded / accepted design
- The toast is page-local, so a reload within 5 s loses Undo. That fits "closing the tab means I'm done". Noted for the PR.
- Undo is a second write, so closing the tab right after clicking Undo may keep the removal. It is low stakes, and the failure direction matches the issue's expectation. Noted.

Refuted: none.

Standards 1 confirmed (fragile rebuild). Spec 1 confirmed (Undo restores foreign removals).
