-- t3-dark: T3 Code's default dark theme, neutral greys with a blue accent.
-- Derived from the ghostty t3-dark theme palette.
-- Supports tree-sitter, LSP diagnostics, and common plugins.

local bg = "#0a0a0a"
local fg = "#f5f5f5"
local cursor = "#b4cbff"

-- Ghostty t3-dark palette
local c = {
  panel          = "#111111",
  blue           = "#568ef9",
  green          = "#54c57a",
  amber          = "#e4b750",
  slate          = "#87a7d0",
  purple         = "#bb8aef",
  teal           = "#51cec7",
  text           = "#f5f5f5",
  comment        = "#818181",
  red            = "#ff6467",
  light_green    = "#89dea1",
  light_amber    = "#f3d086",
  light_slate    = "#a7c3e8",
  light_purple   = "#ceacf7",
  light_teal     = "#91e2dc",
  white          = "#ffffff",
  light_blue     = "#87bafd",
  border         = "#191919",
  subtle         = "#363636",
  selection_bg   = "#343a47",
  selection_fg   = "#ffffff",
}

local transparent = vim.g.t3_dark_transparent == true
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
  vim.o.background = "dark"
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "t3-dark"

  -- ==========================================================================
  -- Base editor groups
  -- ==========================================================================
  h("Normal",       { fg = fg, bg = main_bg })
  h("NormalFloat",  { fg = fg, bg = panel_bg })
  h("NormalSB",     { fg = fg, bg = main_bg })
  h("EndOfBuffer",  { fg = c.border })
  h("Cursor",       { fg = bg, bg = cursor })
  h("CursorColumn", { bg = c.panel })
  h("CursorLine",   { bg = "#0d0d0d" })
  h("CursorLineNr", { fg = c.text, gui = "bold" })
  h("LineNr",       { fg = c.subtle })
  h("SignColumn",   { bg = main_bg })
  h("ColorColumn",  { bg = "#0f0f0f" })

  h("Visual",        { bg = c.selection_bg, fg = c.selection_fg })
  h("VisualNOS",     { bg = c.selection_bg })
  h("Search",        { fg = bg, bg = c.amber })
  h("IncSearch",     { fg = bg, bg = c.blue })
  h("CurSearch",     { link = "IncSearch" })
  h("Substitute",    { fg = bg, bg = c.blue })

  h("MatchParen",    { fg = c.light_blue, gui = "bold" })

  h("NonText",       { fg = c.border })
  h("SpecialKey",    { fg = c.border })
  h("Whitespace",    { fg = c.border })
  h("Conceal",       { fg = c.subtle })

  h("Pmenu",         { fg = fg, bg = panel_bg })
  h("PmenuSel",      { fg = bg, bg = c.blue })
  h("PmenuSbar",     { bg = c.border })
  h("PmenuThumb",    { bg = c.subtle })

  h("WildMenu",      { fg = bg, bg = c.blue })
  h("Question",      { fg = c.green })
  h("MoreMsg",       { fg = c.green })
  h("ModeMsg",       { fg = fg })

  h("TabLine",       { fg = c.comment, bg = main_bg })
  h("TabLineFill",   { bg = main_bg })
  h("TabLineSel",    { fg = c.blue, bg = main_bg, gui = "bold" })

  h("Title",         { fg = c.blue, gui = "bold" })

  h("StatusLine",    { fg = fg, bg = panel_bg })
  h("StatusLineNC",  { fg = c.comment, bg = main_bg })
  h("StatusLineTerm",    { link = "StatusLine" })
  h("StatusLineTermNC",  { link = "StatusLineNC" })

  h("VertSplit",     { fg = c.border, bg = main_bg })

  h("FoldColumn",    { fg = c.subtle, bg = main_bg })
  h("Folded",        { fg = c.comment, bg = "#0d0d0d" })

  h("SpellBad",      { guisp = c.red, gui = "undercurl" })
  h("SpellCap",      { guisp = c.amber, gui = "undercurl" })
  h("SpellLocal",    { guisp = c.teal, gui = "undercurl" })
  h("SpellRare",     { guisp = c.purple, gui = "undercurl" })

  h("DiffAdd",       { fg = c.green, bg = "#082313" })
  h("DiffChange",    { fg = c.amber, bg = "#312108" })
  h("DiffDelete",    { fg = c.red, bg = "#301214" })
  h("DiffText",      { fg = bg, bg = c.amber })

  h("DiagnosticError",            { fg = c.red, gui = "italic" })
  h("DiagnosticWarn",             { fg = c.amber, gui = "italic" })
  h("DiagnosticInfo",             { fg = c.slate })
  h("DiagnosticHint",             { fg = c.light_purple })
  h("DiagnosticOk",               { fg = c.green })
  h("DiagnosticUnderlineError",   { guisp = c.red, gui = "undercurl" })
  h("DiagnosticUnderlineWarn",    { guisp = c.amber, gui = "undercurl" })
  h("DiagnosticUnderlineInfo",    { guisp = c.slate, gui = "undercurl" })
  h("DiagnosticUnderlineHint",    { guisp = c.light_purple, gui = "undercurl" })
  h("DiagnosticUnderlineOk",      { guisp = c.green, gui = "undercurl" })

  h("LspReferenceText",  { bg = c.selection_bg })
  h("LspReferenceRead",  { bg = c.selection_bg })
  h("LspReferenceWrite", { bg = c.selection_bg })
  h("LspInlayHint",      { fg = c.subtle, bg = main_bg })

  -- ==========================================================================
  -- Syntax groups
  -- ==========================================================================
  h("Comment",        { fg = c.comment, gui = "italic" })
  h("Constant",       { fg = c.light_amber })
  h("String",         { fg = c.green })
  h("Character",      { fg = c.light_amber })
  h("Number",         { fg = c.amber })
  h("Boolean",        { fg = c.amber })
  h("Float",          { fg = c.amber })

  h("Identifier",     { fg = fg })
  h("Function",       { fg = c.purple })
  h("Method",         { fg = c.purple })

  h("Statement",      { fg = c.blue })
  h("Conditional",    { fg = c.blue })
  h("Repeat",         { fg = c.blue })
  h("Label",          { fg = c.blue })
  h("Operator",       { fg = c.slate })
  h("Keyword",        { fg = c.blue })
  h("Exception",      { fg = c.red })

  h("PreProc",        { fg = c.blue })
  h("Include",        { fg = c.blue })
  h("Define",         { fg = c.blue })
  h("Macro",          { fg = c.purple })
  h("PreCondit",      { fg = c.blue })

  h("Type",           { fg = c.teal })
  h("StorageClass",   { fg = c.light_purple })
  h("Structure",      { fg = c.teal })
  h("Typedef",        { fg = c.light_purple })

  h("Special",        { fg = c.light_amber })
  h("SpecialChar",    { fg = c.teal })
  h("Tag",            { fg = c.blue })
  h("Delimiter",      { fg = c.slate })
  h("SpecialComment", { fg = c.comment, gui = "italic" })
  h("Debug",          { fg = c.light_purple })

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
  h("@comment.note",          { fg = c.slate })

  h("@constant",              { link = "Constant" })
  h("@constant.builtin",      { fg = c.amber })
  h("@constant.macro",        { link = "Macro" })

  h("@module",                { fg = c.light_purple })
  h("@module.builtin",        { fg = c.purple })
  h("@namespace",             { fg = c.light_purple })

  h("@symbol",                { fg = c.light_teal })

  h("@string",                { link = "String" })
  h("@string.documentation",  { fg = c.green, gui = "italic" })
  h("@string.regex",          { fg = c.light_amber })
  h("@string.escape",         { fg = c.teal })
  h("@string.special",        { fg = c.light_teal })
  h("@string.special.symbol", { fg = c.light_teal })
  h("@string.special.url",    { fg = c.slate, gui = "underline" })
  h("@string.special.path",   { fg = c.teal })

  h("@character",             { link = "Character" })
  h("@character.special",     { fg = c.teal })

  h("@boolean",               { link = "Boolean" })
  h("@number",                { link = "Number" })
  h("@number.float",          { link = "Float" })

  h("@type",                  { link = "Type" })
  h("@type.builtin",          { fg = c.light_teal })
  h("@type.definition",       { fg = c.light_purple, gui = "italic" })
  h("@type.qualifier",        { fg = c.blue })

  h("@attribute",             { fg = c.light_amber })
  h("@property",              { fg = c.light_slate })

  h("@function",              { link = "Function" })
  h("@function.builtin",      { fg = c.purple, gui = "italic" })
  h("@function.call",         { link = "Function" })
  h("@function.macro",        { fg = c.purple })
  h("@function.method",       { link = "Method" })
  h("@function.method.call",  { link = "Method" })

  h("@constructor",           { fg = c.teal })
  h("@operator",              { link = "Operator" })

  h("@keyword",               { link = "Keyword" })
  h("@keyword.conditional",   { link = "Conditional" })
  h("@keyword.repeat",        { link = "Repeat" })
  h("@keyword.debug",         { link = "Debug" })
  h("@keyword.directive",     { fg = c.blue })
  h("@keyword.directive.define", { link = "Define" })
  h("@keyword.exception",     { link = "Exception" })
  h("@keyword.function",      { fg = c.blue })
  h("@keyword.import",        { fg = c.blue })
  h("@keyword.operator",      { fg = c.slate })
  h("@keyword.return",        { fg = c.red })
  h("@keyword.storage",       { link = "StorageClass" })
  h("@keyword.type",          { fg = c.blue })

  h("@label",                 { link = "Label" })
  h("@label.builtin",         { fg = c.blue })

  h("@punctuation.delimiter", { fg = c.slate })
  h("@punctuation.bracket",   { fg = c.light_slate })
  h("@punctuation.special",   { fg = c.light_teal })

  h("@variable",              { fg = fg })
  h("@variable.builtin",      { fg = c.blue, gui = "italic" })
  h("@variable.member",       { fg = c.light_slate })
  h("@variable.parameter",    { fg = c.light_amber })
  h("@variable.parameter.builtin", { fg = c.amber })

  h("@field",                 { fg = c.light_slate })

  h("@markup.heading",        { fg = c.blue, gui = "bold" })
  h("@markup.heading.1",      { fg = c.blue, gui = "bold" })
  h("@markup.heading.2",      { fg = c.light_blue, gui = "bold" })
  h("@markup.heading.3",      { fg = c.amber, gui = "bold" })
  h("@markup.heading.4",      { fg = c.light_amber, gui = "bold" })
  h("@markup.heading.5",      { fg = c.teal, gui = "bold" })
  h("@markup.heading.6",      { fg = c.slate, gui = "bold" })
  h("@markup.italic",         { gui = "italic" })
  h("@markup.bold",           { gui = "bold" })
  h("@markup.strikethrough",  { gui = "strikethrough" })
  h("@markup.underline",      { gui = "underline" })
  h("@markup.link",           { fg = c.teal, gui = "underline" })
  h("@markup.link.label",     { fg = c.light_teal })
  h("@markup.link.url",       { fg = c.slate, gui = "underline" })
  h("@markup.list",           { fg = c.amber })
  h("@markup.list.checked",   { fg = c.green })
  h("@markup.list.unchecked", { fg = c.comment })
  h("@markup.raw",            { fg = c.green })
  h("@markup.raw.block",      { fg = c.green, bg = "#0d0d0d" })
  h("@markup.quote",          { fg = c.comment, gui = "italic" })
  h("@markup.math",           { fg = c.light_teal })
  h("@markup.environment",    { fg = c.teal })

  h("@diff.plus",             { fg = c.green })
  h("@diff.minus",            { fg = c.red })
  h("@diff.delta",            { fg = c.amber })

  h("@tag",                   { fg = c.blue })
  h("@tag.builtin",           { fg = c.blue })
  h("@tag.attribute",         { fg = c.light_amber })
  h("@tag.delimiter",         { fg = c.slate })

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
  h("TelescopePromptBorder", { fg = c.blue, bg = main_bg })
  h("TelescopePromptTitle",  { fg = c.blue, bg = main_bg })
  h("TelescopeResultsTitle", { fg = c.comment, bg = main_bg })
  h("TelescopePreviewTitle", { fg = c.comment, bg = main_bg })
  h("TelescopeSelection",    { fg = fg, bg = c.selection_bg })
  h("TelescopeSelectionCaret", { fg = c.blue })
  h("TelescopeMatching",     { fg = c.amber, gui = "bold" })

  -- NvimTree / Oil
  h("NvimTreeNormal",      { fg = fg, bg = main_bg })
  h("NvimTreeFolderName",  { fg = c.slate })
  h("NvimTreeOpenedFolderName", { fg = c.light_slate })
  h("NvimTreeGitDirty",    { fg = c.amber })
  h("NvimTreeGitNew",      { fg = c.green })
  h("NvimTreeGitDeleted",  { fg = c.red })

  -- WhichKey
  h("WhichKey",           { fg = c.blue, gui = "bold" })
  h("WhichKeyGroup",      { fg = c.amber })
  h("WhichKeyDesc",       { fg = fg })
  h("WhichKeySeparator",  { fg = c.subtle })
  h("WhichKeyFloat",      { bg = main_bg })

  -- Lazy
  h("LazyReasonStart",    { fg = c.green })
  h("LazyReasonRuntime",  { fg = c.slate })
  h("LazyReasonSource",   { fg = c.teal })
  h("LazyReasonPlugin",   { fg = c.purple })
  h("LazyDir",            { fg = c.slate })
  h("LazyUrl",            { fg = c.teal, gui = "underline" })
  h("LazyCommit",         { fg = c.amber })
  h("LazySpecial",        { fg = c.light_teal })
  h("LazyH1",             { fg = c.blue, gui = "bold" })
  h("LazyButton",         { fg = bg, bg = c.blue })

  -- Noice / Notify
  h("NoiceFormatTitle",      { fg = c.blue, gui = "bold" })
  h("NoiceFormatProgressDone", { bg = c.green })
  h("NoiceFormatProgressTodo", { bg = c.border })
  h("NotifyERRORTitle",  { fg = c.red })
  h("NotifyWARNTitle",   { fg = c.amber })
  h("NotifyINFOTitle",   { fg = c.slate })
  h("NotifyDEBUDTitle",  { fg = c.purple })
  h("NotifyTRACETitle",  { fg = c.light_purple })

  -- Flash
  h("FlashLabel",        { fg = bg, bg = c.blue, gui = "bold" })

  -- Neo-tree
  h("NeoTreeNormal",     { fg = fg, bg = main_bg })
  h("NeoTreeDirectoryName", { fg = c.slate })
  h("NeoTreeGitAdded",   { fg = c.green })
  h("NeoTreeGitModified", { fg = c.amber })
  h("NeoTreeGitDeleted",  { fg = c.red })
  h("NeoTreeGitUntracked", { fg = c.light_purple })

  -- Trouble
  h("TroubleText",       { fg = fg })
  h("TroubleCount",      { fg = c.blue, gui = "bold" })
  h("TroubleSource",     { fg = c.comment })

  -- Indent Blankline / Ibl
  h("IblIndent",         { fg = "#131313" })
  h("IblScope",          { fg = c.subtle })

  -- Mini
  h("MiniStatuslineModeNormal", { fg = bg, bg = c.blue, gui = "bold" })
  h("MiniStatuslineModeInsert", { fg = bg, bg = c.green, gui = "bold" })
  h("MiniStatuslineModeVisual", { fg = bg, bg = c.purple, gui = "bold" })
  h("MiniStatuslineModeReplace", { fg = bg, bg = c.red, gui = "bold" })
  h("MiniStatuslineModeCommand", { fg = bg, bg = c.amber, gui = "bold" })
  h("MiniStatuslineModeOther",   { fg = bg, bg = c.slate, gui = "bold" })
  h("MiniIndentscopeSymbol",     { fg = c.subtle })

  -- Bufferline
  h("BufferLineTab",         { fg = c.comment, bg = main_bg })
  h("BufferLineTabSelected", { fg = c.blue, bg = main_bg })
  h("BufferLineBuffer",      { fg = c.comment, bg = main_bg })
  h("BufferLineBufferSelected", { fg = fg, bg = main_bg, gui = "bold" })
  h("BufferLineBufferVisible",  { fg = c.comment, bg = main_bg })
  h("BufferLineIndicatorSelected", { fg = c.blue })
  h("BufferLinePick",        { fg = c.blue })
  h("BufferLineDuplicate",   { fg = c.subtle })
  h("BufferLinePickVisible", { fg = c.blue })
  h("BufferLineDevIcon",             { fg = c.comment })
  h("BufferLineDevIconSelected",     { fg = c.blue })
  h("BufferLineDevIconVisible",      { fg = c.comment })
end

setup()
