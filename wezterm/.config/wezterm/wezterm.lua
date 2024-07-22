-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Medium" })

config.font_size = 12.2
config.freetype_load_flags = "NO_HINTING"

-- Maximize window
local mux = wezterm.mux

local cache_dir = os.getenv("HOME") .. "/.cache/wezterm/"
local window_size_cache_path = cache_dir .. "window_size_cache.txt"

wezterm.on("gui-startup", function()
	os.execute("mkdir " .. cache_dir)

	local window_size_cache_file = io.open(window_size_cache_path, "r")
	if window_size_cache_file ~= nil then
		_, _, width, height = string.find(window_size_cache_file:read(), "(%d+),(%d+)")
		mux.spawn_window({ width = tonumber(width), height = tonumber(height) })
		window_size_cache_file:close()
	else
		local tab, pane, window = mux.spawn_window({})
		window:gui_window():maximize()
	end
end)

wezterm.on("window-resized", function(window, pane)
	local window_size_cache_file = io.open(window_size_cache_path, "r")
	if window_size_cache_file == nil then
		local tab_size = pane:tab():get_size()
		cols = tab_size["cols"]
		rows = tab_size["rows"] + 2 -- Without adding the 2 here, the window doesn't maximize
		contents = string.format("%d,%d", cols, rows)
		window_size_cache_file = assert(io.open(window_size_cache_path, "w"))
		window_size_cache_file:write(contents)
		window_size_cache_file:close()
	end
end)

-- Put tab bar at bottom
config.tab_bar_at_bottom = true
-- Do not use fancy tab bar
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"

-- Set colorscheme
config.color_scheme = "Solarized Dark - Patched"

config.colors = {
	tab_bar = {
		background = "#00151a",
		active_tab = {
			bg_color = "#00151a",
			fg_color = "#ff9a99",
		},
		inactive_tab = {
			bg_color = "#002b37",
			fg_color = "#268bd3",
		},
		new_tab = {
			bg_color = "#7a8f12",
			fg_color = "#9eabac",
		},
	},
}

-- Background image
config.background = {
	{
		source = {
			File = "/home/arnab/Pictures/termwalls/sao.png",
		},
		repeat_x = "NoRepeat",
		repeat_y = "NoRepeat",
		vertical_align = "Middle",
		horizontal_align = "Center",
		hsb = {
			brightness = 0.05,
		},
	},
}

return config
