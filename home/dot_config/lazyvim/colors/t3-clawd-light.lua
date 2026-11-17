-- t3-clawd-light: Claude's ivory and warm grays with clay as the one accent.
-- Matches the light variant of the T3 Clawd T3 Code theme.
-- Supports tree-sitter, LSP diagnostics, and common plugins.

local bg = "#faf9f5"
local fg = "#141413"
local cursor = "#c96442"

local c = {
  panel     = "#f5f4ed",
  accent    = "#c96442",
  accent_hi = "#b5573a",
  fn        = "#9a6a45",
  prop      = "#6b5a3e",
  green     = "#5f7a3a",
  amber     = "#a86a1c",
  cream     = "#8c5a16",
  type      = "#8a5a8a",
  mauve     = "#75497a",
  teal      = "#3d7a68",
  punct     = "#6b6a64",
  text      = "#141413",
  comment   = "#87867f",
  red       = "#b5452f",
  border    = "#e5e3da",
  subtle    = "#d1cfc5",
  selection_bg = "#f2d6c9",
  selection_fg = "#141413",
}

local transparent = vim.g.t3_clawd_light_transparent == true
local main_bg = transparent and "NONE" or bg
local panel_bg = transparent and "NONE" or c.panel

local function h(group, opts)
  opts = opts or {}
  vim.api.nvim_set_hl(0, group, {
    fg = opts.fg,
    bg = opts.bg,
    sp = opts.guisp,
    bold = opts.gui == "bold" or nil,
    italic = opts.gui == "italic" or opts.gui == "italic,bold" or opts.gui == "bold,italic" or nil,
    undercurl = opts.gui == "undercurl" or nil,
    underline = opts.gui == "underline" or nil,
    strikethrough = opts.gui == "strikethrough" or nil,
    reverse = opts.gui == "reverse" or nil,
    link = opts.link,
  })
end

