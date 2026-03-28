local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local config = wezterm.config_builder()

-- Ensure OSC 52 is allowed (copy / paste from remote server - ssh)
allow_clipboard_from_remote_filesystem = true

-- Start in full screen
wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

-- -- Check for OS
local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

config.default_prog = { "/bin/zsh", "-l" }
-- config.default_prog = { os.getenv("SHELL") or "/bin/zsh", "-il" }

-- config.color_scheme = "Tokyo Night Storm (Gogh)"
config.color_scheme = "Hardcore"

config.window_padding = {
	left = 40,
	right = 20,
	top = 10,
	bottom = 10,
}

config.scrollback_lines = 10000
config.audible_bell = "Disabled"
--
if is_darwin() then
	config.window_decorations = "RESIZE"
	config.font_size = 16
	config.native_macos_fullscreen_mode = false
end

if is_linux() then
	config.enable_wayland = true
	config.window_decorations = "TITLE|RESIZE"
	config.font_size = 11
end

config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- Ensure ligatures work
config.font_shaper = "Harfbuzz"
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

config.window_close_confirmation = "NeverPrompt"
--
-- config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Thin" })
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Thin" })

config.freetype_render_target = "HorizontalLcd"
--
config.hide_tab_bar_if_only_one_tab = true
--
config.adjust_window_size_when_changing_font_size = false
--
--
config.window_background_opacity = 0.95

config.inactive_pane_hsb = {
	saturation = 0.7,
	brightness = 0.5,
}

config.leader = {
	key = "w",
	mods = "CTRL",
	timeout_milliseconds = 1000,
}
--
config.keys = {
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "_", mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "h", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "j", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "k", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "l", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "c", mods = "CTRL|SHIFT", action = act({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = "CTRL|SHIFT", action = act({ PasteFrom = "Clipboard" }) },
	{ key = "f", mods = "LEADER", action = act.ToggleFullScreen },
	{ key = "r", mods = "LEADER", action = act.RotatePanes("Clockwise") },
}
-- MacOS copy / Paste
if is_darwin() then
	table.insert(config.keys, { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") })
	table.insert(config.keys, { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") })
end

return config
