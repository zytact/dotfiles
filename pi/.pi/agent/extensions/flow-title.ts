import { readFileSync } from "node:fs";
import path from "node:path";
import type {
  ExtensionAPI,
  ExtensionContext,
  Theme,
} from "@earendil-works/pi-coding-agent";

type Rgb = [number, number, number];
type ThemeDefinition = {
  vars?: Record<string, string | number>;
  export?: { pageBg?: string | number };
};
type Renderable = {
  render(width: number): string[];
  invalidate?: () => void;
};
type RenderableContainer = Renderable & { children: Renderable[] };
type TuiLike = RenderableContainer & { requestRender(force?: boolean): void };

const ANSI_PATTERN =
  /[\u001B\u009B][[\]()#;?]*(?:(?:(?:[a-zA-Z\d]*(?:;[a-zA-Z\d]*)*)?\u0007)|(?:(?:\d{1,4}(?:;\d{0,4})*)?[\dA-PR-TZcf-nq-uy=><~]))/g;

const TITLE_LINES = [
  "   ███████████████████████████╗  ",
  "   ╚══██████╔════════██████╔══╝  ",
  "      ██████║        ██████║     ",
  "      ██████║        ██████║     ",
  "      ██████║        ██████║     ",
  "      ██████║        ██████║     ",
  "      ██████║        ██████║     ",
  "      ██████║        ██████║     ",
  "   ████████████╗  ████████████╗  ",
  "   ╚═══════════╝  ╚═══════════╝  ",
];

const ZYTACT_LINES = ["zytact"];

function parseRgb(value: string): Rgb | undefined {
  const hex = value.match(/^#([\da-f]{2})([\da-f]{2})([\da-f]{2})$/i);
  if (hex)
    return [
      parseInt(hex[1]!, 16),
      parseInt(hex[2]!, 16),
      parseInt(hex[3]!, 16),
    ];

  const ansi = value.match(/(?:38|48);2;(\d+);(\d+);(\d+)/);
  if (ansi) return [Number(ansi[1]), Number(ansi[2]), Number(ansi[3])];
}

function configuredBackground(theme: Theme): Rgb | undefined {
  try {
    const definition = JSON.parse(
      readFileSync(theme.sourcePath!, "utf8"),
    ) as ThemeDefinition;
    const pageBg = definition.export?.pageBg;
    const value = pageBg === undefined ? definition.vars?.bg : pageBg;
    const resolved =
      typeof value === "string" ? (definition.vars?.[value] ?? value) : value;
    if (typeof resolved === "string") {
      const rgb = parseRgb(resolved);
      if (rgb) return rgb;
    }
  } catch {}

  return parseRgb(theme.getBgAnsi("customMessageBg"));
}

function mix(a: number, b: number, amount: number) {
  return Math.round(a + (b - a) * amount);
}

function gradientText(text: string, phase: number, theme: Theme) {
  const accent = parseRgb(theme.getFgAnsi("accent"));
  if (!accent) return theme.fg("accent", text);

  const background = configuredBackground(theme);
  if (!background) return theme.fg("accent", text);

  const chars = [...text];
  const span = Math.max(chars.length - 1, 1);

  return chars
    .map((char, index) => {
      if (char === " ") return char;
      const position = (index / span + phase) % 1;
      const intensity = 0.5 + 0.5 * Math.sin(Math.PI * position);
      const color: Rgb = [
        mix(background[0], accent[0], intensity),
        mix(background[1], accent[1], intensity),
        mix(background[2], accent[2], intensity),
      ];
      return `\x1b[38;2;${color[0]};${color[1]};${color[2]}m${char}\x1b[0m`;
    })
    .join("");
}

function center(text: string, width: number) {
  const length = [...text].length;
  if (length >= width) return text;
  return `${" ".repeat(Math.floor((width - length) / 2))}${text}`;
}

function projectName() {
  return path.basename(process.cwd()) || "session";
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function isRenderable(value: unknown): value is Renderable {
  return isRecord(value) && typeof value.render === "function";
}

function isRenderableContainer(value: unknown): value is RenderableContainer {
  return isRenderable(value) && Array.isArray(value.render);
}

function withoutAnsi(text: string) {
  return text.replace(ANSI_PATTERN, "");
}

function renderedText(component: Renderable) {
  try {
    return withoutAnsi(component.render(120).join("\n"));
  } catch {
    return "";
  }
}

function hasSectionHeader(text: string, header: string) {
  return text.split("\n").some((line) => line.trim() === header);
}

function isHiddenStartupListing(component: Renderable) {
  const text = renderedText(component);
  const isThemesListing =
    hasSectionHeader(text, "[Themes]") &&
    (text.includes("/themes/") || text.includes(".pi/agent/themes"));
  const isExtensionsListing =
    hasSectionHeader(text, "[Extensions]") &&
    (text.includes("/extensions/") || text.includes(".pi/agent/extensions"));

  return isThemesListing || isExtensionsListing;
}

function isBlankSpacer(component: Renderable) {
  return renderedText(component).trim() === "";
}

function renderHeader(
  width: number,
  phase: number,
  subtitleText: string,
  theme: Theme,
) {
  const lines = TITLE_LINES.map((line, row) =>
    gradientText(center(line, width), phase + row * 0.02, theme),
  );
  const subtitle = center(subtitleText, width);
  const zytact = ZYTACT_LINES.map((line) =>
    theme.fg("muted", center(line, width)),
  );

  return ["", ...lines, theme.bold(theme.fg("text", subtitle)), ...zytact, ""];
}

export default function (pi: ExtensionAPI) {
  let requestRender: (() => void) | undefined;
  let currentModelId = "no model selected";

  function installHeader(ctx: ExtensionContext) {
    ctx.ui.setHeader((tui, theme) => {
      requestRender = () => tui.requestRender();
      return {
        render(width: number) {
          return renderHeader(
            width,
            0,
            `${currentModelId} · ${projectName()}`,
            theme,
          );
        },
        invalidate() {
          tui.requestRender();
        },
      };
    });
  }

  pi.on("session_start", (_event, ctx) => {
    currentModelId = ctx.model?.id ?? "no model selected";
    if (!ctx.hasUI) return;
    installHeader(ctx);
  });

  pi.on("model_select", (event) => {
    currentModelId = event.model.id;
    requestRender?.();
  });

  pi.on("session_shutdown", (_event, ctx) => {
    if (ctx.hasUI) ctx.ui.setHeader(undefined);
  });

  pi.registerCommand("flow-title", {
    description: "Enable the theme-aware flowing session header",
    handler: async (_args, ctx) => {
      installHeader(ctx);
      ctx.ui.notify("Flow title enabled", "info");
    },
  });

  pi.registerCommand("flow-title-builtin", {
    description: "Restore pi's built-in header for this session",
    handler: async (_args, ctx) => {
      ctx.ui.setHeader(undefined);
      ctx.ui.notify("Built-in header restored", "info");
    },
  });
}
