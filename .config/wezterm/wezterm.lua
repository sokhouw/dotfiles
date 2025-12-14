---@class wezterm_config

-- Pull in the wezterm API
local wezterm = require "wezterm" ---@type Wezterm
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder() ---@type Config

-- window configudation
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.hide_tab_bar_if_only_one_tab = true

-- font size and color scheme.
config.font_size = 12
config.font = wezterm.font("0xProto Nerd Font", {})

config.color_scheme = "Liquid Carbon Transparent (Gogh)"
config.color_scheme = "Material Darker (base16)"
-- config.color_scheme = "MaterialOcean"
-- config.color_scheme = "Aci (Gogh)"
config.color_scheme = "tokyonight"
config.window_background_opacity = 1

config.window_decorations = "TITLE|RESIZE"

-- mouse
config.mouse_bindings = {
  -- Paste on right-click
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom("PrimarySelection")
  },
}

-- plugins ------------------------------------------------

local theme_rotator = wezterm.plugin.require "https://github.com/koh-sh/wezterm-theme-rotator"

-- Apply the plugin
theme_rotator.apply_to_config(config)

-- Finally, return the configuration to wezterm:
return config
