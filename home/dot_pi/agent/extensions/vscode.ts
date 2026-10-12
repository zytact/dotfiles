import { spawn } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function openEditor(command: string, cwd: string) {
	return new Promise<void>((resolve, reject) => {
		const child = spawn(command, [cwd], {
			cwd,
			detached: true,
			stdio: "ignore",
		});

		child.once("error", reject);
		child.once("spawn", () => {
			child.unref();
			resolve();
		});
	});
}

export default function (pi: ExtensionAPI) {
	pi.registerCommand("vscode", {
		description: "Open the current Pi session working directory in VS Code",
		handler: async (_args, ctx) => {
			const cwd = ctx.cwd;

			try {
				await openEditor("code", cwd);
				ctx.ui.notify(`Opened ${cwd} in VS Code`, "info");
			} catch (error) {
				const message = error instanceof Error ? error.message : String(error);
				ctx.ui.notify(`Failed to open VS Code: ${message}`, "error");
			}
		},
	});
}
