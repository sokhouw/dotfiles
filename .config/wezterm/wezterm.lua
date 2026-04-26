

-- Pull in the wezterm API
local wezterm = require("wezterm") ---@type Wezterm

-- This will hold the configuration.
local config = wezterm.config_builder() ---@type Config

config.automatically_reload_config = true

-- font size and color scheme.
config.font_size = 12
config.font = wezterm.font("0xProto Nerd Font", {})

config.color_scheme = "Aci (Gogh)"
config.color_scheme = "Espresso Libre (Gogh)"
config.color_scheme = "Colors (base16)"
config.color_scheme = "Cyberdyne"
config.color_scheme = "Dark Pastel"
config.color_scheme = "Darkside (Gogh)"
config.color_scheme = "Digerati (terminal.sexy)"
config.color_scheme = "Darktooth (base16)"
config.color_scheme = "Dark+"
config.color_scheme = "Brogrammer"
config.color_scheme = "Aardvark Blue"
config.color_scheme = "Liquid Carbon Transparent (Gogh)"
config.color_scheme = "Cobalt2"

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}
-- mouse
config.mouse_bindings = {
  -- Paste on right-click
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action.PasteFrom("PrimarySelection")
  },
}

-- replace tmux -------------------------------------------
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  { mods = "LEADER", key = "-", action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }) },
  { mods = "LEADER", key = "=", action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { mods = "LEADER", key = "c", action = wezterm.action.SpawnTab('CurrentPaneDomain') },
  { mods = "LEADER", key = "z", action = wezterm.action.TogglePaneZoomState },
  { mods = "LEADER", key = "f", action = wezterm.action.ToggleFullScreen },

  { mods = "LEADER", key = "1", action = wezterm.action.ActivateTab(0) },
  { mods = "LEADER", key = "2", action = wezterm.action.ActivateTab(1) },
  { mods = "LEADER", key = "3", action = wezterm.action.ActivateTab(2) },
  { mods = "LEADER", key = "4", action = wezterm.action.ActivateTab(3) },
  { mods = "LEADER", key = "5", action = wezterm.action.ActivateTab(4) },
  { mods = "LEADER", key = "6", action = wezterm.action.ActivateTab(5) },
  { mods = "LEADER", key = "7", action = wezterm.action.ActivateTab(6) },
  { mods = "LEADER", key = "8", action = wezterm.action.ActivateTab(7) },
  { mods = "LEADER", key = "9", action = wezterm.action.ActivateTab(8) },
  { mods = "LEADER", key = "0", action = wezterm.action.ActivateTab(9) },

  { mods = "LEADER", key = "LeftArrow",  action = wezterm.action.ActivatePaneDirection('Left') },
  { mods = "LEADER", key = "DownArrow",  action = wezterm.action.ActivatePaneDirection('Down') },
  { mods = "LEADER", key = "UpArrow",    action = wezterm.action.ActivatePaneDirection('Up') },
  { mods = "LEADER", key = "RightArrow", action = wezterm.action.ActivatePaneDirection('Right') },

  { mods = "ALT",    key = "1", action = wezterm.action.ActivatePaneByIndex(0) },
  { mods = "ALT",    key = "2", action = wezterm.action.ActivatePaneByIndex(1) },
  { mods = "ALT",    key = "3", action = wezterm.action.ActivatePaneByIndex(2) },
  { mods = "ALT",    key = "4", action = wezterm.action.ActivatePaneByIndex(3) },
  { mods = "ALT",    key = "5", action = wezterm.action.ActivatePaneByIndex(4) },
  { mods = "ALT",    key = "6", action = wezterm.action.ActivatePaneByIndex(5) },
  { mods = "ALT",    key = "7", action = wezterm.action.ActivatePaneByIndex(6) },
  { mods = "ALT",    key = "8", action = wezterm.action.ActivatePaneByIndex(7) },
  { mods = "ALT",    key = "9", action = wezterm.action.ActivatePaneByIndex(8) },
  { mods = "ALT",    key = "0", action = wezterm.action.ActivatePaneByIndex(9) },

  -- theme selector --
  { mods = "LEADER", key = "t", action = wezterm.action.EmitEvent("choose-theme") },

}

-- theme selector (version 1) -----------------------------

-- wezterm.on("choose-theme", function(window, pane)
--   -- get all built-in color schemes
--   local schemes = wezterm.color.get_builtin_schemes()
--   local choices = {}
--
--   for name, _ in pairs(schemes) do
--     table.insert(choices, { label = name })
--   end
--   table.sort(choices, function(a, b) return a.label < b.label end)
--
--   window:perform_action(
--     wezterm.action.InputSelector({
--       title = "Pick a Color Scheme",
--       choices = choices,
--       fuzzy = true,               -- optional fuzzy search
--       action = wezterm.action_callback(function(_, _, _, label)
--         -- apply the chosen scheme immediately to this window
--         window:set_config_overrides({ color_scheme = label })
--       end),
--     }),
--     pane
--   )
-- end)

-- theme selector (version 2) -----------------------------

-- local default_theme = "Cobalt2"
-- local env_theme = os.getenv("WEZ_THEME") or default_theme
--


-- plugins ------------------------------------------------

-- local theme_rotator = wezterm.plugin.require "https://github.com/koh-sh/wezterm-theme-rotator"
-- theme_rotator.apply_to_config(config)

-- local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
-- bar.apply_to_config(config)

-- window configudation
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.window_background_opacity = 1
config.window_decorations = "NONE"

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
  options = {
    icons_enabled = true,
    theme = 'Catppuccin Mocha',
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
--    tabline_a = { 'mode' },
    tabline_b = { 'workspace' },
    tabline_c = { ' ' },
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = { 'ram', 'cpu' },
    tabline_y = { 'datetime' },
    tabline_z = { 'domain' },
  },
  extensions = {},
})
tabline.apply_to_config(config)

-- Finally, return the configuration to wezterm:
return config
