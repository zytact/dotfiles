import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const CODEX_PROVIDER_ID = "openai-codex";
const CODEX_USAGE_URL = "https://chatgpt.com/backend-api/wham/usage";
const STATUS_KEY = "codex-reset-countdown";
const FETCH_INTERVAL_MS = 5 * 60_000;
const TICK_INTERVAL_MS = 30_000;
const TIMEOUT_MS = 15_000;

interface WindowInfo {
  resetsAt?: number;
}

interface SnapshotInfo {
  limitId: string;
  limitName?: string;
  primary?: WindowInfo;
  secondary?: WindowInfo;
}

export default function codexResetCountdown(pi: ExtensionAPI) {
  let fetchTimer: ReturnType<typeof setTimeout> | undefined;
  let tickTimer: ReturnType<typeof setTimeout> | undefined;
  let latest: SnapshotInfo | undefined;
  let currentCtx: ExtensionContext | undefined;

  const clearTimers = () => {
    if (fetchTimer) clearTimeout(fetchTimer);
    if (tickTimer) clearTimeout(tickTimer);
    fetchTimer = undefined;
    tickTimer = undefined;
  };

  const clearStatus = (ctx: ExtensionContext) => {
    clearTimers();
    latest = undefined;
    ctx.ui.setStatus(STATUS_KEY, undefined);
  };

  const scheduleTick = () => {
    if (!currentCtx || !latest) return;
    if (tickTimer) clearTimeout(tickTimer);
    tickTimer = setTimeout(() => {
      if (!currentCtx || !latest || currentCtx.model?.provider !== CODEX_PROVIDER_ID) return;
      currentCtx.ui.setStatus(STATUS_KEY, formatStatus(latest));
      scheduleTick();
    }, TICK_INTERVAL_MS);
    tickTimer.unref?.();
  };

  const scheduleFetch = () => {
    if (!currentCtx) return;
    if (fetchTimer) clearTimeout(fetchTimer);
    fetchTimer = setTimeout(() => {
      void refresh(currentCtx);
    }, FETCH_INTERVAL_MS);
    fetchTimer.unref?.();
  };

  const refresh = async (ctx: ExtensionContext) => {
    currentCtx = ctx;
    if (ctx.model?.provider !== CODEX_PROVIDER_ID) {
      clearStatus(ctx);
      return;
    }

    const snapshot = await fetchSnapshot(ctx).catch(() => undefined);
    if (!snapshot) {
      ctx.ui.setStatus(STATUS_KEY, "↺5h ? ↺wk ?");
      scheduleFetch();
      return;
    }

    latest = snapshot;
    ctx.ui.setStatus(STATUS_KEY, formatStatus(snapshot));
    scheduleTick();
    scheduleFetch();
  };

  pi.on("session_start", (_event, ctx) => {
    void refresh(ctx);
  });

  pi.on("session_tree", (_event, ctx) => {
    void refresh(ctx);
  });

  pi.on("model_select", (_event, ctx) => {
    void refresh(ctx);
  });

  pi.on("session_shutdown", (_event, ctx) => {
    clearStatus(ctx);
  });
}

async function fetchSnapshot(ctx: ExtensionContext): Promise<SnapshotInfo | undefined> {
  const headers = await resolvePiCodexAuthHeaders(ctx);
  if (!headers) return undefined;

  const response = await fetchWithTimeout(CODEX_USAGE_URL, { headers }, TIMEOUT_MS);
  if (!response.ok) return undefined;

  const payload = (await response.json()) as {
    rate_limit?: unknown;
    additional_rate_limits?: unknown;
  };

  const snapshots = normalizeSnapshots(payload);
  return snapshots[0];
}

