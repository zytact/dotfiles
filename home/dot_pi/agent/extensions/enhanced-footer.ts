import type { AssistantMessage, Usage } from "@earendil-works/pi-ai";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

function formatTokens(count: number): string {
	if (count < 1_000) return count.toString();
	if (count < 10_000) return `${(count / 1_000).toFixed(1)}k`;
	if (count < 1_000_000) return `${Math.round(count / 1_000)}k`;
	if (count < 10_000_000) return `${(count / 1_000_000).toFixed(1)}M`;
	return `${Math.round(count / 1_000_000)}M`;
}

function formatDuration(milliseconds: number): string {
	const seconds = Math.floor(milliseconds / 1_000);
	const hours = Math.floor(seconds / 3_600);
	const minutes = Math.floor((seconds % 3_600) / 60);
	const remainingSeconds = seconds % 60;
	return [hours, minutes, remainingSeconds]
		.map((value, index) => (index === 0 ? value.toString() : value.toString().padStart(2, "0")))
		.join(":");
}

function singleLine(text: string): string {
	return text.replace(/[\r\n\t]/g, " ").replace(/ +/g, " ").trim();
}

function joinSides(left: string, right: string, width: number): string {
	const gap = 2;
	const leftWidth = visibleWidth(left);
	const rightWidth = visibleWidth(right);

	if (leftWidth + gap + rightWidth <= width) {
		return left + " ".repeat(width - leftWidth - rightWidth) + right;
	}

	const availableRight = width - leftWidth - gap;
	if (availableRight > 0) {
		const fittedRight = truncateToWidth(right, availableRight, "");
		return left + " ".repeat(Math.max(gap, width - leftWidth - visibleWidth(fittedRight))) + fittedRight;
	}

	return truncateToWidth(left, width, "…");
}

export default function enhancedFooter(pi: ExtensionAPI) {
	let activeMs = 0;
	let activeSince: number | undefined;

	const totalActiveMs = () => activeMs + (activeSince === undefined ? 0 : Date.now() - activeSince);

	const persistActiveTime = (ctx: ExtensionContext) => {
		if (activeSince === undefined) return;
		activeMs = totalActiveMs();
		activeSince = undefined;
		ctx.sessionManager.appendCustomEntry("enhanced-footer-active-time", { activeMs });
	};

	pi.on("session_start", (_event, ctx) => {
		activeMs = 0;
		activeSince = undefined;
		for (const entry of ctx.sessionManager.getBranch()) {
			if (entry.type === "custom" && entry.customType === "enhanced-footer-active-time") {
				const stored = entry.data as { activeMs?: unknown } | undefined;
				if (typeof stored?.activeMs === "number") activeMs = stored.activeMs;
			}
		}
		if (ctx.mode !== "tui") return;

		ctx.ui.setFooter((tui, theme, footerData) => {
			const unsubscribe = footerData.onBranchChange(() => tui.requestRender());
			const interval = setInterval(() => tui.requestRender(), 1_000);

			return {
				dispose: () => {
					clearInterval(interval);
					unsubscribe();
				},
				invalidate() {},
				render(width: number): string[] {
					let input = 0;
					let output = 0;
					let cacheRead = 0;
					let cacheWrite = 0;
					let cost = 0;

					const addUsage = (usage: Usage | undefined) => {
						if (!usage) return;
						input += usage.input ?? 0;
						output += usage.output ?? 0;
						cacheRead += usage.cacheRead ?? 0;
						cacheWrite += usage.cacheWrite ?? 0;
						cost += usage.cost?.total ?? 0;
					};

					for (const entry of ctx.sessionManager.getEntries()) {
						if (entry.type === "message" && entry.message.role === "assistant") {
							addUsage((entry.message as AssistantMessage).usage);
						} else if (entry.type === "message" && entry.message.role === "toolResult") {
							addUsage(entry.message.usage);
						} else if (entry.type === "branch_summary" || entry.type === "compaction") {
							addUsage(entry.usage);
						}
					}

					const branch = footerData.getGitBranch();
					const location = theme.fg("accent", ctx.cwd);
					const branchText = branch ? theme.fg("success", `  git:${branch}`) : "";
					const sessionName = ctx.sessionManager.getSessionName();
					const nameText = sessionName ? theme.fg("muted", `  ${sessionName}`) : "";
					const locationLine = truncateToWidth(location + branchText + nameText, width, "…");

					const cacheableInput = input + cacheRead + cacheWrite;
					const cacheHitPercent = cacheableInput > 0 ? (cacheRead / cacheableInput) * 100 : 0;
					const usageParts = [
						theme.fg("accent", `in ${formatTokens(input)}`),
						theme.fg("mdLink", `out ${formatTokens(output)}`),
						theme.fg("success", `cache hit ${cacheHitPercent.toFixed(1)}%`),
					];
					if (cost > 0) usageParts.push(theme.fg("muted", `$${cost.toFixed(3)}`));

					const model = ctx.model?.id ?? "no model";
					const thinking = ctx.model?.reasoning ? `  ${ctx.thinkingLevel}` : "";
					const modelText = theme.fg("accent", model) + theme.fg("thinkingMedium", thinking);
					const usageLine = joinSides(usageParts.join(theme.fg("dim", "  •  ")), modelText, width);

					const context = ctx.getContextUsage();
					const used = context?.tokens ?? 0;
					const limit = context?.contextWindow ?? ctx.model?.contextWindow ?? 0;
					const percent = context?.percent ?? (limit > 0 ? (used / limit) * 100 : 0);
					const boundedPercent = Math.max(0, Math.min(100, percent ?? 0));
					const color = boundedPercent >= 90 ? "error" : boundedPercent >= 70 ? "warning" : "success";
					const barWidth = width >= 100 ? 20 : width >= 70 ? 14 : 10;
					const filled = Math.round((boundedPercent / 100) * barWidth);
					const bar = theme.fg(color, "█".repeat(filled)) + theme.fg("dim", "░".repeat(barWidth - filled));
					const tokenText = context?.tokens === null
						? `unknown / ${formatTokens(limit)}`
						: `${formatTokens(used)} / ${formatTokens(limit)}`;
					const contextLine = truncateToWidth(
						theme.fg("muted", "context  ") + bar + theme.fg(color, `  ${tokenText}  ${boundedPercent.toFixed(1)}%`),
						width,
						"…",
					);

					const activityLine = truncateToWidth(
						theme.fg("muted", "active  ") + theme.fg("accent", formatDuration(totalActiveMs())),
						width,
						"…",
					);
					const lines = [locationLine, activityLine, usageLine, contextLine];
					const statuses = [...footerData.getExtensionStatuses().values()].map(singleLine).filter(Boolean);
					if (statuses.length > 0) {
						lines.push(truncateToWidth(statuses.join("  "), width, "…"));
					}
					return lines;
				},
			};
		});
	});

	pi.on("agent_start", () => {
		if (activeSince === undefined) activeSince = Date.now();
	});

	pi.on("agent_end", (_event, ctx) => {
		persistActiveTime(ctx);
	});

	pi.on("session_shutdown", (_event, ctx) => {
		persistActiveTime(ctx);
	});
}
