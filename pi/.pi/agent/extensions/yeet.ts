import path from "node:path";
import { complete, type Message } from "@earendil-works/pi-ai";
import { BorderedLoader, type ExtensionAPI, type ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Key, matchesKey, truncateToWidth, wrapTextWithAnsi } from "@earendil-works/pi-tui";

const PROTECTED_BRANCHES = new Set(["main", "master", "develop"]);
const COMMIT_TYPES = "feat, fix, docs, style, refactor, test, chore, ci, perf, build";
const TITLE_FRAMES = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
const TEXT_FRAMES = ["·  ", "•• ", "•••", " ••", "  •"];

let yeetStatusTimer: ReturnType<typeof setInterval> | null = null;
let yeetStatusToken = 0;

interface ExecResult {
	stdout: string;
	stderr: string;
	code: number;
}

interface GitStatusItem {
	path: string;
	x: string;
	y: string;
	kind: "tracked" | "untracked";
}

interface PrDraft {
	title: string;
	body: string;
}

interface StageChoiceItem extends GitStatusItem {
	id: string;
}

function textOf(result: { content: Array<{ type: string; text?: string }> }): string {
	return result.content
		.filter((c): c is { type: "text"; text: string } => c.type === "text" && typeof c.text === "string")
		.map((c) => c.text)
		.join("\n")
		.trim();
}

function stripFences(text: string): string {
	const trimmed = text.trim();
	if (!trimmed.startsWith("```")) return trimmed;
	return trimmed.replace(/^```[a-zA-Z0-9_-]*\n?/, "").replace(/\n?```$/, "").trim();
}

function shellQuote(value: string): string {
	return `'${value.replace(/'/g, `'"'"'`)}'`;
}

function parseStatus(stdout: string): GitStatusItem[] {
	return stdout
		.split("\n")
		.map((line) => line.trimEnd())
		.filter(Boolean)
		.map((line) => {
			if (line.startsWith("?? ")) {
				return { path: line.slice(3), x: "?", y: "?", kind: "untracked" as const };
			}
			return {
				path: line.slice(3),
				x: line[0] || " ",
				y: line[1] || " ",
				kind: "tracked" as const,
			};
		});
}

function unstagedOrUntracked(items: GitStatusItem[]): GitStatusItem[] {
	return items.filter((item) => item.kind === "untracked" || item.y !== " ");
}

function hasStaged(items: GitStatusItem[]): boolean {
	return items.some((item) => item.kind === "tracked" && item.x !== " ");
}

function truncate(text: string, n: number): string {
	return text.length > n ? `${text.slice(0, n - 1)}…` : text;
}

function fmtStatus(items: GitStatusItem[]): string {
	return items.map((item) => `${item.kind === "untracked" ? "??" : `${item.x}${item.y}`} ${item.path}`).join("\n");
}

function addWrapped(lines: string[], text: string, width: number, indent = ""): void {
	const contentWidth = Math.max(1, width - indent.length);
	for (const line of wrapTextWithAnsi(text, contentWidth)) {
		lines.push(truncateToWidth(`${indent}${line}`, width));
	}
}

function yeetTitle(text: string, frame = 0): string {
	return `${TITLE_FRAMES[frame % TITLE_FRAMES.length]} ${text}`;
}

function baseTitle(): string {
	return `π - ${path.basename(process.cwd())}`;
}

function stopYeetStatus(ctx: ExtensionContext): void {
	if (yeetStatusTimer) {
		clearInterval(yeetStatusTimer);
		yeetStatusTimer = null;
	}
	ctx.ui.setStatus("yeet", undefined);
	ctx.ui.setTitle(baseTitle());
}

function setYeetStatus(ctx: ExtensionContext, text?: string): void {
	if (!text) {
		stopYeetStatus(ctx);
		return;
	}

	const token = ++yeetStatusToken;
	if (yeetStatusTimer) clearInterval(yeetStatusTimer);

	let frame = 0;
	const paint = () => {
		if (token !== yeetStatusToken) return;
		const spinner = TITLE_FRAMES[frame % TITLE_FRAMES.length];
		const pulse = TEXT_FRAMES[frame % TEXT_FRAMES.length];
		ctx.ui.setStatus("yeet", ctx.ui.theme.fg("accent", `${spinner} yeet: ${text} ${pulse}`));
		ctx.ui.setTitle(yeetTitle(`yeet: ${text} ${pulse}`, frame));
		frame++;
	};

	paint();
	yeetStatusTimer = setInterval(paint, 100);
}

