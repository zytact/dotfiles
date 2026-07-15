import { dirname } from "node:path";
import { readFile } from "node:fs/promises";
import {
  CustomEditor,
  type ExtensionAPI,
  stripFrontmatter,
} from "@earendil-works/pi-coding-agent";
import {
  type AutocompleteItem,
  type AutocompleteProvider,
  type AutocompleteSuggestions,
  type EditorComponent,
  fuzzyFilter,
} from "@earendil-works/pi-tui";

const SKILL_REFERENCE = /(?:^|(?<=[^a-zA-Z0-9_$]))\$([a-z0-9]+(?:-[a-z0-9]+)*)\b/g;
const MAX_SUGGESTIONS = 20;
const DECORATED_EDITOR = Symbol("inline-skills-editor");

type SkillItem = AutocompleteItem & {
  name: string;
  filePath: string;
  baseDir: string;
};
type AnsiToken = { escape?: string; character?: string };
type DecoratedEditor = EditorComponent & { [DECORATED_EDITOR]?: boolean };

function findReferencedSkillNames(prompt: string): string[] {
  // A native /skill invocation is already expanded. Only inspect its user-supplied
  // arguments so shell variables in the skill instructions are not reinterpreted.
  const nativeSkillEnd = prompt.startsWith('<skill name="')
    ? prompt.indexOf("</skill>")
    : -1;
  const userText = nativeSkillEnd === -1
    ? prompt
    : prompt.slice(nativeSkillEnd + "</skill>".length);

  return [...userText.matchAll(SKILL_REFERENCE)].map((match) => match[1]!);
}

function getSkillItems(pi: ExtensionAPI): SkillItem[] {
  return pi
    .getCommands()
    .filter((command) => command.source === "skill" && command.name.startsWith("skill:"))
    .map((command) => {
      const name = command.name.slice("skill:".length);
      return {
        name,
        filePath: command.sourceInfo.path,
        baseDir: command.sourceInfo.baseDir ?? dirname(command.sourceInfo.path),
        value: `$${name}`,
        label: `$${name}`,
        description: command.description,
      };
    })
    .sort((a, b) => a.name.localeCompare(b.name));
}

function extractSkillToken(textBeforeCursor: string): string | undefined {
  return textBeforeCursor.match(/(?:^|[^a-zA-Z0-9_$])\$([a-z0-9-]*)$/)?.[1];
}

function createSkillAutocompleteProvider(
  pi: ExtensionAPI,
  current: AutocompleteProvider,
): AutocompleteProvider {
  return {
    triggerCharacters: [...new Set([...(current.triggerCharacters ?? []), "$"])],

    async getSuggestions(lines, cursorLine, cursorCol, options): Promise<AutocompleteSuggestions | null> {
      const textBeforeCursor = (lines[cursorLine] ?? "").slice(0, cursorCol);
      const query = extractSkillToken(textBeforeCursor);
      if (query === undefined) {
        return current.getSuggestions(lines, cursorLine, cursorCol, options);
      }

      const skills = getSkillItems(pi);
      const matches = query.length === 0
        ? skills.slice(0, MAX_SUGGESTIONS)
        : fuzzyFilter(
            skills,
            query,
            (skill) => `${skill.name} ${skill.description ?? ""}`,
          ).slice(0, MAX_SUGGESTIONS);

      if (options.signal.aborted || matches.length === 0) {
        return current.getSuggestions(lines, cursorLine, cursorCol, options);
      }

      return { items: matches, prefix: `$${query}` };
    },

    applyCompletion(lines, cursorLine, cursorCol, item, prefix) {
      return current.applyCompletion(lines, cursorLine, cursorCol, item, prefix);
    },

    shouldTriggerFileCompletion(lines, cursorLine, cursorCol) {
      return current.shouldTriggerFileCompletion?.(lines, cursorLine, cursorCol) ?? true;
    },
  };
}

function tokenizeAnsi(line: string): AnsiToken[] {
  const tokens: AnsiToken[] = [];
  let index = 0;

  while (index < line.length) {
    if (line[index] !== "\x1b") {
      tokens.push({ character: line[index] });
      index++;
      continue;
    }

    let end = index + 1;
    const next = line[end];
    if (next === "[") {
      end++;
      while (end < line.length && !(line[end]! >= "@" && line[end]! <= "~")) end++;
      end++;
    } else if (next === "]" || next === "_" || next === "P" || next === "^") {
      end++;
      while (
        end < line.length &&
        line[end] !== "\x07" &&
        !(line[end] === "\x1b" && line[end + 1] === "\\")
      ) {
        end++;
      }
      end += line[end] === "\x07" ? 1 : 2;
    } else {
      end++;
    }

    tokens.push({ escape: line.slice(index, end) });
    index = end;
  }

  return tokens;
}

