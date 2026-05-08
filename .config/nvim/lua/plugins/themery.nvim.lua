local everforest = function(style)
  return {
    name = "everforest-" .. style,
    colorscheme = "everforest",
    before = string.format([[
      vim.g.everforest_background = "%s"
      vim.o.background = "dark"
    ]], style),
  }
end

local sonokai = function(style)
  return {
    name = "sonokai-" .. style,
    colorscheme = "sonokai",
    before = string.format([[
      vim.g.sonokai_style = "%s"
    ]], style),
  }
end

local themes = {
  "carbonfox", "duskfox", "nightfox", "nordfox", "terafox",
  "catppuccin", "catppuccin-frappe", "catppuccin-latte", "catppuccin-macchiato", "catppuccin-mocha",
  everforest("hard"), everforest("medium"), everforest("soft"),
  "gruvbox",
  "happy_hacking",
  "kanagawa-dragon", "kanagawa-lotus", "kanagawa-wave",
  "nefertiti",
  "quantum",
  "rose-pine-dawn", "rose-pine-main", "rose-pine-moon",
  sonokai("andromeda"), sonokai("atlantis"), sonokai("default"), sonokai("espresso"), sonokai("maia"), sonokai("shusia"),
  "spacegray",
  "tender",
  "thorn", "thorn-forest", "thorn-field",
  "tokyonight", "tokyonight-night", "tokyonight-moon", "tokyonight-storm", "tokyonight-day",
  "vague",
  "vimbrains",
  "vorange",
  "vscode",
}

return {
  "zaldih/themery.nvim",
  lazy = false,
  opts = {
    themes = themes,
    livePreview = true,
  },
}
