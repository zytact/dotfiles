lvim.leader = ","
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- Bufferline
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- For moving(not cutting and pasting) blocks of code at once
lvim.keys.visual_mode["J"] = ":m '>+1<CR>gv=gv"
lvim.keys.visual_mode["K"] = ":m '<-2<CR>gv=gv"

-- -- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["t"] = { "<cmd>ToggleTerm<CR>", "ToggleTerm" }
lvim.builtin.which_key.mappings["gf"] = { "<cmd>Telescope git_files<CR>", "Find Git Files" }
lvim.builtin.which_key.mappings["U"] = { "<cmd>UndotreeToggle<CR>", "Toggle UndoTree" }
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
