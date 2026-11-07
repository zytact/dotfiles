# Review run 1, #367, fixed point 05b2f49, HEAD e32344c

## Standards
Confirmed:
- (heuristic) `dtsg.ts` readToken comment said a missing token is never sent; `?? ''` still sends '' when a 200 page names no token. Fixed in d545eb0.
- (heuristic) `docs/instagram-protocol.md` bullet credited `withDtsgToken` instead of the token read, and said every Watch confirms the profile when only Posts/Avatar do (`NEEDS_PROFILE`). Fixed in d545eb0.

Refuted: none. Test changes (POSTS_DOC_ID scoping, fake profile route) judged fine.

## Spec
Confirmed:
- (deferred) separate failure for a `text/html` answer not implemented. Spec frames it as "would also"; doing it changes the closed CheckIncompleteReason protocol list and error-model contract. Recorded as kept.
Ungrounded:
- `server_timestamps` dropped from profileById: not verified live; covered by the live drive.
- 200 home page with no token still sends empty fb_dtsg. Spec scopes it to "when the home page is refused"; Watch path fails earlier at ViewerMissing on a signed-out page. Kept.
Refuted:
- Capture script update: script never used profileById. Callers' new RateLimited/GraphQLRequestFailed handling: consistent.

Confirmed: Standards 2, Spec 1. Worst Standards: misleading readToken comment. Worst Spec: no distinct html failure (deferred).
