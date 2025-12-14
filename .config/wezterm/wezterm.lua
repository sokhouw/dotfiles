---@class wezterm_config

-- Pull in the wezterm API
local wezterm = require 'wezterm' ---@type Wezterm

-- This will hold the configuration.
local config = wezterm.config_builder() ---@type Config

-- initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 50
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- font size and color scheme.
config.font_size = 12
config.color_scheme = 'AdventureTime'

config.hide_tab_bar_if_only_one_tab = true


-- Finally, return the configuration to wezterm:
return config
