-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font({ family = "CaskaydiaCove Nerd Font", weight = "DemiBold" })

config.font_size = 8.5
local harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
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
config.enable_wayland = true
config.window_background_opacity = 1.0
config.window_decorations = "TITLE|RESIZE"

-- Disable inactive pane higlighting
config.inactive_pane_hsb = {
	hue = 1.0,
	saturation = 1.0,
	brightness = 1.0,
}

-- Custom theme disabled
-- config.colors = {
-- 	foreground = "#cfe7ff",
-- 	background = "#111010",
-- 	cursor_bg = "#39ff88",
-- 	cursor_border = "#39ff88",
-- 	cursor_fg = "#111010",
-- 	selection_bg = "#4c1d95",
-- 	selection_fg = "#fdf4ff",
-- 	ansi = {
-- 		"#0a0f1a",
-- 		"#ff5faf",
-- 		"#39ff88",
-- 		"#ffd166",
-- 		"#4aa3ff",
-- 		"#a78bfa",
-- 		"#22d3ee",
-- 		"#dbeafe",
-- 	},
-- 	brights = {
-- 		"#1e3a5f",
-- 		"#ff8cc6",
-- 		"#7dffb3",
-- 		"#ffe08a",
-- 		"#7cc4ff",
-- 		"#c4b5fd",
-- 		"#67e8f9",
-- 		"#eff6ff",
-- 	},
-- 	tab_bar = {
-- 		background = "#111010",
-- 		active_tab = {
-- 			bg_color = "#4aa3ff",
-- 			fg_color = "#111010",
-- 		},
-- 		inactive_tab = {
-- 			bg_color = "#0a0f1a",
-- 			fg_color = "#cfe7ff",
-- 		},
-- 		new_tab = {
-- 			bg_color = "#0a0f1a",
-- 			fg_color = "#4aa3ff",
-- 		},
-- 	},
-- }

config.color_schemes = {
	["GitHub Dark Colorblind"] = {
		foreground = "#c9d1d9",
		background = "#0d1117",
		cursor_bg = "#58a6ff",
		cursor_border = "#58a6ff",
		cursor_fg = "#0d1117",
		selection_bg = "#0c2d6b",
		selection_fg = "#c9d1d9",
		ansi = {
			"#484f58",
			"#ec8e2c",
			"#58a6ff",
			"#d29922",
			"#58a6ff",
			"#bc8cff",
			"#76e3ea",
			"#b1bac4",
		},
		brights = {
			"#6e7681",
			"#fdac54",
			"#79c0ff",
			"#e3b341",
			"#79c0ff",
			"#d2a8ff",
			"#a5f3fc",
			"#f0f6fc",
		},
		tab_bar = {
			background = "#0d1117",
			active_tab = {
				bg_color = "#161b22",
				fg_color = "#f0f6fc",
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#0d1117",
				fg_color = "#8b949e",
			},
			inactive_tab_hover = {
				bg_color = "#21262d",
				fg_color = "#c9d1d9",
			},
			new_tab = {
				bg_color = "#0d1117",
				fg_color = "#8b949e",
			},
			new_tab_hover = {
				bg_color = "#21262d",
				fg_color = "#c9d1d9",
			},
		},
	},
}

config.color_scheme = "GitHub Dark Colorblind"

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

-- Background image disabled
-- config.background = {
-- 	{
-- 		source = {
-- 			File = "/home/arnab/Pictures/1398568-blur-20.png",
-- 		},
-- 		repeat_x = "NoRepeat",
-- 		repeat_y = "NoRepeat",
-- 		vertical_align = "Middle",
-- 		horizontal_align = "Center",
-- 		hsb = {
-- 			brightness = 0.1,
-- 		},
-- 	},
-- }

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
