return {
  "mason-org/mason.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter"
  },
  build = ":MasonUpdate",
  config = Toolkit.mason.config,
  lazy = false,
  opts = {
    automatic_enable = true,
    ensure_installed = {
      "lua-language-server",
      "shellcheck",
    },
  },
}
