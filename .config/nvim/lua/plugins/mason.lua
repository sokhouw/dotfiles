return {
  "mason-org/mason.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter"
  },
  build = ":MasonUpdate",
  lazy = false,
  opts = {
    ensure_installed = {
      "tree-sitter-cli",
      "lua-language-server",
      "shellcheck",
    },
  },
  config = function(_, opts)
    Core.mason.setup(opts)
  end,
}