function normalizeSnapshots(payload: {
  rate_limit?: unknown;
  additional_rate_limits?: unknown;
}): SnapshotInfo[] {
  const snapshots: SnapshotInfo[] = [];

  const primary = normalizeSnapshot("codex", undefined, payload.rate_limit);
  if (primary) snapshots.push(primary);

  const additional = Array.isArray(payload.additional_rate_limits)
    ? payload.additional_rate_limits
    : [];

  for (const item of additional) {
    if (!item || typeof item !== "object") continue;
    const row = item as {
      limit_name?: unknown;
      metered_feature?: unknown;
      rate_limit?: unknown;
    };
    const limitId = asString(row.metered_feature) ?? asString(row.limit_name);
    if (!limitId) continue;
    const snap = normalizeSnapshot(limitId, asString(row.limit_name), row.rate_limit);
    if (snap) snapshots.push(snap);
  }

  return snapshots;
}

function normalizeSnapshot(
  limitId: string,
  limitName: string | undefined,
  rateLimit: unknown,
): SnapshotInfo | undefined {
  if (!rateLimit || typeof rateLimit !== "object") return undefined;
  const details = rateLimit as { primary_window?: unknown; secondary_window?: unknown };
  const primary = normalizeWindow(details.primary_window);
  const secondary = normalizeWindow(details.secondary_window);
  if (!primary && !secondary) return undefined;
  return { limitId, limitName, primary, secondary };
}

function normalizeWindow(value: unknown): WindowInfo | undefined {
  if (!value || typeof value !== "object") return undefined;
  const window = value as { reset_at?: unknown };
  const resetsAt = asNumber(window.reset_at);
  if (!resetsAt) return undefined;
  return { resetsAt };
}

async function resolvePiCodexAuthHeaders(
  ctx: ExtensionContext,
): Promise<Record<string, string> | undefined> {
  const model = ctx.model;
  if (!model || model.provider !== CODEX_PROVIDER_ID) return undefined;

  const auth = await ctx.modelRegistry.getApiKeyAndHeaders(model);
  if (!auth.ok) return undefined;

  const headers = { ...(auth.headers ?? {}) };
  if (!hasHeader(headers, "Authorization") && auth.apiKey) {
    headers.Authorization = `Bearer ${auth.apiKey}`;
  }
  if (!hasHeader(headers, "User-Agent")) {
    headers["User-Agent"] = "pi-codex-reset-countdown";
  }
  return hasHeader(headers, "Authorization") ? headers : undefined;
}

function formatStatus(snapshot: SnapshotInfo): string {
  const p = snapshot.primary?.resetsAt;
  const s = snapshot.secondary?.resetsAt;
  return `󱫥 5h reset: ${formatCountdown(p)} | weekly reset: ${formatCountdown(s)}`;
}

function formatCountdown(resetAtEpochSeconds: number | undefined): string {
  if (!resetAtEpochSeconds) return "?";
  const ms = resetAtEpochSeconds * 1000 - Date.now();
  if (ms <= 0) return "now";

  let totalSeconds = Math.floor(ms / 1000);
  const days = Math.floor(totalSeconds / 86_400);
  totalSeconds -= days * 86_400;
  const hours = Math.floor(totalSeconds / 3_600);
  totalSeconds -= hours * 3_600;
  const minutes = Math.floor(totalSeconds / 60);

  if (days > 0) return `${days}d ${hours}h`;
  if (hours > 0) return `${hours}h ${minutes}m`;
  if (minutes > 0) return `${minutes}m`;
  return `${totalSeconds}s`;
}

async function fetchWithTimeout(url: string, init: RequestInit, timeoutMs: number): Promise<Response> {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), timeoutMs);
  try {
    return await fetch(url, { ...init, signal: controller.signal });
  } finally {
    clearTimeout(timeout);
  }
}

function hasHeader(headers: Record<string, string>, name: string): boolean {
  return Object.keys(headers).some((key) => key.toLowerCase() === name.toLowerCase());
}

function asString(value: unknown): string | undefined {
  return typeof value === "string" ? value : undefined;
}

function asNumber(value: unknown): number | undefined {
  if (typeof value === "number" && Number.isFinite(value)) return value;
  if (typeof value === "string" && value.trim()) {
    const parsed = Number(value);
    if (Number.isFinite(parsed)) return parsed;
  }
  return undefined;
}