async function withYeetStatus<T>(ctx: ExtensionContext, text: string, fn: () => Promise<T>): Promise<T> {
	setYeetStatus(ctx, text);
	try {
		return await fn();
	} finally {
		stopYeetStatus(ctx);
	}
}

async function run(pi: ExtensionAPI, args: string[], cwd: string): Promise<ExecResult> {
	const result = await pi.exec("git", args, { cwd, timeout: 30_000 });
	return { stdout: result.stdout, stderr: result.stderr, code: result.code };
}

async function ensureGitRepo(pi: ExtensionAPI, cwd: string): Promise<boolean> {
	const result = await run(pi, ["rev-parse", "--git-dir"], cwd);
	return result.code === 0;
}

async function getStatus(pi: ExtensionAPI, cwd: string): Promise<GitStatusItem[]> {
	const result = await run(pi, ["status", "--porcelain"], cwd);
	return result.code === 0 ? parseStatus(result.stdout) : [];
}

async function currentBranch(pi: ExtensionAPI, cwd: string): Promise<string | null> {
	const result = await run(pi, ["rev-parse", "--abbrev-ref", "HEAD"], cwd);
	return result.code === 0 ? result.stdout.trim() : null;
}

async function baseBranch(pi: ExtensionAPI, cwd: string): Promise<string | null> {
	const head = await run(pi, ["symbolic-ref", "refs/remotes/origin/HEAD"], cwd);
	if (head.code === 0) {
		const ref = head.stdout.trim();
		const branch = ref.split("/").pop();
		if (branch) return branch;
	}
	for (const branch of ["main", "master", "develop"]) {
		const check = await run(pi, ["show-ref", "--verify", `refs/heads/${branch}`], cwd);
		if (check.code === 0) return branch;
	}
	return null;
}

async function hasGh(pi: ExtensionAPI, cwd: string): Promise<boolean> {
	const result = await pi.exec("bash", ["-lc", "command -v gh >/dev/null 2>&1"], { cwd, timeout: 10_000 });
	return result.code === 0;
}

async function llm(ctx: any, prompt: string, systemPrompt: string, label: string): Promise<string | null> {
	if (!ctx.model) {
		ctx.ui.notify("No model selected", "error");
		return null;
	}

	return ctx.ui.custom<string | null>((tui: any, theme: any, _kb: any, done: (v: string | null) => void) => {
		const loader = new BorderedLoader(tui, theme, label);
		loader.onAbort = () => done(null);

		const go = async () => {
			const auth = await ctx.modelRegistry.getApiKeyAndHeaders(ctx.model!);
			if (!auth.ok || !auth.apiKey) throw new Error(auth.ok ? `No API key for ${ctx.model!.provider}` : auth.error);

			const msg: Message = {
				role: "user",
				content: [{ type: "text", text: prompt }],
				timestamp: Date.now(),
			};

			const response = await complete(
				ctx.model!,
				{ systemPrompt, messages: [msg] },
				{ apiKey: auth.apiKey, headers: auth.headers, signal: loader.signal },
			);
			if (response.stopReason === "aborted") return null;
			return textOf(response);
		};

		go().then(done).catch(() => done(null));
		return loader;
	});
}

