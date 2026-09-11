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
config.tab_max_width = 50
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
	["Targaryen"] = {
		foreground = "#ebd9d2",
		background = "#000000",
		cursor_bg = "#ff7a29",
		cursor_border = "#ff7a29",
		cursor_fg = "#000000",
		selection_bg = "#4a161c",
		selection_fg = "#fff5f0",
		ansi = { "#17090b", "#f5384f", "#57b894", "#d9a441", "#7d9bb5", "#a06fbf", "#6fbfb2", "#ebd9d2" },
		brights = { "#947474", "#ff5a6e", "#7fd6ae", "#f0c98a", "#9fbcd4", "#c49ada", "#93d8cc", "#fff5f0" },
		tab_bar = {
			background = "#000000",
			active_tab = { bg_color = "#33070f", fg_color = "#fff5f0", intensity = "Bold" },
			inactive_tab = { bg_color = "#000000", fg_color = "#a1837c" },
			inactive_tab_hover = { bg_color = "#240f12", fg_color = "#ebd9d2" },
			new_tab = { bg_color = "#000000", fg_color = "#a1837c" },
			new_tab_hover = { bg_color = "#240f12", fg_color = "#f5384f" },
		},
	},
	["Targaryen Light"] = {
		foreground = "#2b1a18",
		background = "#faf3ea",
		cursor_bg = "#b8501e",
		cursor_border = "#b8501e",
		cursor_fg = "#faf3ea",
		selection_bg = "#f0d9b5",
		selection_fg = "#1a0f0e",
		ansi = { "#e2d2c6", "#b3202f", "#2f7f63", "#8a6612", "#456e8c", "#7a3f9c", "#1f7a6e", "#2b1a18" },
		brights = { "#b09a92", "#8f1826", "#24664f", "#6e5210", "#35576f", "#5f3079", "#176159", "#1a0f0e" },
		tab_bar = {
			background = "#f2e7d9",
			active_tab = { bg_color = "#faf3ea", fg_color = "#1a0f0e", intensity = "Bold" },
			inactive_tab = { bg_color = "#f2e7d9", fg_color = "#6f5854" },
			inactive_tab_hover = { bg_color = "#f0d9b5", fg_color = "#2b1a18" },
			new_tab = { bg_color = "#f2e7d9", fg_color = "#6f5854" },
			new_tab_hover = { bg_color = "#f0d9b5", fg_color = "#b3202f" },
		},
	},
	["Carbonfox"] = {
		foreground = "#f2f4f8",
		background = "#161616",
		cursor_bg = "#f2f4f8",
		cursor_border = "#f2f4f8",
		cursor_fg = "#161616",
		selection_bg = "#525253",
		selection_fg = "#f2f4f8",
		ansi = { "#282828", "#ee5396", "#25be6a", "#08bdba", "#78a9ff", "#be95ff", "#33b1ff", "#dfdfe0" },
		brights = { "#484848", "#ff7eb6", "#42be65", "#3ddbd9", "#82cfff", "#be95ff", "#3ddbd9", "#ffffff" },
		tab_bar = {
			background = "#161616",
			active_tab = { bg_color = "#252525", fg_color = "#f2f4f8", intensity = "Bold" },
			inactive_tab = { bg_color = "#161616", fg_color = "#7b7c7e" },
			inactive_tab_hover = { bg_color = "#353535", fg_color = "#f2f4f8" },
			new_tab = { bg_color = "#161616", fg_color = "#78a9ff" },
			new_tab_hover = { bg_color = "#353535", fg_color = "#f2f4f8" },
		},
	},
	["Blue Matrix Light"] = {
		foreground = "#123047",
		background = "#e3ebf0",
		cursor_bg = "#008f5a",
		cursor_border = "#008f5a",
		cursor_fg = "#e3ebf0",
		selection_bg = "#d8eaff",
		selection_fg = "#071a1f",
		ansi = {
			"#cedde6",
			"#c0266f",
			"#008f5a",
			"#9a6a00",
			"#0969da",
			"#6d5bd0",
			"#008aa6",
			"#123047",
		},
		brights = {
			"#7aa7bd",
			"#a3195b",
			"#00784c",
			"#7c5600",
			"#005fb8",
			"#5848b8",
			"#007f98",
			"#071a1f",
		},
		tab_bar = {
			background = "#cedde6",
			active_tab = {
				bg_color = "#e3ebf0",
				fg_color = "#071a1f",
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#cedde6",
				fg_color = "#376078",
			},
			inactive_tab_hover = {
				bg_color = "#d8eaff",
				fg_color = "#123047",
			},
			new_tab = {
				bg_color = "#cedde6",
				fg_color = "#376078",
			},
			new_tab_hover = {
				bg_color = "#d8eaff",
				fg_color = "#123047",
			},
		},
	},
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
    	["GitHub Light Colorblind"] = {
		foreground = "#24292f",
		background = "#ffffff",
		cursor_bg = "#0969da",
		cursor_border = "#0969da",
		cursor_fg = "#ffffff",
		selection_bg = "#b6e3ff",
		selection_fg = "#24292f",
		ansi = {
			"#24292f",
			"#b35900",
			"#0550ae",
			"#4d2d00",
			"#0969da",
			"#8250df",
			"#1b7c83",
			"#6e7781",
		},
		brights = {
			"#57606a",
			"#8a4600",
			"#0969da",
			"#633c01",
			"#218bff",
			"#a475f9",
			"#3192aa",
			"#8c959f",
		},
		tab_bar = {
			background = "#f6f8fa",
			active_tab = {
				bg_color = "#ffffff",
				fg_color = "#24292f",
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#f6f8fa",
				fg_color = "#57606a",
			},
			inactive_tab_hover = {
				bg_color = "#eaeef2",
				fg_color = "#24292f",
			},
			new_tab = {
				bg_color = "#f6f8fa",
				fg_color = "#57606a",
			},
			new_tab_hover = {
				bg_color = "#eaeef2",
				fg_color = "#24292f",
			},
		},
	},


}

config.color_scheme = "Targaryen Light"

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
