local sources = { "crates" }
for _, name in ipairs(sources) do
  table.insert(lvim.builtin.cmp.sources, { name = name })
end
