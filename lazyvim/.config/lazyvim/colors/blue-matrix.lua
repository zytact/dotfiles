-- blue-matrix: a blue/cyan/teal-on-black colorscheme for Neovim
-- Derived from the ghostty blue-matrix theme palette.
-- Supports tree-sitter, LSP diagnostics, and common plugins.

local bg = "#000000"
local fg = "#bfdbfe"
local cursor = "#93c5fd"

-- Ghostty blue-matrix palette
local c = {
  black          = "#0a0f1a",
  bright_blue    = "#4aa3ff",
  teal           = "#2dd4bf",
  light_blue     = "#7dd3fc",
  blue           = "#3b82f6",
  indigo         = "#6366f1",
  cyan           = "#22d3ee",
  pale_blue      = "#dbeafe",
  dark_blue      = "#1e3a5f",
  light_bright   = "#7cc4ff",
  light_teal     = "#5eead4",
  pale_sky       = "#bae6fd",
  med_blue       = "#60a5fa",
  light_indigo   = "#818cf8",
  light_cyan     = "#67e8f9",
  white          = "#eff6ff",
  selection_bg   = "#1e3a8a",
  selection_fg   = "#f0f9ff",
}

local function h(group, opts)
  opts = opts or {}
  local gui = opts.gui and "gui=" .. opts.gui or "gui=NONE"
  local guisp = opts.guisp and "guisp=" .. opts.guisp or ""
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
  vim.g.colors_name = "blue-matrix"

  -- ==========================================================================
  -- Base editor groups
  -- ==========================================================================
  h("Normal",       { fg = fg, bg = bg })
  h("NormalFloat",  { fg = fg, bg = c.black })
  h("NormalSB",     { fg = fg, bg = bg })
  h("EndOfBuffer",  { fg = c.dark_blue })
  h("Cursor",       { fg = bg, bg = cursor })
  h("CursorColumn", { bg = c.black })
  h("CursorLine",   { bg = "#0d1225" })
  h("CursorLineNr", { fg = c.light_bright, gui = "bold" })
  h("LineNr",       { fg = c.dark_blue })
  h("SignColumn",   { bg = bg })
  h("ColorColumn",  { bg = "#0d1520" })

  h("Visual",        { bg = c.selection_bg, fg = c.selection_fg })
  h("VisualNOS",     { bg = c.selection_bg })
  h("Search",        { fg = bg, bg = c.med_blue })
  h("IncSearch",     { fg = bg, bg = c.cyan })
  h("CurSearch",     { link = "IncSearch" })
  h("Substitute",    { fg = bg, bg = c.light_teal })

  h("MatchParen",    { fg = c.cyan, gui = "bold" })

  h("NonText",       { fg = c.dark_blue })
  h("SpecialKey",    { fg = c.dark_blue })
  h("Whitespace",    { fg = c.dark_blue })
  h("Conceal",       { fg = c.dark_blue })

  h("Pmenu",         { fg = fg, bg = c.black })
  h("PmenuSel",      { fg = bg, bg = c.med_blue })
  h("PmenuSbar",     { bg = c.dark_blue })
  h("PmenuThumb",    { bg = c.med_blue })

  h("WildMenu",      { fg = bg, bg = c.cyan })
  h("Question",      { fg = c.light_teal })
  h("MoreMsg",       { fg = c.light_teal })
  h("ModeMsg",       { fg = fg })

  h("TabLine",       { fg = c.dark_blue, bg = bg })
  h("TabLineFill",   { bg = bg })
  h("TabLineSel",    { fg = c.bright_blue, bg = bg, gui = "bold" })

  h("Title",         { fg = c.bright_blue, gui = "bold" })

  h("StatusLine",    { fg = fg, bg = c.black })
  h("StatusLineNC",  { fg = c.dark_blue, bg = bg })
  h("StatusLineTerm",    { link = "StatusLine" })
  h("StatusLineTermNC",  { link = "StatusLineNC" })

  h("VertSplit",     { fg = c.dark_blue, bg = bg })

  h("FoldColumn",    { fg = c.dark_blue, bg = bg })
  h("Folded",        { fg = c.med_blue, bg = "#0d1225" })

  h("SpellBad",      { guisp = c.bright_blue, gui = "undercurl" })
  h("SpellCap",      { guisp = c.med_blue, gui = "undercurl" })
  h("SpellLocal",    { guisp = c.teal, gui = "undercurl" })
  h("SpellRare",     { guisp = c.indigo, gui = "undercurl" })

  h("DiffAdd",       { fg = c.teal, bg = "#0a1f1a" })
  h("DiffChange",    { fg = c.med_blue, bg = "#0a1525" })
  h("DiffDelete",    { fg = c.bright_blue, bg = "#1a0a0f" })
  h("DiffText",      { fg = bg, bg = c.med_blue })

  h("DiagnosticError",            { fg = "#f87171", gui = "italic" })
  h("DiagnosticWarn",             { fg = "#fbbf24", gui = "italic" })
  h("DiagnosticInfo",             { fg = c.med_blue })
  h("DiagnosticHint",             { fg = c.light_indigo })
  h("DiagnosticOk",               { fg = c.teal })
  h("DiagnosticUnderlineError",   { guisp = "#f87171", gui = "undercurl" })
  h("DiagnosticUnderlineWarn",    { guisp = "#fbbf24", gui = "undercurl" })
  h("DiagnosticUnderlineInfo",    { guisp = c.med_blue, gui = "undercurl" })
  h("DiagnosticUnderlineHint",    { guisp = c.light_indigo, gui = "undercurl" })
  h("DiagnosticUnderlineOk",      { guisp = c.teal, gui = "undercurl" })

  h("LspReferenceText",  { bg = c.selection_bg })
  h("LspReferenceRead",  { bg = c.selection_bg })
  h("LspReferenceWrite", { bg = c.selection_bg })
  h("LspInlayHint",      { fg = c.dark_blue, bg = bg })

  -- ==========================================================================
  -- Syntax groups
  -- ==========================================================================
  h("Comment",        { fg = c.blue, gui = "italic" })
  h("Constant",       { fg = c.light_blue })
  h("String",         { fg = c.teal })
  h("Character",      { fg = c.light_teal })
  h("Number",         { fg = c.light_blue })
  h("Boolean",        { fg = c.cyan })
  h("Float",          { fg = c.light_blue })

  h("Identifier",     { fg = fg })
  h("Function",       { fg = c.cyan })
  h("Method",         { fg = c.cyan })

  h("Statement",      { fg = c.bright_blue })
  h("Conditional",    { fg = c.bright_blue })
  h("Repeat",         { fg = c.bright_blue })
  h("Label",          { fg = c.bright_blue })
  h("Operator",       { fg = c.med_blue })
  h("Keyword",        { fg = c.bright_blue })
  h("Exception",      { fg = c.bright_blue })

  h("PreProc",        { fg = c.indigo })
  h("Include",        { fg = c.indigo })
  h("Define",         { fg = c.indigo })
  h("Macro",          { fg = c.indigo })
  h("PreCondit",      { fg = c.indigo })

  h("Type",           { fg = c.light_indigo })
  h("StorageClass",   { fg = c.light_indigo })
  h("Structure",      { fg = c.light_indigo })
  h("Typedef",        { fg = c.light_indigo })

  h("Special",        { fg = c.light_cyan })
  h("SpecialChar",    { fg = c.light_cyan })
  h("Tag",            { fg = c.bright_blue })
  h("Delimiter",      { fg = c.med_blue })
  h("SpecialComment", { fg = c.blue, gui = "italic" })
  h("Debug",          { fg = c.light_cyan })

  h("Underlined",     { fg = fg, gui = "underline" })
  h("Ignore",         { fg = c.dark_blue })
  h("Error",          { fg = "#f87171", bg = bg })
  h("Todo",           { fg = bg, bg = c.bright_blue })

  -- ==========================================================================
  -- Treesitter highlight groups
  -- ==========================================================================
  h("@comment",               { link = "Comment" })
  h("@comment.todo",          { fg = bg, bg = c.bright_blue })
  h("@comment.error",         { fg = "#f87171" })
  h("@comment.warning",       { fg = "#fbbf24" })
  h("@comment.note",          { fg = c.med_blue })

  h("@constant",              { link = "Constant" })
  h("@constant.builtin",      { fg = c.cyan })
  h("@constant.macro",        { link = "Macro" })

  h("@module",                { fg = c.light_indigo })
  h("@module.builtin",        { fg = c.indigo })
  h("@namespace",             { fg = c.light_indigo })

  h("@symbol",                { fg = c.light_cyan })

  h("@string",                { link = "String" })
  h("@string.documentation",  { fg = c.teal, gui = "italic" })
  h("@string.regex",          { fg = c.light_teal })
  h("@string.escape",         { fg = c.cyan })
  h("@string.special",        { fg = c.light_cyan })
  h("@string.special.symbol", { fg = c.light_cyan })
  h("@string.special.url",    { fg = c.med_blue, gui = "underline" })
  h("@string.special.path",   { fg = c.teal })

  h("@character",             { link = "Character" })
  h("@character.special",     { fg = c.cyan })

  h("@boolean",               { link = "Boolean" })
  h("@number",                { link = "Number" })
  h("@number.float",          { link = "Float" })

  h("@type",                  { link = "Type" })
  h("@type.builtin",          { fg = c.indigo })
  h("@type.definition",       { fg = c.light_indigo, gui = "italic" })
  h("@type.qualifier",        { fg = c.indigo })

  h("@attribute",             { fg = c.light_bright })
  h("@property",              { fg = c.light_bright })

  h("@function",              { link = "Function" })
  h("@function.builtin",      { fg = c.cyan, gui = "italic" })
  h("@function.call",         { link = "Function" })
  h("@function.macro",        { fg = c.indigo })
  h("@function.method",       { link = "Method" })
  h("@function.method.call",  { link = "Method" })

  h("@constructor",           { fg = c.cyan })
  h("@operator",              { link = "Operator" })

  h("@keyword",               { link = "Keyword" })
  h("@keyword.conditional",   { link = "Conditional" })
  h("@keyword.repeat",        { link = "Repeat" })
  h("@keyword.debug",         { link = "Debug" })
  h("@keyword.directive",     { fg = c.indigo })
  h("@keyword.directive.define", { link = "Define" })
  h("@keyword.exception",     { link = "Exception" })
  h("@keyword.function",      { fg = c.bright_blue })
  h("@keyword.import",        { fg = c.indigo })
  h("@keyword.operator",      { fg = c.med_blue })
  h("@keyword.return",        { fg = c.bright_blue })
  h("@keyword.storage",       { link = "StorageClass" })
  h("@keyword.type",          { fg = c.indigo })

  h("@label",                 { link = "Label" })
  h("@label.builtin",         { fg = c.bright_blue })

  h("@punctuation.delimiter", { fg = c.med_blue })
  h("@punctuation.bracket",   { fg = c.light_bright })
  h("@punctuation.special",   { fg = c.light_cyan })

  h("@variable",              { fg = fg })
  h("@variable.builtin",      { fg = c.bright_blue, gui = "italic" })
  h("@variable.member",       { fg = c.light_bright })
  h("@variable.parameter",    { fg = c.pale_sky })
  h("@variable.parameter.builtin", { fg = c.med_blue })

  h("@field",                 { fg = c.light_bright })

  h("@markup.heading",        { fg = c.bright_blue, gui = "bold" })
  h("@markup.heading.1",      { fg = c.bright_blue, gui = "bold" })
  h("@markup.heading.2",      { fg = c.med_blue, gui = "bold" })
  h("@markup.heading.3",      { fg = c.light_bright, gui = "bold" })
  h("@markup.heading.4",      { fg = c.cyan, gui = "bold" })
  h("@markup.heading.5",      { fg = c.teal, gui = "bold" })
  h("@markup.heading.6",      { fg = c.light_teal, gui = "bold" })
  h("@markup.italic",         { gui = "italic" })
  h("@markup.bold",           { gui = "bold" })
  h("@markup.strikethrough",  { gui = "strikethrough" })
  h("@markup.underline",      { gui = "underline" })
  h("@markup.link",           { fg = c.med_blue, gui = "underline" })
  h("@markup.link.label",     { fg = c.teal })
  h("@markup.link.url",       { fg = c.med_blue, gui = "underline" })
  h("@markup.list",           { fg = c.bright_blue })
  h("@markup.list.checked",   { fg = c.teal })
  h("@markup.list.unchecked", { fg = c.med_blue })
  h("@markup.raw",            { fg = c.teal })
  h("@markup.raw.block",      { fg = c.teal, bg = "#0a1215" })
  h("@markup.quote",          { fg = c.med_blue, gui = "italic" })
  h("@markup.math",           { fg = c.light_cyan })
  h("@markup.environment",    { fg = c.cyan })

  h("@diff.plus",             { fg = c.teal })
  h("@diff.minus",            { fg = "#f87171" })
  h("@diff.delta",            { fg = c.med_blue })

  h("@tag",                   { fg = c.bright_blue })
  h("@tag.builtin",           { fg = c.indigo })
  h("@tag.attribute",         { fg = c.light_bright })
  h("@tag.delimiter",         { fg = c.med_blue })

  h("@error",                 { fg = "#f87171" })

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
  h("TelescopeNormal",    { fg = fg, bg = bg })
  h("TelescopeBorder",    { fg = c.dark_blue, bg = bg })
  h("TelescopePromptBorder", { fg = c.med_blue, bg = bg })
  h("TelescopePromptTitle",  { fg = c.bright_blue, bg = bg })
  h("TelescopeResultsTitle", { fg = c.dark_blue, bg = bg })
  h("TelescopePreviewTitle", { fg = c.dark_blue, bg = bg })
  h("TelescopeSelection",    { fg = fg, bg = c.selection_bg })
  h("TelescopeSelectionCaret", { fg = c.cyan })
  h("TelescopeMatching",     { fg = c.cyan, gui = "bold" })

  -- NvimTree / Oil
  h("NvimTreeNormal",      { fg = fg, bg = bg })
  h("NvimTreeFolderName",  { fg = c.med_blue })
  h("NvimTreeOpenedFolderName", { fg = c.bright_blue })
  h("NvimTreeGitDirty",    { fg = "#fbbf24" })
  h("NvimTreeGitNew",      { fg = c.teal })
  h("NvimTreeGitDeleted",  { fg = "#f87171" })

  -- WhichKey
  h("WhichKey",           { fg = c.cyan, gui = "bold" })
  h("WhichKeyGroup",      { fg = c.med_blue })
  h("WhichKeyDesc",       { fg = fg })
  h("WhichKeySeparator",  { fg = c.dark_blue })
  h("WhichKeyFloat",      { bg = bg })

  -- Lazy
  h("LazyReasonStart",    { fg = c.teal })
  h("LazyReasonRuntime",  { fg = c.med_blue })
  h("LazyReasonSource",   { fg = c.cyan })
  h("LazyReasonPlugin",   { fg = c.indigo })
  h("LazyDir",            { fg = c.med_blue })
  h("LazyUrl",            { fg = c.teal, gui = "underline" })
  h("LazyCommit",         { fg = c.light_blue })
  h("LazySpecial",        { fg = c.light_cyan })
  h("LazyH1",             { fg = c.bright_blue, gui = "bold" })
  h("LazyButton",         { fg = bg, bg = c.med_blue })

  -- Noice / Notify
  h("NoiceFormatTitle",      { fg = c.bright_blue, gui = "bold" })
  h("NoiceFormatProgressDone", { bg = c.teal })
  h("NoiceFormatProgressTodo", { bg = c.dark_blue })
  h("NotifyERRORTitle",  { fg = "#f87171" })
  h("NotifyWARNTitle",   { fg = "#fbbf24" })
  h("NotifyINFOTitle",   { fg = c.med_blue })
  h("NotifyDEBUDTitle",  { fg = c.indigo })
  h("NotifyTRACETitle",  { fg = c.light_indigo })

  -- Flash
  h("FlashLabel",        { fg = bg, bg = c.cyan, gui = "bold" })

  -- Neo-tree
  h("NeoTreeNormal",     { fg = fg, bg = bg })
  h("NeoTreeDirectoryName", { fg = c.med_blue })
  h("NeoTreeGitAdded",   { fg = c.teal })
  h("NeoTreeGitModified", { fg = "#fbbf24" })
  h("NeoTreeGitDeleted",  { fg = "#f87171" })
  h("NeoTreeGitUntracked", { fg = c.light_bright })

  -- Trouble
  h("TroubleText",       { fg = fg })
  h("TroubleCount",      { fg = c.cyan, gui = "bold" })
  h("TroubleSource",     { fg = c.med_blue })

  -- Indent Blankline / Ibl
  h("IblIndent",         { fg = "#0d1a30" })
  h("IblScope",          { fg = c.dark_blue })

  -- Mini
  h("MiniStatuslineModeNormal", { fg = bg, bg = c.bright_blue, gui = "bold" })
  h("MiniStatuslineModeInsert", { fg = bg, bg = c.cyan, gui = "bold" })
  h("MiniStatuslineModeVisual", { fg = bg, bg = c.indigo, gui = "bold" })
  h("MiniStatuslineModeReplace", { fg = bg, bg = c.teal, gui = "bold" })
  h("MiniStatuslineModeCommand", { fg = bg, bg = c.med_blue, gui = "bold" })
  h("MiniStatuslineModeOther",   { fg = bg, bg = c.dark_blue, gui = "bold" })
  h("MiniIndentscopeSymbol",     { fg = c.dark_blue })

  -- Bufferline
  h("BufferLineTab",         { fg = c.dark_blue, bg = bg })
  h("BufferLineTabSelected", { fg = c.bright_blue, bg = bg })
  h("BufferLineBuffer",      { fg = c.dark_blue, bg = bg })
  h("BufferLineBufferSelected", { fg = fg, bg = bg, gui = "bold" })
  h("BufferLineBufferVisible",  { fg = c.med_blue, bg = bg })
  h("BufferLineIndicatorSelected", { fg = c.cyan })
  h("BufferLinePick",        { fg = c.cyan })
  h("BufferLineDuplicate",   { fg = c.dark_blue })
  h("BufferLinePickVisible", { fg = c.cyan })
  h("BufferLineDevIcon",             { fg = c.dark_blue })
  h("BufferLineDevIconSelected",     { fg = c.cyan })
  h("BufferLineDevIconVisible",      { fg = c.med_blue })
end

setup()
