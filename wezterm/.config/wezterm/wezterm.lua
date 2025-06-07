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
config.window_background_opacity = 0.8

-- Disable inactive pane higlighting
config.inactive_pane_hsb = {
	hue = 1.0,
	saturation = 1.0,
	brightness = 1.0,
}

-- Set colorscheme
config.color_scheme = "Tokyo Night Day"

config.colors = {
	tab_bar = {
        background = "#e1e2e7",
        active_tab = {
            bg_color = "#c4c8da",
            fg_color = "#3760bf",
        },
        inactive_tab = {
            bg_color = "#e1e2e7",
            fg_color = "#6172b0",
        },
        new_tab = {
            bg_color = "#e1e2e7",
            fg_color = "#3760bf",
        },
    },
}

config.keys = {
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
	{
		key = "Enter",
		mods = "CTRL",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 30 },
		}),
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