function highlightSkillReferences(
  line: string,
  knownSkills: ReadonlySet<string>,
  color: (text: string) => string,
): string {
  const tokens = tokenizeAnsi(line);
  const visibleText = tokens
    .flatMap((token) => token.character ?? [])
    .join("");
  const ranges: Array<[number, number]> = [];

  for (const match of visibleText.matchAll(SKILL_REFERENCE)) {
    const name = match[1]!;
    if (!knownSkills.has(name)) continue;
    const dollarOffset = match[0].lastIndexOf("$");
    const start = match.index + dollarOffset;
    ranges.push([start, start + name.length + 1]);
  }

  if (ranges.length === 0) return line;

  let visibleIndex = 0;
  let result = "";
  for (const token of tokens) {
    if (token.escape !== undefined) {
      result += token.escape;
      continue;
    }

    const character = token.character ?? "";
    const highlighted = ranges.some(
      ([start, end]) => visibleIndex >= start && visibleIndex < end,
    );
    result += highlighted ? color(character) : character;
    visibleIndex++;
  }

  return result;
}

function decorateEditor(
  editor: EditorComponent,
  pi: ExtensionAPI,
  color: (text: string) => string,
): EditorComponent {
  const decorated = editor as DecoratedEditor;
  if (decorated[DECORATED_EDITOR]) return editor;

  const render = editor.render.bind(editor);
  editor.render = (width) => {
    const knownSkills = new Set(getSkillItems(pi).map((skill) => skill.name));
    return render(width).map((line) =>
      highlightSkillReferences(line, knownSkills, color),
    );
  };
  decorated[DECORATED_EDITOR] = true;
  return editor;
}

async function formatSkill(skill: SkillItem): Promise<string> {
  const content = await readFile(skill.filePath, "utf8");
  const body = stripFrontmatter(content).trim();

  return `<skill name="${skill.name}" location="${skill.filePath}">\nReferences are relative to ${skill.baseDir}.\n\n${body}\n</skill>`;
}

export default function inlineSkills(pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (!ctx.hasUI) return;
    ctx.ui.addAutocompleteProvider((current) =>
      createSkillAutocompleteProvider(pi, current),
    );
  });

  // resources_discover runs after every extension's session_start handler. This
  // lets us decorate an editor installed by another extension instead of replacing it.
  pi.on("resources_discover", (_event, ctx) => {
    if (!ctx.hasUI) return;

    const currentFactory = ctx.ui.getEditorComponent();
    ctx.ui.setEditorComponent((tui, theme, keybindings) => {
      const editor = currentFactory
        ? currentFactory(tui, theme, keybindings)
        : new CustomEditor(tui, theme, keybindings);
      return decorateEditor(editor, pi, (text) => ctx.ui.theme.fg("accent", text));
    });
  });

  pi.on("input", async (event, ctx) => {
    // Let Pi's native implementation own native skill commands unchanged.
    if (event.text.startsWith("/skill:")) return { action: "continue" } as const;

    const referencedNames = findReferencedSkillNames(event.text);
    if (referencedNames.length === 0) return { action: "continue" } as const;

    const skillsByName = new Map(
      getSkillItems(pi).map((skill) => [skill.name, skill]),
    );
    const uniqueNames = [...new Set(referencedNames)];
    const invokedSkills: string[] = [];

    for (const name of uniqueNames) {
      const skill = skillsByName.get(name);
      if (!skill) continue;

      try {
        invokedSkills.push(await formatSkill(skill));
      } catch (error) {
        if (ctx.hasUI) {
          const message = error instanceof Error ? error.message : String(error);
          ctx.ui.notify(`Could not load $${name}: ${message}`, "error");
        }
      }
    }

    if (invokedSkills.length === 0) return { action: "continue" } as const;

    const invokedNames = new Set(
      uniqueNames.filter((name) => skillsByName.has(name)),
    );
    const prompt = event.text
      .replace(SKILL_REFERENCE, (reference, name: string) =>
        invokedNames.has(name) ? "" : reference,
      )
      .trim();
    const text = prompt.length > 0
      ? `${invokedSkills.join("\n\n")}\n\n${prompt}`
      : invokedSkills.join("\n\n");

    return { action: "transform", text } as const;
  });
}
