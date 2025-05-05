local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.enable_scroll_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.colors = {
	background = "#282828",
	foreground = "#d8d5cc",
	cursor_bg = "#88857c",
	ansi = {
		"#282828",
		"#f2777a",
		"#99cc99",
		"#ffcc66",
		"#6699cc",
		"#cc99cc",
		"#66cccc",
		"#d8d5cc",
	},
	brights = {
		"#747369",
		"#f4797c",
		"#9bce9b",
		"#ffcd67",
		"#689bce",
		"#ce9bce",
		"#69cece",
		"#f2f0ec",
	},
}
config.window_background_opacity = 0.9
config.font = wezterm.font("NotoMono Nerd Font")
config.enable_tab_bar = false
config.enable_kitty_graphics = true

local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
modal.apply_to_config(config)

return config