async function chooseFilesToStage(ctx: any, items: GitStatusItem[]): Promise<GitStatusItem[] | null> {
	const choices: StageChoiceItem[] = items.map((item, index) => ({ ...item, id: `${index}:${item.path}` }));
	return ctx.ui.custom<GitStatusItem[] | null>((tui: any, theme: any, _kb: any, done: (v: GitStatusItem[] | null) => void) => {
		let index = 0;
		let cachedLines: string[] | undefined;
		const selected = new Set(choices.map((item) => item.id));

		function refresh() {
			cachedLines = undefined;
			tui.requestRender();
		}

		function toggleCurrent() {
			const item = choices[index];
			if (!item) return;
			if (selected.has(item.id)) selected.delete(item.id);
			else selected.add(item.id);
			refresh();
		}

		function handleInput(data: string) {
			if (matchesKey(data, Key.up)) {
				index = Math.max(0, index - 1);
				refresh();
				return;
			}
			if (matchesKey(data, Key.down)) {
				index = Math.min(choices.length - 1, index + 1);
				refresh();
				return;
			}
			if (matchesKey(data, Key.space)) {
				toggleCurrent();
				return;
			}
			if (data === "a") {
				for (const item of choices) selected.add(item.id);
				refresh();
				return;
			}
			if (data === "n") {
				selected.clear();
				refresh();
				return;
			}
			if (matchesKey(data, Key.enter)) {
				if (selected.size === 0) return;
				done(choices.filter((item) => selected.has(item.id)));
				return;
			}
			if (matchesKey(data, Key.escape)) {
				done(null);
			}
		}

		function render(width: number): string[] {
			if (cachedLines) return cachedLines;
			const lines: string[] = [];
			const add = (text: string) => lines.push(truncateToWidth(text, width));

			add(theme.fg("accent", "─".repeat(width)));
			addWrapped(lines, theme.fg("text", " Choose files to stage"), width);
			lines.push("");
			for (let i = 0; i < choices.length; i++) {
				const item = choices[i];
				const focused = i === index;
				const prefix = focused ? theme.fg("accent", "> ") : "  ";
				const marker = selected.has(item.id) ? "[x]" : "[ ]";
				const status = item.kind === "untracked" ? "??" : `${item.x}${item.y}`;
				const label = `${marker} ${status} ${item.path}`;
				add(`${prefix}${focused ? theme.fg("accent", label) : theme.fg(selected.has(item.id) ? "success" : "text", label)}`);
			}
			lines.push("");
			if (selected.size === 0) add(theme.fg("warning", " Select at least one file."));
			add(theme.fg("dim", " ↑↓ move • Space toggle • a all • n none • Enter stage • Esc cancel"));
			add(theme.fg("accent", "─".repeat(width)));
			cachedLines = lines;
			return lines;
		}

		return { render, invalidate: () => { cachedLines = undefined; }, handleInput };
	});
}

async function stageForCommit(pi: ExtensionAPI, ctx: any): Promise<boolean> {
	const cwd = ctx.cwd;
	const status = await withYeetStatus(ctx, "checking git status", () => getStatus(pi, cwd));
	const pending = unstagedOrUntracked(status);
	if (pending.length === 0) return true;

	const chosen = await chooseFilesToStage(ctx, pending);
	if (!chosen || chosen.length === 0) return false;

	const tracked = chosen.filter((item) => item.kind === "tracked").map((item) => item.path);
	const untracked = chosen.filter((item) => item.kind === "untracked").map((item) => item.path);

	if (tracked.length > 0) {
		const addTracked = await withYeetStatus(ctx, "staging files", () =>
			pi.exec(
				"bash",
				["-lc", `git add -- ${tracked.map(shellQuote).join(" ")}`],
				{ cwd, timeout: 30_000 },
			),
		);
		if (addTracked.code !== 0) {
			ctx.ui.notify(addTracked.stderr.trim() || "git add failed", "error");
			return false;
		}
	}

	if (untracked.length > 0) {
		const addUntracked = await withYeetStatus(ctx, "staging files", () =>
			pi.exec(
				"bash",
				["-lc", `git add -- ${untracked.map(shellQuote).join(" ")}`],
				{ cwd, timeout: 30_000 },
			),
		);
		if (addUntracked.code !== 0) {
			ctx.ui.notify(addUntracked.stderr.trim() || "git add failed", "error");
			return false;
		}
	}

	return true;
}

