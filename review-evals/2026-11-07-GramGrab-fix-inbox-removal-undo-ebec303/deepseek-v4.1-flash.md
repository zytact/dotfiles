# Review: ebec303 fix(watch): commit inbox removals at once and make Undo restore them

Reviewed `git diff 5a34187...ebec30365e44cb087b804091b63d0546c850c38a`.

Note: the worktree has uncommitted changes on top of ebec303 that fix two of the findings below (unknown-id handling in `combined`/`remove`, and the `collect` rebuild in `restoreInboxEntries`). Findings describe ebec303 as instructed.

## Standards

Hard violations: none found. `docs/error-model.md` adds no new failure code, so no registry row was owed. The new message is covered by the schema union, `MessageHandlers`, and `MESSAGE_REFUSALS`, and the background rejects an unreadable request like its siblings.

Judgement calls:

1. Duplicated Code. The "collect record exists, is not a status record, has `removedAt`" predicate is now in three places: `restoreInboxEntries` (`service.ts:1040-1048`), `inboxRemove` (`service.ts:596-602`), and `inInbox` (`discoveries.ts:299-303`). Extracting one predicate next to `inInbox` would make the tombstone rules single-source.

2. Duplicated Code / fragile record rebuild. `service.ts:1054` clears the tombstone by reconstructing the record:

   ```ts
   ? { ...discovery, collect: { at: discovery.collect.at } }
   ```

   Every other write in this file spreads and overrides (`{ ...discovery.collect, removedAt: now }`). Rebuilding by hand silently drops any field a later schema adds and makes the reader re-derive `CollectRecord`'s shape.

3. Possible Data Clumps / Divergent Change. `removing` and `undoable` (`inbox-export.tsx:107-110`) are parallel states that must move in lockstep, and they are updated in four separate places (`remove`, its `then`, and both branches of `undoRemove`). One discriminated per-batch state would make "hidden" and "undoable" impossible to disagree.

4. Mysterious Name. `removing` (state) and `removals` (ref) at `inbox-export.tsx:108` and `:114` name two different things almost identically; `pendingRemovals` would read better.

5. Type looseness. `removals` is `useRef<Promise<unknown>>` (`:114`) though only settlement is ever used. `Promise<void>` states the intent.

6. Missing focused test. `restoreInboxEntries` gets no service-level test; coverage is only through the options page. Multi-login groups, a store write refusal mid-restore, and restoring an id that was never tombstoned are untested. Possible Speculative Generality in the multi-login loop is only defensible if tested.

## Spec

Requirement: "closing the tab means 'I'm done', so the removal goes through. Only Undo should keep the entries."

Implemented. `remove` now sends `WatchInboxRemove` in the click handler (`inbox-export.tsx:296-307`), and the test asserts the tombstone immediately (`watches.test.tsx:192-205`). Closing the tab no longer discards anything, and the issue's worker-side pending flag is unnecessary; the stated deviation is sound.

Incorrect or partial:

1. The undoable set includes entries the worker did not remove. `combined` folds `unknownEntryIds` into `removed` (`inbox-export.tsx:66-70`), and `remove`'s `then` only drops ids absent from that set (`:302-305`). So the toast can read "Removed 2 entries" when one was never tombstoned, and Undo then sends a restore for it that silently no-ops. "Only Undo should keep the entries" is preserved, but the count and the affordance overstate what happened.

2. A failed Undo loses both the entries and the affordance. `undoRemove` clears `undoable` before awaiting (`:232-234`) and on failure only renders a failure title (`:243-244`); the tombstoned entries stay removed with no way to retry. `WATCH_STORE_FAILED`'s recovery is `retry-operation` (`docs/error-model.md:87`), and no retry is offered here.

3. `removing` never releases successfully removed ids. After the Undo window closes, `undoable` empties but the settle handler only removes ids that failed (`:305`), so `removing` grows for the page's lifetime. No current symptom (the store refresh hides the entries), but it contradicts the state's documented meaning and would hide an entry that ever reappeared without an Undo path.

4. Restore is not scoped to the Undo window or to `inInbox`. `restoreInboxEntries` clears `removedAt` on any owned tombstoned entry it is given (`service.ts:1038-1050`), so a delayed or replayed `WATCH_INBOX_RESTORE` can un-tombstone old removals and expired entries. Owner checking is correct, and the UI only sends 5-second-old ids, so this is a design excess rather than an exploitable hole.

Verified correct: Undo cannot overtake an in-flight removal (the `removals` chain at `:307` plus `await removals.current` at `:235`), partial login failure drops only failed ids, and restored entries survive the `onChanged` refresh (`watches.test.tsx` Undo test).

Residual risk on the exact repro: the toast appears before the command resolves (`setUndoable` at `:291-295` runs first), so closing the tab while the toast is visible can still lose the removal if the background never receives the in-flight message. The message is dispatched synchronously in the click handler, so the window is small, but the fix removes the timer, not the delivery dependency.
