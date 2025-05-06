-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Medium" })

config.font_size = 10.5
harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.line_height = 1.3
config.freetype_load_flags = "NO_HINTING"

-- Maximize window
local mux = wezterm.mux

local cache_dir = os.getenv("HOME") .. "/.cache/wezterm/"
local window_size_cache_path = cache_dir .. "window_size_cache.txt"

-- Put tab bar at bottom
config.tab_bar_at_bottom = true
-- Do not use fancy tab bar
config.use_fancy_tab_bar = false
config.enable_tab_bar = true
config.window_background_opacity = 1

-- Set colorscheme
config.color_scheme = "Tokyo Night"

config.colors = {
	tab_bar = {
		background = "#1e1e2e",
		active_tab = {
			bg_color = "#525677",
			fg_color = "#89b4fa",
		},
		inactive_tab = {
			bg_color = "#1e1e2e",
			fg_color = "#80ac81",
		},
		new_tab = {
			bg_color = "#1e1e2e",
			fg_color = "#dc9f7b",
		},
	},
}

config.keys = {
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
	{
		key = "Enter",
		mods = "CTRL",
		action = wezterm.action.SplitHorizontal,
	},
	{
		key = "D",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { "zsh", "-c", "source ~/.zshrc && source ~/.zshenv && file=$(tv dotfiles) && nvim $file" },
		}),
	},
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { "zsh", "-c", "source ~/.zshrc && source ~/.zshenv && open_proj && exec zsh" },
		}),
	},
}

-- Background image
-- config.background = {
-- 	{
-- 		source = {
-- 			File = "/home/arnab/Pictures/termwalls/alex-knight-japan.png",
-- 		},
-- 		repeat_x = "NoRepeat",
-- 		repeat_y = "NoRepeat",
-- 		vertical_align = "Middle",
-- 		horizontal_align = "Center",
-- 		hsb = {
-- 			brightness = 0.05,
-- 		},
-- 	},
-- }

return config