async function genCommitMessage(pi: ExtensionAPI, ctx: any): Promise<string | null> {
	const cwd = ctx.cwd;
	const [stat, diff] = await withYeetStatus(ctx, "reading staged diff", () =>
		Promise.all([
			run(pi, ["diff", "--cached", "--stat", "--diff-filter=ACMRD"], cwd),
			run(pi, ["diff", "--cached", "--diff-filter=ACMRD"], cwd),
		]),
	);
	if (stat.code !== 0 || diff.code !== 0) return null;

	const prompt = [
		"Generate one conventional commit message.",
		`Allowed types: ${COMMIT_TYPES}.`,
		"Format: type(scope): description or type: description.",
		"Lowercase. Imperative. Max 72 chars. Output only message.",
		"",
		"## git diff --cached --stat",
		stat.stdout.trim() || "(empty)",
		"",
		"## git diff --cached",
		diff.stdout.trim() || "(empty)",
	].join("\n");

	return withYeetStatus(ctx, "generating commit msg", () =>
		llm(ctx, prompt, "You write precise conventional commit messages.", "Generating commit msg..."),
	);
}

async function doPush(pi: ExtensionAPI, ctx: any, branch?: string | null): Promise<{ ok: boolean }> {
	const cwd = ctx.cwd;
	const target = branch || (await withYeetStatus(ctx, "detecting branch", () => currentBranch(pi, cwd)));
	if (!target) {
		ctx.ui.notify("Could not detect branch for push", "warning");
		return { ok: false };
	}

	const push = await withYeetStatus(ctx, `pushing ${target}`, () => run(pi, ["push", "-u", "origin", target], cwd));
	if (push.stdout.trim()) ctx.ui.notify(push.stdout.trim(), push.code === 0 ? "info" : "warning");
	if (push.stderr.trim()) ctx.ui.notify(push.stderr.trim(), push.code === 0 ? "info" : "warning");
	if (push.code !== 0) {
		ctx.ui.notify("git push failed", "warning");
		return { ok: false };
	}
	return { ok: true };
}

async function doCommit(pi: ExtensionAPI, ctx: any, opts?: { push?: boolean }): Promise<{ ok: boolean; message?: string }> {
	const cwd = ctx.cwd;
	if (!(await stageForCommit(pi, ctx))) return { ok: false };

	const status = await withYeetStatus(ctx, "checking staged files", () => getStatus(pi, cwd));
	if (!hasStaged(status)) {
		ctx.ui.notify("Nothing staged", "warning");
		return { ok: false };
	}

	let message = (await genCommitMessage(pi, ctx))?.split("\n")[0].trim();
	if (!message) {
		ctx.ui.notify("Could not generate commit msg", "error");
		return { ok: false };
	}

	while (true) {
		const action = await ctx.ui.select("Commit", [
			`Accept: ${message}`,
			"Edit message",
			"Abort",
		]);
		if (!action || action === "Abort") return { ok: false };
		if (action === "Edit message") {
			const edited = await ctx.ui.editor("Commit message", message);
			if (edited === undefined) return { ok: false };
			message = edited.trim();
			if (!message) continue;
			continue;
		}
		break;
	}

	const result = await withYeetStatus(ctx, "committing", () => run(pi, ["commit", "-m", message], cwd));
	if (result.stdout.trim()) ctx.ui.notify(result.stdout.trim(), result.code === 0 ? "info" : "warning");
	if (result.stderr.trim()) ctx.ui.notify(result.stderr.trim(), result.code === 0 ? "info" : "warning");
	if (result.code !== 0) {
		ctx.ui.notify("git commit failed", "error");
		return { ok: false };
	}

	if (opts?.push) await doPush(pi, ctx);
	return { ok: true, message };
}

async function genBranchName(pi: ExtensionAPI, ctx: any): Promise<string | null> {
	const cwd = ctx.cwd;
	let stat = await withYeetStatus(ctx, "reading branch context", () => run(pi, ["diff", "--cached", "--stat"], cwd));
	if (!stat.stdout.trim()) stat = await withYeetStatus(ctx, "reading branch context", () => run(pi, ["diff", "--stat", "HEAD"], cwd));

	const prompt = [
		"Generate one git branch name.",
		"Rules: lowercase, kebab-case, prefix with feat/ fix/ chore/ docs/ refactor/ test/ perf/ ci/ build/ style.",
		"Max 50 chars. Output only branch name.",
		"",
		"## context",
		stat.stdout.trim() || "(empty)",
	].join("\n");

	return withYeetStatus(ctx, "generating branch name", () =>
		llm(ctx, prompt, "You write terse git branch names.", "Generating branch name..."),
	);
}

