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
	["T3 Dark"] = {
		foreground = "#f5f5f5",
		background = "#0a0a0a",
		cursor_bg = "#b4cbff",
		cursor_border = "#b4cbff",
		cursor_fg = "#0a0a0a",
		selection_bg = "#343a47",
		selection_fg = "#ffffff",
		ansi = { "#111111", "#fb414a", "#54c57a", "#e4b750", "#51a2ff", "#bb8aef", "#51cec7", "#f5f5f5" },
		brights = { "#818181", "#fd7277", "#89dea1", "#f3d086", "#87bafd", "#ceacf7", "#91e2dc", "#ffffff" },
		tab_bar = {
			background = "#0a0a0a",
			active_tab = { bg_color = "#181f2e", fg_color = "#ffffff", intensity = "Bold" },
			inactive_tab = { bg_color = "#0a0a0a", fg_color = "#a3a3a3" },
			inactive_tab_hover = { bg_color = "#141414", fg_color = "#f5f5f5" },
			new_tab = { bg_color = "#0a0a0a", fg_color = "#a3a3a3" },
			new_tab_hover = { bg_color = "#141414", fg_color = "#568ef9" },
		},
	},
	["Targaryen Light"] = {
		foreground = "#26231f",
		background = "#f9f9f8",
		cursor_bg = "#b8501e",
		cursor_border = "#b8501e",
		cursor_fg = "#f9f9f8",
		selection_bg = "#e4e2de",
		selection_fg = "#141210",
		ansi = { "#dedddb", "#b3202f", "#2f7f63", "#8a6612", "#456e8c", "#7a3f9c", "#1f7a6e", "#26231f" },
		brights = { "#a3a09c", "#8f1826", "#24664f", "#6e5210", "#35576f", "#5f3079", "#176159", "#141210" },
		tab_bar = {
			background = "#efeeec",
			active_tab = { bg_color = "#f9f9f8", fg_color = "#141210", intensity = "Bold" },
			inactive_tab = { bg_color = "#efeeec", fg_color = "#625f5a" },
			inactive_tab_hover = { bg_color = "#e4e2de", fg_color = "#26231f" },
			new_tab = { bg_color = "#efeeec", fg_color = "#625f5a" },
			new_tab_hover = { bg_color = "#e4e2de", fg_color = "#b3202f" },
		},
	},
	["Washi"] = {
		foreground = "#27221d",
		background = "#faf9f6",
		cursor_bg = "#c44323",
		cursor_border = "#c44323",
		cursor_fg = "#faf9f6",
		selection_bg = "#e8e2db",
		selection_fg = "#15110d",
		ansi = { "#e2dfdb", "#b32130", "#457d52", "#976712", "#32618e", "#714085", "#29706c", "#27221d" },
		brights = { "#a39d98", "#c44323", "#31623d", "#755010", "#224a71", "#5b2f6d", "#155855", "#15110d" },
		tab_bar = {
			background = "#f1efeb",
			active_tab = { bg_color = "#faf9f6", fg_color = "#15110d", intensity = "Bold" },
			inactive_tab = { bg_color = "#f1efeb", fg_color = "#68625c" },
			inactive_tab_hover = { bg_color = "#e8e2db", fg_color = "#27221d" },
			new_tab = { bg_color = "#f1efeb", fg_color = "#68625c" },
			new_tab_hover = { bg_color = "#e8e2db", fg_color = "#c44323" },
		},
	},
	["Washi Neutral"] = {
		foreground = "#232323",
		background = "#f9f9f9",
		cursor_bg = "#3065cd",
		cursor_border = "#3065cd",
		cursor_fg = "#f9f9f9",
		selection_bg = "#e3e3e3",
		selection_fg = "#121212",
		ansi = { "#dfdfdf", "#b32130", "#457d52", "#976712", "#3065cd", "#714085", "#29706c", "#232323" },
		brights = { "#9e9e9e", "#c44323", "#31623d", "#755010", "#2354b3", "#5b2f6d", "#155855", "#121212" },
		tab_bar = {
			background = "#efefef",
			active_tab = { bg_color = "#f9f9f9", fg_color = "#121212", intensity = "Bold" },
			inactive_tab = { bg_color = "#efefef", fg_color = "#636363" },
			inactive_tab_hover = { bg_color = "#e3e3e3", fg_color = "#232323" },
			new_tab = { bg_color = "#efefef", fg_color = "#636363" },
			new_tab_hover = { bg_color = "#e3e3e3", fg_color = "#3065cd" },
		},
	},
	["Okibi"] = {
		foreground = "#d7d7d7",
		background = "#000000",
		cursor_bg = "#f9681a",
		cursor_border = "#f9681a",
		cursor_fg = "#000000",
		selection_bg = "#4a1502",
		selection_fg = "#eeeeee",
		ansi = { "#161616", "#dc6478", "#6cc085", "#ddb96c", "#66a8d5", "#b690e1", "#6fcac4", "#d7d7d7" },
		brights = { "#7b7b7b", "#f9681a", "#98daa9", "#edd198", "#91bdde", "#cbb0ec", "#a0dfda", "#eeeeee" },
		tab_bar = {
			background = "#000000",
			active_tab = { bg_color = "#421201", fg_color = "#eeeeee", intensity = "Bold" },
			inactive_tab = { bg_color = "#000000", fg_color = "#999999" },
			inactive_tab_hover = { bg_color = "#0e0e0e", fg_color = "#d7d7d7" },
			new_tab = { bg_color = "#000000", fg_color = "#999999" },
			new_tab_hover = { bg_color = "#0e0e0e", fg_color = "#f9681a" },
		},
	},
	["Okibi Light"] = {
		foreground = "#1f1f1f",
		background = "#e1e1e1",
		cursor_bg = "#c94c18",
		cursor_border = "#c94c18",
		cursor_fg = "#e1e1e1",
		selection_bg = "#efac8d",
		selection_fg = "#101010",
		ansi = { "#c5c5c5", "#ac2e36", "#4a7c55", "#946824", "#34729b", "#6f4381", "#326f6b", "#1f1f1f" },
		brights = { "#808080", "#c94c18", "#366140", "#72511d", "#216188", "#593269", "#1f5754", "#101010" },
		tab_bar = {
			background = "#d6d6d6",
			active_tab = { bg_color = "#e1e1e1", fg_color = "#101010", intensity = "Bold" },
			inactive_tab = { bg_color = "#d6d6d6", fg_color = "#555555" },
			inactive_tab_hover = { bg_color = "#c9c9c9", fg_color = "#1f1f1f" },
			new_tab = { bg_color = "#d6d6d6", fg_color = "#555555" },
			new_tab_hover = { bg_color = "#c9c9c9", fg_color = "#c94c18" },
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

config.color_scheme = "Okibi"

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
