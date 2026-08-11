-- targaryen: a blood/fire-on-AMOLED-black colorscheme for Neovim
-- Derived from the ghostty targaryen theme palette.
-- Supports tree-sitter, LSP diagnostics, and common plugins.

local bg = "#000000"
local fg = "#ebd9d2"
local cursor = "#ff7a29"

-- Ghostty targaryen palette
local c = {
  ember_black    = "#17090b",
  dragonfire     = "#f5384f",
  wildfire       = "#57b894",
  gold           = "#d9a441",
  steel          = "#7d9bb5",
  violet         = "#a06fbf",
  dragonglass    = "#6fbfb2",
  ash            = "#ebd9d2",
  ember_grey     = "#947474",
  blood          = "#ff6b81",
  light_wildfire = "#7fd6ae",
  light_gold     = "#f0c98a",
  light_steel    = "#9fbcd4",
  light_violet   = "#c49ada",
  light_glass    = "#93d8cc",
  white          = "#fff5f0",
  ember          = "#ff7a29",
  scorch         = "#2b1216",
  scar           = "#56262c",
  selection_bg   = "#4a161c",
  selection_fg   = "#fff5f0",
}

local transparent = vim.g.targaryen_transparent == true
local main_bg = transparent and "NONE" or bg
local panel_bg = transparent and "NONE" or c.ember_black

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
  vim.g.colors_name = "targaryen"

  -- ==========================================================================
  -- Base editor groups
  -- ==========================================================================
  h("Normal",       { fg = fg, bg = main_bg })
  h("NormalFloat",  { fg = fg, bg = panel_bg })
  h("NormalSB",     { fg = fg, bg = main_bg })
  h("EndOfBuffer",  { fg = c.scorch })
  h("Cursor",       { fg = bg, bg = cursor })
  h("CursorColumn", { bg = c.ember_black })
  h("CursorLine",   { bg = "#0d0708" })
  h("CursorLineNr", { fg = c.gold, gui = "bold" })
  h("LineNr",       { fg = c.scar })
  h("SignColumn",   { bg = main_bg })
  h("ColorColumn",  { bg = "#120a0b" })

  h("Visual",        { bg = c.selection_bg, fg = c.selection_fg })
  h("VisualNOS",     { bg = c.selection_bg })
  h("Search",        { fg = bg, bg = c.gold })
  h("IncSearch",     { fg = bg, bg = c.ember })
  h("CurSearch",     { link = "IncSearch" })
  h("Substitute",    { fg = bg, bg = c.dragonfire })

  h("MatchParen",    { fg = c.ember, gui = "bold" })

  h("NonText",       { fg = c.scorch })
  h("SpecialKey",    { fg = c.scorch })
  h("Whitespace",    { fg = c.scorch })
  h("Conceal",       { fg = c.scar })

  h("Pmenu",         { fg = fg, bg = panel_bg })
  h("PmenuSel",      { fg = bg, bg = c.dragonfire })
  h("PmenuSbar",     { bg = c.scorch })
  h("PmenuThumb",    { bg = c.scar })

  h("WildMenu",      { fg = bg, bg = c.ember })
  h("Question",      { fg = c.wildfire })
  h("MoreMsg",       { fg = c.wildfire })
  h("ModeMsg",       { fg = fg })

  h("TabLine",       { fg = c.ember_grey, bg = main_bg })
  h("TabLineFill",   { bg = main_bg })
  h("TabLineSel",    { fg = c.dragonfire, bg = main_bg, gui = "bold" })

  h("Title",         { fg = c.dragonfire, gui = "bold" })

  h("StatusLine",    { fg = fg, bg = panel_bg })
  h("StatusLineNC",  { fg = c.ember_grey, bg = main_bg })
  h("StatusLineTerm",    { link = "StatusLine" })
  h("StatusLineTermNC",  { link = "StatusLineNC" })

  h("VertSplit",     { fg = c.scorch, bg = main_bg })

  h("FoldColumn",    { fg = c.scar, bg = main_bg })
  h("Folded",        { fg = c.ember_grey, bg = "#0d0708" })

  h("SpellBad",      { guisp = c.blood, gui = "undercurl" })
  h("SpellCap",      { guisp = c.gold, gui = "undercurl" })
  h("SpellLocal",    { guisp = c.dragonglass, gui = "undercurl" })
  h("SpellRare",     { guisp = c.violet, gui = "undercurl" })

  h("DiffAdd",       { fg = c.wildfire, bg = "#0b2119" })
  h("DiffChange",    { fg = c.gold, bg = "#1a1006" })
  h("DiffDelete",    { fg = c.blood, bg = "#2e0d14" })
  h("DiffText",      { fg = bg, bg = c.gold })

  h("DiagnosticError",            { fg = c.blood, gui = "italic" })
  h("DiagnosticWarn",             { fg = c.gold, gui = "italic" })
  h("DiagnosticInfo",             { fg = c.steel })
  h("DiagnosticHint",             { fg = c.light_violet })
  h("DiagnosticOk",               { fg = c.wildfire })
  h("DiagnosticUnderlineError",   { guisp = c.blood, gui = "undercurl" })
  h("DiagnosticUnderlineWarn",    { guisp = c.gold, gui = "undercurl" })
  h("DiagnosticUnderlineInfo",    { guisp = c.steel, gui = "undercurl" })
  h("DiagnosticUnderlineHint",    { guisp = c.light_violet, gui = "undercurl" })
  h("DiagnosticUnderlineOk",      { guisp = c.wildfire, gui = "undercurl" })

  h("LspReferenceText",  { bg = c.selection_bg })
  h("LspReferenceRead",  { bg = c.selection_bg })
  h("LspReferenceWrite", { bg = c.selection_bg })
  h("LspInlayHint",      { fg = c.scar, bg = main_bg })

  -- ==========================================================================
  -- Syntax groups
  -- ==========================================================================
  h("Comment",        { fg = c.ember_grey, gui = "italic" })
  h("Constant",       { fg = c.light_gold })
  h("String",         { fg = c.gold })
  h("Character",      { fg = c.light_gold })
  h("Number",         { fg = c.violet })
  h("Boolean",        { fg = c.ember })
  h("Float",          { fg = c.violet })

  h("Identifier",     { fg = fg })
  h("Function",       { fg = c.ember })
  h("Method",         { fg = c.ember })

  h("Statement",      { fg = c.dragonfire })
  h("Conditional",    { fg = c.dragonfire })
  h("Repeat",         { fg = c.dragonfire })
  h("Label",          { fg = c.dragonfire })
  h("Operator",       { fg = c.steel })
  h("Keyword",        { fg = c.dragonfire })
  h("Exception",      { fg = c.blood })

  h("PreProc",        { fg = c.violet })
  h("Include",        { fg = c.violet })
  h("Define",         { fg = c.violet })
  h("Macro",          { fg = c.violet })
  h("PreCondit",      { fg = c.violet })

  h("Type",           { fg = c.dragonglass })
  h("StorageClass",   { fg = c.light_violet })
  h("Structure",      { fg = c.dragonglass })
  h("Typedef",        { fg = c.light_violet })

  h("Special",        { fg = c.light_gold })
  h("SpecialChar",    { fg = c.ember })
  h("Tag",            { fg = c.dragonfire })
  h("Delimiter",      { fg = c.steel })
  h("SpecialComment", { fg = c.ember_grey, gui = "italic" })
  h("Debug",          { fg = c.light_violet })

  h("Underlined",     { fg = fg, gui = "underline" })
  h("Ignore",         { fg = c.scar })
  h("Error",          { fg = c.blood, bg = main_bg })
  h("Todo",           { fg = bg, bg = c.gold })

  -- ==========================================================================
  -- Treesitter highlight groups
  -- ==========================================================================
  h("@comment",               { link = "Comment" })
  h("@comment.todo",          { fg = bg, bg = c.gold })
  h("@comment.error",         { fg = c.blood })
  h("@comment.warning",       { fg = c.gold })
  h("@comment.note",          { fg = c.steel })

  h("@constant",              { link = "Constant" })
  h("@constant.builtin",      { fg = c.ember })
  h("@constant.macro",        { link = "Macro" })

  h("@module",                { fg = c.light_violet })
  h("@module.builtin",        { fg = c.violet })
  h("@namespace",             { fg = c.light_violet })

  h("@symbol",                { fg = c.light_glass })

  h("@string",                { link = "String" })
  h("@string.documentation",  { fg = c.gold, gui = "italic" })
  h("@string.regex",          { fg = c.light_gold })
  h("@string.escape",         { fg = c.ember })
  h("@string.special",        { fg = c.light_glass })
  h("@string.special.symbol", { fg = c.light_glass })
  h("@string.special.url",    { fg = c.steel, gui = "underline" })
  h("@string.special.path",   { fg = c.dragonglass })

  h("@character",             { link = "Character" })
  h("@character.special",     { fg = c.ember })

  h("@boolean",               { link = "Boolean" })
  h("@number",                { link = "Number" })
  h("@number.float",          { link = "Float" })

  h("@type",                  { link = "Type" })
  h("@type.builtin",          { fg = c.light_glass })
  h("@type.definition",       { fg = c.light_violet, gui = "italic" })
  h("@type.qualifier",        { fg = c.violet })

  h("@attribute",             { fg = c.light_gold })
  h("@property",              { fg = c.light_steel })

  h("@function",              { link = "Function" })
  h("@function.builtin",      { fg = c.ember, gui = "italic" })
  h("@function.call",         { link = "Function" })
  h("@function.macro",        { fg = c.violet })
  h("@function.method",       { link = "Method" })
  h("@function.method.call",  { link = "Method" })

  h("@constructor",           { fg = c.dragonglass })
  h("@operator",              { link = "Operator" })

  h("@keyword",               { link = "Keyword" })
  h("@keyword.conditional",   { link = "Conditional" })
  h("@keyword.repeat",        { link = "Repeat" })
  h("@keyword.debug",         { link = "Debug" })
  h("@keyword.directive",     { fg = c.violet })
  h("@keyword.directive.define", { link = "Define" })
  h("@keyword.exception",     { link = "Exception" })
  h("@keyword.function",      { fg = c.dragonfire })
  h("@keyword.import",        { fg = c.violet })
  h("@keyword.operator",      { fg = c.steel })
  h("@keyword.return",        { fg = c.blood })
  h("@keyword.storage",       { link = "StorageClass" })
  h("@keyword.type",          { fg = c.violet })

  h("@label",                 { link = "Label" })
  h("@label.builtin",         { fg = c.dragonfire })

  h("@punctuation.delimiter", { fg = c.steel })
  h("@punctuation.bracket",   { fg = c.light_steel })
  h("@punctuation.special",   { fg = c.light_glass })

  h("@variable",              { fg = fg })
  h("@variable.builtin",      { fg = c.dragonfire, gui = "italic" })
  h("@variable.member",       { fg = c.light_steel })
  h("@variable.parameter",    { fg = c.light_gold })
  h("@variable.parameter.builtin", { fg = c.gold })

  h("@field",                 { fg = c.light_steel })

  h("@markup.heading",        { fg = c.dragonfire, gui = "bold" })
  h("@markup.heading.1",      { fg = c.dragonfire, gui = "bold" })
  h("@markup.heading.2",      { fg = c.ember, gui = "bold" })
  h("@markup.heading.3",      { fg = c.gold, gui = "bold" })
  h("@markup.heading.4",      { fg = c.light_gold, gui = "bold" })
  h("@markup.heading.5",      { fg = c.dragonglass, gui = "bold" })
  h("@markup.heading.6",      { fg = c.steel, gui = "bold" })
  h("@markup.italic",         { gui = "italic" })
  h("@markup.bold",           { gui = "bold" })
  h("@markup.strikethrough",  { gui = "strikethrough" })
  h("@markup.underline",      { gui = "underline" })
  h("@markup.link",           { fg = c.dragonglass, gui = "underline" })
  h("@markup.link.label",     { fg = c.light_glass })
  h("@markup.link.url",       { fg = c.steel, gui = "underline" })
  h("@markup.list",           { fg = c.gold })
  h("@markup.list.checked",   { fg = c.wildfire })
  h("@markup.list.unchecked", { fg = c.ember_grey })
  h("@markup.raw",            { fg = c.gold })
  h("@markup.raw.block",      { fg = c.gold, bg = "#0d0708" })
  h("@markup.quote",          { fg = c.ember_grey, gui = "italic" })
  h("@markup.math",           { fg = c.light_glass })
  h("@markup.environment",    { fg = c.dragonglass })

  h("@diff.plus",             { fg = c.wildfire })
  h("@diff.minus",            { fg = c.blood })
  h("@diff.delta",            { fg = c.gold })

  h("@tag",                   { fg = c.dragonfire })
  h("@tag.builtin",           { fg = c.violet })
  h("@tag.attribute",         { fg = c.light_gold })
  h("@tag.delimiter",         { fg = c.steel })

  h("@error",                 { fg = c.blood })

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
  h("TelescopeBorder",    { fg = c.scorch, bg = main_bg })
  h("TelescopePromptBorder", { fg = c.dragonfire, bg = main_bg })
  h("TelescopePromptTitle",  { fg = c.dragonfire, bg = main_bg })
  h("TelescopeResultsTitle", { fg = c.ember_grey, bg = main_bg })
  h("TelescopePreviewTitle", { fg = c.ember_grey, bg = main_bg })
  h("TelescopeSelection",    { fg = fg, bg = c.selection_bg })
  h("TelescopeSelectionCaret", { fg = c.ember })
  h("TelescopeMatching",     { fg = c.gold, gui = "bold" })

  -- NvimTree / Oil
  h("NvimTreeNormal",      { fg = fg, bg = main_bg })
  h("NvimTreeFolderName",  { fg = c.steel })
  h("NvimTreeOpenedFolderName", { fg = c.light_steel })
  h("NvimTreeGitDirty",    { fg = c.gold })
  h("NvimTreeGitNew",      { fg = c.wildfire })
  h("NvimTreeGitDeleted",  { fg = c.blood })

  -- WhichKey
  h("WhichKey",           { fg = c.ember, gui = "bold" })
  h("WhichKeyGroup",      { fg = c.gold })
  h("WhichKeyDesc",       { fg = fg })
  h("WhichKeySeparator",  { fg = c.scar })
  h("WhichKeyFloat",      { bg = main_bg })

  -- Lazy
  h("LazyReasonStart",    { fg = c.wildfire })
  h("LazyReasonRuntime",  { fg = c.steel })
  h("LazyReasonSource",   { fg = c.dragonglass })
  h("LazyReasonPlugin",   { fg = c.violet })
  h("LazyDir",            { fg = c.steel })
  h("LazyUrl",            { fg = c.dragonglass, gui = "underline" })
  h("LazyCommit",         { fg = c.gold })
  h("LazySpecial",        { fg = c.light_glass })
  h("LazyH1",             { fg = c.dragonfire, gui = "bold" })
  h("LazyButton",         { fg = bg, bg = c.dragonfire })

  -- Noice / Notify
  h("NoiceFormatTitle",      { fg = c.dragonfire, gui = "bold" })
  h("NoiceFormatProgressDone", { bg = c.wildfire })
  h("NoiceFormatProgressTodo", { bg = c.scorch })
  h("NotifyERRORTitle",  { fg = c.blood })
  h("NotifyWARNTitle",   { fg = c.gold })
  h("NotifyINFOTitle",   { fg = c.steel })
  h("NotifyDEBUDTitle",  { fg = c.violet })
  h("NotifyTRACETitle",  { fg = c.light_violet })

  -- Flash
  h("FlashLabel",        { fg = bg, bg = c.ember, gui = "bold" })

  -- Neo-tree
  h("NeoTreeNormal",     { fg = fg, bg = main_bg })
  h("NeoTreeDirectoryName", { fg = c.steel })
  h("NeoTreeGitAdded",   { fg = c.wildfire })
  h("NeoTreeGitModified", { fg = c.gold })
  h("NeoTreeGitDeleted",  { fg = c.blood })
  h("NeoTreeGitUntracked", { fg = c.light_violet })

  -- Trouble
  h("TroubleText",       { fg = fg })
  h("TroubleCount",      { fg = c.ember, gui = "bold" })
  h("TroubleSource",     { fg = c.ember_grey })

  -- Indent Blankline / Ibl
  h("IblIndent",         { fg = "#1a0d0f" })
  h("IblScope",          { fg = c.scar })

  -- Mini
  h("MiniStatuslineModeNormal", { fg = bg, bg = c.dragonfire, gui = "bold" })
  h("MiniStatuslineModeInsert", { fg = bg, bg = c.ember, gui = "bold" })
  h("MiniStatuslineModeVisual", { fg = bg, bg = c.violet, gui = "bold" })
  h("MiniStatuslineModeReplace", { fg = bg, bg = c.wildfire, gui = "bold" })
  h("MiniStatuslineModeCommand", { fg = bg, bg = c.gold, gui = "bold" })
  h("MiniStatuslineModeOther",   { fg = bg, bg = c.steel, gui = "bold" })
  h("MiniIndentscopeSymbol",     { fg = c.scar })

  -- Bufferline
  h("BufferLineTab",         { fg = c.ember_grey, bg = main_bg })
  h("BufferLineTabSelected", { fg = c.dragonfire, bg = main_bg })
  h("BufferLineBuffer",      { fg = c.ember_grey, bg = main_bg })
  h("BufferLineBufferSelected", { fg = fg, bg = main_bg, gui = "bold" })
  h("BufferLineBufferVisible",  { fg = c.ember_grey, bg = main_bg })
  h("BufferLineIndicatorSelected", { fg = c.dragonfire })
  h("BufferLinePick",        { fg = c.ember })
  h("BufferLineDuplicate",   { fg = c.scar })
  h("BufferLinePickVisible", { fg = c.ember })
  h("BufferLineDevIcon",             { fg = c.ember_grey })
  h("BufferLineDevIconSelected",     { fg = c.ember })
  h("BufferLineDevIconVisible",      { fg = c.ember_grey })
end

setup()