async function doBranch(pi: ExtensionAPI, ctx: any): Promise<{ ok: boolean; name?: string }> {
	const cwd = ctx.cwd;
	let name = (await genBranchName(pi, ctx))?.split("\n")[0].trim();
	if (!name) {
		ctx.ui.notify("Could not generate branch name", "error");
		return { ok: false };
	}

	while (true) {
		const action = await ctx.ui.select("Branch", [`Checkout: ${name}`, "Custom name", "Abort"]);
		if (!action || action === "Abort") return { ok: false };
		if (action === "Custom name") {
			const edited = await ctx.ui.editor("Branch name", name);
			if (edited === undefined) return { ok: false };
			name = edited.trim();
			if (!name) continue;
			continue;
		}
		break;
	}

	const result = await withYeetStatus(ctx, `creating branch ${name}`, () => run(pi, ["checkout", "-b", name], cwd));
	if (result.stdout.trim()) ctx.ui.notify(result.stdout.trim(), result.code === 0 ? "info" : "warning");
	if (result.stderr.trim()) ctx.ui.notify(result.stderr.trim(), result.code === 0 ? "info" : "warning");
	if (result.code !== 0) {
		ctx.ui.notify("git checkout -b failed", "error");
		return { ok: false };
	}
	return { ok: true, name };
}

async function genPrDraft(pi: ExtensionAPI, ctx: any, base: string, branch: string): Promise<PrDraft | null> {
	const cwd = ctx.cwd;
	const [log, stat, names, diff, oldest] = await withYeetStatus(ctx, "reading PR context", () =>
		Promise.all([
			run(pi, ["log", `${base}..${branch}`, "--oneline"], cwd),
			run(pi, ["diff", `${base}...${branch}`, "--stat"], cwd),
			run(pi, ["diff", `${base}...${branch}`, "--name-only"], cwd),
			run(pi, ["diff", `${base}...${branch}`, "--diff-filter=ACMRD"], cwd),
			run(pi, ["log", `${base}..${branch}`, "--reverse", "--format=%s"], cwd),
		]),
	);
	const fallbackTitle = oldest.stdout.trim().split("\n")[0]?.trim() || `chore: update ${branch}`;

	const titlePrompt = [
		"Generate one concise GitHub PR title.",
		"Prefer reusing or lightly adapting the oldest commit subject.",
		"Output title only.",
		"",
		`Base: ${base}`,
		`Branch: ${branch}`,
		`Fallback title: ${fallbackTitle}`,
		"",
		"## commits",
		log.stdout.trim() || "(empty)",
	].join("\n");
	const title = (await withYeetStatus(ctx, "generating PR title", () =>
		llm(ctx, titlePrompt, "You write crisp GitHub PR titles.", "Generating PR title..."),
	))
		?.split("\n")[0]
		.trim() || fallbackTitle;

	const bodyPrompt = [
		"Write a GitHub PR body in markdown.",
		"Requirements:",
		"- Start with 3-5 bullet points summarizing actual changes.",
		"- Then a blank line.",
		"- Then exactly this heading: ## Test plan",
		"- Under it, add 1-5 bullet points with realistic tests run. If none evident, say '- Not run (not provided)'.",
		"- No intro sentence. No code fences.",
		"- Do not leave summary or test plan empty.",
		"",
		`Base: ${base}`,
		`Branch: ${branch}`,
		`Title: ${title}`,
		"",
		"## commits",
		log.stdout.trim() || "(empty)",
		"",
		"## files",
		names.stdout.trim() || "(empty)",
		"",
		"## diff stat",
		stat.stdout.trim() || "(empty)",
		"",
		"## diff",
		truncate(diff.stdout.trim() || "(empty)", 12000),
	].join("\n");
	let body = await withYeetStatus(ctx, "generating PR body", () =>
		llm(ctx, bodyPrompt, "You write precise GitHub PR bodies.", "Generating PR body..."),
	);
	body = stripFences(body || "").trim();
	if (!body || !body.includes("## Test plan")) {
		body = "- Summary unavailable\n\n## Test plan\n- Not run (not provided)";
	}
	return { title, body };
}