local function setup()
  vim.cmd("hi clear")
  vim.o.background = "light"
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "t3-clawd-light"

  -- ==========================================================================
  -- Base editor groups
  -- ==========================================================================
  h("Normal",       { fg = fg, bg = main_bg })
  h("NormalFloat",  { fg = fg, bg = panel_bg })
  h("NormalSB",     { fg = fg, bg = main_bg })
  h("EndOfBuffer",  { fg = c.border })
  h("Cursor",       { fg = bg, bg = cursor })
  h("CursorColumn", { bg = c.panel })
  h("CursorLine",   { bg = "#f5f4ed" })
  h("CursorLineNr", { fg = c.text, gui = "bold" })
  h("LineNr",       { fg = c.subtle })
  h("SignColumn",   { bg = main_bg })
  h("ColorColumn",  { bg = "#f0eee6" })

  h("Visual",        { bg = c.selection_bg, fg = c.selection_fg })
  h("VisualNOS",     { bg = c.selection_bg })
  h("Search",        { fg = bg, bg = c.amber })
  h("IncSearch",     { fg = bg, bg = c.accent })
  h("CurSearch",     { link = "IncSearch" })
  h("Substitute",    { fg = bg, bg = c.accent })

  h("MatchParen",    { fg = c.accent_hi, gui = "bold" })

  h("NonText",       { fg = c.border })
  h("SpecialKey",    { fg = c.border })
  h("Whitespace",    { fg = c.border })
  h("Conceal",       { fg = c.subtle })

  h("Pmenu",         { fg = fg, bg = panel_bg })
  h("PmenuSel",      { fg = bg, bg = c.accent })
  h("PmenuSbar",     { bg = c.border })
  h("PmenuThumb",    { bg = c.subtle })

  h("WildMenu",      { fg = bg, bg = c.accent })
  h("Question",      { fg = c.green })
  h("MoreMsg",       { fg = c.green })
  h("ModeMsg",       { fg = fg })

  h("TabLine",       { fg = c.comment, bg = main_bg })
  h("TabLineFill",   { bg = main_bg })
  h("TabLineSel",    { fg = c.accent, bg = main_bg, gui = "bold" })

  h("Title",         { fg = c.accent, gui = "bold" })

  h("StatusLine",    { fg = fg, bg = panel_bg })
  h("StatusLineNC",  { fg = c.comment, bg = main_bg })
  h("StatusLineTerm",    { link = "StatusLine" })
  h("StatusLineTermNC",  { link = "StatusLineNC" })

  h("VertSplit",     { fg = c.border, bg = main_bg })

  h("FoldColumn",    { fg = c.subtle, bg = main_bg })
  h("Folded",        { fg = c.comment, bg = "#f5f4ed" })

  h("SpellBad",      { guisp = c.red, gui = "undercurl" })
  h("SpellCap",      { guisp = c.amber, gui = "undercurl" })
  h("SpellLocal",    { guisp = c.type, gui = "undercurl" })
  h("SpellRare",     { guisp = c.fn, gui = "undercurl" })

  h("DiffAdd",       { fg = c.green, bg = "#e5ebd6" })
  h("DiffChange",    { fg = c.amber, bg = "#f5e8cf" })
  h("DiffDelete",    { fg = c.red, bg = "#f6dfd9" })
  h("DiffText",      { fg = bg, bg = c.amber })

  h("DiagnosticError",            { fg = c.red, gui = "italic" })
  h("DiagnosticWarn",             { fg = c.amber, gui = "italic" })
  h("DiagnosticInfo",             { fg = c.teal })
  h("DiagnosticHint",             { fg = c.mauve })
  h("DiagnosticOk",               { fg = c.green })
  h("DiagnosticUnderlineError",   { guisp = c.red, gui = "undercurl" })
  h("DiagnosticUnderlineWarn",    { guisp = c.amber, gui = "undercurl" })
  h("DiagnosticUnderlineInfo",    { guisp = c.teal, gui = "undercurl" })
  h("DiagnosticUnderlineHint",    { guisp = c.mauve, gui = "undercurl" })
  h("DiagnosticUnderlineOk",      { guisp = c.green, gui = "undercurl" })

  h("LspReferenceText",  { bg = c.selection_bg })
  h("LspReferenceRead",  { bg = c.selection_bg })
  h("LspReferenceWrite", { bg = c.selection_bg })
  h("LspInlayHint",      { fg = c.subtle, bg = main_bg })

  -- ==========================================================================
  -- Syntax groups
  -- ==========================================================================
  h("Comment",        { fg = c.comment, gui = "italic" })
  h("Constant",       { fg = c.cream })
  h("String",         { fg = c.green })
  h("Character",      { fg = c.cream })
  h("Number",         { fg = c.amber })
  h("Boolean",        { fg = c.amber })
  h("Float",          { fg = c.amber })

  h("Identifier",     { fg = fg })
  h("Function",       { fg = c.fn })
  h("Method",         { fg = c.fn })

  h("Statement",      { fg = c.accent })
  h("Conditional",    { fg = c.accent })
  h("Repeat",         { fg = c.accent })
  h("Label",          { fg = c.accent })
  h("Operator",       { fg = c.punct })
  h("Keyword",        { fg = c.accent })
  h("Exception",      { fg = c.red })

  h("PreProc",        { fg = c.accent })
  h("Include",        { fg = c.accent })
  h("Define",         { fg = c.accent })
  h("Macro",          { fg = c.fn })
  h("PreCondit",      { fg = c.accent })

  h("Type",           { fg = c.type })
  h("StorageClass",   { fg = c.mauve })
  h("Structure",      { fg = c.type })
  h("Typedef",        { fg = c.mauve })

  h("Special",        { fg = c.cream })
  h("SpecialChar",    { fg = c.type })
  h("Tag",            { fg = c.accent })
  h("Delimiter",      { fg = c.punct })
  h("SpecialComment", { fg = c.comment, gui = "italic" })
  h("Debug",          { fg = c.mauve })

  h("Underlined",     { fg = fg, gui = "underline" })
  h("Ignore",         { fg = c.subtle })
  h("Error",          { fg = c.red, bg = main_bg })
  h("Todo",           { fg = bg, bg = c.amber })

  -- ==========================================================================
  -- Treesitter highlight groups
  -- ==========================================================================
  h("@comment",               { link = "Comment" })
  h("@comment.todo",          { fg = bg, bg = c.amber })
  h("@comment.error",         { fg = c.red })
  h("@comment.warning",       { fg = c.amber })
  h("@comment.note",          { fg = c.teal })

  h("@constant",              { link = "Constant" })
  h("@constant.builtin",      { fg = c.amber })
  h("@constant.macro",        { link = "Macro" })

  h("@module",                { fg = c.mauve })
  h("@module.builtin",        { fg = c.fn })
  h("@namespace",             { fg = c.mauve })

  h("@symbol",                { fg = c.teal })

  h("@string",                { link = "String" })
  h("@string.documentation",  { fg = c.green, gui = "italic" })
  h("@string.regex",          { fg = c.cream })
  h("@string.escape",         { fg = c.type })
  h("@string.special",        { fg = c.teal })
  h("@string.special.symbol", { fg = c.teal })
  h("@string.special.url",    { fg = c.accent_hi, gui = "underline" })
  h("@string.special.path",   { fg = c.type })

  h("@character",             { link = "Character" })
  h("@character.special",     { fg = c.type })

  h("@boolean",               { link = "Boolean" })
  h("@number",                { link = "Number" })
  h("@number.float",          { link = "Float" })

  h("@type",                  { link = "Type" })
  h("@type.builtin",          { fg = c.teal })
  h("@type.definition",       { fg = c.mauve, gui = "italic" })
  h("@type.qualifier",        { fg = c.accent })

  h("@attribute",             { fg = c.cream })
  h("@property",              { fg = c.prop })

  h("@function",              { link = "Function" })
  h("@function.builtin",      { fg = c.fn, gui = "italic" })
  h("@function.call",         { link = "Function" })
  h("@function.macro",        { fg = c.fn })
  h("@function.method",       { link = "Method" })
  h("@function.method.call",  { link = "Method" })

  h("@constructor",           { fg = c.type })
  h("@operator",              { link = "Operator" })

  h("@keyword",               { link = "Keyword" })
  h("@keyword.conditional",   { link = "Conditional" })
  h("@keyword.repeat",        { link = "Repeat" })
  h("@keyword.debug",         { link = "Debug" })
  h("@keyword.directive",     { fg = c.accent })
  h("@keyword.directive.define", { link = "Define" })
  h("@keyword.exception",     { link = "Exception" })
  h("@keyword.function",      { fg = c.accent })
  h("@keyword.import",        { fg = c.accent })
  h("@keyword.operator",      { fg = c.punct })
  h("@keyword.return",        { fg = c.red })
  h("@keyword.storage",       { link = "StorageClass" })
  h("@keyword.type",          { fg = c.accent })

  h("@label",                 { link = "Label" })
  h("@label.builtin",         { fg = c.accent })

  h("@punctuation.delimiter", { fg = c.punct })
  h("@punctuation.bracket",   { fg = c.punct })
  h("@punctuation.special",   { fg = c.teal })

  h("@variable",              { fg = fg })
  h("@variable.builtin",      { fg = c.accent, gui = "italic" })
  h("@variable.member",       { fg = c.prop })
  h("@variable.parameter",    { fg = c.cream })
  h("@variable.parameter.builtin", { fg = c.amber })

  h("@field",                 { fg = c.prop })

  h("@markup.heading",        { fg = c.accent, gui = "bold" })
  h("@markup.heading.1",      { fg = c.accent, gui = "bold" })
  h("@markup.heading.2",      { fg = c.accent_hi, gui = "bold" })
  h("@markup.heading.3",      { fg = c.amber, gui = "bold" })
  h("@markup.heading.4",      { fg = c.cream, gui = "bold" })
  h("@markup.heading.5",      { fg = c.mauve, gui = "bold" })
  h("@markup.heading.6",      { fg = c.fn, gui = "bold" })
  h("@markup.italic",         { gui = "italic" })
  h("@markup.bold",           { gui = "bold" })
  h("@markup.strikethrough",  { gui = "strikethrough" })
  h("@markup.underline",      { gui = "underline" })
  h("@markup.link",           { fg = c.accent, gui = "underline" })
  h("@markup.link.label",     { fg = c.accent_hi })
  h("@markup.link.url",       { fg = c.accent_hi, gui = "underline" })
  h("@markup.list",           { fg = c.amber })
  h("@markup.list.checked",   { fg = c.green })
  h("@markup.list.unchecked", { fg = c.comment })
  h("@markup.raw",            { fg = c.green })
  h("@markup.raw.block",      { fg = c.green, bg = "#f5f4ed" })
  h("@markup.quote",          { fg = c.comment, gui = "italic" })
  h("@markup.math",           { fg = c.teal })
  h("@markup.environment",    { fg = c.type })

  h("@diff.plus",             { fg = c.green })
  h("@diff.minus",            { fg = c.red })
  h("@diff.delta",            { fg = c.amber })

  h("@tag",                   { fg = c.accent })
  h("@tag.builtin",           { fg = c.accent })
  h("@tag.attribute",         { fg = c.cream })
  h("@tag.delimiter",         { fg = c.punct })

  h("@error",                 { fg = c.red })

  -- ==========================================================================
  -- LSP Semantic Tokens
  -- ==========================================================================
  h("@lsp.type.class",         { link = "@type" })
  h("@lsp.type.comment",       { link = "@comment" })
  h("@lsp.type.decorator",     { link = "@attribute" })
  h("@lsp.type.enum",          { link = "@type" })
  h("@lsp.type.enumMember",    { link = "@constant" })
  h("@lsp.type.function",      { link = "@function" })
  h("@lsp.type.interface",     { link = "@type" })
  h("@lsp.type.keyword",       { link = "@keyword" })
  h("@lsp.type.macro",         { link = "@constant.macro" })
  h("@lsp.type.method",        { link = "@function.method" })
  h("@lsp.type.modifier",      { link = "@type.qualifier" })
  h("@lsp.type.namespace",     { link = "@namespace" })
  h("@lsp.type.number",        { link = "@number" })
  h("@lsp.type.operator",      { link = "@operator" })
  h("@lsp.type.parameter",     { link = "@variable.parameter" })
  h("@lsp.type.property",      { link = "@property" })
  h("@lsp.type.selfKeyword",   { link = "@variable.builtin" })
  h("@lsp.type.selfTypeKeyword", { link = "@type.builtin" })
  h("@lsp.type.string",        { link = "@string" })
  h("@lsp.type.struct",        { link = "@type" })
  h("@lsp.type.typeAlias",     { link = "@type.definition" })
  h("@lsp.type.typeParameter", { link = "@type.definition" })
  h("@lsp.type.union",         { link = "@type" })
  h("@lsp.type.variable",      { link = "@variable" })

  -- ==========================================================================
  -- Plugin highlights
  -- ==========================================================================

  -- Telescope
  h("TelescopeNormal",    { fg = fg, bg = main_bg })
  h("TelescopeBorder",    { fg = c.border, bg = main_bg })
  h("TelescopePromptBorder", { fg = c.accent, bg = main_bg })
  h("TelescopePromptTitle",  { fg = c.accent, bg = main_bg })
  h("TelescopeResultsTitle", { fg = c.comment, bg = main_bg })
  h("TelescopePreviewTitle", { fg = c.comment, bg = main_bg })
  h("TelescopeSelection",    { fg = fg, bg = c.selection_bg })
  h("TelescopeSelectionCaret", { fg = c.accent })
  h("TelescopeMatching",     { fg = c.amber, gui = "bold" })

  -- NvimTree / Oil
  h("NvimTreeNormal",      { fg = fg, bg = main_bg })
  h("NvimTreeFolderName",  { fg = c.fn })
  h("NvimTreeOpenedFolderName", { fg = c.prop })
  h("NvimTreeGitDirty",    { fg = c.amber })
  h("NvimTreeGitNew",      { fg = c.green })
  h("NvimTreeGitDeleted",  { fg = c.red })

  -- WhichKey
  h("WhichKey",           { fg = c.accent, gui = "bold" })
  h("WhichKeyGroup",      { fg = c.amber })
  h("WhichKeyDesc",       { fg = fg })
  h("WhichKeySeparator",  { fg = c.subtle })
  h("WhichKeyFloat",      { bg = main_bg })

  -- Lazy
  h("LazyReasonStart",    { fg = c.green })
  h("LazyReasonRuntime",  { fg = c.fn })
  h("LazyReasonSource",   { fg = c.type })
  h("LazyReasonPlugin",   { fg = c.fn })
  h("LazyDir",            { fg = c.fn })
  h("LazyUrl",            { fg = c.type, gui = "underline" })
  h("LazyCommit",         { fg = c.amber })
  h("LazySpecial",        { fg = c.teal })
  h("LazyH1",             { fg = c.accent, gui = "bold" })
  h("LazyButton",         { fg = bg, bg = c.accent })

  -- Noice / Notify
  h("NoiceFormatTitle",      { fg = c.accent, gui = "bold" })
  h("NoiceFormatProgressDone", { bg = c.green })
  h("NoiceFormatProgressTodo", { bg = c.border })
  h("NotifyERRORTitle",  { fg = c.red })
  h("NotifyWARNTitle",   { fg = c.amber })
  h("NotifyINFOTitle",   { fg = c.teal })
  h("NotifyDEBUDTitle",  { fg = c.fn })
  h("NotifyTRACETitle",  { fg = c.mauve })

  -- Flash
  h("FlashLabel",        { fg = bg, bg = c.accent, gui = "bold" })

  -- Neo-tree
  h("NeoTreeNormal",     { fg = fg, bg = main_bg })
  h("NeoTreeDirectoryName", { fg = c.fn })
  h("NeoTreeGitAdded",   { fg = c.green })
  h("NeoTreeGitModified", { fg = c.amber })
  h("NeoTreeGitDeleted",  { fg = c.red })
  h("NeoTreeGitUntracked", { fg = c.mauve })

  -- Trouble
  h("TroubleText",       { fg = fg })
  h("TroubleCount",      { fg = c.accent, gui = "bold" })
  h("TroubleSource",     { fg = c.comment })

  -- Indent Blankline / Ibl
  h("IblIndent",         { fg = "#edebe3" })
  h("IblScope",          { fg = c.subtle })

  -- Mini
  h("MiniStatuslineModeNormal", { fg = bg, bg = c.accent, gui = "bold" })
  h("MiniStatuslineModeInsert", { fg = bg, bg = c.green, gui = "bold" })
  h("MiniStatuslineModeVisual", { fg = bg, bg = c.fn, gui = "bold" })
  h("MiniStatuslineModeReplace", { fg = bg, bg = c.red, gui = "bold" })
  h("MiniStatuslineModeCommand", { fg = bg, bg = c.amber, gui = "bold" })
  h("MiniStatuslineModeOther",   { fg = bg, bg = c.teal, gui = "bold" })
  h("MiniIndentscopeSymbol",     { fg = c.subtle })

  -- Bufferline
  h("BufferLineTab",         { fg = c.comment, bg = main_bg })
  h("BufferLineTabSelected", { fg = c.accent, bg = main_bg })
  h("BufferLineBuffer",      { fg = c.comment, bg = main_bg })
  h("BufferLineBufferSelected", { fg = fg, bg = main_bg, gui = "bold" })
  h("BufferLineBufferVisible",  { fg = c.comment, bg = main_bg })
  h("BufferLineIndicatorSelected", { fg = c.accent })
  h("BufferLinePick",        { fg = c.accent })
  h("BufferLineDuplicate",   { fg = c.subtle })
  h("BufferLinePickVisible", { fg = c.accent })
  h("BufferLineDevIcon",             { fg = c.comment })
  h("BufferLineDevIconSelected",     { fg = c.accent })
  h("BufferLineDevIconVisible",      { fg = c.comment })
end

setup()
