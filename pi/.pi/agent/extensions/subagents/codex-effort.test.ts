import assert from "node:assert/strict";
import test from "node:test";
import {
  preferredCodexEffort,
  supportedCodexEffort,
} from "./src/backends/codex.ts";

function modelList(...efforts: string[]) {
  return {
    data: [
      {
        id: "gpt-5.6-luna",
        supportedReasoningEfforts: efforts.map((reasoningEffort) => ({
          reasoningEffort,
        })),
      },
    ],
  };
}

test("Codex preserves max effort when the model supports it", () => {
  assert.equal(preferredCodexEffort("max"), "max");
  assert.equal(
    supportedCodexEffort(
      "max",
      "gpt-5.6-luna",
      modelList("low", "medium", "high", "xhigh", "max"),
    ),
    "max",
  );
});

test("Codex downgrades max to xhigh for older model capabilities", () => {
  assert.equal(
    supportedCodexEffort(
      "max",
      "gpt-5.6-luna",
      modelList("low", "medium", "high", "xhigh"),
    ),
    "xhigh",
  );
});
