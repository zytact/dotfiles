import {
  getSupportedThinkingLevels,
  type ModelThinkingLevel,
} from "@earendil-works/pi-ai";
import {
  DynamicBorder,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";
import {
  Container,
  type SelectItem,
  SelectList,
  Text,
} from "@earendil-works/pi-tui";

const LEVEL_DESCRIPTIONS: Record<ModelThinkingLevel, string> = {
  off: "No reasoning",
  minimal: "Very brief reasoning (~1k tokens)",
  low: "Light reasoning (~2k tokens)",
  medium: "Moderate reasoning (~8k tokens)",
  high: "Deep reasoning (~16k tokens)",
  xhigh: "Extra-high reasoning (~32k tokens)",
  max: "Maximum reasoning",
};

export default function reasoningPicker(pi: ExtensionAPI) {
  pi.registerCommand("reasoning", {
    description: "Select the reasoning effort for the current model",
    handler: async (_args, ctx) => {
      if (ctx.mode !== "tui") {
        ctx.ui.notify("/reasoning requires TUI mode", "error");
        return;
      }

      const model = ctx.model;
      if (!model) {
        ctx.ui.notify("No model is currently selected", "warning");
        return;
      }

      const currentLevel = pi.getThinkingLevel();
      const availableLevels = getSupportedThinkingLevels(model);
      const items: SelectItem[] = availableLevels.map((level) => ({
        value: level,
        label: level === currentLevel ? `${level} (current)` : level,
        description: LEVEL_DESCRIPTIONS[level],
      }));

      const selectedLevel = await ctx.ui.custom<ModelThinkingLevel | null>(
        (tui, theme, _keybindings, done) => {
          const container = new Container();
          container.addChild(
            new DynamicBorder((text: string) => theme.fg("accent", text)),
          );
          container.addChild(
            new Text(
              theme.fg("accent", theme.bold("Select Reasoning Effort")),
              1,
              0,
            ),
          );
          container.addChild(
            new Text(
              theme.fg("dim", `${model.provider}/${model.id}`),
              1,
              0,
            ),
          );

          const selectList = new SelectList(
            items,
            items.length,
            {
              selectedPrefix: (text) => theme.fg("accent", text),
              selectedText: (text) => theme.fg("accent", text),
              description: (text) => theme.fg("muted", text),
              scrollInfo: (text) => theme.fg("dim", text),
              noMatch: (text) => theme.fg("warning", text),
            },
            { minPrimaryColumnWidth: 12, maxPrimaryColumnWidth: 32 },
          );

          const currentIndex = availableLevels.indexOf(currentLevel);
          if (currentIndex >= 0) selectList.setSelectedIndex(currentIndex);

          selectList.onSelect = (item) =>
            done(item.value as ModelThinkingLevel);
          selectList.onCancel = () => done(null);
          container.addChild(selectList);
          container.addChild(
            new Text(
              theme.fg(
                "dim",
                "↑↓ navigate • enter select • esc cancel",
              ),
              1,
              0,
            ),
          );
          container.addChild(
            new DynamicBorder((text: string) => theme.fg("accent", text)),
          );

          return {
            render: (width: number) => container.render(width),
            invalidate: () => container.invalidate(),
            handleInput: (data: string) => {
              selectList.handleInput(data);
              tui.requestRender();
            },
          };
        },
      );

      if (selectedLevel === null || selectedLevel === undefined) return;

      pi.setThinkingLevel(selectedLevel);
      ctx.ui.notify(`Reasoning effort: ${pi.getThinkingLevel()}`, "info");
    },
  });
}