async function doPr(pi: ExtensionAPI, ctx: any): Promise<{ ok: boolean }> {
	const cwd = ctx.cwd;
	if (!(await hasGh(pi, cwd))) {
		ctx.ui.notify("gh not installed; skipping PR", "warning");
		return { ok: false };
	}

	const branch = await currentBranch(pi, cwd);
	const base = await baseBranch(pi, cwd);
	if (!branch || !base) {
		ctx.ui.notify("Could not detect branch/base", "error");
		return { ok: false };
	}

	let draft = await genPrDraft(pi, ctx, base, branch);
	if (!draft) {
		ctx.ui.notify("Could not generate PR draft", "error");
		return { ok: false };
	}

	while (true) {
		const action = await ctx.ui.select("PR", [
			`Open PR: ${truncate(draft.title, 70)}`,
			"Edit title",
			"Edit body",
			"Abort",
		]);
		if (!action || action === "Abort") return { ok: false };
		if (action === "Edit title") {
			const edited = await ctx.ui.editor("PR title", draft.title);
			if (edited === undefined) return { ok: false };
			draft = { ...draft, title: edited.trim() || draft.title };
			continue;
		}
		if (action === "Edit body") {
			const edited = await ctx.ui.editor("PR body", draft.body);
			if (edited === undefined) return { ok: false };
			draft = { ...draft, body: edited };
			continue;
		}
		break;
	}

	const result = await withYeetStatus(ctx, "creating PR", () =>
		pi.exec("gh", ["pr", "create", "--base", base, "--title", draft.title, "--body", draft.body], {
			cwd,
			timeout: 60_000,
		}),
	);
	if (result.stdout.trim()) ctx.ui.notify(result.stdout.trim(), result.code === 0 ? "info" : "warning");
	if (result.stderr.trim()) ctx.ui.notify(result.stderr.trim(), result.code === 0 ? "info" : "warning");
	if (result.code !== 0) {
		ctx.ui.notify("gh pr create failed", "error");
		return { ok: false };
	}
	return { ok: true };
}

async function doAuto(pi: ExtensionAPI, ctx: any): Promise<void> {
	const cwd = ctx.cwd;
	const branch = await currentBranch(pi, cwd);
	if (branch && PROTECTED_BRANCHES.has(branch)) {
		const branched = await doBranch(pi, ctx);
		if (!branched.ok) return;
	}

	const committed = await doCommit(pi, ctx, { push: true });
	if (!committed.ok) return;

	if (await hasGh(pi, cwd)) {
		await doPr(pi, ctx);
	} else {
		ctx.ui.notify("gh not installed; skipped PR", "warning");
	}
}

export default function yeet(pi: ExtensionAPI) {
	pi.on("session_shutdown", async (_event, ctx) => {
		setYeetStatus(ctx);
	});

	pi.registerCommand("yeet", {
		description: "AI git workflow: /yeet [commit|branch|pr|auto]",
		getArgumentCompletions: (prefix) => {
			const cmds = ["commit", "branch", "pr", "auto"];
			return cmds.filter((x) => x.startsWith(prefix)).map((x) => ({ value: x, label: x }));
		},
		handler: async (args, ctx) => {
			if (ctx.mode !== "tui") {
				ctx.ui.notify("/yeet needs TUI", "error");
				return;
			}
			if (!(await ensureGitRepo(pi, ctx.cwd))) {
				ctx.ui.notify("Not a git repo", "error");
				return;
			}

			const sub = args.trim();
			if (!sub) {
				ctx.ui.notify("Usage: /yeet [commit|branch|pr|auto]", "info");
				return;
			}

			switch (sub) {
				case "commit":
					await doCommit(pi, ctx, { push: true });
					return;
				case "branch":
					await doBranch(pi, ctx);
					return;
				case "pr":
					await doPr(pi, ctx);
					return;
				case "auto":
					await doAuto(pi, ctx);
					return;
				default:
					ctx.ui.notify("Usage: /yeet [commit|branch|pr|auto]", "info");
			}
		},
	});
}
